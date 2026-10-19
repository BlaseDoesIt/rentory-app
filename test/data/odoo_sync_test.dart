import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rentory/data/local/database.dart';
import 'package:rentory/data/odoo/odoo_client.dart';
import 'package:rentory/data/odoo/odoo_repository.dart';
import 'package:rentory/data/odoo/odoo_sync.dart';
import 'package:rentory/data/repository.dart';
import 'package:rentory/domain/enums.dart';

/// Odoo's JSON-2 API over records held in memory: just the calls a pull
/// makes, with `=` and `>=` domains.
class FakeOdoo extends OdooClient {
  FakeOdoo()
    : super(
        const OdooCredentials(
          url: 'https://odoo.test',
          database: 'test-db',
          apiKey: 'k',
        ),
      );

  final records = <String, Map<int, Map<String, Object?>>>{};
  final calls = <String>[];
  final writes = <Map<String, Object?>>[];
  final actions =
      <({String model, String method, Map<String, Object?> args})>[];
  var nextId = 9000;
  bool manager = true;

  void put(String model, int id, Map<String, Object?> fields) {
    records.putIfAbsent(model, () => {})[id] = {
      'id': id,
      'write_date': '2026-10-19 10:00:00',
      ...stored(fields),
    };
  }

  /// `[[6, 0, ids]]` is how a many2many is written; Odoo then reads ids.
  static Map<String, Object?> stored(Map<String, Object?> vals) => {
    for (final e in vals.entries)
      e.key: switch (e.value) {
        [[6, 0, final List<Object?> ids]] => ids,
        final v => v,
      },
  };

  bool _matches(Map<String, Object?> r, List<Object?> domain) {
    for (final c in domain) {
      final [field, op, value] = c as List;
      final raw = r[field as String];
      // A many2one compares by its id, as in Odoo.
      final have = raw is List && raw.length == 2 && raw.last is String
          ? raw.first
          : raw;
      final ok = switch (op) {
        '=' => have == value,
        '>=' => (have as String).compareTo(value as String) >= 0,
        'in' => (value as List).contains(have),
        '>' => have is num && have > (value as num),
        '!=' => have != value && !(value == false && have == null),
        _ => throw UnimplementedError('$op'),
      };
      if (!ok) return false;
    }
    return true;
  }

  Map<String, Object?> _pick(Map<String, Object?> r, List<Object?> fields) => {
    'id': r['id'],
    for (final f in fields) f as String: r[f] ?? false,
  };

  @override
  Future<Object?> call(
    String model,
    String method, [
    Map<String, Object?> args = const {},
  ]) async {
    calls.add('$model.$method');
    final rows = (records[model] ?? {}).values;
    final domain = (args['domain'] as List?) ?? const [];
    switch (method) {
      case 'context_get':
        return {'uid': 13};
      case 'has_group':
        return manager;
      case 'create':
        final vals = Map<String, Object?>.from(
          (args['vals_list'] as List).single as Map,
        );
        final id = nextId++;
        put(model, id, vals);
        actions.add((model: model, method: method, args: args));
        return [id];
      case 'unlink':
        for (final id in args['ids'] as List) {
          records[model]?.remove(id);
        }
        actions.add((model: model, method: method, args: args));
        return true;
      case 'write':
        writes.add(args);
        for (final id in args['ids'] as List) {
          records[model]![id]!
            ..addAll(stored(Map<String, Object?>.from(args['vals'] as Map)))
            ..['write_date'] = '2026-10-19 12:00:00';
        }
        return true;
      case 'search_count':
        return rows.length;
      case 'search':
        return [
          for (final r in rows)
            if (_matches(r, domain)) r['id'],
        ];
      case 'read':
        final ids = args['ids'] as List;
        return [
          for (final id in ids)
            if (records[model]?[id] case final r?)
              _pick(r, args['fields'] as List),
        ];
      case 'search_read':
        final hits =
            [
              for (final r in rows)
                if (_matches(r, domain)) r,
            ]..sort(
              (a, b) => (a['write_date'] as String).compareTo(
                b['write_date'] as String,
              ),
            );
        final offset = (args['offset'] as int?) ?? 0;
        return [
          for (final r
              in hits.skip(offset).take((args['limit'] as int?) ?? 1 << 30))
            _pick(r, args['fields'] as List),
        ];
    }
    // Rentory's actions: recorded, and answered like Odoo does.
    actions.add((model: model, method: method, args: args));
    return true;
  }
}

