import 'dart:io';

import 'package:flutter/widgets.dart';

import '../data/local/database.dart';
import '../data/local/local_repository.dart';
import '../data/repository.dart';
import '../data/sync/remote_store.dart';
import '../data/sync/sync_engine.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

/// Where the shared server is. Build flags win (phones get them at build
/// time: `--dart-define-from-file`); on a PC the user env vars work too.
/// Neither set means standalone on this device only.
class AppConfig {
  const AppConfig({this.supabaseUrl, this.supabaseKey});

  final String? supabaseUrl;
  final String? supabaseKey;

  bool get hasServer =>
      (supabaseUrl ?? '').isNotEmpty && (supabaseKey ?? '').isNotEmpty;

  static AppConfig load() {
    String? pick(String name, String fromDefine) {
      if (fromDefine.isNotEmpty) return fromDefine;
      final desktop =
          Platform.isWindows || Platform.isMacOS || Platform.isLinux;
      return desktop ? Platform.environment[name] : null;
    }

    return AppConfig(
      supabaseUrl: pick(
        'SUPABASE_URL',
        const String.fromEnvironment('SUPABASE_URL'),
      ),
      supabaseKey: pick(
        'SUPABASE_ANON_KEY',
        const String.fromEnvironment('SUPABASE_ANON_KEY'),
      ),
    );
  }
}

/// Everything the screens need, handed down the widget tree.
class Services extends InheritedWidget {
  const Services({
    super.key,
    required this.db,
    required this.backend,
    required this.userEmail,
    required this.onSignOut,
    required super.child,
  });

  final RentoryDatabase db;
  final Backend backend;
  RentoryRepository get repo => backend.repo;

  /// Null in standalone mode.
  SyncEngine? get sync => backend.sync;
  final String? userEmail;
  final Future<void> Function()? onSignOut;

  static Services of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Services>()!;

  @override
  bool updateShouldNotify(Services old) =>
      backend != old.backend || userEmail != old.userEmail;

  /// Standalone: this device's database and its own order numbers.
  static Backend standalone(RentoryDatabase db) =>
      Backend(LocalRepository(db, gateway: LocalBookingGateway(db)), null);

  /// Shared through Supabase: bookings refereed by the server.
  static Backend shared(RentoryDatabase db, SupabaseClient client) {
    final sync = SyncEngine(db, SupabaseRemoteStore(client));
    final repo = LocalRepository(
      db,
      gateway: SupabaseBookingGateway(sync),
      currentUserId: () => client.auth.currentUser?.id,
    );
    return Backend(repo, sync);
  }
}

/// The repository the screens use and, when shared, the engine syncing it.
class Backend {
  const Backend(this.repo, this.sync);
  final RentoryRepository repo;
  final SyncEngine? sync;
}
