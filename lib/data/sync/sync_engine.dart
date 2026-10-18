import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';

import '../local/database.dart';
import '../repository.dart';
import 'remote_store.dart';

enum SyncPhase { idle, syncing, offline, error }

class SyncStatus {
  const SyncStatus(this.phase, {this.lastSynced, this.message});
  final SyncPhase phase;
  final DateTime? lastSynced;
  final String? message;
}

/// Keeps the device's SQLite database and the server in step.
///
/// * **Push**: rows marked dirty, parents before children, then the flag is
///   cleared only if the row has not changed again in the meantime.
/// * **Pull**: rows the server stamped after the last sequence number this
///   device saw. The newer `updated_at` wins; an unpushed local edit is never
///   overwritten by an older server copy.
/// * **Photos**: files saved on the device are uploaded on the next pass.
/// * **Right away**: the app is online only, so every local edit starts a
///   pass within a moment instead of waiting for the timer.
///
/// Works generically off the drift table metadata, so a new column needs no
/// change here.
class SyncEngine {
  SyncEngine(
    this.db,
    this.remote, {
    this.interval = const Duration(seconds: 10),
    this.pullOverlap = 50,
  });

  final RentoryDatabase db;
  final RemoteStore remote;
  final Duration interval;

  /// Re-read this many sequence numbers behind the cursor each pull: two
  /// transactions can commit out of order, and re-reading is harmless.
  final int pullOverlap;

  /// Server-only columns that have no local counterpart.
  static const _serverOnly = {'server_seq', 'updated_by'};

  /// Tables this device never writes to the server (made by the server).
  static const _pullOnly = {'profiles'};

  final _status = StreamController<SyncStatus>.broadcast();
  Stream<SyncStatus> get status => _status.stream;
  SyncStatus _last = const SyncStatus(SyncPhase.idle);
  SyncStatus get lastStatus => _last;

  Timer? _timer;
  Timer? _soon;
  StreamSubscription<Set<TableUpdate>>? _edits;
  Future<void>? _running;

  /// An edit came in while a pass was running; run another after it.
  bool _again = false;

  /// The last finished pass could not reach the server. Stays true through
  /// the retry, so the app stays covered until a pass gets through.
  bool get unreachable => _unreachable;
  bool _unreachable = false;

  void start() {
    _timer ??= Timer.periodic(interval, (_) => unawaited(syncNow()));
    _edits ??= db.tableUpdates().listen((_) => _editMade());
    unawaited(syncNow());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _soon?.cancel();
    _edits?.cancel();
    _edits = null;
  }

  /// Push a local edit soon. A burst of writes becomes one pass.
  void _editMade() {
    if (_running != null) {
      _again = true;
      return;
    }
    _soon?.cancel();
    _soon = Timer(
      const Duration(milliseconds: 400),
      () => unawaited(syncNow()),
    );
  }

  Future<void> dispose() async {
    stop();
    await _status.close();
  }

  /// One full pass. Concurrent calls share the pass already running.
  Future<void> syncNow() => _running ??= _pass().whenComplete(() {
    _running = null;
    if (_again && _edits != null) {
      _again = false;
      _editMade();
    }
  });

  Future<void> _pass() async {
    _emit(SyncStatus(SyncPhase.syncing, lastSynced: _last.lastSynced));
    try {
      await push();
      await uploadPhotos();
      await pull();
      _unreachable = false;
      _emit(SyncStatus(SyncPhase.idle, lastSynced: DateTime.now().toUtc()));
    } on RuleException {
      rethrow;
    } catch (e) {
      _unreachable = isConnectionProblem(e);
      _emit(
        SyncStatus(
          _unreachable ? SyncPhase.offline : SyncPhase.error,
          lastSynced: _last.lastSynced,
          message: e.toString(),
        ),
      );
    }
  }