void main() {
  late RentoryDatabase db;
  late FakeOdoo odoo;
  late OdooSyncEngine engine;
  late OdooRepository repo;
  const ids = OdooIds('test-db');

  setUp(() {
    db = RentoryDatabase.memory(NativeDatabase.memory());
    odoo = FakeOdoo()
      ..put('res.users', 13, {'name': 'Kosai', 'login': 'k@x', 'share': false})
      ..put('res.users', 25, {'name': 'Sam', 'share': false})
      ..put('res.partner', 7, {'name': 'Syria TV', 'phone': '+963 1'})
      ..put('rentory.location', 1, {'name': 'Store', 'active': true})
      ..put('rentory.asset', 10, {
        'name': 'Light',
        'tracking': 'serial',
        'rental_ok': true,
        'rental_price_day': 50,
        'location_id': [1, 'Store'],
        'notes': '<p>Handle <b>with</b> care</p>',
        'active': true,
      })
      ..put('rentory.asset.serial', 100, {
        'asset_id': [10, 'Light'],
        'name': 'L-01',
        'state': 'out',
        'active': true,
      })
      ..put('rentory.asset.serial', 101, {
        'asset_id': [10, 'Light'],
        'name': 'L-02',
        'state': 'available',
        'active': true,
      })
      ..put('rentory.order', 400, {
        'name': 'RNT/2026/00400',
        'company_id': [13, 'Rental House'],
        'partner_id': [7, 'Syria TV'],
        'date_start': '2026-10-10 08:00:00',
        'date_end': '2026-10-12 08:00:00',
        'state': 'partial_return',
        'discount_type': 'percent',
        'discount_value': 0,
        'amount_paid': 60,
        'late_fee_manual': true,
        'sig_rental_contract': true,
        'document_ids': [3],
      })
      ..put('rentory.customer.document', 3, {'name': 'ID card', 'active': true})
      ..put('rentory.order.line', 4000, {
        'order_id': [400, 'RNT/2026/00400'],
        'line_type': 'asset',
        'asset_id': [10, 'Light'],
        'name': 'Light',
        'quantity': 2,
        'price_day': 50,
        'date_start': '2026-10-10 08:00:00',
        'date_end': '2026-10-12 08:00:00',
        'dates_overridden': false,
        'rental_state': 'picked_up',
        'condition_out': 'good',
        'serial_ids': [100, 101],
      })
      ..put('rentory.order.line', 4001, {
        'order_id': [400, 'RNT/2026/00400'],
        'line_type': 'section',
        'name': 'Lights',
        'is_section': true,
      })
      ..put('rentory.return.check', 9, {
        'line_id': [4000, 'Light'],
        'order_id': [400, 'RNT/2026/00400'],
        'serial_id': [101, 'L-02'],
        'serial_name': 'L-02',
        'condition': 'good',
        'returned_at': '2026-10-12 07:00:00',
      })
      ..put('rentory.asset.photo', 5, {
        'asset_id': [10, 'Light'],
        'sequence': 10,
        'name': 'front',
        'create_date': '2026-09-01 10:00:00',
      });
    engine = OdooSyncEngine(db, odoo);
    repo = OdooRepository(
      db,
      engine,
      clock: () => DateTime.utc(2026, 10, 13, 9),
    );
  });

  tearDown(() => db.close());

  test(
    'an Odoo order arrives with its customer, lines, units and checks',
    () async {
      await engine.pull();

      final orders = await repo.watchOrders().first;
      expect(orders, hasLength(1));
      final order = orders.single;
      expect(order.order.number, 'RNT/2026/00400');
      expect(order.order.odooId, 400);
      expect(order.order.state, OrderState.partialReturn);
      expect(order.customerLabel, 'Syria TV');

      final detail = await repo.loadOrder(order.order.id);
      final light = detail.lines.firstWhere(
        (l) => l.line.lineType == LineType.asset,
      );
      expect(light.serials.map((s) => s.name), ['L-01', 'L-02']);
      expect(light.returnChecks, hasLength(1));
      // The order's own dates, not copies on the line.
      expect(light.line.dateStart, isNull);
      expect(
        detail.lines.where((l) => l.line.lineType == LineType.section),
        hasLength(1),
      );

      // Two days at 2 x 50, then one unit still out a day late: 50.
      expect(order.amounts.total, 200);
      expect(order.amounts.lateFee, 100);
      expect(order.amounts.paid, 60);
      expect(order.amounts.paymentState, PaymentState.due);
      expect(await repo.orderDocuments(order.order.id), hasLength(1));

      final asset = await repo.loadAsset(ids.of('rentory.asset', 10));
      expect(asset.asset.notes, 'Handle with care');
      expect(await repo.currentRole(), Role.admin);
      final photos = await repo.assetPhotos(asset.asset.id);
      expect(photos.single.storagePath, OdooRemoteStore.photoPath(5));
    },
  );

  test('a quiet database writes nothing on the next pass', () async {
    await engine.pull();
    var notices = 0;
    final sub = db.tableUpdates().listen((_) => notices++);
    await engine.pull();
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    expect(notices, 0);
  });

  test('later edits come through, and deletes on a full check', () async {
    await engine.pull();
    odoo.put('rentory.order', 400, {
      ...odoo.records['rentory.order']![400]!,
      'amount_paid': 300,
      'write_date': '2026-10-19 11:00:00',
    });
    odoo.records['rentory.order.line']!.remove(4001);
    await engine.pull();
    var detail = await repo.loadOrder(ids.of('rentory.order', 400));
    expect(detail.summary.amounts.paid, 300);
    expect(detail.summary.amounts.paymentState, PaymentState.paid);

    final full = OdooSyncEngine(db, odoo, reconcileEvery: 1);
    await full.pull();
    detail = await repo.loadOrder(ids.of('rentory.order', 400));
    expect(
      detail.lines.where((l) => l.line.lineType == LineType.section),
      isEmpty,
    );
  });

  test('without the manager group the user is office staff', () async {
    odoo.manager = false;
    await engine.pull();
    expect(await repo.currentRole(), Role.office);
  });

  test('late days and payment edits go to Odoo, then come back', () async {
    await engine.pull();
    final id = ids.of('rentory.order', 400);
    await repo.setLateDays(id, 5);
    expect(odoo.writes.last['vals'], {
      'late_fee_manual': true,
      'late_days_override': 5,
      'late_days_edited': true,
    });
    var d = await repo.loadOrder(id);
    expect(d.lateDaysCounted, 2);
    expect(d.lateDaysCharged, 5);
    expect(d.summary.amounts.lateFee, 250); // the unit still out: 5 x 50

    await repo.setLateDays(id, null);
    d = await repo.loadOrder(id);
    expect(d.order.lateDaysEdited, isFalse);
    expect(d.lateDaysCharged, 2);

    await repo.updateOrder(id, const OrdersCompanion(amountPaid: Value(80)));
    expect(odoo.writes.last['vals'], {'amount_paid': 80.0});
    d = await repo.loadOrder(id);
    expect(d.summary.amounts.paid, 80);

    // Fields the app cannot send yet are refused, not dropped.
    await expectLater(
      repo.updateOrder(
        id,
        const OrdersCompanion(state: Value(OrderState.cancelled)),
      ),
      throwsA(isA<RuleException>()),
    );
  });

  group('everyday writes', () {
    String order400() => ids.of('rentory.order', 400);
    String line4000() => ids.of('rentory.order.line', 4000);
    ({String model, String method, Map<String, Object?> args}) last(
      String method,
    ) => odoo.actions.lastWhere((a) => a.method == method);
    Map<Object?, Object?> created() =>
        (last('create').args['vals_list'] as List).single as Map;

    test(
      'a new order needs a phone, then lands in the orders\' company',
      () async {
        await engine.pull();
        await expectLater(
          repo.createOrder(
            customerName: 'Walk-in',
            start: DateTime.utc(2026, 11, 1, 9),
            end: DateTime.utc(2026, 11, 2, 9),
          ),
          throwsA(isA<RuleException>()),
        );
        final id = await repo.createOrder(
          customerId: ids.of('res.partner', 7),
          start: DateTime.utc(2026, 11, 1, 9),
          end: DateTime.utc(2026, 11, 2, 9),
        );
        final create = last('create');
        expect(create.model, 'rentory.order');
        final vals = created();
        expect(vals['partner_id'], 7);
        expect(vals['customer_phone'], '+963 1');
        expect(vals['date_start'], '2026-11-01 09:00:00');
        // The orders' company, not the one the user has open in Odoo.
        expect((create.args['context'] as Map)['allowed_company_ids'], [13]);
        expect((await repo.loadOrder(id)).order.odooId, 9000);
      },
    );

    test('lines carry the asset\'s name, price and units', () async {
      await engine.pull();
      await repo.addLine(
        order400(),
        type: LineType.asset,
        assetId: ids.of('rentory.asset', 10),
        serialIds: [ids.of('rentory.asset.serial', 101)],
      );
      final vals = created();
      expect(vals['name'], 'Light');
      expect(vals['price_day'], 50.0);
      expect(vals['quantity'], 1.0);
      expect(vals['serial_ids'], [
        [
          6,
          0,
          [101],
        ],
      ]);
    });

    test(
      'a draft books as an order, a running one books its new lines',
      () async {
        await engine.pull();
        await repo.book(order400());
        expect(odoo.actions.where((a) => a.method == 'action_book'), isEmpty);
        odoo.put('rentory.order', 400, {
          ...odoo.records['rentory.order']![400]!,
          'state': 'draft',
          'write_date': '2026-10-19 13:00:00',
        });
        await engine.pull();
        await repo.book(order400());
        expect(last('action_book').args['ids'], [400]);
      },
    );

    test(
      'a forced pickup tells Odoo, which checks the manager group',
      () async {
        await engine.pull();
        await repo.pickupAll(order400(), force: true);
        final call = last('action_pickup_all');
        expect(call.args['ids'], [400]);
        expect((call.args['context'] as Map)['rentory_force'], true);
        await repo.pickupAll(order400(), lineIds: [line4000()]);
        expect(last('action_pickup').args['ids'], [4000]);
      },
    );

    test('a return goes through the wizard, one row per unit', () async {
      await engine.pull();
      await repo.returnLine(
        line4000(),
        units: {
          ids.of('rentory.asset.serial', 100): (
            condition: Condition.damaged,
            note: 'cracked',
          ),
        },
      );
      final wizard = odoo.actions.firstWhere(
        (a) => a.model == 'rentory.return.wizard' && a.method == 'create',
      );
      final vals = (wizard.args['vals_list'] as List).single as Map;
      expect(vals['order_id'], 400);
      expect(vals['line_ids'], [
        [
          0,
          0,
          {
            'order_line_id': 4000,
            'serial_id': 100,
            'selected': true,
            'condition_in': 'damaged',
            'condition_note': 'cracked',
          },
        ],
      ]);
      expect(last('action_confirm').model, 'rentory.return.wizard');
    });

    test(
      'cancel, draft, documents and unbook use Rentory\'s actions',
      () async {
        await engine.pull();
        await repo.cancel(order400());
        await repo.resetToDraft(order400());
        await repo.markDocumentsReturned(order400());
        await repo.unbookLine(line4000());
        expect(
          [for (final a in odoo.actions) a.method],
          containsAllInOrder([
            'action_cancel',
            'action_draft',
            'action_documents_returned',
            'action_reset_line',
          ]),
        );
      },
    );

    test('an order with history is not deleted', () async {
      await engine.pull();
      await expectLater(
        repo.removeOrder(order400()),
        throwsA(isA<RuleException>()),
      );
      expect(odoo.actions.where((a) => a.method == 'unlink'), isEmpty);
    });

    test('assets: status through actions, unknown fields refused', () async {
      await engine.pull();
      final asset = ids.of('rentory.asset', 10);
      await repo.setAssetStatus(asset, AssetManualState.maintenance);
      expect(last('action_set_maintenance').args['ids'], [10]);
      await repo.updateAsset(
        asset,
        const AssetsCompanion(rentalPriceDay: Value(60)),
      );
      expect(odoo.writes.last['vals'], {'rental_price_day': 60.0});
      await repo.addUnits(asset, ['L-03']);
      expect(created()['name'], 'L-03');
      await expectLater(
        repo.updateAsset(asset, const AssetsCompanion(imagePath: Value('x'))),
        throwsA(isA<RuleException>()),
      );
    });

    test('a new customer is an Odoo contact', () async {
      await engine.pull();
      final id = await repo.createCustomer(name: 'New Studio', phone: '123');
      expect(created(), {
        'name': 'New Studio',
        'phone': '123',
        'customer_rank': 1,
      });
      expect((await repo.customers(search: 'New')).single.id, id);
    });
  });

  test('an asset picture in Odoo becomes its cover', () async {
    odoo.put('rentory.asset', 10, {
      ...odoo.records['rentory.asset']![10]!,
      'image_1920': 'base64...',
    });
    await engine.pull();
    final asset = await repo.loadAsset(ids.of('rentory.asset', 10));
    expect(asset.photos.first.storagePath, OdooRemoteStore.assetImagePath(10));
    expect(asset.photos, hasLength(2));
  });

  test('what Odoo cannot do is refused; order photos stay local', () async {
    await engine.pull();
    final id = ids.of('rentory.order', 400);
    await expectLater(repo.restoreOrder(id), throwsA(isA<RuleException>()));
    await repo.addOrderPhoto(id, '/tmp/x.jpg');
    expect(await repo.orderPhotos(id), hasLength(1));
    final dirty = await db
        .customSelect('SELECT count(*) c FROM orders WHERE dirty = 1')
        .getSingle();
    expect(dirty.read<int>('c'), 0);
  });

  group('mapper', () {
    test('Odoo datetimes are UTC', () {
      expect(
        OdooMapper.when('2026-10-19 09:08:44'),
        '2026-10-19T09:08:44.000Z',
      );
      expect(OdooMapper.when('2026-10-19'), '2026-10-19T00:00:00.000Z');
      expect(OdooMapper.when(false), isNull);
    });

    test('unknown selection values fall back', () {
      expect(
        OdooMapper.key('part', LineType.values, fallback: 'asset'),
        'asset',
      );
      expect(OdooMapper.key(false, AssetManualState.values), isNull);
    });

    test('addresses are cleaned', () {
      expect(
        OdooCredentials.cleanUrl('erp.example.com/odoo/action-12'),
        'https://erp.example.com',
      );
    });
  });

  test('ids are stable per database and differ across databases', () {
    expect(
      ids.of('rentory.order', 1),
      const OdooIds('test-db').of('rentory.order', 1),
    );
    expect(
      ids.of('rentory.order', 1),
      isNot(const OdooIds('prod').of('rentory.order', 1)),
    );
    expect(ids.ref('rentory.order', [1, 'x']), ids.of('rentory.order', 1));
    expect(ids.ref('rentory.order', false), isNull);
  });
}
