import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';

import '../../domain/enums.dart';
import '../../domain/rules/availability.dart' as availability;
import '../billing.dart';
import '../local/database.dart';
import '../local/local_repository.dart';
import '../repository.dart';
import 'odoo_client.dart';
import 'odoo_sync.dart';

/// Odoo mode. Reads come from the local copy of Odoo's data. Every change
/// goes to Odoo first, through Rentory's own actions where it has them, so
/// Odoo's rules have the last word; then the copy is pulled again. Order
/// photos are the exception: they never leave the phone in any mode.
///
/// Methods built from others in [LocalRepository] (scanning onto an order,
/// for one) reach Odoo through the overrides here.
class OdooRepository extends LocalRepository {
  OdooRepository(super.db, this.engine, {super.clock})
    : super(
        gateway: const OdooBookingGateway(),
        currentUserId: () => engine.currentUserId,
      );

  final OdooSyncEngine engine;
  OdooClient get client => engine.client;

  static const message =
      'Connected to Odoo: this change is not sent to Odoo from the app yet. '
      'Make it in Odoo for now.';

  static Never _no() => throw RuleException.one(message);

  Future<int> _oid(String table, String id) => odooIdOf(db, table, id);

  Future<Object> _ref(String table, String? id) async =>
      id == null ? false : await _oid(table, id);

  /// Runs in the company Rentory's records live in, so what is created here
  /// lands next to them rather than in the company the user has open.
  Future<Map<String, Object?>> _context([Map<String, Object?>? more]) async => {
    'allowed_company_ids': [await engine.rentoryCompany()],
    ...?more,
  };

  /// One call to Odoo; Odoo's refusal comes back as a rule's, and [order]'s
  /// records are read again afterwards.
  Future<Object?> _call(
    String model,
    String method,
    Map<String, Object?> args, {
    int? order,
    Map<String, Object?>? context,
  }) async {
    final ctx = await _context(context);
    return odooCall(
      engine,
      order: order,
      () => client.call(model, method, {...args, 'context': ctx}),
    );
  }

  Future<int> _create(
    String model,
    Map<String, Object?> vals, {
    int? order,
  }) async {
    final created = await _call(model, 'create', {
      'vals_list': [vals],
    }, order: order);
    final id = created is List ? created.first : created;
    return (id as num).toInt();
  }

  Future<void> _write(
    String model,
    List<int> ids,
    Map<String, Object?> vals, {
    int? order,
  }) => _call(model, 'write', {'ids': ids, 'vals': vals}, order: order);

  Future<int> _orderOfLine(String lineId) async {
    final line = await (db.select(
      db.orderLines,
    )..where((l) => l.id.equals(lineId))).getSingle();
    return _oid('orders', line.orderId);
  }

  // ------------------------------------------------------------ orders

  @override
  Future<String> createOrder({
    String? customerId,
    String? customerName,
    String? customerPhone,
    required DateTime start,
    required DateTime end,
  }) async {
    Customer? customer;
    if (customerId != null) {
      customer = await (db.select(
        db.customers,
      )..where((c) => c.id.equals(customerId))).getSingleOrNull();
    }
    final name = customerName ?? customer?.name;
    final phone = customerPhone ?? customer?.phone;
    if ((phone ?? '').trim().isEmpty) {
      throw RuleException.one(
        'Odoo needs a phone number for the customer. Add one to the order.',
      );
    }
    final id = await _create('rentory.order', {
      'partner_id': await _ref('customers', customerId),
      'customer_name': name ?? false,
      'customer_phone': phone,
      'date_start': odooDateTime(start),
      'date_end': odooDateTime(end),
    });
    await engine.refetchOrder(id);
    return engine.ids.of('rentory.order', id);
  }

  @override
  Future<void> updateOrder(String orderId, OrdersCompanion changes) async {
    final vals = await orderValues(changes);
    final id = await _oid('orders', orderId);
    await _write('rentory.order', [id], vals, order: id);
  }

  @override
  Future<void> setLateDays(String orderId, int? days) async {
    if (days != null && days < 0) {
      throw RuleException.one('Late days cannot be below zero.');
    }
    final id = await _oid('orders', orderId);
    await _write(
      'rentory.order',
      [id],
      days == null
          ? {'late_days_edited': false}
          : {
              'late_fee_manual': true,
              'late_days_override': days,
              'late_days_edited': true,
            },
      order: id,
    );
  }

  @override
  Future<void> setItemsExamined(String orderId, bool examined) =>
      updateOrder(orderId, OrdersCompanion(itemsExamined: Value(examined)));

