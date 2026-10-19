import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rentory/app/app.dart';
import 'package:rentory/app/backend_choice.dart';
import 'package:rentory/app/language.dart';
import 'package:rentory/app/services.dart';
import 'package:rentory/data/local/database.dart';
import 'package:rentory/data/odoo/odoo_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Odoo can be chosen instead, and back again', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final db = RentoryDatabase.memory(NativeDatabase.memory());
    addTearDown(db.close);
    final choice = BackendController(
      draft: const OdooCredentials(
        url: 'https://staging.example.com',
        database: 'staging-db',
        apiKey: '',
      ),
    );
    await tester.pumpWidget(
      RentoryApp(
        config: const AppConfig(),
        db: db,
        language: LanguageController(const Locale('en')),
        backendChoice: choice,
      ),
    );
    await tester.pump();

    // No Supabase address in this build: Odoo is offered.
    await tester.tap(find.text('Connect to Odoo instead'));
    await tester.pump();
    expect(choice.kind, BackendKind.odoo);
    expect(find.text('Connect to Odoo'), findsOneWidget);
    expect(find.text('https://staging.example.com'), findsOneWidget);
    expect(find.text('staging-db'), findsOneWidget);

    // An empty key is refused before anything is sent.
    await tester.tap(find.byKey(const Key('odoo-connect')));
    await tester.pump();
    expect(
      find.text('Fill in the address, database and API key.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Use the Rentory server instead'));
    await tester.pump();
    expect(choice.kind, BackendKind.supabase);
    expect(find.text('Connect to Odoo instead'), findsOneWidget);
  });
}
