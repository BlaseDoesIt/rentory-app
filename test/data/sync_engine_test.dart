import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rentory/data/local/database.dart';
import 'package:rentory/data/local/local_repository.dart';
import 'package:rentory/data/repository.dart';
import 'package:rentory/data/sync/remote_store.dart';
import 'package:rentory/data/sync/sync_engine.dart';
import 'package:rentory/domain/enums.dart';

/// A stand-in for Supabase: tables of JSON rows stamped from one sequence,
/// and a booking referee with the same overlap rule as the SQL function.
class FakeServer implements RemoteStore {
  final tables = <String, Map<String, Map<String, Object?>>>{};
  final claims = <({String serial, String line, DateTime s, DateTime e})>[];
  var _seq = 0;
  var _numbers = 0;

  Map<String, Map<String, Object?>> t(String name) =>
      tables.putIfAbsent(name, () => {});

  void _stamp(String table, Map<String, Object?> row) {
    t(table)[row['id'] as String] = {...row, 'server_seq': ++_seq};
  }

  @override
  Future<void> upsert(String table, List<Map<String, Object?>> rows) async {
    for (final r in rows) {
      final old = t(table)[r['id']];
      // Same rule as rentory_touch(): an older update is skipped.
      if (old != null &&
          DateTime.parse(r['updated_at'] as String)
              .isBefore(DateTime.parse(old['updated_at'] as String))) {
        continue;
      }
      _stamp(table, {...?old, ...r});
    }
  }

  @override
  Future<List<Map<String, Object?>>> changesSince(
    String table,
    int afterSeq, {
    int limit = 500,
  }) async {
    final rows =
        t(table).values
            .where((r) => (r['server_seq'] as int) > afterSeq)
            .toList()
          ..sort(
            (a, b) =>
                (a['server_seq'] as int).compareTo(b['server_seq'] as int),
          );
    return rows.take(limit).toList();
  }

  @override
  Future<String> bookOrder(String orderId) async {
    final o = t('orders')[orderId]!;
    if (o['number'] != null && o['state'] != 'draft') {
      return o['number'] as String;
    }
    final now = DateTime.now().toUtc().toIso8601String();
    final pending = <({String serial, String line, DateTime s, DateTime e})>[];
    for (final l in t('order_lines').values.where(
      (l) =>
          l['order_id'] == orderId &&
          l['deleted'] != true &&
          l['line_type'] == 'asset',
    )) {
      final s = DateTime.parse((l['date_start'] ?? o['date_start']) as String);
      final e = DateTime.parse((l['date_end'] ?? o['date_end']) as String);
      for (final link in t(
        'order_line_serials',
      ).values.where((x) => x['line_id'] == l['id'] && x['deleted'] != true)) {
        final serial = link['serial_id'] as String;
        final clash = [
          ...claims,
          ...pending,
        ].any((c) => c.serial == serial && c.s.isBefore(e) && c.e.isAfter(s));
        if (clash) {
          throw RuleException.one('${l['name']}: unit already booked.');
        }
        pending.add((serial: serial, line: l['id'] as String, s: s, e: e));
      }
    }
    claims.addAll(pending);
    final number =
        (o['number'] as String?) ??
        'RO/2026/${(++_numbers).toString().padLeft(4, '0')}';
    _stamp('orders', {
      ...o,
      'state': 'booked',
      'number': number,
      'updated_at': now,
    });
    return number;
  }

  @override
  Future<void> uploadPhoto(String path, Uint8List bytes) async {}
}

class Device {
  Device(FakeServer server, String user)
    : db = RentoryDatabase.memory(NativeDatabase.memory()) {
    sync = SyncEngine(db, server, pullOverlap: 0);
    repo = LocalRepository(
      db,
      gateway: SupabaseBookingGateway(sync),
      currentUserId: () => user,
      clock: () => fixedClock ?? DateTime.now().toUtc(),
    );
  }

  final RentoryDatabase db;
  late final SyncEngine sync;
  late final LocalRepository repo;

  /// Real time unless a test pins it.
  DateTime? fixedClock;

  Future<void> close() async {
    await sync.dispose();
    await db.close();
  }
}

