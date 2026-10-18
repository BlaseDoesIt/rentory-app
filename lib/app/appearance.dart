import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Light, dark, or following the device, as picked in Settings.
class AppearanceController extends ValueNotifier<ThemeMode> {
  AppearanceController([super.value = ThemeMode.system]);

  static const _key = 'theme_mode';

  /// Reads the saved choice. A broken preferences store just means "device".
  static Future<AppearanceController> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString(_key);
      return AppearanceController(
        ThemeMode.values.where((m) => m.name == name).firstOrNull ??
            ThemeMode.system,
      );
    } catch (_) {
      return AppearanceController();
    }
  }

  Future<void> choose(ThemeMode mode) async {
    value = mode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, mode.name);
    } catch (_) {
      // Kept for this run only.
    }
  }
}

/// Hands the controller to Settings; sits above MaterialApp.
class AppearanceScope extends InheritedNotifier<AppearanceController> {
  const AppearanceScope({
    super.key,
    required AppearanceController controller,
    required super.child,
  }) : super(notifier: controller);

  static AppearanceController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppearanceScope>()!.notifier!;
}
