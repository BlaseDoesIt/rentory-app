import 'dart:async';

import 'package:drift/drift.dart';

import '../../domain/enums.dart';
import '../../domain/rules/availability.dart' hide autofillSerials;
import '../../domain/rules/availability.dart'
    as availability
    show autofillSerials;
import '../../domain/rules/late_fee.dart';
import '../../domain/rules/money.dart';
import '../../domain/rules/order_rules.dart';
import '../repository.dart';
import 'database.dart';
import 'tables.dart';

/// [RentoryRepository] on the device's own SQLite database. Every write marks
/// the row dirty so the sync engine pushes it; nothing here knows about the
/// network except through [gateway].
class LocalRepository implements RentoryRepository {
  LocalRepository(
    this.db, {
    required this.gateway,
    String? Function()? currentUserId,
    DateTime Function()? clock,
  }) : _userId = currentUserId ?? (() => null),
       _clock = clock ?? (() => DateTime.now().toUtc());

  final RentoryDatabase db;
  final BookingGateway gateway;
  final String? Function() _userId;
  final DateTime Function() _clock;

  Value<DateTime> get _ts => Value(_clock());
  static const _dirty = Value(true);

  Expression<bool> _alive(SyncColumns t) => t.deleted.equals(false);

  // ============================================================ watching

  /// Re-runs [load] whenever any of [tables] changes.
  Stream<T> _watch<T>(
    Set<ResultSetImplementation> tables,
    Future<T> Function() load,
  ) async* {
    yield await load();
    await for (final _ in db.tableUpdates(
      TableUpdateQuery.onAllTables(tables.toList()),
    )) {
      yield await load();
    }
  }

  @override
  Stream<List<OrderSummary>> watchOrders({OrderState? state}) => _watch(
    {
      db.orders,
      db.orderLines,
      db.orderLineSerials,
      db.returnChecks,
      db.customers,
    },
    () async {
      final query = db.select(db.orders)..where((o) => _alive(o));
      if (state != null) {
        query.where((o) => o.state.equalsValue(state));
      }
      query.orderBy([
        (o) => OrderingTerm.desc(o.dateStart),
        (o) => OrderingTerm.desc(o.updatedAt),
      ]);
      final orders = await query.get();
      return [for (final o in orders) (await _detail(o)).summary];
    },
  );

  @override
  Stream<List<AssetSummary>> watchAssets({String? search}) => _watch(
    {db.assets, db.serials, db.parts, db.orderLines, db.categories},
    () async {
      final query = db.select(db.assets)
        ..where((a) => _alive(a) & a.active.equals(true))
        ..orderBy([(a) => OrderingTerm.asc(a.name)]);
      final term = search?.trim();
      if (term != null && term.isNotEmpty) {
        final like = '%$term%';
        query.where(
          (a) => a.name.like(like) | a.code.like(like) | a.barcode.like(like),
        );
      }
      final assets = await query.get();
      final categories = {
        for (final c in await db.select(db.categories).get()) c.id: c.name,
      };
      final out = await _qtyOutByAsset();
      return [
        for (final a in assets)
          AssetSummary(
            asset: a,
            categoryName: categories[a.categoryId],
            total: a.tracking == Tracking.serial
                ? (await _serialFacts(a.id))
                      .where((s) => s.fitToPromise)
                      .length
                      .toDouble()
                : a.qtyManual,
            out: out[a.id] ?? 0,
          ),
      ];
    },
  );

  @override
  Future<OrderDetail> loadOrder(String orderId) async =>
      _detail(await _order(orderId));

  // ============================================================ reading

  Future<Order> _order(String id) =>
      (db.select(db.orders)..where((o) => o.id.equals(id))).getSingle();

  Future<OrderLine> _line(String id) =>
      (db.select(db.orderLines)..where((l) => l.id.equals(id))).getSingle();

  Future<List<OrderLine>> _lines(String orderId) =>
      (db.select(db.orderLines)
            ..where((l) => l.orderId.equals(orderId) & _alive(l))
            ..orderBy([(l) => OrderingTerm.asc(l.sequence)]))
          .get();

  Future<List<Serial>> _serialsOfLine(String lineId) async {
    final query =
        db.select(db.serials).join([
            innerJoin(
              db.orderLineSerials,
              db.orderLineSerials.serialId.equalsExp(db.serials.id),
            ),
          ])
          ..where(
            db.orderLineSerials.lineId.equals(lineId) &
                db.orderLineSerials.deleted.equals(false),
          )
          ..orderBy([OrderingTerm.asc(db.serials.name)]);
    return [for (final row in await query.get()) row.readTable(db.serials)];
  }

  Future<List<Part>> _partsOfLine(OrderLine line) async {
    if (line.lineType == LineType.part && line.partId != null) {
      return (db.select(
        db.parts,
      )..where((p) => p.id.equals(line.partId!))).get();
    }
    if (line.lineType != LineType.asset) return const [];
    final query =
        db.select(db.parts).join([
          innerJoin(
            db.orderLineParts,
            db.orderLineParts.partId.equalsExp(db.parts.id),
          ),
        ])..where(
          db.orderLineParts.lineId.equals(line.id) &
              db.orderLineParts.deleted.equals(false),
        );
    return [for (final row in await query.get()) row.readTable(db.parts)];
  }

