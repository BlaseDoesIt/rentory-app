import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The language picked in Settings. Null follows the device.
class LanguageController extends ValueNotifier<Locale?> {
  LanguageController([super.value]);

  static const _key = 'language';
  static const supported = [Locale('en'), Locale('ar')];

  /// Reads the saved choice. A broken preferences store just means "device".
  static Future<LanguageController> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(_key);
      return LanguageController(code == null ? null : Locale(code));
    } catch (_) {
      return LanguageController();
    }
  }

  Future<void> choose(Locale? locale) async {
    value = locale;
    try {
      final prefs = await SharedPreferences.getInstance();
      if (locale == null) {
        await prefs.remove(_key);
      } else {
        await prefs.setString(_key, locale.languageCode);
      }
    } catch (_) {
      // Kept for this run only.
    }
  }
}

/// Hands the controller to Settings. Sits above MaterialApp, so pushed
/// routes see it too.
class LanguageScope extends InheritedNotifier<LanguageController> {
  const LanguageScope({
    super.key,
    required LanguageController controller,
    required super.child,
  }) : super(notifier: controller);

  static LanguageController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LanguageScope>()!.notifier!;
}
