import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Where an Odoo database is and whose API key opens it.
class OdooCredentials {
  const OdooCredentials({
    required this.url,
    required this.database,
    required this.apiKey,
  });

  /// `https://example.odoo.com`, without `/odoo` or a trailing slash.
  final String url;
  final String database;

  /// The person's own key (Odoo: Preferences > Account Security > API Keys).
  final String apiKey;

  bool get complete =>
      url.isNotEmpty && database.isNotEmpty && apiKey.isNotEmpty;

  /// What people paste: the address bar may carry `/odoo/...` or `/web#...`.
  static String cleanUrl(String raw) {
    var url = raw.trim();
    if (url.isEmpty) return url;
    if (!url.contains('://')) url = 'https://$url';
    final uri = Uri.parse(url);
    return Uri(
      scheme: uri.scheme,
      host: uri.host,
      port: uri.hasPort ? uri.port : null,
    ).toString();
  }
}

/// Odoo refused the call, with its own words (a `UserError`, an access
/// error, a wrong key). [status] is the HTTP status.
class OdooException implements Exception {
  const OdooException(this.message, {this.status, this.name});
  final String message;
  final int? status;

  /// Odoo's exception class, e.g. `odoo.exceptions.UserError`.
  final String? name;

  bool get badKey => status == 401;

  @override
  String toString() => message;
}

/// Odoo's sentences use long dashes ("still with the customer — check
/// them back in"); the app reads them as commas.
String plainDashes(String text) => text
    .replaceAll(RegExp(r'\s+[—–]\s+'), ', ')
    .replaceAll(RegExp('[—–]'), '-');

/// Who the key belongs to.
class OdooUser {
  const OdooUser({required this.id, required this.name, required this.login});
  final int id;
  final String name;
  final String login;
}

/// Odoo 19's JSON-2 API: `POST /json/2/<model>/<method>` with the API key as
/// a bearer token and named arguments as the body. Only public methods can
/// be called.
class OdooClient {
  OdooClient(
    this.credentials, {
    HttpClient? http,
    this.timeout = const Duration(seconds: 60),
  }) : _http = http ?? HttpClient();

  final OdooCredentials credentials;
  final Duration timeout;
  final HttpClient _http;

  Future<Object?> call(
    String model,
    String method, [
    Map<String, Object?> args = const {},
  ]) async {
    final uri = Uri.parse('${credentials.url}/json/2/$model/$method');
    final request = await _http.postUrl(uri).timeout(timeout);
    request.headers
      ..set(HttpHeaders.authorizationHeader, 'bearer ${credentials.apiKey}')
      ..set('X-Odoo-Database', credentials.database)
      ..contentType = ContentType.json;
    request.add(utf8.encode(jsonEncode(args)));
    final response = await request.close().timeout(timeout);
    final body = await response.transform(utf8.decoder).join().timeout(timeout);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body.isEmpty ? null : jsonDecode(body);
    }
    throw _error(response.statusCode, body);
  }

  static OdooException _error(int status, String body) {
    try {
      final json = jsonDecode(body);
      if (json is Map && json['message'] is String) {
        return OdooException(
          plainDashes(json['message'] as String),
          status: status,
          name: json['name'] as String?,
        );
      }
    } catch (_) {
      // Not JSON: a proxy page or a plain-text error.
    }
    final text = body.length > 300 ? '${body.substring(0, 300)}...' : body;
    return OdooException(
      'Odoo answered $status${text.isEmpty ? '' : ': $text'}',
      status: status,
    );
  }

  Future<List<Map<String, Object?>>> searchRead(
    String model, {
    List<Object?> domain = const [],
    required List<String> fields,
    String? order,
    int? limit,
    int? offset,
    bool activeTest = true,
  }) async {
    final rows = await call(model, 'search_read', {
      'domain': domain,
      'fields': fields,
      'order': ?order,
      'limit': ?limit,
      'offset': ?offset,
      if (!activeTest) 'context': {'active_test': false},
    });
    return [for (final r in rows as List) Map<String, Object?>.from(r as Map)];
  }

  Future<List<int>> search(
    String model, {
    List<Object?> domain = const [],
    bool activeTest = true,
  }) async {
    final ids = await call(model, 'search', {
      'domain': domain,
      if (!activeTest) 'context': {'active_test': false},
    });
    return [for (final id in ids as List) (id as num).toInt()];
  }

  Future<List<Map<String, Object?>>> read(
    String model,
    List<int> ids, {
    required List<String> fields,
  }) async {
    if (ids.isEmpty) return const [];
    final rows = await call(model, 'read', {'ids': ids, 'fields': fields});
    return [for (final r in rows as List) Map<String, Object?>.from(r as Map)];
  }

  /// The key's owner. A wrong key or database fails here, before any data.
  Future<OdooUser> whoAmI() async {
    final ctx = await call('res.users', 'context_get') as Map;
    final uid = (ctx['uid'] as num).toInt();
    final row = (await read(
      'res.users',
      [uid],
      fields: ['name', 'login'],
    )).first;
    return OdooUser(
      id: uid,
      name: row['name'] as String? ?? '',
      login: row['login'] as String? ?? '',
    );
  }

  /// Fails with Odoo's own words when Rentory is not installed on this
  /// database or the user has no Rentory access.
  Future<void> checkRentory() =>
      call('rentory.order', 'search_count', {'domain': const []});

  Future<bool> hasGroup(int uid, String xmlId) async =>
      await call('res.users', 'has_group', {
        'ids': [uid],
        'group_ext_id': xmlId,
      }) ==
      true;

  /// The databases on a server, when it lists them (odoo.sh does, one per
  /// branch). Empty when it does not.
  static Future<List<String>> databases(String url, {HttpClient? http}) async {
    final client = http ?? HttpClient();
    try {
      final request = await client
          .postUrl(Uri.parse('$url/web/database/list'))
          .timeout(const Duration(seconds: 20));
      request.headers.contentType = ContentType.json;
      request.add(utf8.encode(jsonEncode({'jsonrpc': '2.0', 'params': {}})));
      final response = await request.close().timeout(
        const Duration(seconds: 20),
      );
      final body = await response.transform(utf8.decoder).join();
      final result = (jsonDecode(body) as Map)['result'];
      return result is List ? [for (final d in result) '$d'] : const [];
    } on FormatException {
      return const [];
    } finally {
      if (http == null) client.close();
    }
  }

  void close() => _http.close(force: true);
}