  Future<List<ReturnCheck>> _checksOfLine(String lineId) => (db.select(
    db.returnChecks,
  )..where((c) => c.lineId.equals(lineId) & _alive(c))).get();

  ({DateTime? start, DateTime? end}) _window(OrderLine l, Order o) =>
      (start: l.dateStart ?? o.dateStart, end: l.dateEnd ?? o.dateEnd);

  double _outstanding(
    OrderLine l,
    List<Serial> serials,
    List<ReturnCheck> checks,
  ) {
    if (l.lineType == LineType.section) return 0;
    if (serials.isNotEmpty) {
      final ids = {for (final s in serials) s.id};
      final back = {
        for (final c in checks)
          if (c.serialId != null && ids.contains(c.serialId)) c.serialId,
      };
      return (serials.length - back.length).toDouble();
    }
    return l.rentalState == RentalState.returned ? 0 : l.quantity;
  }

  Future<OrderDetail> _detail(Order order) async {
    final now = _clock();
    final lines = await _lines(order.id);
    final views = <LineView>[];
    for (final l in lines) {
      final serials = await _serialsOfLine(l.id);
      final checks = await _checksOfLine(l.id);
      final asset = l.assetId == null
          ? null
          : await (db.select(
              db.assets,
            )..where((a) => a.id.equals(l.assetId!))).getSingleOrNull();
      final w = _window(l, order);
      final days = l.lineType == LineType.section
          ? 0
          : billableDays(w.start, w.end);
      views.add(
        LineView(
          line: l,
          asset: asset,
          serials: serials,
          returnChecks: checks,
          days: days,
          subtotal: l.lineType == LineType.section
              ? 0
              : lineSubtotal(
                  priceDay: l.priceDay,
                  discountPercent: l.discount,
                  quantity: l.quantity,
                  days: days,
                ),
          qtyOutstanding: _outstanding(l, serials, checks),
        ),
      );
    }

    final linesTotal = views.fold<double>(0, (a, v) => a + v.subtotal);
    final ratio = discountRatio(
      linesTotal,
      order.discountType,
      order.discountValue,
    );
    final late = orderLateFee(
      lines: [
        for (final v in views)
          if (v.line.lineType != LineType.section)
            (line: _lateInput(v, order), qtyOutstanding: v.qtyOutstanding),
      ],
      now: now,
      orderCancelled: order.state == OrderState.cancelled,
      discountRatio: ratio,
      manual: order.lateFeeManual,
      daysEdited: order.lateDaysEdited,
      daysOverride: order.lateDaysOverride,
    );
    final amounts = orderAmounts(
      lineSubtotals: views.map((v) => v.subtotal),
      discountType: order.discountType,
      discountValue: order.discountValue,
      lateFee: late.amount,
      paid: order.amountPaid,
    );
    final facts = [for (final v in views) _facts(v)];
    final overdue = isOverdue(
      state: order.state,
      dateEnd: order.dateEnd,
      lines: facts,
      now: now,
    );

    var label = order.customerName ?? '';
    if (label.isEmpty && order.customerId != null) {
      final c = await (db.select(
        db.customers,
      )..where((c) => c.id.equals(order.customerId!))).getSingleOrNull();
      label = c?.name ?? '';
    }

    return OrderDetail(
      summary: OrderSummary(
        order: order,
        customerLabel: label,
        amounts: amounts,
        itemCount: views.where((v) => v.line.lineType == LineType.asset).length,
        overdue: overdue,
        daysLate: daysLate(overdue: overdue, dateEnd: order.dateEnd, now: now),
      ),
      lines: views,
      lateDailyRate: late.dailyRate,
    );
  }

  LateLineInput _lateInput(LineView v, Order order) {
    final back = {
      for (final c in v.returnChecks)
        if (c.serialId != null) c.serialId: c.returnedAt,
    };
    return LateLineInput(
      rentalState: v.line.rentalState,
      dateEnd: v.line.dateEnd ?? order.dateEnd,
      priceDayNet: priceDayNet(v.line.priceDay, v.line.discount),
      quantity: v.line.quantity,
      serialReturnedAt: v.serials.isEmpty
          ? null
          : [for (final s in v.serials) back[s.id]],
      returnedAt: v.line.returnedAt,
    );
  }

  LineFacts _facts(LineView v) => LineFacts(
    type: v.line.lineType,
    rentalState: v.line.rentalState,
    name: v.line.name.isNotEmpty ? v.line.name : (v.asset?.name ?? ''),
    quantity: v.line.quantity,
    tracking: v.asset?.tracking ?? Tracking.none,
    serialCount: v.serials.length,
  );

