import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rentory/data/local/database.dart';
import 'package:rentory/data/local/local_repository.dart';
import 'package:rentory/data/repository.dart';
import 'package:rentory/domain/enums.dart';

void main() {
  late RentoryDatabase db;
  late LocalRepository repo;
  var now = DateTime.utc(2026, 10, 1, 9);

  late String camera;
  late String tripod;

  setUp(() async {
    now = DateTime.utc(2026, 10, 1, 9);
    db = RentoryDatabase.memory(NativeDatabase.memory());
    repo = LocalRepository(
      db,
      gateway: LocalBookingGateway(db),
      currentUserId: () => 'u1',
      clock: () => now,
    );
    camera = (await db.into(db.assets).insertReturning(AssetsCompanion.insert(
      name: 'Sony FX6',
      tracking: const Value(Tracking.serial),
      rentalPriceDay: const Value(100),
    )))
        .id;
    for (final n in ['FX6-001', 'FX6-002']) {
      await db.into(db.serials).insert(SerialsCompanion.insert(
            assetId: camera,
            name: n,
            barcode: Value(n),
          ));
    }
    tripod = (await db.into(db.assets).insertReturning(AssetsCompanion.insert(
      name: 'Tripod',
      qtyManual: const Value(3),
      rentalPriceDay: const Value(10),
    )))
        .id;
  });

  tearDown(() => db.close());

  Future<String> order({int fromDay = 5, int toDay = 7}) => repo.createOrder(
        customerName: 'Test customer',
        start: DateTime.utc(2026, 10, fromDay, 9),
        end: DateTime.utc(2026, 10, toDay, 9),
      );

  Future<SerialState> stateOf(String name) async =>
      (await (db.select(db.serials)..where((s) => s.name.equals(name)))
              .getSingle())
          .state;

  test('a full rental: book, pickup, split return, money', () async {
    final o = await order();
    final camLine = await repo.addLine(o,
        type: LineType.asset, assetId: camera, quantity: 2);
    await repo.addLine(o, type: LineType.section, name: 'Support');
    await repo.addLine(o,
        type: LineType.asset, assetId: tripod, quantity: 2);

    expect(await repo.autofillSerials(camLine), 0);
    await repo.book(o);

    var d = await repo.loadOrder(o);
    expect(d.order.state, OrderState.booked);
    expect(d.order.number, 'RO/2026/0001');
    expect(await stateOf('FX6-001'), SerialState.reserved);
    // 2 days: cameras 2 x 100 x 2 + tripods 2 x 10 x 2
    expect(d.summary.amounts.total, 440);

    // The contract gates the handover.
    await expectLater(repo.pickupAll(o), throwsA(isA<RuleException>()));
    await repo.updateOrder(
        o, const OrdersCompanion(sigRentalContract: Value(true)));
    await repo.pickupAll(o);
    d = await repo.loadOrder(o);
    expect(d.order.state, OrderState.pickedUp);
    expect(await stateOf('FX6-002'), SerialState.out);

    // One camera back damaged on time, the other a day late.
    final serials = d.lines.first.serials;
    now = DateTime.utc(2026, 10, 7, 8);
    await repo.returnLine(camLine, units: {
      serials[0].id: (condition: Condition.damaged, note: 'cracked screen'),
    });
    d = await repo.loadOrder(o);
    expect(d.order.state, OrderState.pickedUp); // tripods still out
    expect(await stateOf('FX6-001'), SerialState.maintenance);
    expect(d.lines.first.qtyOutstanding, 1);

    now = DateTime.utc(2026, 10, 8, 8);
    await repo.returnAll(o);
    d = await repo.loadOrder(o);
    expect(d.order.state, OrderState.returned);
    expect(await stateOf('FX6-002'), SerialState.available);
    expect(d.lines.first.line.conditionIn, Condition.damaged);
    // One camera one day late (100) + both tripods one day late (2 x 10).
    expect(d.summary.amounts.lateFee, 120);
    expect(d.summary.amounts.charged, 560);
  });

  test('a unit booked by one order cannot be booked by another', () async {
    final first = await order();
    final line1 = await repo.addLine(first,
        type: LineType.asset, assetId: camera, quantity: 1);
    await repo.autofillSerials(line1);
    await repo.book(first);

    final second = await order(fromDay: 6, toDay: 8);
    final line2 = await repo.addLine(second,
        type: LineType.asset, assetId: camera, quantity: 1);
    final options = await repo.serialOptions(line2);
    expect(options.map((o) => o.serial.name), ['FX6-002']);

    // Force the clashing unit onto the line: booking refuses it.
    final taken = (await repo.loadOrder(first)).lines.first.serials.single;
    await repo.setLineSerials(line2, [taken.id]);
    await expectLater(repo.book(second), throwsA(isA<RuleException>()));
  });

  test('untracked stock is counted by quantity', () async {
    final a = await order();
    await repo.addLine(a, type: LineType.asset, assetId: tripod, quantity: 2);
    await repo.book(a);

    final b = await order();
    await repo.addLine(b, type: LineType.asset, assetId: tripod, quantity: 2);
    await expectLater(repo.book(b), throwsA(isA<RuleException>()));

    // Back-to-back is fine.
    final c = await order(fromDay: 7, toDay: 9);
    await repo.addLine(c, type: LineType.asset, assetId: tripod, quantity: 3);
    await repo.book(c);
    expect((await repo.loadOrder(c)).order.number, 'RO/2026/0002');
  });

  test('cancel releases units; items out block cancel', () async {
    final o = await order();
    final line = await repo.addLine(o,
        type: LineType.asset, assetId: camera, quantity: 1);
    await repo.autofillSerials(line);
    await repo.book(o);
    await repo.cancel(o);
    expect(await stateOf('FX6-001'), SerialState.available);
    expect((await repo.loadOrder(o)).order.state, OrderState.cancelled);

    final p = await order();
    final l2 =
        await repo.addLine(p, type: LineType.asset, assetId: camera);
    await repo.autofillSerials(l2);
    await repo.book(p);
    await repo.pickupAll(p, force: true);
    await expectLater(repo.cancel(p), throwsA(isA<RuleException>()));
  });

  test('scan finds a serial by barcode', () async {
    final hit = await repo.findByCode('FX6-002');
    expect(hit.serial?.name, 'FX6-002');
    expect(hit.asset?.name, 'Sony FX6');
  });

  test('every write is marked for sync', () async {
    final o = await order();
    final row =
        await (db.select(db.orders)..where((x) => x.id.equals(o))).getSingle();
    expect(row.dirty, isTrue);
    expect(row.id, hasLength(36));
  });
}