  /// Odoo field values for the order fields the app edits. Anything else in
  /// [c] is refused rather than silently dropped.
  Future<Map<String, Object?>> orderValues(OrdersCompanion c) async {
    final vals = <String, Object?>{};
    void put<T>(String field, Value<T> v, [Object? Function(T)? to]) {
      if (v.present) vals[field] = to == null ? v.value : to(v.value);
    }

    put('discount_type', c.discountType, (DiscountType t) => t.key);
    put('discount_value', c.discountValue);
    put('amount_deposit', c.amountDeposit);
    put('amount_paid', c.amountPaid);
    put('note', c.note, (String? n) => n ?? false);
    put('customer_name', c.customerName, (String? n) => n ?? false);
    put('customer_phone', c.customerPhone, (String? n) => n ?? false);
    put('date_start', c.dateStart, odooDateTime);
    put('date_end', c.dateEnd, odooDateTime);
    put('allow_line_dates_outside', c.allowLineDatesOutside);
    put('sig_rental_contract', c.sigRentalContract);
    put('sig_pickup_return_receipt', c.sigPickupReturnReceipt);
    put('sig_loan_contract', c.sigLoanContract);
    put('items_captured', c.itemsCaptured);
    put('items_examined', c.itemsExamined);
    put('late_fee_manual', c.lateFeeManual);
    put('late_days_edited', c.lateDaysEdited);
    put('late_days_override', c.lateDaysOverride);
    put('photos_url', c.photosUrl, (String? n) => n ?? false);
    put('signature_name', c.signatureName, (String? n) => n ?? false);
    put('signature_date', c.signatureDate, odooDateTime);
    put(
      'signature_target',
      c.signatureTarget,
      (SignatureTarget? t) => t?.key ?? false,
    );
    put(
      'capture_method',
      c.captureMethod,
      (CaptureMethod? m) => m?.key ?? false,
    );
    if (c.customerId.present) {
      vals['partner_id'] = await _ref('customers', c.customerId.value);
    }
    // The signature is a picture on this device; Odoo keeps the image.
    if (c.signaturePath.present) {
      final path = c.signaturePath.value;
      vals['signature'] = path == null
          ? false
          : base64Encode(await File(path).readAsBytes());
    }

    const handled = {
      'discount_type', 'discount_value', 'amount_deposit', 'amount_paid',
      'note', 'customer_name', 'customer_phone', 'date_start', 'date_end',
      'allow_line_dates_outside', 'sig_rental_contract',
      'sig_pickup_return_receipt', 'sig_loan_contract', 'items_captured',
      'items_examined', 'late_fee_manual', 'late_days_edited',
      'late_days_override', 'photos_url', 'capture_method',
      'signature_name', 'signature_date', 'signature_target',
      'signature_path', 'customer_id',
      // Bookkeeping the local repository adds; meaningless to Odoo.
      'updated_at', 'dirty',
    };
    final other = c.toColumns(false).keys.where((k) => !handled.contains(k));
    if (other.isNotEmpty || vals.isEmpty) _no();
    return vals;
  }

  @override
  Future<void> cancel(String orderId) async {
    final id = await _oid('orders', orderId);
    await _call('rentory.order', 'action_cancel', {
      'ids': [id],
    }, order: id);
  }

  @override
  Future<void> resetToDraft(String orderId) async {
    final id = await _oid('orders', orderId);
    await _call('rentory.order', 'action_draft', {
      'ids': [id],
    }, order: id);
  }

  /// Odoo orders cannot be archived: one that never went anywhere is
  /// deleted, anything with history stays on the list (cancel it instead).
  @override
  Future<Removal> removeOrder(String orderId) async {
    final detail = await loadOrder(orderId);
    final o = detail.order;
    final everOut = detail.lines.any((v) => v.line.rentalState.goneOut);
    if (everOut ||
        (o.state != OrderState.draft && o.state != OrderState.cancelled)) {
      throw RuleException.one(
        'Odoo keeps orders that were booked or went out. Cancel it instead; '
        'only drafts and cancelled orders nothing left on can be deleted.',
      );
    }
    final id = await _oid('orders', orderId);
    await _call('rentory.order', 'unlink', {
      'ids': [id],
    });
    await engine.markGone('orders', [orderId]);
    return Removal.deleted;
  }

  @override
  Future<void> restoreOrder(String orderId) async => _no();

  @override
  Future<void> setOrderDocuments(
    String orderId,
    Set<String> documentTypeIds,
  ) async {
    final id = await _oid('orders', orderId);
    await _write(
      'rentory.order',
      [id],
      {
        'document_ids': [
          [
            6,
            0,
            [for (final d in documentTypeIds) await _oid('document_types', d)],
          ],
        ],
      },
      order: id,
    );
  }

  @override
  Future<void> markDocumentsReturned(String orderId) async {
    final id = await _oid('orders', orderId);
    await _call('rentory.order', 'action_documents_returned', {
      'ids': [id],
    }, order: id);
  }

  // ------------------------------------------------------------- lines