  /// Units of one asset with what the picker needs to know.
  Future<List<SerialFacts>> _serialFacts(String assetId) async {
    final serials =
        await (db.select(db.serials)..where(
              (s) =>
                  s.assetId.equals(assetId) & _alive(s) & s.active.equals(true),
            ))
            .get();
    final parts =
        await (db.select(db.parts)..where(
              (p) =>
                  p.assetId.equals(assetId) &
                  _alive(p) &
                  p.active.equals(true) &
                  p.kind.equalsValue(PartKind.mandatory),
            ))
            .get();
    final partLineIds = <String>{
      for (final l in await (db.select(
        db.orderLines,
      )..where((l) => l.lineType.equalsValue(LineType.part))).get())
        l.id,
    };
    bool blocked(Serial s) => parts.any(
      (p) =>
          p.serialId == s.id &&
          (p.condition == 'lost' ||
              p.condition == 'damaged' ||
              (p.state != PartState.available &&
                  partLineIds.contains(p.currentLineId))),
    );
    return [
      for (final s in serials)
        SerialFacts(
          id: s.id,
          name: s.name,
          state: s.state,
          blockedByPart: blocked(s),
        ),
    ];
  }

  /// Every line of [assetId] as a claim on the calendar.
  Future<List<Claim>> _claims(String assetId) async {
    final query =
        db.select(db.orderLines).join([
          innerJoin(db.orders, db.orders.id.equalsExp(db.orderLines.orderId)),
        ])..where(
          db.orderLines.assetId.equals(assetId) &
              db.orderLines.lineType.equalsValue(LineType.asset) &
              db.orderLines.deleted.equals(false) &
              db.orders.deleted.equals(false),
        );
    final claims = <Claim>[];
    for (final row in await query.get()) {
      final l = row.readTable(db.orderLines);
      final o = row.readTable(db.orders);
      final w = _window(l, o);
      if (w.start == null || w.end == null) continue;
      final serials = await _serialsOfLine(l.id);
      final checks = await _checksOfLine(l.id);
      final back = {for (final c in checks) c.serialId};
      claims.add(
        Claim(
          lineId: l.id,
          orderId: o.id,
          assetId: assetId,
          orderState: o.state,
          rentalState: l.rentalState,
          start: w.start!,
          end: w.end!,
          qtyOutstanding: _outstanding(l, serials, checks),
          serialIds: {
            for (final s in serials)
              if (!back.contains(s.id)) s.id,
          },
        ),
      );
    }
    return claims;
  }

  Future<Map<String, double>> _qtyOutByAsset() async {
    final lines =
        await (db.select(db.orderLines)..where(
              (l) =>
                  _alive(l) &
                  l.lineType.equalsValue(LineType.asset) &
                  l.rentalState.equalsValue(RentalState.pickedUp),
            ))
            .get();
    final out = <String, double>{};
    for (final l in lines) {
      if (l.assetId == null) continue;
      final qty = _outstanding(
        l,
        await _serialsOfLine(l.id),
        await _checksOfLine(l.id),
      );
      out[l.assetId!] = (out[l.assetId!] ?? 0) + qty;
    }
    return out;
  }

  // ============================================================ editing

  @override
  Future<String> createOrder({
    String? customerId,
    String? customerName,
    String? customerPhone,
    required DateTime start,
    required DateTime end,
  }) async {
    final problem = datesProblem(start, end);
    if (problem != null) throw RuleException.one(problem);
    var discountType = DiscountType.percent;
    var discountValue = 0.0;
    String? discountId;
    if (customerId != null) {
      final rule = await _customerDiscount(customerId, start);
      if (rule != null) {
        discountType = rule.discountType;
        discountValue = rule.discountValue;
        discountId = rule.id;
      }
    }
    final row = await db
        .into(db.orders)
        .insertReturning(
          OrdersCompanion.insert(
            customerId: Value(customerId),
            customerName: Value(customerName),
            customerPhone: Value(customerPhone),
            dateStart: Value(start.toUtc()),
            dateEnd: Value(end.toUtc()),
            discountType: Value(discountType),
            discountValue: Value(discountValue),
            customerDiscountId: Value(discountId),
            userId: Value(_userId()),
            updatedAt: _ts,
          ),
        );
    return row.id;
  }

  /// The customer's standing discount valid on [when], if any.
  Future<CustomerDiscount?> _customerDiscount(
    String customerId,
    DateTime when,
  ) async {
    final rules =
        await (db.select(db.customerDiscounts)..where(
              (d) =>
                  d.customerId.equals(customerId) &
                  _alive(d) &
                  d.active.equals(true),
            ))
            .get();
    for (final r in rules) {
      if (r.dateFrom != null && when.isBefore(r.dateFrom!)) continue;
      if (r.dateTo != null && when.isAfter(r.dateTo!)) continue;
      return r;
    }
    return null;
  }

  @override
  Future<void> updateOrder(String orderId, OrdersCompanion changes) async {
    await (db.update(db.orders)..where((o) => o.id.equals(orderId))).write(
      changes.copyWith(updatedAt: _ts, dirty: _dirty),
    );
  }

