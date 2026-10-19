import 'package:flutter/foundation.dart';

/// Work the user is waiting on: a button's action, a call to Odoo, an
/// upload. The app shows a spinner while [busy] is above zero.
///
/// Background refreshes are not counted: they run every few seconds and
/// nobody is waiting for them.
abstract final class Activity {
  static final busy = ValueNotifier<int>(0);

  static Future<T> track<T>(Future<T> Function() work) async {
    busy.value++;
    try {
      return await work();
    } finally {
      busy.value--;
    }
  }
}