  /// The server could not be reached at all, as opposed to answering with
  /// an error. Supabase wraps socket errors in its own exceptions, so the
  /// text is checked too.
  static bool isConnectionProblem(Object e) {
    if (e is SocketException ||
        e is TimeoutException ||
        e is HandshakeException) {
      return true;
    }
    final text = e.toString();
    return const [
      'SocketException',
      'Failed host lookup',
      'Connection closed',
      'Connection refused',
      'Connection reset',
      'Network is unreachable',
      'ClientException',
      'AuthRetryableFetchException',
    ].any(text.contains);
  }

  void _emit(SyncStatus s) {
    _last = s;
    if (!_status.isClosed) _status.add(s);
  }

  TableInfo _table(String name) =>
      db.allTables.firstWhere((t) => t.actualTableName == name);

  // ------------------------------------------------------------- push

  Future<void> push() async {
    for (final name in syncedTables) {
      if (_pullOnly.contains(name)) continue;
      final table = _table(name);
      while (true) {
        final rows = await db
            .customSelect('SELECT * FROM "$name" WHERE dirty = 1 LIMIT 200')
            .get();
        if (rows.isEmpty) break;
        final payload = [for (final r in rows) _toRemote(table, r.data)];
        await remote.upsert(name, payload);
        for (final r in rows) {
          // Only if untouched since we read it; a newer edit stays dirty.
          await db.customUpdate(
            'UPDATE "$name" SET dirty = 0 WHERE id = ? AND updated_at = ?',
            variables: [
              Variable.withString(r.data['id'] as String),
              Variable.withString(r.data['updated_at'] as String),
            ],
          );
        }
        if (rows.length < 200) break;
      }
    }
  }

  Map<String, Object?> _toRemote(TableInfo table, Map<String, Object?> raw) {
    final out = <String, Object?>{};
    for (final c in table.$columns) {
      if (c.name == 'dirty') continue;
      final v = raw[c.name];
      out[c.name] = switch (c.type) {
        DriftSqlType.bool => v == null ? null : v == 1,
        _ => v,
      };
    }
    return out;
  }

  // ------------------------------------------------------------- pull

  Future<int> _cursor(String name) async {
    final row = await (db.select(
      db.syncCursors,
    )..where((c) => c.tableName_.equals(name))).getSingleOrNull();
    return row?.serverSeq ?? 0;
  }

  Future<void> _setCursor(String name, int seq) => db
      .into(db.syncCursors)
      .insertOnConflictUpdate(
        SyncCursorsCompanion.insert(tableName_: name, serverSeq: Value(seq)),
      );

  Future<void> pull() async {
    for (final name in syncedTables) {
      final table = _table(name);
      final cursor = await _cursor(name);
      var after = cursor - pullOverlap < 0 ? 0 : cursor - pullOverlap;
      var maxSeq = cursor;
      var changed = false;
      while (true) {
        final rows = await remote.changesSince(name, after);
        if (rows.isEmpty) break;
        for (final row in rows) {
          final seq = (row['server_seq'] as num).toInt();
          if (seq > maxSeq) maxSeq = seq;
          if (await _apply(table, row)) changed = true;
        }
        after = (rows.last['server_seq'] as num).toInt();
        if (rows.length < 500) break;
      }
      if (maxSeq != cursor) await _setCursor(name, maxSeq);
      if (changed) db.notifyUpdates({TableUpdate.onTable(table)});
    }
  }

