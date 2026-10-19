import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/odoo/odoo_client.dart';

/// Where the data lives. One at a time; the two never sync with each other.
enum BackendKind { supabase, odoo }

/// The backend picked in Settings, and the Odoo sign-in. The Odoo address
/// and database go in the preferences; the API key in the OS keychain.
class BackendController extends ChangeNotifier {
  BackendController({
    this.kind = BackendKind.supabase,
    this.odoo,
    this.odooUserName,
    this.draft,
    SecretStore? secrets,
  }) : _secrets = secrets ?? const SecretStore();

  BackendKind kind;

  /// Null until someone signs in to Odoo on this device.
  OdooCredentials? odoo;

  /// Who the key belongs to, as Odoo names them.
  String? odooUserName;

  /// What the Odoo sign-in form starts with: the last address and database,
  /// or on a development PC the `ODOO_URL` / `ODOO_DB` / `ODOO_API_KEY` env
  /// vars.
  OdooCredentials? draft;

  final SecretStore _secrets;

  static const _kindKey = 'backend';
  static const _urlKey = 'odoo_url';
  static const _dbKey = 'odoo_db';
  static const _userKey = 'odoo_user_name';
  static const _secretKey = 'odoo_api_key';

  /// Reads the saved choice. A broken store just means "Rentory server".
  static Future<BackendController> load({SecretStore? secrets}) async {
    final store = secrets ?? const SecretStore();
    try {
      final prefs = await SharedPreferences.getInstance();
      final kind = prefs.getString(_kindKey) == BackendKind.odoo.name
          ? BackendKind.odoo
          : BackendKind.supabase;
      final url = prefs.getString(_urlKey) ?? '';
      final db = prefs.getString(_dbKey) ?? '';
      final key = await store.read(_secretKey) ?? '';
      final saved = OdooCredentials(url: url, database: db, apiKey: key);
      return BackendController(
        kind: kind,
        odoo: saved.complete ? saved : null,
        odooUserName: prefs.getString(_userKey),
        draft: saved.complete ? saved : _fromEnv(saved),
        secrets: store,
      );
    } catch (_) {
      return BackendController(draft: _fromEnv(null), secrets: store);
    }
  }

  static OdooCredentials? _fromEnv(OdooCredentials? saved) {
    final desktop = Platform.isWindows || Platform.isMacOS || Platform.isLinux;
    final env = desktop ? Platform.environment : const <String, String>{};
    String pick(String? have, String name) =>
        (have ?? '').isNotEmpty ? have! : env[name] ?? '';
    final url = pick(saved?.url, 'ODOO_URL');
    final db = pick(saved?.database, 'ODOO_DB');
    final key = pick(saved?.apiKey, 'ODOO_API_KEY');
    if (url.isEmpty && db.isEmpty && key.isEmpty) return null;
    return OdooCredentials(url: url, database: db, apiKey: key);
  }

  Future<void> choose(BackendKind next) async {
    if (next == kind) return;
    kind = next;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kindKey, next.name);
    } catch (_) {
      // Kept for this run only.
    }
  }

  /// Keeps a sign-in that Odoo accepted.
  Future<void> signInToOdoo(
    OdooCredentials credentials,
    String userName,
  ) async {
    odoo = credentials;
    draft = credentials;
    odooUserName = userName;
    kind = BackendKind.odoo;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kindKey, BackendKind.odoo.name);
      await prefs.setString(_urlKey, credentials.url);
      await prefs.setString(_dbKey, credentials.database);
      await prefs.setString(_userKey, userName);
      await _secrets.write(_secretKey, credentials.apiKey);
    } catch (_) {
      // Kept for this run only: the next launch asks again.
    }
  }

  /// Forgets the API key; the address and database stay for next time.
  Future<void> signOutOfOdoo() async {
    final was = odoo;
    odoo = null;
    odooUserName = null;
    if (was != null) {
      draft = OdooCredentials(url: was.url, database: was.database, apiKey: '');
    }
    notifyListeners();
    try {
      await _secrets.delete(_secretKey);
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
    } catch (_) {
      // Nothing saved to forget.
    }
  }
}

/// The OS keychain (Windows Credential Manager, Android Keystore, ...).
class SecretStore {
  const SecretStore();

  static const _storage = FlutterSecureStorage();

  Future<String?> read(String key) => _storage.read(key: key);
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);
  Future<void> delete(String key) => _storage.delete(key: key);
}

/// Hands the controller to Settings and the sign-in pages. Sits above
/// MaterialApp, so pushed routes see it too.
class BackendScope extends InheritedNotifier<BackendController> {
  const BackendScope({
    super.key,
    required BackendController controller,
    required super.child,
  }) : super(notifier: controller);

  static BackendController? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<BackendScope>()?.notifier;
}