  @override
  Future<String> addLine(
    String orderId, {
    required LineType type,
    String? assetId,
    String? partId,
    String? name,
    double quantity = 1,
    double? priceDay,
    double discount = 0,
  }) async {
    var price = priceDay ?? 0;
    var label = name ?? '';
    final askedAsset = assetId;
    if (type == LineType.asset && askedAsset != null) {
      final asset = await (db.select(
        db.assets,
      )..where((a) => a.id.equals(askedAsset))).getSingle();
      if (!asset.rentalOk) {
        throw RuleException.one('${asset.name} is not for rent.');
      }
      price = priceDay ?? asset.rentalPriceDay;
      if (label.isEmpty) label = asset.name;
    } else if (type == LineType.part && partId != null) {
      final part = await (db.select(
        db.parts,
      )..where((p) => p.id.equals(partId))).getSingle();
      price = priceDay ?? part.rentalPriceDay;
      if (label.isEmpty) label = part.name;
      assetId = part.assetId;
    }
    final last =
        await (db.select(db.orderLines)
              ..where((l) => l.orderId.equals(orderId))
              ..orderBy([(l) => OrderingTerm.desc(l.sequence)])
              ..limit(1))
            .getSingleOrNull();
    final section = type == LineType.section;
    final row = await db
        .into(db.orderLines)
        .insertReturning(
          OrderLinesCompanion.insert(
            orderId: orderId,
            sequence: Value((last?.sequence ?? 0) + 10),
            lineType: Value(type),
            assetId: Value(section ? null : assetId),
            partId: Value(section ? null : partId),
            name: Value(label),
            quantity: Value(section ? 0 : quantity),
            priceDay: Value(section ? 0 : price),
            discount: Value(section ? 0 : discount),
            updatedAt: _ts,
          ),
        );
    return row.id;
  }

  @override
  Future<void> removeLine(String lineId) async {
    final line = await _line(lineId);
    if (line.rentalState.goneOut) {
      throw RuleException.one('This line has already left. Return it instead.');
    }
    await db.transaction(() async {
      await _releaseLine(line);
      await (db.update(db.orderLines)..where((l) => l.id.equals(lineId))).write(
        OrderLinesCompanion(
          deleted: const Value(true),
          updatedAt: _ts,
          dirty: _dirty,
        ),
      );
      await (db.update(
        db.orderLineSerials,
      )..where((s) => s.lineId.equals(lineId))).write(
        OrderLineSerialsCompanion(
          deleted: const Value(true),
          updatedAt: _ts,
          dirty: _dirty,
        ),
      );
    });
  }

  // ============================================================ serials

  @override
  Future<List<SerialOption>> serialOptions(String lineId) async {
    final line = await _line(lineId);
    final order = await _order(line.orderId);
    final w = _window(line, order);
    if (line.assetId == null || w.start == null || w.end == null) {
      return const [];
    }
    return freeSerials(
      serials: await _serialFacts(line.assetId!),
      assetId: line.assetId!,
      claims: await _claims(line.assetId!),
      ask: Ask(
        start: w.start!,
        end: w.end!,
        orderId: order.id,
        ignoreLineIds: {line.id},
      ),
      now: _clock(),
    );
  }

  @override
  Future<void> setLineSerials(String lineId, List<String> serialIds) async {
    final line = await _line(lineId);
    if (line.rentalState != RentalState.none) {
      throw RuleException.one('Units can only be changed before booking.');
    }
    await db.transaction(() async {
      await (db.update(
        db.orderLineSerials,
      )..where((s) => s.lineId.equals(lineId) & _alive(s))).write(
        OrderLineSerialsCompanion(
          deleted: const Value(true),
          updatedAt: _ts,
          dirty: _dirty,
        ),
      );
      for (final id in serialIds) {
        await db
            .into(db.orderLineSerials)
            .insert(
              OrderLineSerialsCompanion.insert(
                lineId: lineId,
                serialId: id,
                updatedAt: _ts,
              ),
            );
      }
      await (db.update(db.orderLines)..where((l) => l.id.equals(lineId))).write(
        OrderLinesCompanion(
          quantity: Value(serialIds.length.toDouble()),
          updatedAt: _ts,
          dirty: _dirty,
        ),
      );
    });
  }

  @override
  Future<int> autofillSerials(String lineId) async {
    final line = await _line(lineId);
    final wanted = line.quantity.round();
    final options = await serialOptions(lineId);
    final picked = availability.autofillSerials(options, wanted);
    await setLineSerials(lineId, [for (final s in picked) s.id]);
    // setLineSerials makes quantity follow the units; keep what was asked.
    await (db.update(db.orderLines)..where((l) => l.id.equals(lineId))).write(
      OrderLinesCompanion(quantity: Value(line.quantity)),
    );
    return wanted - picked.length;
  }

  // ============================================================ lifecycle