  @override
  Future<String> addLine(
    String orderId, {
    required LineType type,
    String? assetId,
    String? name,
    double quantity = 1,
    double? priceDay,
    double discount = 0,
    List<String> serialIds = const [],
  }) async {
    final order = await _oid('orders', orderId);
    Asset? asset;
    if (assetId != null) {
      asset = await (db.select(
        db.assets,
      )..where((a) => a.id.equals(assetId))).getSingle();
    }
    // The form fills these from the asset in Odoo; the API does not.
    final lines = await (db.select(
      db.orderLines,
    )..where((l) => l.orderId.equals(orderId) & l.deleted.equals(false))).get();
    final last = lines.fold<int>(0, (a, l) => l.sequence > a ? l.sequence : a);
    final id = await _create('rentory.order.line', {
      'order_id': order,
      'line_type': type.key,
      'sequence': last + 10,
      'name': name ?? asset?.name ?? '',
      if (type != LineType.section) ...{
        'asset_id': await _ref('assets', assetId),
        'quantity': serialIds.isNotEmpty
            ? serialIds.length.toDouble()
            : quantity,
        'price_day': priceDay ?? asset?.rentalPriceDay ?? 0,
        'discount': discount,
      },
      if (serialIds.isNotEmpty)
        'serial_ids': [
          [
            6,
            0,
            [for (final s in serialIds) await _oid('serials', s)],
          ],
        ],
    }, order: order);
    return engine.ids.of('rentory.order.line', id);
  }

  @override
  Future<void> updateLine(
    String lineId, {
    String? name,
    double? quantity,
    double? priceDay,
    double? discount,
  }) async {
    final vals = {
      'name': ?name,
      'quantity': ?quantity,
      'price_day': ?priceDay,
      'discount': ?discount,
    };
    if (vals.isEmpty) return;
    await _write(
      'rentory.order.line',
      [await _oid('order_lines', lineId)],
      vals,
      order: await _orderOfLine(lineId),
    );
  }

  @override
  Future<void> removeLine(String lineId) async {
    final order = await _orderOfLine(lineId);
    await _call('rentory.order.line', 'unlink', {
      'ids': [await _oid('order_lines', lineId)],
    }, order: order);
    await engine.markGone('order_lines', [lineId]);
  }

  @override
  Future<void> moveLines(String orderId, List<String> lineIds) async {
    final order = await _oid('orders', orderId);
    for (final (i, lineId) in lineIds.indexed) {
      await client.call('rentory.order.line', 'write', {
        'ids': [await _oid('order_lines', lineId)],
        'vals': {'sequence': (i + 1) * 10},
        'context': await _context(),
      });
    }
    await odooCall(engine, order: order, () async => null);
  }

  @override
  Future<void> setLineSerials(String lineId, List<String> serialIds) =>
      _setUnits(lineId, serialIds);

  Future<void> _setUnits(
    String lineId,
    List<String> serialIds, {
    double? quantity,
  }) async {
    final line = await (db.select(
      db.orderLines,
    )..where((l) => l.id.equals(lineId))).getSingle();
    if (line.rentalState.goneOut) {
      throw RuleException.one(
        '${line.name} is already out. Add a new line for more units.',
      );
    }
    await _write(
      'rentory.order.line',
      [await _oid('order_lines', lineId)],
      {
        'serial_ids': [
          [
            6,
            0,
            [for (final s in serialIds) await _oid('serials', s)],
          ],
        ],
        'quantity': quantity ?? serialIds.length.toDouble(),
      },
      order: await _oid('orders', line.orderId),
    );
  }

  @override
  Future<int> autofillSerials(String lineId) async {
    final line = await (db.select(
      db.orderLines,
    )..where((l) => l.id.equals(lineId))).getSingle();
    final wanted = line.quantity.round();
    final picked = availability.autofillSerials(
      await serialOptions(lineId),
      wanted,
    );
    await _setUnits(lineId, [
      for (final s in picked) s.id,
    ], quantity: line.quantity);
    return wanted - picked.length;
  }

  @override
  Future<void> setLineDates(
    String lineId,
    DateTime? start,
    DateTime? end,
  ) async {
    final id = await _oid('order_lines', lineId);
    final order = await _orderOfLine(lineId);
    if (start == null && end == null) {
      await _call('rentory.order.line', 'action_resync_dates', {
        'ids': [id],
      }, order: order);
      return;
    }
    await _write(
      'rentory.order.line',
      [id],
      {
        'date_start': ?(start == null ? null : odooDateTime(start)),
        'date_end': ?(end == null ? null : odooDateTime(end)),
        'dates_overridden': true,
      },
      order: order,
    );
  }

  // --------------------------------------------------------- lifecycle

  @override
  Future<void> book(String orderId, {List<String>? lineIds}) async {
    final detail = await loadOrder(orderId);
    final order = await _oid('orders', orderId);
    final reopen =
        detail.order.state == OrderState.draft ||
        detail.order.state == OrderState.cancelled;
    if (lineIds == null && reopen) {
      await _call('rentory.order', 'action_book', {
        'ids': [order],
      }, order: order);
      return;
    }
    final ids = [
      for (final v in detail.lines)
        if (lineIds == null
            ? v.line.rentalState == RentalState.none &&
                  v.line.lineType != LineType.section
            : lineIds.contains(v.line.id))
          await _oid('order_lines', v.line.id),
    ];
    if (ids.isEmpty) return;
    await _call('rentory.order.line', 'action_book_line', {
      'ids': ids,
    }, order: order);
  }

