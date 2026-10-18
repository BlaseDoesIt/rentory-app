import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rentory/app/app.dart';
import 'package:rentory/app/language.dart';
import 'package:rentory/app/services.dart';
import 'package:rentory/data/local/database.dart';
import 'package:rentory/data/local/local_repository.dart';
import 'package:rentory/domain/enums.dart';
import 'package:rentory/features/assets/asset_detail_page.dart';
import 'package:rentory/features/assets/asset_form_page.dart';
import 'package:rentory/features/orders/order_detail_page.dart';
import 'package:rentory/features/orders/pickup_page.dart';
import 'package:rentory/features/orders/return_page.dart';
import 'package:rentory/features/orders/unit_picker.dart';
import 'package:rentory/features/scan/scan_page.dart';
import 'package:rentory/l10n/app_localizations.dart';

/// Lets drift and file work finish, then draws the result.
Future<void> settle(WidgetTester tester, [int rounds = 6]) async {
  for (var i = 0; i < rounds; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 30)),
    );
    await tester.pump(const Duration(milliseconds: 300));
  }
}

Future<void> tapOn(WidgetTester tester, Finder f) async {
  await tester.ensureVisible(f);
  await tester.pump();
  await tester.tap(f);
  await settle(tester);
}

Future<void> typeInto(WidgetTester tester, Key key, String text) async {
  final f = find.byKey(key);
  await tester.ensureVisible(f);
  await tester.enterText(f, text);
  await tester.pump();
}

/// [ago] days back from today at 09:00 UTC (negative is the future).
DateTime day(int fromToday) {
  final t = DateTime.now().toUtc();
  return DateTime.utc(t.year, t.month, t.day, 9).add(Duration(days: fromToday));
}

