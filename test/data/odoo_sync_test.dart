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
  bool manager = true;

  void put(String model, int id, Map<String, Object?> fields) {
    records.putIfAbsent(model, () => {})[id] = {
      'id': id,
      'write_date': '2026-10-19 10:00:00',
      ...fields,
    };
  }

  bool _matches(Map<String, Object?> r, List<Object?> domain) {
    for (final c in domain) {
      final [field, op, value] = c as List;
      final have = r[field as String];
      final ok = switch (op) {
        '=' => have == value,
        '>=' => (have as String).compareTo(value as String) >= 0,
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
    throw UnimplementedError('$model.$method');
  }
}

void main() {
  late RentoryDatabase db;
  late FakeOdoo odoo;
  late OdooSyncEngine engine;
  late OdooReadOnlyRepository repo;
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
    repo = OdooReadOnlyRepository(
      db,
      gateway: const OdooBookingGateway(),
      currentUserId: () => engine.currentUserId,
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

  test('changes are refused in Odoo mode, order photos are not', () async {
    await engine.pull();
    final id = ids.of('rentory.order', 400);
    await expectLater(repo.book(id), throwsA(isA<RuleException>()));
    await expectLater(repo.cancel(id), throwsA(isA<RuleException>()));
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