  @override
  Future<void> unbookLine(String lineId) async {
    await _call('rentory.order.line', 'action_reset_line', {
      'ids': [await _oid('order_lines', lineId)],
    }, order: await _orderOfLine(lineId));
  }

  @override
  Future<void> pickupAll(
    String orderId, {
    bool force = false,
    List<String>? lineIds,
  }) async {
    final order = await _oid('orders', orderId);
    // A manager's override, checked again by Odoo against their groups.
    final context = force ? const {'rentory_force': true} : null;
    if (lineIds == null) {
      await _call(
        'rentory.order',
        'action_pickup_all',
        {
          'ids': [order],
        },
        order: order,
        context: context,
      );
      return;
    }
    await _call(
      'rentory.order.line',
      'action_pickup',
      {
        'ids': [for (final l in lineIds) await _oid('order_lines', l)],
      },
      order: order,
      context: context,
    );
  }

  /// Through Rentory's return wizard: one row per unit coming back, each
  /// with its own condition, exactly as the counter does it in Odoo.
  @override
  Future<void> returnLine(
    String lineId, {
    Map<String, UnitReturn>? units,
    Condition fallback = Condition.good,
  }) async {
    final detail = await loadOrder(
      (await (db.select(
        db.orderLines,
      )..where((l) => l.id.equals(lineId))).getSingle()).orderId,
    );
    final v = detail.lines.firstWhere((v) => v.line.id == lineId);
    if (v.line.rentalState != RentalState.pickedUp) {
      throw RuleException.one(
        '${v.line.name} was never picked up, so it cannot be returned.',
      );
    }
    final back = {for (final c in v.returnChecks) c.serialId};
    final line = await _oid('order_lines', lineId);
    final rows = <Map<String, Object?>>[];
    if (v.serials.isEmpty) {
      rows.add({
        'order_line_id': line,
        'selected': true,
        'condition_in': fallback.key,
      });
    } else {
      for (final s in v.serials) {
        if (back.contains(s.id)) continue;
        if (units != null && !units.containsKey(s.id)) continue;
        final u = units?[s.id];
        rows.add({
          'order_line_id': line,
          'serial_id': await _oid('serials', s.id),
          'selected': true,
          'condition_in': (u?.condition ?? fallback).key,
          'condition_note': u?.note ?? false,
        });
      }
    }
    if (rows.isEmpty) return;
    final order = await _oid('orders', detail.order.id);
    final wizard = await _create('rentory.return.wizard', {
      'order_id': order,
      'line_ids': [
        for (final r in rows) [0, 0, r],
      ],
    });
    await _call('rentory.return.wizard', 'action_confirm', {
      'ids': [wizard],
    }, order: order);
  }

  @override
  Future<void> returnAll(String orderId) async {
    final id = await _oid('orders', orderId);
    await _call('rentory.order', 'action_return_all', {
      'ids': [id],
    }, order: id);
  }

  // --------------------------------------------------------- customers

  @override
  Future<String> createCustomer({required String name, String? phone}) async {
    final id = await _create('res.partner', {
      'name': name,
      'phone': phone ?? false,
      'customer_rank': 1,
    });
    await engine.refetchPartners([id]);
    return engine.ids.of('res.partner', id);
  }

  // --------------------------------------------------------- inventory

  @override
  Future<String> createCategory(String name) async {
    final id = await _create('rentory.asset.category', {'name': name});
    await engine.refetch('rentory.asset.category', [id]);
    return engine.ids.of('rentory.asset.category', id);
  }

  @override
  Future<String> createLocation(String name) async {
    final id = await _create('rentory.location', {'name': name});
    await engine.refetch('rentory.location', [id]);
    return engine.ids.of('rentory.location', id);
  }

