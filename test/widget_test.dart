import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rentory/app/app.dart';
import 'package:rentory/app/services.dart';
import 'package:rentory/data/demo_seed.dart';
import 'package:rentory/data/local/database.dart';
import 'package:rentory/data/local/local_repository.dart';

void main() {
  testWidgets('the app shows demo orders and assets', (tester) async {
    final db = RentoryDatabase.memory(NativeDatabase.memory());
    final repo = LocalRepository(db, gateway: LocalBookingGateway(db));
    await tester.runAsync(() => DemoSeed(db, repo).run());
    tester.view.physicalSize = const Size(1200, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      RentoryApp(
        config: const AppConfig(),
        db: db,
        backend: Backend(repo, null),
      ),
    );
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(seconds: 1)),
    );
    await tester.pump();

    expect(find.text('Sample Productions'), findsOneWidget);
    expect(find.text('Test Films'), findsOneWidget);
    // Dashboard: one order out, and it is late.
    expect(
      find.descendant(
        of: find.byKey(const Key('stat-overdue')),
        matching: find.text('1'),
      ),
      findsOneWidget,
    );
    expect(find.textContaining(RegExp(r'days? late')), findsOneWidget);

    await tester.tap(find.text('Assets').last);
    await tester.pump();
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(seconds: 1)),
    );
    await tester.pump();
    expect(find.text('Canon EOS C300 Mark III'), findsOneWidget);
    // 3 units: one out on the late order.
    expect(find.text('2 of 3 available'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(db.close);
  });

  testWidgets('a build without the server address says so', (tester) async {
    final db = RentoryDatabase.memory(NativeDatabase.memory());
    await tester.pumpWidget(RentoryApp(config: const AppConfig(), db: db));
    await tester.pump();
    expect(find.textContaining('without the server address'), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(db.close);
  });
}
