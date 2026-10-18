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
    camera =
        (await db
                .into(db.assets)
                .insertReturning(
                  AssetsCompanion.insert(
                    name: 'Sony FX6',
                    tracking: const Value(Tracking.serial),
                    rentalPriceDay: const Value(100),
                  ),
                ))
            .id;
    for (final n in ['FX6-001', 'FX6-002']) {
      await db
          .into(db.serials)
          .insert(
            SerialsCompanion.insert(
              assetId: camera,
              name: n,
              barcode: Value(n),
            ),
          );
    }
    tripod =
        (await db
                .into(db.assets)
                .insertReturning(
                  AssetsCompanion.insert(
                    name: 'Tripod',
                    qtyManual: const Value(3),
                    rentalPriceDay: const Value(10),
                  ),
                ))
            .id;
  });

  tearDown(() => db.close());

  Future<String> order({int fromDay = 5, int toDay = 7}) => repo.createOrder(
    customerName: 'Test customer',
    start: DateTime.utc(2026, 10, fromDay, 9),
    end: DateTime.utc(2026, 10, toDay, 9),
  );

  Future<SerialState> stateOf(String name) async => (await (db.select(
    db.serials,
  )..where((s) => s.name.equals(name))).getSingle()).state;

  test('a full rental: book, pickup, split return, money', () async {
    final o = await order();
    final camLine = await repo.addLine(
      o,
      type: LineType.asset,
      assetId: camera,
      quantity: 2,
    );
    await repo.addLine(o, type: LineType.section, name: 'Support');
    await repo.addLine(o, type: LineType.asset, assetId: tripod, quantity: 2);

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
      o,
      const OrdersCompanion(sigRentalContract: Value(true)),
    );
    await repo.pickupAll(o);
    d = await repo.loadOrder(o);
    expect(d.order.state, OrderState.pickedUp);
    expect(await stateOf('FX6-002'), SerialState.out);

    // One camera back damaged on time, the other a day late.
    final serials = d.lines.first.serials;
    now = DateTime.utc(2026, 10, 7, 8);
    await repo.returnLine(
      camLine,
      units: {
        serials[0].id: (condition: Condition.damaged, note: 'cracked screen'),
      },
    );
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
    final line1 = await repo.addLine(
      first,
      type: LineType.asset,
      assetId: camera,
      quantity: 1,
    );
    await repo.autofillSerials(line1);
    await repo.book(first);

    final second = await order(fromDay: 6, toDay: 8);
    final line2 = await repo.addLine(
      second,
      type: LineType.asset,
      assetId: camera,
      quantity: 1,
    );
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
    final line = await repo.addLine(
      o,
      type: LineType.asset,
      assetId: camera,
      quantity: 1,
    );
    await repo.autofillSerials(line);
    await repo.book(o);
    await repo.cancel(o);
    expect(await stateOf('FX6-001'), SerialState.available);
    expect((await repo.loadOrder(o)).order.state, OrderState.cancelled);

    final p = await order();
    final l2 = await repo.addLine(p, type: LineType.asset, assetId: camera);
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
    final row = await (db.select(
      db.orders,
    )..where((x) => x.id.equals(o))).getSingle();
    expect(row.dirty, isTrue);
    expect(row.id, hasLength(36));
  });

  test('customers: create, search, and order editing', () async {
    final id = await repo.createCustomer(name: '  Studio One ', phone: '');
    await repo.createCustomer(name: 'Other', phone: '+963 11');
    expect((await repo.customers(search: 'studio')).single.id, id);
    expect((await repo.customers(search: '963')).single.name, 'Other');
    await expectLater(
      repo.createCustomer(name: ' '),
      throwsA(isA<RuleException>()),
    );

    final o = await order();
    final line = await repo.addLine(o, type: LineType.asset, assetId: tripod);
    await repo.updateLine(line, quantity: 2, priceDay: 12, discount: 50);
    var d = await repo.loadOrder(o);
    // 2 x 12 x 2 days, half off.
    expect(d.lines.single.subtotal, 24);
    await expectLater(
      repo.updateLine(line, discount: 120),
      throwsA(isA<RuleException>()),
    );

    await repo.book(o);
    await expectLater(
      repo.updateLine(line, quantity: 1),
      throwsA(isA<RuleException>()),
    );
  });

  test('paperwork: documents, photos, role, documents returned', () async {
    final o = await order();
    final types = <String>[];
    for (final n in ['ID card', 'Passport']) {
      types.add(
        (await db
                .into(db.documentTypes)
                .insertReturning(DocumentTypesCompanion.insert(name: n)))
            .id,
      );
    }
    expect((await repo.documentTypes()).length, 2);
    await repo.setOrderDocuments(o, {types[0]});
    expect(await repo.orderDocuments(o), {types[0]});
    await repo.setOrderDocuments(o, {types[1]});
    await repo.setOrderDocuments(o, {types[0], types[1]});
    expect(await repo.orderDocuments(o), {types[0], types[1]});
    // Turned back on, not added twice.
    expect((await db.select(db.orderDocuments).get()).length, 2);

    await repo.markDocumentsReturned(o);
    final row = (await repo.loadOrder(o)).order;
    expect(row.documentsReturnedAt, now);
    expect(row.documentsReturnedBy, 'u1');

    final photo = await repo.addPhoto(
      localPath: 'C:/x/1.jpg',
      orderId: o,
      note: 'pickup',
    );
    final photos = await repo.photos(o);
    expect(photos.single.id, photo);
    expect(photos.single.dirty, isTrue);
    expect(photos.single.storagePath, isNull);

    // Signed in without a profile row: office, not admin.
    expect(await repo.currentRole(), Role.office);
    await db
        .into(db.profiles)
        .insert(
          ProfilesCompanion.insert(
            id: const Value('u1'),
            name: 'Boss',
            role: const Value(Role.admin),
          ),
        );
    expect(await repo.currentRole(), Role.admin);
  });

  test('scan finds the order a unit is on', () async {
    final o = await order();
    final line = await repo.addLine(o, type: LineType.asset, assetId: camera);
    await repo.autofillSerials(line);
    final unit = (await repo.loadOrder(o)).lines.single.serials.single;
    // A draft holds nothing.
    expect(await repo.currentOrderFor(serialId: unit.id), isNull);
    await repo.book(o);
    expect(await repo.currentOrderFor(serialId: unit.id), o);

    final t = await order();
    await repo.addLine(t, type: LineType.asset, assetId: tripod);
    expect(await repo.currentOrderFor(assetId: tripod), isNull);
    await repo.book(t);
    expect(await repo.currentOrderFor(assetId: tripod), t);
  });

  test('creating assets: by unit, by quantity, clashes refused', () async {
    final cat = await repo.createCategory('Lenses');
    expect(await repo.createCategory(' lenses '), cat);
    final lens = await repo.createAsset(
      name: 'Sigma 18-35',
      code: 'LNS-001',
      categoryId: cat,
      tracking: Tracking.serial,
      units: ['SIG-1', ' SIG-2 ', 'sig-1', ''],
      priceDay: 25,
    );
    final d = await repo.loadAsset(lens);
    expect(d.serials.map((s) => s.name), ['SIG-1', 'SIG-2']);
    expect(d.summary.total, 2);
    expect(d.summary.categoryName, 'Lenses');
    expect(d.asset.barcode, 'LNS-001');
    expect((await repo.findByCode('SIG-2')).asset?.id, lens);

    await repo.addUnits(lens, ['SIG-3']);
    expect((await repo.loadAsset(lens)).summary.total, 3);

    final stands = await repo.createAsset(
      name: 'C-stand',
      tracking: Tracking.none,
      quantity: 5,
      priceDay: 4,
    );
    expect((await repo.loadAsset(stands)).summary.total, 5);
    await expectLater(
      repo.addUnits(stands, ['X']),
      throwsA(isA<RuleException>()),
    );

    // Already scannable: an asset code, a unit name.
    for (final bad in [
      () => repo.createAsset(
        name: 'Copy',
        code: 'LNS-001',
        tracking: Tracking.none,
      ),
      () => repo.createAsset(
        name: 'Copy',
        tracking: Tracking.serial,
        units: ['FX6-001'],
      ),
      () => repo.createAsset(name: ' ', tracking: Tracking.none),
      () => repo.createAsset(name: 'No units', tracking: Tracking.serial),
    ]) {
      await expectLater(bad(), throwsA(isA<RuleException>()));
    }
  });
}