  /// Odoo values for an asset's fields. Unknown ones are refused.
  Future<Map<String, Object?>> assetValues(AssetsCompanion c) async {
    final vals = <String, Object?>{};
    void put<T>(String field, Value<T> v, [Object? Function(T)? to]) {
      if (v.present) vals[field] = to == null ? v.value : to(v.value);
    }

    Object? text(String? s) => (s ?? '').isEmpty ? false : s;
    put('name', c.name);
    put('code', c.code, text);
    put('barcode', c.barcode, text);
    put('tracking', c.tracking, (Tracking t) => t.key);
    put('rental_ok', c.rentalOk);
    put('qty_manual', c.qtyManual);
    put('rental_price_day', c.rentalPriceDay);
    put('declared_value', c.declaredValue);
    put('notes', c.notes, text);
    put('active', c.active);
    put('evaluation_url', c.evaluationUrl, text);
    put('acquisition_date', c.acquisitionDate, odooDate);
    put('unit_cost', c.unitCost);
    put('ownership', c.ownership, (Ownership o) => o.key);
    put('supplier_name', c.supplierName, text);
    put('supplier_phone', c.supplierPhone, text);
    put('supplier_reference', c.supplierReference, text);
    put('rented_in_date_start', c.rentedInDateStart, odooDateTime);
    put('rented_in_date_end', c.rentedInDateEnd, odooDateTime);
    put('rented_in_cost_day', c.rentedInCostDay);
    put('rented_in_deposit', c.rentedInDeposit);
    put(
      'rented_in_condition_in',
      c.rentedInConditionIn,
      (LoanCondition l) => l.key,
    );
    put(
      'rented_in_condition_out',
      c.rentedInConditionOut,
      (LoanCondition? l) => l?.key ?? false,
    );
    put('rented_in_note', c.rentedInNote, text);
    if (c.categoryId.present) {
      vals['category_id'] = await _ref('categories', c.categoryId.value);
    }
    if (c.locationId.present) {
      vals['location_id'] = await _ref('locations', c.locationId.value);
    }
    if (c.sourceId.present) {
      vals['source_id'] = await _ref('customers', c.sourceId.value);
    }
    const handled = {
      'name',
      'code',
      'barcode',
      'tracking',
      'rental_ok',
      'qty_manual',
      'rental_price_day',
      'declared_value',
      'notes',
      'active',
      'evaluation_url',
      'acquisition_date',
      'unit_cost',
      'ownership',
      'supplier_name',
      'supplier_phone',
      'supplier_reference',
      'rented_in_date_start',
      'rented_in_date_end',
      'rented_in_cost_day',
      'rented_in_deposit',
      'rented_in_condition_in',
      'rented_in_condition_out',
      'rented_in_note',
      'category_id',
      'location_id',
      'source_id',
      'updated_at',
      'dirty',
      'id',
    };
    final other = c.toColumns(false).keys.where((k) => !handled.contains(k));
    if (other.isNotEmpty) _no();
    return vals;
  }

  @override
  Future<String> createAsset({
    required String name,
    String? code,
    String? barcode,
    String? categoryId,
    String? locationId,
    required Tracking tracking,
    double quantity = 1,
    List<String> units = const [],
    double priceDay = 0,
    double declaredValue = 0,
    String? notes,
    AssetsCompanion more = const AssetsCompanion(),
  }) async {
    final vals = await assetValues(
      more.copyWith(
        name: Value(name),
        code: Value(code),
        barcode: Value(barcode),
        categoryId: Value(categoryId),
        locationId: Value(locationId),
        tracking: Value(tracking),
        qtyManual: Value(tracking == Tracking.none ? quantity : 0),
        rentalPriceDay: Value(priceDay),
        declaredValue: Value(declaredValue),
        notes: Value(notes),
      ),
    );
    final id = await _create('rentory.asset', vals);
    if (tracking == Tracking.serial && units.isNotEmpty) {
      await _create('rentory.asset.serial', {
        'asset_id': id,
        'name': units.first,
      });
      for (final unit in units.skip(1)) {
        await _create('rentory.asset.serial', {'asset_id': id, 'name': unit});
      }
    }
    await engine.refetchAsset(id);
    return engine.ids.of('rentory.asset', id);
  }

  @override
  Future<void> updateAsset(String assetId, AssetsCompanion changes) async {
    final vals = await assetValues(changes);
    if (vals.isEmpty) return;
    final id = await _oid('assets', assetId);
    await _write('rentory.asset', [id], vals);
    await engine.refetchAsset(id);
  }

  @override
  Future<void> changeTracking(
    String assetId,
    Tracking tracking, {
    List<String> units = const [],
    double? quantity,
  }) async {
    final id = await _oid('assets', assetId);
    await _write(
      'rentory.asset',
      [id],
      {
        'tracking': tracking.key,
        if (tracking == Tracking.none && quantity != null)
          'qty_manual': quantity,
      },
    );
    if (tracking == Tracking.serial) {
      for (final unit in units) {
        await _create('rentory.asset.serial', {'asset_id': id, 'name': unit});
      }
    }
    await engine.refetchAsset(id);
  }

  /// Archived in Odoo when anything ever used it, deleted otherwise.
  @override
  Future<Removal> removeAsset(String assetId) async {
    final id = await _oid('assets', assetId);
    final used = await db
        .customSelect(
          'SELECT count(*) AS n FROM order_lines '
          'WHERE asset_id = ? AND deleted = 0',
          variables: [Variable.withString(assetId)],
        )
        .getSingle();
    if (used.read<int>('n') > 0) {
      await _write('rentory.asset', [id], {'active': false});
      await engine.refetchAsset(id);
      return Removal.archived;
    }
    await _call('rentory.asset', 'unlink', {
      'ids': [id],
    });
    await engine.markGone('assets', [assetId]);
    return Removal.deleted;
  }

  @override
  Future<void> restoreAsset(String assetId) async {
    final id = await _oid('assets', assetId);
    await _write('rentory.asset', [id], {'active': true});
    await engine.refetchAsset(id);
  }