  @override
  Future<void> book(String orderId) async {
    final detail = await loadOrder(orderId);
    final order = detail.order;
    final problems = bookProblems(order.state, [
      for (final v in detail.lines) _facts(v),
    ]);
    if (problems.isNotEmpty) throw RuleException(problems);
    problems.addAll(await _availabilityProblems(detail));
    if (problems.isNotEmpty) throw RuleException(problems);

    // Always confirmed, even when re-booking a numbered order: the units
    // still have to be refereed. The number itself is kept.
    final number = await gateway.confirmBooking(orderId, _clock());
    await db.transaction(() async {
      await updateOrder(
        orderId,
        OrdersCompanion(
          state: const Value(OrderState.booked),
          number: Value(number),
        ),
      );
      for (final v in detail.lines) {
        if (v.line.lineType == LineType.section ||
            v.line.rentalState != RentalState.none) {
          continue;
        }
        await _setLine(
          v.line.id,
          const OrderLinesCompanion(rentalState: Value(RentalState.booked)),
        );
        for (final s in v.serials) {
          // Never stamp 'reserved' over a unit that is physically out.
          if (s.state == SerialState.available) {
            await _setSerial(s.id, SerialState.reserved, v.line);
          }
        }
        for (final p in await _partsOfLine(v.line)) {
          if (p.state == PartState.available) {
            await _setPart(p.id, PartState.reserved, v.line);
          }
        }
      }
    });
  }

  Future<List<String>> _availabilityProblems(OrderDetail detail) async {
    final order = detail.order;
    final now = _clock();
    final problems = <String>[];
    for (final v in detail.lines) {
      final l = v.line;
      if (l.lineType != LineType.asset || l.assetId == null) continue;
      final w = _window(l, order);
      if (w.start == null || w.end == null) {
        problems.add('${l.name}: no dates.');
        continue;
      }
      final ask = Ask(
        start: w.start!,
        end: w.end!,
        orderId: order.id,
        ignoreLineIds: {l.id},
      );
      final claims = await _claims(l.assetId!);
      if (v.asset?.tracking == Tracking.serial) {
        final free = {
          for (final o in freeSerials(
            serials: await _serialFacts(l.assetId!),
            assetId: l.assetId!,
            claims: claims,
            ask: ask,
            now: now,
          ))
            o.serial.id,
        };
        for (final s in v.serials) {
          if (!free.contains(s.id)) {
            problems.add('${l.name}: ${s.name} is not free for these dates.');
          }
        }
      } else {
        final free = freeQuantity(
          rentableQty: v.asset?.qtyManual ?? 0,
          assetId: l.assetId!,
          claims: claims,
          ask: ask,
          now: now,
        );
        if (l.quantity > free) {
          problems.add(
            '${l.name}: ${_qty(l.quantity)} asked, '
            '${_qty(free)} free for these dates.',
          );
        }
      }
    }
    return problems;
  }

  @override
  Future<void> pickupAll(String orderId, {bool force = false}) async {
    final detail = await loadOrder(orderId);
    final order = detail.order;
    if (!OrderState.committed.contains(order.state)) {
      throw RuleException.one('Book the order before picking it up.');
    }
    final problems = pickupProblems(
      rentalContractSigned: order.sigRentalContract,
      forcedByAdmin: force,
    );
    for (final v in detail.lines) {
      if (!canPickUpLine(_facts(v))) continue;
      if (_facts(v).missingSerials) {
        problems.add('${v.line.name}: pick the units before handing it over.');
      }
      for (final s in v.serials) {
        if (s.state == SerialState.out && s.currentLineId != v.line.id) {
          problems.add('${s.name} is still out on another order.');
        }
      }
    }
    if (problems.isNotEmpty) throw RuleException(problems);

    final now = _clock();
    await db.transaction(() async {
      for (final v in detail.lines) {
        if (!canPickUpLine(_facts(v))) continue;
        await _setLine(
          v.line.id,
          OrderLinesCompanion(
            rentalState: const Value(RentalState.pickedUp),
            pickedUpAt: Value(now),
            pickedUpBy: Value(_userId()),
          ),
        );
        for (final s in v.serials) {
          await _setSerial(s.id, SerialState.out, v.line);
        }
        for (final p in await _partsOfLine(v.line)) {
          await _setPart(p.id, PartState.out, v.line);
        }
      }
      await _syncState(orderId);
    });
  }

