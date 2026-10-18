import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'app/language.dart';
import 'app/services.dart';
import 'data/local/database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = AppConfig.load();
  if (config.hasServer) {
    await Supabase.initialize(
      url: config.supabaseUrl!,
      publishableKey: config.supabaseKey!,
    );
  }
  final language = await LanguageController.load();
  runApp(RentoryApp(config: config, db: RentoryDatabase(), language: language));
}