  @override
  Future<void> setAssetStatus(String assetId, AssetManualState? state) async {
    final id = await _oid('assets', assetId);
    await _call(
      'rentory.asset',
      switch (state) {
        AssetManualState.maintenance => 'action_set_maintenance',
        AssetManualState.retired => 'action_set_retired',
        null => 'action_reset_status',
      },
      {
        'ids': [id],
      },
    );
    await engine.refetchAsset(id);
  }

  @override
  Future<void> giveBack(
    String assetId, {
    required LoanCondition condition,
    String? note,
  }) async {
    final id = await _oid('assets', assetId);
    await _write(
      'rentory.asset',
      [id],
      {
        'rented_in_condition_out': condition.key,
        if (note != null && note.isNotEmpty) 'rented_in_note': note,
      },
    );
    await _call('rentory.asset', 'action_rented_in_give_back', {
      'ids': [id],
    });
    await engine.refetchAsset(id);
  }

  @override
  Future<void> updateUnit(String serialId, SerialsCompanion changes) async {
    final c = changes;
    final vals = <String, Object?>{
      if (c.name.present) 'name': c.name.value,
      if (c.note.present) 'note': c.note.value ?? false,
      if (c.declaredValue.present) 'declared_value': c.declaredValue.value,
      if (c.unitCost.present) 'unit_cost': c.unitCost.value,
      if (c.evaluationUrl.present)
        'evaluation_url': c.evaluationUrl.value ?? false,
      if (c.acquisitionDate.present)
        'acquisition_date': odooDate(c.acquisitionDate.value),
      if (c.active.present) 'active': c.active.value,
    };
    if (c.locationId.present) {
      vals['location_id'] = await _ref('locations', c.locationId.value);
    }
    if (c.sourceId.present) {
      vals['source_id'] = await _ref('customers', c.sourceId.value);
    }
    const handled = {
      'name',
      'note',
      'declared_value',
      'unit_cost',
      'evaluation_url',
      'acquisition_date',
      'active',
      'location_id',
      'source_id',
      'updated_at',
      'dirty',
      'id',
    };
    if (c.toColumns(false).keys.any((k) => !handled.contains(k))) _no();
    if (vals.isEmpty) return;
    final id = await _oid('serials', serialId);
    await _write('rentory.asset.serial', [id], vals);
    await engine.refetch('rentory.asset.serial', [id]);
  }

  @override
  Future<void> setUnitState(String serialId, SerialState state) async {
    final id = await _oid('serials', serialId);
    final method = switch (state) {
      SerialState.available => 'action_set_available',
      SerialState.maintenance => 'action_set_maintenance',
      SerialState.lost => 'action_set_lost',
      SerialState.retired => 'action_set_retired',
      _ => throw RuleException.one(
        'A unit is reserved or sent out by its orders, not by hand.',
      ),
    };
    await _call('rentory.asset.serial', method, {
      'ids': [id],
    });
    await engine.refetch('rentory.asset.serial', [id]);
  }

  @override
  Future<void> addUnits(String assetId, List<String> names) async {
    final id = await _oid('assets', assetId);
    for (final name in names) {
      await _create('rentory.asset.serial', {'asset_id': id, 'name': name});
    }
    await engine.refetchAsset(id);
  }

  // ------------------------------------------------------------ photos

  /// Asset and unit photos go to Odoo's galleries. Pickup and return photos
  /// are attached to the order in Odoo and kept on this device too, since
  /// Odoo has no gallery for them.
  @override
  Future<String> addPhoto({
    required String localPath,
    String? assetId,
    String? orderId,
    String? lineId,
    String? serialId,
    String? note,
  }) async {
    final data = base64Encode(await File(localPath).readAsBytes());
    if (orderId != null || lineId != null) {
      final order = orderId != null
          ? await _oid('orders', orderId)
          : await _orderOfLine(lineId!);
      await _create('ir.attachment', {
        'name': note ?? localPath.split(RegExp(r'[\\/]')).last,
        'datas': data,
        'res_model': 'rentory.order',
        'res_id': order,
      });
      final id = await super.addPhoto(
        localPath: localPath,
        assetId: assetId,
        orderId: orderId,
        lineId: lineId,
        serialId: serialId,
        note: note,
      );
      // Already in Odoo: nothing for the sync to send.
      await db.customStatement(
        "UPDATE photos SET dirty = 0, storage_path = 'odoo/attachment' "
        'WHERE id = ?',
        [id],
      );
      return id;
    }
    String? asset = assetId;
    if (asset == null && serialId != null) {
      asset = (await (db.select(
        db.serials,
      )..where((s) => s.id.equals(serialId))).getSingle()).assetId;
    }
    if (asset == null) throw RuleException.one('A photo needs an asset.');
    final id = await _create('rentory.asset.photo', {
      'asset_id': await _oid('assets', asset),
      'serial_id': await _ref('serials', serialId),
      'name': note ?? 'Photo',
      'image_1920': data,
    });
    await engine.refetch('rentory.asset.photo', [id]);
    return engine.ids.of('rentory.asset.photo', id);
  }

