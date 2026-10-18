import 'package:drift/drift.dart';

import '../domain/enums.dart';
import 'local/database.dart';
import 'repository.dart';

/// Demo inventory based on Rentory's own demo data (`demo/rentory_demo.xml`),
/// plus made-up customers and a few orders in different states. No real
/// Sokoon customers or records.
class DemoSeed {
  DemoSeed(this.db, this.repo);
  final RentoryDatabase db;
  final RentoryRepository repo;

  Future<bool> isEmpty() async =>
      (await (db.select(db.assets)..limit(1)).get()).isEmpty;

  Future<void> run() async {
    if (!await isEmpty()) return;

    final loc = <String, String>{};
    for (final name in ['Warehouse', 'Shelf A', 'Shelf B', 'Van 1']) {
      loc[name] =
          (await db
                  .into(db.locations)
                  .insertReturning(LocationsCompanion.insert(name: name)))
              .id;
    }
    final cat = <String, String>{};
    for (final name in [
      'Cameras',
      'Lighting',
      'Audio',
      'Support & Grip',
      'Monitoring',
    ]) {
      cat[name] =
          (await db
                  .into(db.categories)
                  .insertReturning(CategoriesCompanion.insert(name: name)))
              .id;
    }
    for (final (i, name) in [
      'National ID card',
      'Passport',
      'Driving licence',
    ].indexed) {
      await db
          .into(db.documentTypes)
          .insert(
            DocumentTypesCompanion.insert(
              name: name,
              sequence: Value((i + 1) * 10),
            ),
          );
    }

    Future<String> asset(
      String name,
      String code,
      String category,
      double price, {
      List<String> serials = const [],
      double qty = 1,
      String location = 'Shelf A',
    }) async {
      final id =
          (await db
                  .into(db.assets)
                  .insertReturning(
                    AssetsCompanion.insert(
                      name: name,
                      code: Value(code),
                      barcode: Value(code),
                      categoryId: Value(cat[category]),
                      tracking: Value(
                        serials.isEmpty ? Tracking.none : Tracking.serial,
                      ),
                      qtyManual: Value(serials.isEmpty ? qty : 0),
                      rentalPriceDay: Value(price),
                      locationId: Value(loc[location]),
                    ),
                  ))
              .id;
      for (final s in serials) {
        await db
            .into(db.serials)
            .insert(
              SerialsCompanion.insert(
                assetId: id,
                name: s,
                barcode: Value(s),
                locationId: Value(loc[location]),
              ),
            );
      }
      return id;
    }

    final c300 = await asset(
      'Canon EOS C300 Mark III',
      'CAM-001',
      'Cameras',
      180,
      serials: ['C300-A-0417', 'C300-B-0918', 'C300-C-1102'],
    );
    final fx6 = await asset(
      'Sony FX6',
      'CAM-002',
      'Cameras',
      150,
      serials: ['FX6-0231', 'FX6-0244'],
    );
    await asset(
      'DJI Ronin 4D-6K',
      'CAM-003',
      'Cameras',
      220,
      serials: ['RON4D-0007'],
    );
    await asset(
      'ARRI Alexa Mini LF',
      'CAM-SUB-001',
      'Cameras',
      450,
      location: 'Warehouse',
    );
    await asset(
      'Sennheiser MKH 416 Shotgun Mic',
      'AUD-001',
      'Audio',
      35,
      serials: ['MKH-8812', 'MKH-8817'],
    );
    await asset(
      'Atomos Ninja V Recorder',
      'MON-001',
      'Monitoring',
      30,
      serials: ['NINJA-1101', 'NINJA-1108', 'NINJA-1119'],
      location: 'Shelf B',
    );
    final lights = await asset(
      'Aputure LS 600d Pro',
      'LGT-001',
      'Lighting',
      45,
      qty: 6,
      location: 'Shelf B',
    );
    final tripods = await asset(
      'Manfrotto 546B Tripod',
      'GRP-001',
      'Support & Grip',
      18,
      qty: 8,
      location: 'Warehouse',
    );
    await asset('Zoom F8n Pro Field Recorder', 'AUD-002', 'Audio', 40, qty: 3);
    await asset(
      'Godox Softbox Kit (90cm)',
      'LGT-002',
      'Lighting',
      22,
      qty: 4,
      location: 'Shelf B',
    );

    final customers = <String>[];
    for (final (name, phone) in [
      ('Demo Studio', '+000 0000 0001'),
      ('Sample Productions', '+000 0000 0002'),
      ('Test Films', '+000 0000 0003'),
    ]) {
      customers.add(
        (await db
                .into(db.customers)
                .insertReturning(
                  CustomersCompanion.insert(name: name, phone: Value(phone)),
                ))
            .id,
      );
    }
    await db
        .into(db.customerDiscounts)
        .insert(
          CustomerDiscountsCompanion.insert(
            name: 'Regular client',
            customerId: Value(customers[0]),
            discountValue: const Value(10),
          ),
        );

    final today = DateTime.now().toUtc();
    DateTime at(int days, [int hour = 9]) => DateTime.utc(
      today.year,
      today.month,
      today.day,
      hour,
    ).add(Duration(days: days));

    // A quotation still being put together.
    final draft = await repo.createOrder(
      customerId: customers[1],
      customerName: 'Sample Productions',
      start: at(3),
      end: at(5),
    );
    await repo.addLine(draft, type: LineType.section, name: 'Cameras');
    final draftCam = await repo.addLine(
      draft,
      type: LineType.asset,
      assetId: c300,
      quantity: 2,
    );
    await repo.autofillSerials(draftCam);
    await repo.addLine(draft, type: LineType.section, name: 'Lighting');
    await repo.addLine(
      draft,
      type: LineType.asset,
      assetId: lights,
      quantity: 2,
    );

    // A booked job for next week.
    final booked = await repo.createOrder(
      customerId: customers[0],
      customerName: 'Demo Studio',
      start: at(7),
      end: at(10),
    );
    final bookedCam = await repo.addLine(
      booked,
      type: LineType.asset,
      assetId: fx6,
    );
    await repo.autofillSerials(bookedCam);
    await repo.addLine(
      booked,
      type: LineType.asset,
      assetId: tripods,
      quantity: 2,
    );
    await repo.book(booked);

    // Out with the customer and a day late.
    final late = await repo.createOrder(
      customerId: customers[2],
      customerName: 'Test Films',
      start: at(-4),
      end: at(-1),
    );
    final lateCam = await repo.addLine(
      late,
      type: LineType.asset,
      assetId: c300,
    );
    await repo.autofillSerials(lateCam);
    await repo.book(late);
    await repo.updateOrder(
      late,
      const OrdersCompanion(
        sigRentalContract: Value(true),
        amountDeposit: Value(500),
        amountPaid: Value(300),
      ),
    );
    await repo.pickupAll(late);
  }
}
