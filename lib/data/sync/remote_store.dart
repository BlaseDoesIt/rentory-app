import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../repository.dart';

/// The server, as the sync engine sees it. Supabase in the app; an in-memory
/// fake in tests.
abstract interface class RemoteStore {
  /// Insert or update rows by id. Rows use SQL column names.
  Future<void> upsert(String table, List<Map<String, Object?>> rows);

  /// Rows changed after [afterSeq], oldest first.
  Future<List<Map<String, Object?>>> changesSince(
    String table,
    int afterSeq, {
    int limit = 500,
  });

  /// Confirm a booking. Returns the order number, or throws
  /// [RuleException] with the server's reason.
  Future<String> bookOrder(String orderId);

  Future<void> uploadPhoto(String path, Uint8List bytes);

  /// A photo another device uploaded.
  Future<Uint8List> downloadPhoto(String path);
}

class SupabaseRemoteStore implements RemoteStore {
  SupabaseRemoteStore(this.client);
  final SupabaseClient client;

  @override
  Future<void> upsert(String table, List<Map<String, Object?>> rows) async {
    if (rows.isEmpty) return;
    await client.from(table).upsert(rows, onConflict: 'id');
  }

  @override
  Future<List<Map<String, Object?>>> changesSince(
    String table,
    int afterSeq, {
    int limit = 500,
  }) async {
    final rows = await client
        .from(table)
        .select()
        .gt('server_seq', afterSeq)
        .order('server_seq')
        .limit(limit);
    return [for (final r in rows) Map<String, Object?>.from(r)];
  }

  @override
  Future<String> bookOrder(String orderId) async {
    try {
      final number = await client.rpc<String>(
        'book_order',
        params: {'p_order_id': orderId},
      );
      return number;
    } on PostgrestException catch (e) {
      // P0001: a rule refused it (unit taken, not enough stock, no dates).
      if (e.code == 'P0001' || e.code == 'P0002') {
        throw RuleException.one(e.message);
      }
      rethrow;
    }
  }

  @override
  Future<void> uploadPhoto(String path, Uint8List bytes) async {
    await client.storage
        .from('photos')
        .uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            contentType: path.endsWith('.png') ? 'image/png' : 'image/jpeg',
            upsert: true,
          ),
        );
  }

  @override
  Future<Uint8List> downloadPhoto(String path) =>
      client.storage.from('photos').download(path);
}