  @override
  Future<void> setCoverPhoto(String photoId) async {
    final photo = await (db.select(
      db.photos,
    )..where((p) => p.id.equals(photoId))).getSingle();
    if (photo.odooId == null || photo.assetId == null) {
      throw RuleException.one(
        "This is the asset's own picture in Odoo; it is already shown first.",
      );
    }
    final first = (await assetPhotos(photo.assetId!))
        .where((p) => p.odooId != null)
        .firstOrNull;
    if (first == null || first.id == photoId) return;
    await _write(
      'rentory.asset.photo',
      [photo.odooId!],
      {'sequence': first.sequence - 1},
    );
    await engine.refetch('rentory.asset.photo', [photo.odooId!]);
  }

  @override
  Future<void> removePhoto(String photoId) async {
    final photo = await (db.select(
      db.photos,
    )..where((p) => p.id.equals(photoId))).getSingle();
    final path = photo.storagePath ?? '';
    if (photo.odooId != null) {
      await _call('rentory.asset.photo', 'unlink', {
        'ids': [photo.odooId],
      });
      await engine.markGone('photos', [photoId]);
    } else if (path.startsWith(OdooRemoteStore.assetPrefix) &&
        photo.assetId != null) {
      final asset = await _oid('assets', photo.assetId!);
      await _write('rentory.asset', [asset], {'image_1920': false});
      await engine.refetchAsset(asset);
    } else {
      await super.removePhoto(photoId);
    }
  }
}

/// Odoo's UTC "YYYY-MM-DD HH:MM:SS", or false for "empty".
Object odooDateTime(DateTime? t) => t == null
    ? false
    : t.toUtc().toIso8601String().substring(0, 19).replaceFirst('T', ' ');

/// Odoo's "YYYY-MM-DD" for a date field, or false.
Object odooDate(DateTime? t) =>
    t == null ? false : t.toIso8601String().substring(0, 10);

/// The Odoo id behind a local row; refused for rows Odoo never had.
Future<int> odooIdOf(RentoryDatabase db, String table, String id) async {
  final row = await db
      .customSelect(
        'SELECT odoo_id FROM "$table" WHERE id = ?',
        variables: [Variable.withString(id)],
      )
      .getSingleOrNull();
  final odooId = row?.read<int?>('odoo_id');
  if (odooId == null) {
    throw RuleException.one('This record is not in Odoo yet.');
  }
  return odooId;
}

/// Runs a change in Odoo, shows Odoo's refusal like any rule's, and pulls
/// the copy again so the screen shows what Odoo made of it. [order] and its
/// lines, checks and units are re-read whatever their `write_date` says.
Future<T> odooCall<T>(
  OdooSyncEngine engine,
  Future<T> Function() call, {
  int? order,
}) async {
  final T result;
  try {
    result = await call();
  } on OdooException catch (e) {
    throw RuleException.one(e.message);
  }
  await engine.syncAfterChange();
  if (order != null) await engine.refetchOrder(order);
  return result;
}

/// Booking goes through Odoo's own `action_book`, in [OdooRepository.book].
class OdooBookingGateway implements BookingGateway {
  const OdooBookingGateway();

  @override
  Future<String> confirmBooking(
    String orderId,
    DateTime bookedAt, {
    List<String>? lineIds,
  }) async => throw RuleException.one(OdooRepository.message);
}

/// Invoices and payments through Odoo Accounting, reports through the
/// `rentory_app_api` add-on.
class OdooBilling implements BillingService {
  OdooBilling(this.engine);
  final OdooSyncEngine engine;
  OdooClient get _client => engine.client;

  Future<int> _order(String orderId) => odooIdOf(engine.db, 'orders', orderId);

  /// Reads that fail on rights are shown, not thrown as crashes.
  Future<T> _read<T>(Future<T> Function() read) async {
    try {
      return await read();
    } on OdooException catch (e) {
      throw RuleException.one(e.message);
    }
  }

  @override
  Future<List<InvoiceInfo>> invoices(String orderId) async {
    final id = await _order(orderId);
    return _read(() async {
      final order = await _client.read(
        'rentory.order',
        [id],
        fields: const ['invoice_ids'],
      );
      final ids = [
        for (final i in OdooMapper.many(order.firstOrNull?['invoice_ids']))
          (i as num).toInt(),
      ];
      final rows = await _client.read(
        'account.move',
        ids,
        fields: const [
          'name',
          'state',
          'payment_state',
          'amount_total',
          'amount_residual',
          'invoice_date',
        ],
      );
      final list = [
        for (final r in rows)
          InvoiceInfo(
            id: (r['id'] as num).toInt(),
            name: r['name'] is String && r['name'] != '/'
                ? r['name'] as String
                : '',
            state: r['state'] as String? ?? 'draft',
            paymentState: r['payment_state'] is String
                ? r['payment_state'] as String
                : 'not_paid',
            amountTotal: OdooMapper.number(r['amount_total']),
            amountResidual: OdooMapper.number(r['amount_residual']),
            date: switch (OdooMapper.when(r['invoice_date'])) {
              final s? => DateTime.parse(s),
              null => null,
            },
          ),
      ]..sort((a, b) => b.id.compareTo(a.id));
      return list;
    });
  }