  @override
  Future<void> returnLine(
    String lineId, {
    Map<String, UnitReturn>? units,
    Condition fallback = Condition.good,
  }) async {
    final line = await _line(lineId);
    if (line.rentalState == RentalState.returned) return;
    if (line.rentalState != RentalState.pickedUp) {
      throw RuleException.one(
        '${line.name} was never picked up, so it cannot be returned.',
      );
    }
    final now = _clock();
    final user = _userId();
    await db.transaction(() async {
      final serials = await _serialsOfLine(lineId);
      final checks = await _checksOfLine(lineId);

      Future<void> check({
        String? serialId,
        String? partId,
        required Condition condition,
        String? note,
      }) async {
        final existing = checks
            .where((c) => c.serialId == serialId && c.partId == partId)
            .firstOrNull;
        final values = ReturnChecksCompanion(
          condition: Value(condition),
          note: Value(note),
          returnedAt: Value(now),
          returnedBy: Value(user),
          updatedAt: _ts,
          dirty: _dirty,
        );
        if (existing != null) {
          await (db.update(
            db.returnChecks,
          )..where((c) => c.id.equals(existing.id))).write(values);
        } else {
          await db
              .into(db.returnChecks)
              .insert(
                values.copyWith(
                  lineId: Value(lineId),
                  orderId: Value(line.orderId),
                  serialId: Value(serialId),
                  partId: Value(partId),
                ),
              );
        }
      }

      // Only what is still out. Re-checking a unit already back would
      // overwrite the condition it was recorded in (a damage note lost).
      final serialsBack = {for (final c in checks) c.serialId};
      final partsBack = {for (final c in checks) c.partId};

      for (final p in await _partsOfLine(line)) {
        if (partsBack.contains(p.id)) continue;
        await check(partId: p.id, condition: fallback);
        await (db.update(db.parts)..where((x) => x.id.equals(p.id))).write(
          PartsCompanion(
            state: const Value(PartState.available),
            condition: Value(partConditionAfterReturn(fallback)),
            currentOrderId: const Value(null),
            currentLineId: const Value(null),
            updatedAt: _ts,
            dirty: _dirty,
          ),
        );
      }

      var allBack = true;
      if (serials.isNotEmpty) {
        final targets =
            units ??
            {
              for (final s in serials)
                if (!serialsBack.contains(s.id))
                  s.id: (condition: fallback, note: null),
            };
        for (final s in serials) {
          final t = targets[s.id];
          if (t == null) continue;
          await check(serialId: s.id, condition: t.condition, note: t.note);
          await (db.update(db.serials)..where((x) => x.id.equals(s.id))).write(
            SerialsCompanion(
              state: Value(serialStateAfterReturn(t.condition)),
              currentOrderId: const Value(null),
              currentLineId: const Value(null),
              updatedAt: _ts,
              dirty: _dirty,
            ),
          );
        }
        final back = {for (final c in await _checksOfLine(lineId)) c.serialId};
        allBack = serials.every((s) => back.contains(s.id));
      } else if (line.lineType != LineType.part) {
        await check(condition: fallback);
      }

      final worst = Condition.worst([
        for (final c in await _checksOfLine(lineId)) c.condition,
      ]);
      await _setLine(
        lineId,
        OrderLinesCompanion(
          conditionIn: Value(worst ?? fallback),
          rentalState: allBack
              ? const Value(RentalState.returned)
              : const Value.absent(),
          returnedAt: allBack ? Value(now) : const Value.absent(),
          returnedBy: allBack ? Value(user) : const Value.absent(),
        ),
      );
      await _syncState(line.orderId);
    });
  }

  @override
  Future<void> returnAll(String orderId) async {
    // Units nobody described come back good. The line's conditionIn is the
    // worst so far, and reusing it would send a clean twin to maintenance.
    for (final l in await _lines(orderId)) {
      if (l.rentalState == RentalState.pickedUp) {
        await returnLine(l.id);
      }
    }
  }

  @override
  Future<void> cancel(String orderId) async {
    final detail = await loadOrder(orderId);
    final problems = cancelProblems([for (final v in detail.lines) _facts(v)]);
    if (problems.isNotEmpty) throw RuleException(problems);
    await db.transaction(() async {
      for (final v in detail.lines) {
        await _releaseLine(v.line);
        if (v.line.rentalState == RentalState.booked) {
          await _setLine(
            v.line.id,
            const OrderLinesCompanion(rentalState: Value(RentalState.none)),
          );
        }
      }
      await updateOrder(
        orderId,
        const OrdersCompanion(state: Value(OrderState.cancelled)),
      );
    });
  }

  @override
  Future<void> resetToDraft(String orderId) async {
    final detail = await loadOrder(orderId);
    final problems = resetToDraftProblems([
      for (final v in detail.lines) _facts(v),
    ]);
    if (problems.isNotEmpty) throw RuleException(problems);
    await db.transaction(() async {
      for (final v in detail.lines) {
        await _releaseLine(v.line);
        await _setLine(
          v.line.id,
          const OrderLinesCompanion(rentalState: Value(RentalState.none)),
        );
      }
      await updateOrder(
        orderId,
        const OrdersCompanion(state: Value(OrderState.draft)),
      );
    });
  }

  @override
  Future<({Asset? asset, Serial? serial})> findByCode(String code) async {
    final c = code.trim();
    final serial =
        await (db.select(db.serials)
              ..where(
                (s) => _alive(s) & (s.barcode.equals(c) | s.name.equals(c)),
              )
              ..limit(1))
            .getSingleOrNull();
    if (serial != null) {
      final asset = await (db.select(
        db.assets,
      )..where((a) => a.id.equals(serial.assetId))).getSingleOrNull();
      return (asset: asset, serial: serial);
    }
    final asset =
        await (db.select(db.assets)
              ..where(
                (a) => _alive(a) & (a.barcode.equals(c) | a.code.equals(c)),
              )
              ..limit(1))
            .getSingleOrNull();
    return (asset: asset, serial: null);
  }