  /// Write one server row locally. Returns whether anything changed.
  Future<bool> _apply(TableInfo table, Map<String, Object?> row) async {
    final name = table.actualTableName;
    final id = row['id'] as String;
    final local = await db
        .customSelect(
          'SELECT updated_at, dirty FROM "$name" WHERE id = ?',
          variables: [Variable.withString(id)],
        )
        .getSingleOrNull();
    final remoteAt = _iso(row['updated_at'])!;
    if (local != null) {
      final localAt = local.data['updated_at'] as String;
      final dirty = local.data['dirty'] == 1;
      final cmp = DateTime.parse(remoteAt).compareTo(DateTime.parse(localAt));
      if (cmp < 0 && dirty) return false; // our edit is newer; it will push
      if (cmp == 0 && !dirty && await _same(table, id, row)) {
        return false; // already have this version
      }
    }

    final columns = <String>[];
    final values = <Variable>[];
    for (final c in table.$columns) {
      if (_serverOnly.contains(c.name)) continue;
      if (c.name == 'dirty') {
        columns.add('dirty');
        values.add(const Variable(0));
        continue;
      }
      if (!row.containsKey(c.name)) continue;
      columns.add(c.name);
      values.add(Variable(_toLocal(c.type, row[c.name])));
    }
    final placeholders = List.filled(columns.length, '?').join(', ');
    final updates = [
      for (final c in columns)
        if (c != 'id') '"$c" = excluded."$c"',
    ].join(', ');
    await db.customInsert(
      'INSERT INTO "$name" (${columns.map((c) => '"$c"').join(', ')}) '
      'VALUES ($placeholders) ON CONFLICT(id) DO UPDATE SET $updates',
      variables: values,
    );
    return true;
  }

  /// Same timestamp is not proof of same content: two edits can land in one
  /// millisecond. Compare the values before skipping.
  Future<bool> _same(
    TableInfo table,
    String id,
    Map<String, Object?> row,
  ) async {
    final local = await db
        .customSelect(
          'SELECT * FROM "${table.actualTableName}" WHERE id = ?',
          variables: [Variable.withString(id)],
        )
        .getSingle();
    for (final c in table.$columns) {
      if (c.name == 'dirty' || !row.containsKey(c.name)) continue;
      if (_toLocal(c.type, row[c.name]) != local.data[c.name]) return false;
    }
    return true;
  }

  Object? _toLocal(Object type, Object? v) {
    if (v == null) return null;
    return switch (type) {
      DriftSqlType.bool => (v == true || v == 1) ? 1 : 0,
      DriftSqlType.dateTime => _iso(v),
      DriftSqlType.double => (v as num).toDouble(),
      DriftSqlType.int => (v as num).toInt(),
      _ => v,
    };
  }

  /// Drift's own text format: UTC ISO-8601 ending in Z.
  static String? _iso(Object? v) =>
      v == null ? null : DateTime.parse(v as String).toUtc().toIso8601String();

  // ----------------------------------------------------------- photos

  /// The bytes of an uploaded photo, for a device that did not take it.
  Future<Uint8List> downloadPhoto(String storagePath) =>
      remote.downloadPhoto(storagePath);

  Future<void> uploadPhotos() async {
    final pending =
        await (db.select(db.photos)..where(
              (p) =>
                  p.storagePath.isNull() &
                  p.localPath.isNotNull() &
                  p.deleted.equals(false),
            ))
            .get();
    for (final p in pending) {
      final file = File(p.localPath!);
      if (!await file.exists()) continue;
      // Signatures are PNG, camera photos JPEG.
      final ext = p.localPath!.toLowerCase().endsWith('.png') ? 'png' : 'jpg';
      final path = 'photos/${p.id}.$ext';
      await remote.uploadPhoto(path, await file.readAsBytes());
      await (db.update(db.photos)..where((x) => x.id.equals(p.id))).write(
        PhotosCompanion(
          storagePath: Value(path),
          updatedAt: Value(DateTime.now().toUtc()),
          dirty: const Value(true),
        ),
      );
    }
    if (pending.isNotEmpty) await push();
  }
}

/// Bookings confirmed by the server: push the order first so the server can
/// see it, then let Postgres referee the units and hand out the number.
class SupabaseBookingGateway implements BookingGateway {
  SupabaseBookingGateway(this.engine);
  final SyncEngine engine;

  @override
  Future<String> confirmBooking(String orderId, DateTime bookedAt) async {
    await engine.push();
    return engine.remote.bookOrder(orderId);
  }
}
