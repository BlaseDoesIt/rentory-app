import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rentory/app/app.dart';
import 'package:rentory/app/language.dart';
import 'package:rentory/app/services.dart';
import 'package:rentory/data/local/database.dart';
import 'package:rentory/data/local/local_repository.dart';
import 'package:rentory/data/sync/remote_store.dart';
import 'package:rentory/data/sync/sync_engine.dart';
import 'package:rentory/features/orders/order_detail_page.dart';

/// An empty server whose connection can drop.
class _Server implements RemoteStore {
  bool down = true;

  void _check() {
    if (down) throw const SocketException('Network is unreachable');
  }

  @override
  Future<void> upsert(String table, List<Map<String, Object?>> rows) async =>
      _check();

  @override
  Future<List<Map<String, Object?>>> changesSince(
    String table,
    int afterSeq, {
    int limit = 500,
  }) async {
    _check();
    return const [];
  }

  @override
  Future<String> bookOrder(String orderId) async => throw UnimplementedError();

  @override
  Future<void> uploadPhoto(String path, Uint8List bytes) async => _check();

  @override
  Future<Uint8List> downloadPhoto(String path) async => Uint8List(0);
}

Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 30)),
    );
    await tester.pump(const Duration(milliseconds: 300));
  }
}

void main() {
  testWidgets('no connection covers the whole app, open orders included', (
    tester,
  ) async {
    final db = RentoryDatabase.memory(NativeDatabase.memory());
    final server = _Server();
    final sync = SyncEngine(db, server);
    final repo = LocalRepository(db, gateway: LocalBookingGateway(db));
    await tester.runAsync(() async {
      await repo.createOrder(
        customerName: 'Gate test',
        start: DateTime.utc(2026, 11, 1, 9),
        end: DateTime.utc(2026, 11, 2, 9),
      );
      await sync.syncNow();
    });

    await tester.pumpWidget(
      RentoryApp(
        config: const AppConfig(),
        db: db,
        language: LanguageController(const Locale('en')),
        backend: Backend(repo, sync),
      ),
    );
    await settle(tester);
    expect(find.text('No connection'), findsOneWidget);

    // Back online: the app opens.
    server.down = false;
    await tester.tap(find.text('Try again'));
    await settle(tester);
    expect(find.byKey(const Key('connection-gate')), findsNothing);
    await tester.tap(find.textContaining('Gate test'));
    await settle(tester);
    expect(find.byType(OrderDetailPage), findsOneWidget);

    // Dropping again covers the open order, and a retry that still fails
    // keeps it covered.
    server.down = true;
    await tester.runAsync(sync.syncNow);
    await settle(tester);
    expect(find.text('No connection'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await settle(tester);
    expect(find.text('No connection'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(() async {
      await sync.dispose();
      await db.close();
    });
  });
}
