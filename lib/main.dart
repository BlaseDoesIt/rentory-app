import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'app/appearance.dart';
import 'app/language.dart';
import 'app/services.dart';
import 'data/local/database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = AppConfig.load();
  // Anything that fails or hangs here would leave the phone on the launch
  // logo, so the app opens anyway and shows what went wrong.
  String? startupError;
  if (config.hasServer) {
    try {
      await Supabase.initialize(
        url: config.supabaseUrl!,
        publishableKey: config.supabaseKey!,
        // Sign-in is by password only; no auth links to catch.
        authOptions: const FlutterAuthClientOptions(detectSessionInUri: false),
      ).timeout(const Duration(seconds: 20));
    } catch (e) {
      startupError = '$e';
    }
  }
  final language = await LanguageController.load();
  final appearance = await AppearanceController.load();
  runApp(
    RentoryApp(
      config: config,
      db: RentoryDatabase(),
      language: language,
      appearance: appearance,
      startupError: startupError,
    ),
  );
}
