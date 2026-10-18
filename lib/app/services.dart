import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../data/local/database.dart';
import '../data/local/local_repository.dart';
import '../data/repository.dart';
import '../data/sync/remote_store.dart';
import '../data/sync/sync_engine.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

/// Where the server is. Build flags win (release builds get them at build
/// time: `--dart-define-from-file`); on a development PC the user env vars
/// work too. Without either the app can't run.
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
    this.files = const AppFiles(),
    required super.child,
  });

  final RentoryDatabase db;
  final Backend backend;
  RentoryRepository get repo => backend.repo;

  /// Null only in tests.
  SyncEngine? get sync => backend.sync;
  final String? userEmail;
  final Future<void> Function()? onSignOut;

  /// Where photos and signatures are saved before they upload.
  final AppFiles files;

  static Services of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Services>()!;

  /// The same services around another subtree.
  Widget wrap(Widget child) => Services(
    db: db,
    backend: backend,
    userEmail: userEmail,
    onSignOut: onSignOut,
    files: files,
    child: child,
  );

  /// Pushed routes sit outside the tree [Services] was put in, so carry it.
  static Future<T?> push<T>(BuildContext context, Widget page) {
    final services = of(context);
    return Navigator.of(context)
        .push<T>(MaterialPageRoute<T>(builder: (_) => services.wrap(page)));
  }

  @override
  bool updateShouldNotify(Services old) =>
      backend != old.backend || userEmail != old.userEmail;

  /// Through Supabase: bookings refereed by the server. The local database
  /// is only a cache of it.
  static Backend online(RentoryDatabase db, SupabaseClient client) {
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

/// Pictures kept on this device: condition photos and signatures. The sync
/// engine uploads them from here.
class AppFiles {
  const AppFiles({this.root});

  /// Fixed folder (tests). Null uses the app's documents folder.
  final String? root;

  Future<Directory> _dir() async {
    final base = root ?? (await getApplicationDocumentsDirectory()).path;
    final dir = Directory(p.join(base, 'rentory_photos'));
    await dir.create(recursive: true);
    return dir;
  }

  /// Copies a picked or captured picture in and returns its new path.
  Future<String> keep(String sourcePath, String name) async {
    final ext = p.extension(sourcePath).isEmpty
        ? '.jpg'
        : p.extension(sourcePath);
    final target = p.join((await _dir()).path, '$name$ext');
    await File(sourcePath).copy(target);
    return target;
  }

  /// The camera on a phone, a file picker on PC. Null when cancelled.
  Future<String?> pickPhoto() async {
    final phone = Platform.isAndroid || Platform.isIOS;
    final shot = await ImagePicker().pickImage(
      source: phone ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 2000,
      imageQuality: 85,
    );
    return shot?.path;
  }

  Future<String> write(Uint8List bytes, String fileName) async {
    final target = p.join((await _dir()).path, fileName);
    await File(target).writeAsBytes(bytes, flush: true);
    return target;
  }
}