void main() {
  late RentoryDatabase db;
  late LocalRepository repo;
  late Directory files;
  late String camera;
  late String tripod;

  setUp(() async {
    db = RentoryDatabase.memory(NativeDatabase.memory());
    repo = LocalRepository(db, gateway: LocalBookingGateway(db));
    files = await Directory.systemTemp.createTemp('rentory_test');
    camera =
        (await db
                .into(db.assets)
                .insertReturning(
                  AssetsCompanion.insert(
                    name: 'Sony FX6',
                    code: const Value('CAM-2'),
                    tracking: const Value(Tracking.serial),
                    rentalPriceDay: const Value(100),
                  ),
                ))
            .id;
    for (final n in ['FX6-001', 'FX6-002', 'FX6-003']) {
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
                    code: const Value('GRP-1'),
                    qtyManual: const Value(4),
                    rentalPriceDay: const Value(10),
                  ),
                ))
            .id;
    await db
        .into(db.documentTypes)
        .insert(DocumentTypesCompanion.insert(name: 'Passport'));
  });

  tearDown(() async {
    await db.close();
    await files.delete(recursive: true);
  });

  Widget host(Widget page, {Locale locale = const Locale('en')}) => MaterialApp(
    locale: locale,
    supportedLocales: LanguageController.supported,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: Services(
      db: db,
      backend: Backend(repo, null),
      userEmail: null,
      onSignOut: null,
      files: AppFiles(root: files.path),
      child: page,
    ),
  );

  /// Tall enough that whole pages are built.
  void tall(WidgetTester tester) {
    tester.view.physicalSize = const Size(900, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  Future<void> done(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await settle(tester, 1);
  }

  /// A booked order for the next days with [units] cameras and 2 tripods.
  Future<String> bookedOrder({int units = 2}) async {
    final o = await repo.createOrder(
      customerName: 'Demo Studio',
      start: day(1),
      end: day(3),
    );
    final cam = await repo.addLine(
      o,
      type: LineType.asset,
      assetId: camera,
      quantity: units.toDouble(),
    );
    await repo.autofillSerials(cam);
    await repo.addLine(o, type: LineType.asset, assetId: tripod, quantity: 2);
    await repo.book(o);
    return o;
  }

  testWidgets('new order: customer, lines, edit, remove, money', (
    tester,
  ) async {
    await tester.pumpWidget(
      RentoryApp(
        config: const AppConfig(),
        db: db,
        language: LanguageController(const Locale('en')),
        files: AppFiles(root: files.path),
        backend: Backend(repo, null),
      ),
    );
    await settle(tester);
    await tapOn(tester, find.byKey(const Key('new-order')));

    // A new customer from the picker.
    await tapOn(tester, find.byKey(const Key('pick-customer')));
    await tapOn(tester, find.text('New customer'));
    await typeInto(tester, const Key('customer-name'), 'Studio One');
    await typeInto(tester, const Key('customer-phone'), '+963 11 000');
    await tapOn(tester, find.text('Save'));
    expect(find.text('Studio One'), findsOneWidget);
    await tapOn(tester, find.text('Create order'));
    expect(find.text('Studio One'), findsOneWidget);

    // An asset line.
    await tapOn(tester, find.byKey(const Key('add-line')));
    await tapOn(tester, find.text('Tripod'));
    await typeInto(tester, const Key('line-qty'), '2');
    await tapOn(tester, find.byKey(const Key('add-line-confirm')));
    expect(find.text('Tripod'), findsOneWidget);

    // A service and a section.
    await tapOn(tester, find.byKey(const Key('add-line')));
    await tapOn(tester, find.text('Service'));
    await typeInto(tester, const Key('line-name'), 'Delivery');
    await typeInto(tester, const Key('line-price'), '25');
    await tapOn(tester, find.byKey(const Key('add-line-confirm')));
    await tapOn(tester, find.byKey(const Key('add-line')));
    await tapOn(tester, find.text('Section'));
    await typeInto(tester, const Key('line-name'), 'Extras');
    await tapOn(tester, find.byKey(const Key('add-line-confirm')));
    expect(find.text('Delivery'), findsOneWidget);
    // Sections show as small uppercase labels.
    expect(find.text('EXTRAS'), findsOneWidget);

    // Line discount, then remove the service.
    await tapOn(tester, find.text('Tripod'));
    await typeInto(tester, const Key('line-discount'), '50');
    await tapOn(tester, find.byKey(const Key('save-line')));
    await tapOn(tester, find.text('Delivery'));
    await tapOn(tester, find.byKey(const Key('remove-line')));
    await tapOn(tester, find.text('Yes'));
    expect(find.text('Delivery'), findsNothing);

    // Order discount, deposit and paid.
    await tapOn(tester, find.byKey(const Key('edit-money')));
    await typeInto(tester, const Key('order-discount'), '5');
    await typeInto(tester, const Key('order-deposit'), '200');
    await typeInto(tester, const Key('order-paid'), '1,000');
    await tapOn(tester, find.byKey(const Key('save-money')));

    final order = (await tester.runAsync(
      () => db.select(db.orders).getSingle(),
    ))!;
    final d = (await tester.runAsync(() => repo.loadOrder(order.id)))!;
    expect(d.summary.customerLabel, 'Studio One');
    expect(order.customerId, isNotNull);
    expect(order.amountDeposit, 200);
    expect(order.amountPaid, 1000);
    expect(order.discountValue, 5);
    expect(d.lines.map((v) => v.line.name), ['Tripod', 'Extras']);
    final line = d.lines.first.line;
    expect((line.quantity, line.discount), (2.0, 50.0));
    // 2 tripods x 10 x 1 day, half off.
    expect(d.lines.first.subtotal, 10);
    await done(tester);
  });

  testWidgets('unit picker tags overdue units and Autofill skips them', (
    tester,
  ) async {
    late String lineId;
    late String orderId;
    await tester.runAsync(() async {
      // FX6-001 went out last week and should have been back yesterday.
      final late = await repo.createOrder(
        customerName: 'Late',
        start: day(-5),
        end: day(-1),
      );
      final l1 = await repo.addLine(
        late,
        type: LineType.asset,
        assetId: camera,
      );
      await repo.setLineSerials(l1, [
        (await (db.select(
          db.serials,
        )..where((s) => s.name.equals('FX6-001'))).getSingle()).id,
      ]);
      await repo.book(late);
      await repo.pickupAll(late, force: true);

      orderId = await repo.createOrder(
        customerName: 'Next',
        start: day(1),
        end: day(2),
      );
      lineId = await repo.addLine(
        orderId,
        type: LineType.asset,
        assetId: camera,
        quantity: 3,
      );
    });

    await tester.pumpWidget(
      host(UnitPickerPage(orderId: orderId, lineId: lineId)),
    );
    await settle(tester);
    expect(find.text('FX6-001'), findsOneWidget);
    expect(find.text('Overdue'), findsOneWidget);
    expect(find.text('0 of 3 chosen'), findsOneWidget);

    await tapOn(tester, find.byKey(const Key('autofill')));
    expect(find.text('1 unit could not be found.'), findsOneWidget);
    expect(find.text('2 of 3 chosen'), findsOneWidget);
    final picked = (await tester.runAsync(() => repo.loadOrder(orderId)))!
        .lines
        .single
        .serials
        .map((s) => s.name);
    expect(picked, ['FX6-002', 'FX6-003']);

    // Hand-picking the overdue one is allowed.
    await tapOn(tester, find.text('FX6-001'));
    await tapOn(tester, find.byKey(const Key('save-units')));
    final after = (await tester.runAsync(() => repo.loadOrder(orderId)))!
        .lines
        .single
        .serials;
    expect(after, hasLength(3));
    await done(tester);
  });

  testWidgets('pickup: checklist, documents, signature, then hand over', (
    tester,
  ) async {
    final o = (await tester.runAsync(bookedOrder))!;
    tall(tester);
    await tester.pumpWidget(host(PickupPage(orderId: o)));
    await settle(tester);

    // Without the contract an office user is stopped; standalone is admin,
    // so the force switch is offered. Sign properly instead.
    expect(find.byKey(const Key('force-pickup')), findsOneWidget);
    await tapOn(tester, find.byKey(const Key('check-contract')));
    expect(find.byKey(const Key('force-pickup')), findsNothing);
    await tapOn(tester, find.byKey(const Key('check-receipt')));
    await tapOn(tester, find.byKey(const Key('check-captured')));
    await tapOn(tester, find.text('Passport'));

    final pad = find.byKey(const Key('signature-pad'));
    await tester.ensureVisible(pad);
    await tester.pump();
    await tester.drag(pad, const Offset(120, 10));
    await tester.pump();
    await tapOn(tester, find.byKey(const Key('save-signature')));
    await settle(tester, 10);
    expect(find.textContaining('Signed by Demo Studio'), findsOneWidget);

    await tapOn(tester, find.byKey(const Key('hand-over')));

    final d = (await tester.runAsync(() => repo.loadOrder(o)))!;
    expect(d.order.state, OrderState.pickedUp);
    expect(d.order.sigRentalContract, isTrue);
    expect(d.order.sigPickupReturnReceipt, isTrue);
    expect(d.order.sigLoanContract, isFalse);
    expect(d.order.itemsCaptured, isTrue);
    expect(d.order.signatureName, 'Demo Studio');
    expect(File(d.order.signaturePath!).existsSync(), isTrue);
    final photos = (await tester.runAsync(() => repo.photos(o)))!;
    expect(photos.single.note, 'signature');
    expect(photos.single.localPath, d.order.signaturePath);
    expect(
      (await tester.runAsync(() => repo.orderDocuments(o)))!,
      hasLength(1),
    );
    await done(tester);
  });

  testWidgets('admin can hand over without the contract', (tester) async {
    final o = (await tester.runAsync(bookedOrder))!;
    tall(tester);
    await tester.pumpWidget(host(PickupPage(orderId: o)));
    await settle(tester);

    await tapOn(tester, find.byKey(const Key('hand-over')));
    expect(find.text('Rental Contract not signed.'), findsOneWidget);
    await tapOn(tester, find.text('OK'));

    await tapOn(tester, find.byKey(const Key('force-pickup')));
    await tapOn(tester, find.byKey(const Key('hand-over')));
    final d = (await tester.runAsync(() => repo.loadOrder(o)))!;
    expect(d.order.state, OrderState.pickedUp);
    await done(tester);
  });

  testWidgets('return: per-unit condition and note, documents back', (
    tester,
  ) async {
    late String o;
    late List<Serial> units;
    await tester.runAsync(() async {
      o = await bookedOrder();
      final passport = (await repo.documentTypes()).single.id;
      await repo.setOrderDocuments(o, {passport});
      await repo.pickupAll(o, force: true);
      units = (await repo.loadOrder(o)).lines.first.serials;
    });

    tall(tester);
    await tester.pumpWidget(host(ReturnPage(orderId: o)));
    await settle(tester);
    expect(find.text('FX6-001'), findsOneWidget);

    // The first camera comes back damaged with a note; the tripods stay out.
    await tapOn(
      tester,
      find.descendant(
        of: find.byKey(Key('condition-${units[0].id}')),
        matching: find.text('Damaged'),
      ),
    );
    await typeInto(tester, Key('note-${units[0].id}'), 'cracked screen');
    final d0 = (await tester.runAsync(() => repo.loadOrder(o)))!;
    await tapOn(tester, find.byKey(Key('return-line-${d0.lines[1].line.id}')));
    // Documents left with us go back by default.
    expect(
      tester
          .widget<CheckboxListTile>(find.byKey(const Key('documents-returned')))
          .value,
      isTrue,
    );
    await tapOn(tester, find.byKey(const Key('check-in')));

    final d = (await tester.runAsync(() => repo.loadOrder(o)))!;
    expect(d.order.state, OrderState.partialReturn);
    expect(d.order.documentsReturnedAt, isNotNull);
    final checks = {for (final c in d.lines.first.returnChecks) c.serialId: c};
    expect(checks[units[0].id]!.condition, Condition.damaged);
    expect(checks[units[0].id]!.note, 'cracked screen');
    expect(checks[units[1].id]!.condition, Condition.good);
    expect(d.lines[1].line.rentalState, RentalState.pickedUp);
    await done(tester);
  });

  testWidgets('scan: typed or USB code jumps to the unit\'s order', (
    tester,
  ) async {
    final o = (await tester.runAsync(bookedOrder))!;
    await tester.pumpWidget(
      host(const Scaffold(body: ScanPage(camera: false))),
    );
    await settle(tester);
    expect(find.byKey(const Key('scan-camera')), findsNothing);

    await tester.enterText(find.byKey(const Key('scan-field')), 'NOPE-1');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await settle(tester);
    expect(find.text('Nothing matches NOPE-1.'), findsOneWidget);

    // A USB scanner types the code and presses Enter.
    await tester.enterText(find.byKey(const Key('scan-field')), 'FX6-002');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await settle(tester);
    expect(find.byType(OrderDetailPage), findsOneWidget);
    final number = (await tester.runAsync(() => repo.loadOrder(o)))!
        .order
        .number!;
    expect(find.text(number), findsOneWidget);
    await done(tester);
  });

  testWidgets('Arabic: right to left, English digits', (tester) async {
    await tester.runAsync(bookedOrder);
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      RentoryApp(
        config: const AppConfig(),
        db: db,
        language: LanguageController(const Locale('ar')),
        files: AppFiles(root: files.path),
        backend: Backend(repo, null),
      ),
    );
    await settle(tester);

    // Phone width: bottom tabs, in Arabic, laid out right to left.
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('الطلبات'), findsWidgets);
    expect(find.text('مسح'), findsOneWidget);
    final dir = Directionality.of(tester.element(find.byType(NavigationBar)));
    expect(dir, TextDirection.rtl);

    final tile = tester
        .widgetList<Text>(find.byType(Text))
        .map((t) => t.data ?? '')
        .firstWhere((s) => s.contains('RO/'));
    expect(tile, contains('RO/${DateTime.now().year}/0001'));
    final all = tester
        .widgetList<Text>(find.byType(Text))
        .map((t) => t.data ?? '')
        .join(' ');
    expect(all, isNot(matches(RegExp('[٠-٩]'))));
    expect(all, contains('محجوز'));
    await done(tester);
  });

  testWidgets('new asset: units typed and numbered, then more added', (
    tester,
  ) async {
    tall(tester);
    await tester.pumpWidget(host(const NewAssetPage()));
    await settle(tester);

    await typeInto(tester, const Key('asset-name'), 'Sigma 18-35');
    await typeInto(tester, const Key('asset-code'), 'LNS');
    // One typed by hand, three numbered: LNS-002 to LNS-004.
    await typeInto(tester, const Key('asset-unit'), 'LNS-001');
    await tapOn(tester, find.byKey(const Key('add-unit')));
    await tapOn(tester, find.byKey(const Key('number-units')));
    await tapOn(tester, find.byKey(const Key('number-confirm')));
    expect(find.text('4 units'), findsOneWidget);
    await typeInto(tester, const Key('asset-price'), '25');
    await tapOn(tester, find.byKey(const Key('save-asset')));

    expect(find.byType(AssetDetailPage), findsOneWidget);
    expect(find.text('LNS-004'), findsOneWidget);

    await tapOn(tester, find.byKey(const Key('add-units')));
    await tester.enterText(find.byKey(const Key('units-input')), 'LNS-010');
    await tapOn(tester, find.byKey(const Key('save-units-dialog')));
    expect(find.text('LNS-010'), findsOneWidget);

    final lens = (await tester.runAsync(
      () => (db.select(
        db.assets,
      )..where((a) => a.name.equals('Sigma 18-35'))).getSingle(),
    ))!;
    final d = (await tester.runAsync(() => repo.loadAsset(lens.id)))!;
    expect(d.serials.map((u) => u.name), [
      'LNS-001',
      'LNS-002',
      'LNS-003',
      'LNS-004',
      'LNS-010',
    ]);
    expect(lens.rentalPriceDay, 25);
    expect(lens.tracking, Tracking.serial);
    await done(tester);
  });

  testWidgets('new asset counted by quantity; a clash is refused', (
    tester,
  ) async {
    tall(tester);
    await tester.pumpWidget(host(const NewAssetPage()));
    await settle(tester);

    await typeInto(tester, const Key('asset-name'), 'C-stand');
    // Already the tripod's code.
    await typeInto(tester, const Key('asset-code'), 'GRP-1');
    await tapOn(tester, find.text('By quantity'));
    await typeInto(tester, const Key('asset-qty'), '6');
    await tapOn(tester, find.byKey(const Key('save-asset')));
    expect(find.textContaining('already used'), findsOneWidget);
    await tapOn(tester, find.text('OK'));

    await typeInto(tester, const Key('asset-code'), 'GRP-2');
    await tapOn(tester, find.byKey(const Key('save-asset')));
    expect(find.byType(AssetDetailPage), findsOneWidget);
    final stand = (await tester.runAsync(
      () => (db.select(
        db.assets,
      )..where((a) => a.name.equals('C-stand'))).getSingle(),
    ))!;
    expect(
      (stand.qtyManual, stand.tracking, stand.code),
      (6.0, Tracking.none, 'GRP-2'),
    );
    await done(tester);
  });

  testWidgets('rented-in asset: loan fields, warning, give back', (
    tester,
  ) async {
    tall(tester);
    await tester.pumpWidget(host(const NewAssetPage()));
    await settle(tester);
    await typeInto(tester, const Key('asset-name'), 'Borrowed jib');
    await tapOn(tester, find.text('By quantity'));
    await tapOn(tester, find.text('Rented in'));
    await typeInto(tester, const Key('asset-supplier'), 'Grip House');
    await tapOn(tester, find.byKey(const Key('save-asset')));

    expect(find.byType(AssetDetailPage), findsOneWidget);
    // No due date yet: the page says so.
    expect(find.textContaining('no return date'), findsOneWidget);
    await tapOn(tester, find.byKey(const Key('give-back')));
    await tapOn(tester, find.byKey(const Key('give-back-confirm')));

    final jib = (await tester.runAsync(
      () => (db.select(
        db.assets,
      )..where((a) => a.name.equals('Borrowed jib'))).getSingle(),
    ))!;
    expect(jib.ownership, Ownership.rentedIn);
    expect(jib.supplierName, 'Grip House');
    expect(jib.rentedInReturnedAt, isNotNull);
    expect(jib.rentalOk, isFalse);
    await done(tester);
  });

  testWidgets('asset menu: maintenance and back in service', (tester) async {
    tall(tester);
    await tester.pumpWidget(host(AssetDetailPage(assetId: camera)));
    await settle(tester);
    await tapOn(tester, find.byKey(const Key('asset-menu')));
    await tapOn(tester, find.text('Send to maintenance'));
    var a = (await tester.runAsync(() => repo.loadAsset(camera)))!;
    expect(a.asset.stateManual, AssetManualState.maintenance);
    expect(a.serials.every((u) => u.state == SerialState.maintenance), isTrue);

    await tapOn(tester, find.byKey(const Key('asset-menu')));
    await tapOn(tester, find.text('Back in service'));
    a = (await tester.runAsync(() => repo.loadAsset(camera)))!;
    expect(a.asset.stateManual, isNull);
    expect(a.summary.total, 3);
    await done(tester);
  });

  testWidgets('pickup: signing the loan contract ticks it', (tester) async {
    final o = (await tester.runAsync(bookedOrder))!;
    tall(tester);
    await tester.pumpWidget(host(PickupPage(orderId: o)));
    await settle(tester);

    await tapOn(tester, find.byKey(const Key('signature-target')));
    await tapOn(tester, find.text('Loan contract').last);
    final pad = find.byKey(const Key('signature-pad'));
    await tester.ensureVisible(pad);
    await tester.pump();
    await tester.drag(pad, const Offset(120, 10));
    await tester.pump();
    await tapOn(tester, find.byKey(const Key('save-signature')));
    await settle(tester, 10);
    await tapOn(tester, find.text('Macro'));

    final order = (await tester.runAsync(() => repo.loadOrder(o)))!.order;
    expect(order.signatureTarget, SignatureTarget.loanContract);
    expect(order.sigLoanContract, isTrue);
    expect(order.sigRentalContract, isFalse);
    expect(order.captureMethod, CaptureMethod.macro);
    await done(tester);
  });

  testWidgets('order notes are saved', (tester) async {
    final o = (await tester.runAsync(bookedOrder))!;
    tall(tester);
    await tester.pumpWidget(host(OrderDetailPage(orderId: o)));
    await settle(tester);
    await tapOn(tester, find.byKey(const Key('edit-notes')));
    await tester.enterText(find.byKey(const Key('notes-field')), 'Call first');
    await tapOn(tester, find.byKey(const Key('save-notes')));
    expect(find.text('Call first'), findsOneWidget);
    final order = (await tester.runAsync(() => repo.loadOrder(o)))!.order;
    expect(order.note, 'Call first');
    await done(tester);
  });
}