void main() {
  late FakeServer server;
  late Device a;
  late Device b;
  late String camera;
  late String unit;

  setUp(() async {
    server = FakeServer();
    a = Device(server, 'ua');
    b = Device(server, 'ub');
    camera =
        (await a.db
                .into(a.db.assets)
                .insertReturning(
                  AssetsCompanion.insert(
                    name: 'FX6',
                    tracking: const Value(Tracking.serial),
                    rentalPriceDay: const Value(100),
                  ),
                ))
            .id;
    unit =
        (await a.db
                .into(a.db.serials)
                .insertReturning(
                  SerialsCompanion.insert(assetId: camera, name: 'FX6-001'),
                ))
            .id;
    await a.sync.syncNow();
    await b.sync.syncNow();
  });

  tearDown(() async {
    await a.close();
    await b.close();
  });

  Future<String> orderWithCamera(Device d) async {
    final o = await d.repo.createOrder(
      customerName: 'C',
      start: DateTime.utc(2026, 10, 5, 9),
      end: DateTime.utc(2026, 10, 7, 9),
    );
    final line = await d.repo.addLine(o, type: LineType.asset, assetId: camera);
    await d.repo.setLineSerials(line, [unit]);
    return o;
  }

  test(
    'what one device adds, the other sees, with no dirty rows left',
    () async {
      final rows = await b.db.select(b.db.serials).get();
      expect(rows.single.name, 'FX6-001');
      expect(rows.single.dirty, isFalse);
      final aRows = await a.db.select(a.db.assets).get();
      expect(aRows.single.dirty, isFalse);
    },
  );

  test(
    'two devices booking the same unit: the server lets one through',
    () async {
      final oa = await orderWithCamera(a);
      final ob = await orderWithCamera(b); // b has not seen a's order

      await a.repo.book(oa);
      expect((await a.repo.loadOrder(oa)).order.number, 'RO/2026/0001');

      await expectLater(b.repo.book(ob), throwsA(isA<RuleException>()));
      expect((await b.repo.loadOrder(ob)).order.state, OrderState.draft);

      // After syncing, b sees a's booking and its reserved unit.
      await a.sync.syncNow();
      await b.sync.syncNow();
      final seen = await b.repo.loadOrder(oa);
      expect(seen.order.state, OrderState.booked);
      final s = await (b.db.select(
        b.db.serials,
      )..where((x) => x.id.equals(unit))).getSingle();
      expect(s.state, SerialState.reserved);
    },
  );

  test('the later edit wins on both devices', () async {
    final o = await a.repo.createOrder(
      customerName: 'C',
      start: DateTime.utc(2026, 10, 5, 9),
      end: DateTime.utc(2026, 10, 7, 9),
    );
    await a.sync.syncNow();
    await b.sync.syncNow();

    final soon = DateTime.now().toUtc();
    a.fixedClock = soon.add(const Duration(hours: 1));
    await a.repo.updateOrder(o, const OrdersCompanion(note: Value('from A')));
    b.fixedClock = soon.add(const Duration(hours: 2));
    await b.repo.updateOrder(o, const OrdersCompanion(note: Value('from B')));

    await b.sync.syncNow(); // newer edit reaches the server first
    await a.sync.syncNow(); // a's older edit must not overwrite it
    await b.sync.syncNow();

    expect((await a.repo.loadOrder(o)).order.note, 'from B');
    expect((await b.repo.loadOrder(o)).order.note, 'from B');
  });

  test('a removed line disappears on the other device too', () async {
    final o = await orderWithCamera(a);
    await a.sync.syncNow();
    await b.sync.syncNow();
    expect((await b.repo.loadOrder(o)).lines, hasLength(1));

    final line = (await a.repo.loadOrder(o)).lines.single.line.id;
    await a.repo.removeLine(line);
    await a.sync.syncNow();
    await b.sync.syncNow();
    expect((await b.repo.loadOrder(o)).lines, isEmpty);
  });

  test('pulling again changes nothing and does not redirty', () async {
    await b.sync.syncNow();
    final dirty = await b.db
        .customSelect('SELECT COUNT(*) AS n FROM serials WHERE dirty = 1')
        .getSingle();
    expect(dirty.data['n'], 0);
  });
}