  @override
  Future<String?> currentOrderFor({String? serialId, String? assetId}) async {
    if (serialId != null) {
      // A unit nobody holds has no order, even if its twins are out.
      final s = await (db.select(
        db.serials,
      )..where((x) => x.id.equals(serialId))).getSingleOrNull();
      return s?.currentOrderId;
    }
    if (assetId == null) return null;
    final query =
        db.select(db.orders).join([
            innerJoin(
              db.orderLines,
              db.orderLines.orderId.equalsExp(db.orders.id),
            ),
          ])
          ..where(
            db.orderLines.assetId.equals(assetId) &
                db.orderLines.deleted.equals(false) &
                db.orders.deleted.equals(false) &
                db.orders.state.isInValues(OrderState.committed.toList()),
          )
          ..orderBy([OrderingTerm.desc(db.orders.dateStart)])
          ..limit(1);
    final row = await query.getSingleOrNull();
    return row?.readTable(db.orders).id;
  }

  // ============================================================ editor

  @override
  Future<List<Customer>> customers({String? search}) {
    final query = db.select(db.customers)
      ..where((c) => _alive(c))
      ..orderBy([(c) => OrderingTerm.asc(c.name)]);
    final term = search?.trim();
    if (term != null && term.isNotEmpty) {
      final like = '%$term%';
      query.where((c) => c.name.like(like) | c.phone.like(like));
    }
    return query.get();
  }

  @override
  Future<String> createCustomer({required String name, String? phone}) async {
    final clean = name.trim();
    if (clean.isEmpty) throw RuleException.one('The customer needs a name.');
    final p = phone?.trim();
    final row = await db
        .into(db.customers)
        .insertReturning(
          CustomersCompanion.insert(
            name: clean,
            phone: Value(p == null || p.isEmpty ? null : p),
            updatedAt: _ts,
          ),
        );
    return row.id;
  }

  @override
  Future<List<Part>> rentableParts({String? search}) {
    final query = db.select(db.parts)
      ..where(
        (p) =>
            _alive(p) &
            p.active.equals(true) &
            p.kind.equalsValue(PartKind.mandatory).not(),
      )
      ..orderBy([(p) => OrderingTerm.asc(p.name)]);
    final term = search?.trim();
    if (term != null && term.isNotEmpty) {
      final like = '%$term%';
      query.where((p) => p.name.like(like) | p.code.like(like));
    }
    return query.get();
  }

  @override
  Future<void> updateLine(
    String lineId, {
    String? name,
    double? quantity,
    double? priceDay,
    double? discount,
  }) async {
    final line = await _line(lineId);
    if (line.rentalState != RentalState.none) {
      throw RuleException.one(
        'Booked lines are fixed. Put the order back to draft to change them.',
      );
    }
    if (quantity != null && quantity <= 0) {
      throw RuleException.one('Quantity must be more than zero.');
    }
    if (priceDay != null && priceDay < 0) {
      throw RuleException.one('The price cannot be negative.');
    }
    if (discount != null && (discount < 0 || discount > 100)) {
      throw RuleException.one('The discount is a percent from 0 to 100.');
    }
    await _setLine(
      lineId,
      OrderLinesCompanion(
        name: name == null ? const Value.absent() : Value(name),
        quantity: quantity == null ? const Value.absent() : Value(quantity),
        priceDay: priceDay == null ? const Value.absent() : Value(priceDay),
        discount: discount == null ? const Value.absent() : Value(discount),
      ),
    );
  }

  // ============================================================ paperwork

  @override
  Future<Role> currentRole() async {
    final id = _userId();
    if (id == null) return Role.admin;
    final p = await (db.select(
      db.profiles,
    )..where((x) => x.id.equals(id))).getSingleOrNull();
    return p?.role ?? Role.office;
  }

  @override
  Future<List<DocumentType>> documentTypes() =>
      (db.select(db.documentTypes)
            ..where((d) => _alive(d) & d.active.equals(true))
            ..orderBy([(d) => OrderingTerm.asc(d.sequence)]))
          .get();

  @override
  Future<Set<String>> orderDocuments(String orderId) async => {
    for (final d in await (db.select(
      db.orderDocuments,
    )..where((d) => d.orderId.equals(orderId) & _alive(d))).get())
      d.documentTypeId,
  };