  @override
  Future<void> createInvoice(String orderId) async {
    final id = await _order(orderId);
    await odooCall(
      engine,
      order: id,
      () => _client.call('rentory.order', 'action_create_invoice', {
        'ids': [id],
      }),
    );
  }

  @override
  Future<void> invoiceAndPay(String orderId) async {
    final id = await _order(orderId);
    await odooCall(
      engine,
      order: id,
      () => _client.call('rentory.order', 'action_invoice_and_pay', {
        'ids': [id],
      }),
    );
  }

  /// The company an invoice belongs to. Calls on it run in that company:
  /// Rentory's orders sit in their own company, which is often not the one
  /// the user has open in Odoo.
  Future<Map<String, Object?>> _companyContext(int invoiceId) async {
    final move = await _client.read(
      'account.move',
      [invoiceId],
      fields: const ['company_id'],
    );
    final company = OdooIds.odooId(move.firstOrNull?['company_id']);
    return {
      'allowed_company_ids': ?(company == null ? null : [company]),
    };
  }

  @override
  Future<void> postInvoice(int invoiceId) async {
    final context = await _read(() => _companyContext(invoiceId));
    await odooCall(
      engine,
      () => _client.call('account.move', 'action_post', {
        'ids': [invoiceId],
        'context': context,
      }),
    );
  }

  @override
  Future<List<JournalInfo>> paymentJournals(int invoiceId) => _read(() async {
    final move = await _client.read(
      'account.move',
      [invoiceId],
      fields: const ['company_id'],
    );
    final company = OdooIds.odooId(move.firstOrNull?['company_id']);
    int? preferred;
    if (company != null) {
      try {
        final c = await _client.read(
          'res.company',
          [company],
          fields: const ['rentory_receipt_journal_id'],
        );
        preferred = OdooIds.odooId(
          c.firstOrNull?['rentory_receipt_journal_id'],
        );
      } on OdooException {
        // No rights on the company: no preference.
      }
    }
    final journals = await _client.searchRead(
      'account.journal',
      domain: [
        [
          'type',
          'in',
          ['bank', 'cash'],
        ],
        if (company != null) ['company_id', '=', company],
      ],
      fields: const ['name'],
      order: 'sequence, id',
    );
    final list = [
      for (final j in journals)
        JournalInfo(
          id: (j['id'] as num).toInt(),
          name: j['name'] as String? ?? '',
        ),
    ];
    // The Rentory receipts journal first; the rest keep Odoo's order.
    list.sort(
      (a, b) => (a.id == preferred ? 0 : 1) - (b.id == preferred ? 0 : 1),
    );
    return list;
  });

  @override
  Future<void> registerPayment(
    int invoiceId, {
    required double amount,
    required int journalId,
  }) async {
    if (amount <= 0) throw RuleException.one('Enter an amount above zero.');
    final context = {
      ...await _read(() => _companyContext(invoiceId)),
      'active_model': 'account.move',
      'active_ids': [invoiceId],
    };
    await odooCall(engine, () async {
      final created = await _client.call('account.payment.register', 'create', {
        'vals_list': [
          {
            'journal_id': journalId,
            'amount': amount,
            'payment_difference_handling': 'open',
          },
        ],
        'context': context,
      });
      final ids = created is List ? created : [created];
      await _client.call('account.payment.register', 'action_create_payments', {
        'ids': ids,
        'context': context,
      });
    });
  }

  @override
  Future<List<ReportInfo>> reports() => _read(() async {
    final rows = await _client.searchRead(
      'ir.actions.report',
      domain: const [
        ['model', '=', 'rentory.order'],
        ['report_type', '=', 'qweb-pdf'],
      ],
      fields: const ['name', 'report_name'],
      order: 'id',
    );
    return [
      for (final r in rows)
        if ((r['report_name'] as String? ?? '').startsWith('rentory.'))
          ReportInfo(
            reportName: r['report_name'] as String,
            title: r['name'] as String? ?? r['report_name'] as String,
          ),
    ];
  });

  /// What the app asks the add-on for. Kept in step with
  /// `odoo_addons/rentory_app_api`.
  static const reportMethod = 'rentory_app_report_pdf';

  @override
  Future<Uint8List> reportPdf(String orderId, String reportName) async {
    final id = await _order(orderId);
    try {
      final data = await _client.call('rentory.order', reportMethod, {
        'ids': [id],
        'report_name': reportName,
      });
      if (data is! String || data.isEmpty) {
        throw RuleException.one('Odoo sent back an empty document.');
      }
      return base64Decode(data);
    } on OdooException catch (e) {
      // An Odoo without the add-on doesn't know the method.
      if (e.message.contains(reportMethod) || e.status == 404) {
        throw RuleException.one(
          'Printing from the app needs the "Rentory App API" add-on in '
          'Odoo. Ask whoever runs Odoo to install rentory_app_api.',
        );
      }
      throw RuleException.one(e.message);
    }
  }
}