  @override
  Future<void> setOrderDocuments(
    String orderId,
    Set<String> documentTypeIds,
  ) async {
    final rows = await (db.select(
      db.orderDocuments,
    )..where((d) => d.orderId.equals(orderId))).get();
    await db.transaction(() async {
      final have = <String>{};
      for (final r in rows) {
        final keep =
            documentTypeIds.contains(r.documentTypeId) &&
            have.add(r.documentTypeId);
        if (keep != r.deleted) continue;
        await (db.update(
          db.orderDocuments,
        )..where((d) => d.id.equals(r.id))).write(
          OrderDocumentsCompanion(
            deleted: Value(!keep),
            updatedAt: _ts,
            dirty: _dirty,
          ),
        );
      }
      for (final id in documentTypeIds.difference(have)) {
        await db
            .into(db.orderDocuments)
            .insert(
              OrderDocumentsCompanion.insert(
                orderId: orderId,
                documentTypeId: id,
                updatedAt: _ts,
              ),
            );
      }
    });
  }

  @override
  Future<void> markDocumentsReturned(String orderId) => updateOrder(
    orderId,
    OrdersCompanion(
      documentsReturnedAt: Value(_clock()),
      documentsReturnedBy: Value(_userId()),
    ),
  );

  @override
  Future<String> addPhoto({
    required String localPath,
    String? orderId,
    String? lineId,
    String? serialId,
    String? note,
  }) async {
    final row = await db
        .into(db.photos)
        .insertReturning(
          PhotosCompanion.insert(
            localPath: Value(localPath),
            orderId: Value(orderId),
            lineId: Value(lineId),
            serialId: Value(serialId),
            note: Value(note),
            takenAt: Value(_clock()),
            updatedAt: _ts,
          ),
        );
    return row.id;
  }

  @override
  Future<List<Photo>> photos(String orderId) =>
      (db.select(db.photos)
            ..where((p) => p.orderId.equals(orderId) & _alive(p))
            ..orderBy([(p) => OrderingTerm.asc(p.takenAt)]))
          .get();

  // ============================================================ helpers

  /// Hand back what a line holds but has not sent out. Only units this line
  /// itself reserved: a unit reserved to another booking stays put.
  Future<void> _releaseLine(OrderLine line) async {
    for (final s in await _serialsOfLine(line.id)) {
      if (s.state == SerialState.reserved && s.currentLineId == line.id) {
        await (db.update(db.serials)..where((x) => x.id.equals(s.id))).write(
          SerialsCompanion(
            state: const Value(SerialState.available),
            currentOrderId: const Value(null),
            currentLineId: const Value(null),
            updatedAt: _ts,
            dirty: _dirty,
          ),
        );
      }
    }
    for (final p in await _partsOfLine(line)) {
      if (p.state == PartState.reserved && p.currentLineId == line.id) {
        await (db.update(db.parts)..where((x) => x.id.equals(p.id))).write(
          PartsCompanion(
            state: const Value(PartState.available),
            currentOrderId: const Value(null),
            currentLineId: const Value(null),
            updatedAt: _ts,
            dirty: _dirty,
          ),
        );
      }
    }
  }

  Future<void> _setLine(String id, OrderLinesCompanion changes) =>
      (db.update(db.orderLines)..where((l) => l.id.equals(id))).write(
        changes.copyWith(updatedAt: _ts, dirty: _dirty),
      );

  Future<void> _setSerial(String id, SerialState state, OrderLine line) =>
      (db.update(db.serials)..where((s) => s.id.equals(id))).write(
        SerialsCompanion(
          state: Value(state),
          currentOrderId: Value(line.orderId),
          currentLineId: Value(line.id),
          updatedAt: _ts,
          dirty: _dirty,
        ),
      );

  Future<void> _setPart(String id, PartState state, OrderLine line) =>
      (db.update(db.parts)..where((p) => p.id.equals(id))).write(
        PartsCompanion(
          state: Value(state),
          currentOrderId: Value(line.orderId),
          currentLineId: Value(line.id),
          updatedAt: _ts,
          dirty: _dirty,
        ),
      );

  Future<void> _syncState(String orderId) async {
    final detail = await loadOrder(orderId);
    final next = deriveOrderState(detail.order.state, [
      for (final v in detail.lines) _facts(v),
    ]);
    if (next != detail.order.state) {
      await updateOrder(orderId, OrdersCompanion(state: Value(next)));
    }
  }

  static String _qty(double q) =>
      q == q.roundToDouble() ? q.toInt().toString() : q.toStringAsFixed(2);
}

/// Order numbers from this device alone: `RO/<year>/0001`. Good for a single
/// device; with several, the Supabase gateway takes over.
class LocalBookingGateway implements BookingGateway {
  LocalBookingGateway(this.db);
  final RentoryDatabase db;

  @override
  Future<String> confirmBooking(String orderId, DateTime bookedAt) async {
    final existing = await (db.select(
      db.orders,
    )..where((o) => o.id.equals(orderId))).getSingle();
    if (existing.number != null) return existing.number!;
    final prefix = 'RO/${bookedAt.year}/';
    final rows = await (db.select(
      db.orders,
    )..where((o) => o.number.like('$prefix%'))).get();
    var max = 0;
    for (final o in rows) {
      final n = int.tryParse(o.number!.substring(prefix.length)) ?? 0;
      if (n > max) max = n;
    }
    return '$prefix${(max + 1).toString().padLeft(4, '0')}';
  }
}
