import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/local/database.dart';
import '../data/odoo/odoo_client.dart';
import '../data/odoo/odoo_sync.dart';
import '../data/sync/sync_engine.dart';
import '../features/auth/odoo_sign_in_page.dart';
import '../features/assets/assets_page.dart';
import '../features/auth/sign_in_page.dart';
import '../features/orders/orders_page.dart';
import '../features/scan/scan_page.dart';
import '../features/settings/settings_page.dart';
import 'appearance.dart';
import 'backend_choice.dart';
import 'busy_overlay.dart';
import 'connection_gate.dart';
import 'format.dart';
import 'language.dart';
import 'services.dart';
import 'theme.dart';
import 'widgets.dart';

/// The whole app. Rentory works online only: it needs the server's address
/// (build flags or env vars, see [AppConfig]) and a signed-in user.
class RentoryApp extends StatefulWidget {
  const RentoryApp({
    super.key,
    required this.config,
    required this.db,
    this.language,
    this.appearance,
    this.files = const AppFiles(),
    this.backend,
    this.backendChoice,
    this.startupError,
  });

  final AppConfig config;
  final RentoryDatabase db;

  /// The Settings language choice. Null follows the device.
  final LanguageController? language;

  /// Light, dark or system, from Settings.
  final AppearanceController? appearance;
  final AppFiles files;

  /// Skips sign-in and uses this backend as is (tests).
  @visibleForTesting
  final Backend? backend;

  /// Rentory server or Odoo, from Settings.
  final BackendController? backendChoice;

  /// Why the server connection couldn't be set up at launch, if it failed.
  final String? startupError;

  @override
  State<RentoryApp> createState() => _RentoryAppState();
}

class _RentoryAppState extends State<RentoryApp> {
  late final LanguageController _language =
      widget.language ?? LanguageController();
  late final AppearanceController _appearance =
      widget.appearance ?? AppearanceController();
  late final BackendController _choice =
      widget.backendChoice ?? BackendController();

  /// The signed-in session's sync engine, watched by [ConnectionGate].
  final _sync = ValueNotifier<SyncEngine?>(null);

  @override
  void initState() {
    super.initState();
    _sync.value = widget.backend?.sync;
  }

  @override
  void dispose() {
    _sync.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppearanceScope(
      controller: _appearance,
      child: LanguageScope(
        controller: _language,
        child: BackendScope(
          controller: _choice,
          child: ListenableBuilder(
            listenable: Listenable.merge([_language, _appearance, _choice]),
            builder: (context, _) => _app(_language.value),
          ),
        ),
      ),
    );
  }

  Widget _home() {
    final backend = widget.backend;
    if (backend != null) {
      return Services(
        db: widget.db,
        backend: backend,
        userEmail: null,
        onSignOut: null,
        files: widget.files,
        child: const AppShell(),
      );
    }
    if (_choice.kind == BackendKind.odoo) {
      final credentials = _choice.odoo;
      if (credentials == null) return OdooSignInPage(backend: _choice);
      return _OdooRoot(
        key: ValueKey(
          '${credentials.url}|${credentials.database}|${credentials.apiKey}',
        ),
        credentials: credentials,
        choice: _choice,
        files: widget.files,
        sync: _sync,
      );
    }
    if (!widget.config.hasServer) return _NotConfigured(choice: _choice);
    final error = widget.startupError;
    if (error != null) return _StartupFailed(error);
    return _SignedInRoot(db: widget.db, files: widget.files, sync: _sync);
  }

  Widget _app(Locale? locale) {
    return MaterialApp(
      onGenerateTitle: (context) => context.l10n.appName,
      debugShowCheckedModeBanner: false,
      theme: rentoryTheme(Brightness.light),
      darkTheme: rentoryTheme(Brightness.dark),
      themeMode: _appearance.value,
      // Light and dark cross-fade instead of flipping.
      themeAnimationDuration: Mono.medium,
      themeAnimationCurve: Mono.ease,
      locale: locale,
      supportedLocales: LanguageController.supported,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Plain 'ar', never a regional variant: those can switch to
      // Arabic-Indic digits, and the app keeps 0-9.
      localeResolutionCallback: (device, supported) {
        final code = (locale ?? device)?.languageCode;
        return supported.firstWhere(
          (s) => s.languageCode == code,
          orElse: () => supported.first,
        );
      },
      // Above the navigator, so open orders are covered too.
      builder: (context, child) {
        Intl.defaultLocale = Localizations.localeOf(context).languageCode;
        return BusyOverlay(
          child: ConnectionGate(sync: _sync, child: child!),
        );
      },
      home: _home(),
    );
  }
}

/// A build made without the server's address. Nothing works offline, so say
/// so instead of opening an empty app.
class _NotConfigured extends StatelessWidget {
  const _NotConfigured({required this.choice});
  final BackendController choice;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l.notConfigured, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => choice.choose(BackendKind.odoo),
                child: Text(l.useOdooInstead),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The server connection couldn't be set up. Shows the reason so it can be
/// reported.
class _StartupFailed extends StatelessWidget {
  const _StartupFailed(this.error);
  final String error;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      body: SafeArea(
        // Long Java traces don't fit the screen: scroll, and copy in one tap.
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(l.startupFailed, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: error));
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(l.errorCopied)));
                },
                icon: const Icon(Icons.copy),
                label: Text(l.copyError),
              ),
              const SizedBox(height: 16),
              SelectableText(
                error,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Sign in first, then sync for as long as the session lasts.
class _SignedInRoot extends StatefulWidget {
  const _SignedInRoot({
    required this.db,
    required this.files,
    required this.sync,
  });
  final RentoryDatabase db;
  final AppFiles files;
  final ValueNotifier<SyncEngine?> sync;

  @override
  State<_SignedInRoot> createState() => _SignedInRootState();
}

class _SignedInRootState extends State<_SignedInRoot> {
  final _client = Supabase.instance.client;
  late final StreamSubscription<AuthState> _auth;
  Backend? _backend;
  String? _email;

  @override
  void initState() {
    super.initState();
    _apply(_client.auth.currentSession);
    _auth = _client.auth.onAuthStateChange.listen((s) => _apply(s.session));
  }

  void _apply(Session? session) {
    if (session == null) {
      _backend?.sync?.stop();
      widget.sync.value = null;
      if (mounted) {
        setState(() => _backend = null);
      } else {
        _backend = null;
      }
      return;
    }
    if (_backend != null) return;
    final backend = Services.online(widget.db, _client);
    backend.sync!.start();
    widget.sync.value = backend.sync;
    void set() {
      _backend = backend;
      _email = session.user.email;
    }

    mounted ? setState(set) : set();
  }

  @override
  void dispose() {
    _auth.cancel();
    final engine = _backend?.sync;
    engine?.stop();
    _release(widget.sync, engine);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backend = _backend;
    if (backend == null) return SignInPage(client: _client);
    return Services(
      db: widget.db,
      backend: backend,
      userEmail: _email,
      onSignOut: () => _client.auth.signOut(),
      files: widget.files,
      child: const AppShell(),
    );
  }
}

/// Stops [ConnectionGate] watching [engine] once the tree is settled (it is
/// an ancestor, so it can't be told while this subtree is being torn down).
void _release(ValueNotifier<SyncEngine?> sync, SyncEngine? engine) {
  if (engine == null) return;
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (sync.value == engine) sync.value = null;
  });
}

/// Odoo mode: its own local database per Odoo database, filled from Odoo
/// for as long as the sign-in lasts.
class _OdooRoot extends StatefulWidget {
  const _OdooRoot({
    super.key,
    required this.credentials,
    required this.choice,
    required this.files,
    required this.sync,
  });
  final OdooCredentials credentials;
  final BackendController choice;
  final AppFiles files;
  final ValueNotifier<SyncEngine?> sync;

  @override
  State<_OdooRoot> createState() => _OdooRootState();
}

class _OdooRootState extends State<_OdooRoot> {
  late final RentoryDatabase _db = RentoryDatabase.odoo(
    widget.credentials.database,
  );
  late final OdooClient _client = OdooClient(widget.credentials);
  late final OdooSyncEngine _engine = OdooSyncEngine(_db, _client)
    ..signOut = widget.choice.signOutOfOdoo;
  late final Backend _backend = odooBackend(_db, _engine);

  @override
  void initState() {
    super.initState();
    _engine.start();
    // The gate sits above this page: tell it after this frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.sync.value = _engine;
    });
  }

  @override
  void dispose() {
    _engine.stop();
    _release(widget.sync, _engine);
    _client.close();
    unawaited(_db.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Services(
      db: _db,
      backend: _backend,
      userEmail: widget.choice.odooUserName,
      onSignOut: widget.choice.signOutOfOdoo,
      files: widget.files,
      odooDatabase: widget.credentials.database,
      child: const AppShell(),
    );
  }
}

class _Destination {
  const _Destination(this.label, this.icon, this.selectedIcon, this.page);
  final String Function(AppLocalizations) label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget page;
}

final _destinations = [
  _Destination(
    (l) => l.orders,
    Icons.receipt_long_outlined,
    Icons.receipt_long,
    const OrdersPage(),
  ),
  _Destination(
    (l) => l.scan,
    Icons.qr_code_scanner_outlined,
    Icons.qr_code_scanner,
    const ScanPage(),
  ),
  _Destination(
    (l) => l.assets,
    Icons.inventory_2_outlined,
    Icons.inventory_2,
    const AssetsPage(),
  ),
  _Destination(
    (l) => l.settings,
    Icons.settings_outlined,
    Icons.settings,
    const SettingsPage(),
  ),
];

/// Bottom tabs on phones, a side navigation on PC and tablets (with labels
/// once there is room).
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  void _go(int i) {
    if (i != _index) setState(() => _index = i);
  }

  /// Tabs cross-fade with a slight rise instead of snapping.
  Widget _page() => AnimatedSwitcher(
    duration: Mono.medium,
    switchInCurve: Mono.ease,
    switchOutCurve: Curves.easeIn,
    transitionBuilder: (child, a) => FadeTransition(
      opacity: a,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.015),
          end: Offset.zero,
        ).animate(a),
        child: child,
      ),
    ),
    child: KeyedSubtree(
      key: ValueKey(_index),
      child: _destinations[_index].page,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final width = MediaQuery.sizeOf(context).width;

    if (width < 720) {
      return Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(gradient: Mono.page(context)),
          child: SafeArea(bottom: false, child: _page()),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: _go,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            for (final d in _destinations)
              NavigationDestination(
                icon: Icon(d.icon),
                selectedIcon: Icon(d.selectedIcon),
                label: d.label(l),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          _SideNav(extended: width >= 1100, index: _index, onSelect: _go),
          VerticalDivider(
            width: 1,
            color: Theme.of(context).colorScheme.outline,
          ),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: Mono.page(context)),
              child: _page(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SideNav extends StatelessWidget {
  const _SideNav({
    required this.extended,
    required this.index,
    required this.onSelect,
  });
  final bool extended;
  final int index;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return AnimatedContainer(
      duration: Mono.medium,
      curve: Mono.ease,
      width: extended ? 232 : 88,
      color: scheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          child: Column(
            crossAxisAlignment: extended
                ? CrossAxisAlignment.stretch
                : CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(
                  start: extended ? 8 : 0,
                  bottom: 28,
                ),
                child: Row(
                  mainAxisAlignment: extended
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: [
                    const BrandMark(size: 40),
                    if (extended) ...[
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          l.appName,
                          style: text.titleLarge,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              for (final (i, d) in _destinations.indexed)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: _NavItem(
                    icon: i == index ? d.selectedIcon : d.icon,
                    label: d.label(l),
                    selected: i == index,
                    extended: extended,
                    onTap: () => onSelect(i),
                  ),
                ),
              const Spacer(),
              const _SyncDot(),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.extended,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final bool selected;
  final bool extended;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fg = selected ? scheme.onPrimary : scheme.onSurfaceVariant;
    final weight = selected ? FontWeight.w700 : FontWeight.w500;
    final item = AnimatedContainer(
      duration: Mono.medium,
      curve: Mono.ease,
      decoration: BoxDecoration(
        gradient: selected ? Mono.ink(context) : null,
        borderRadius: BorderRadius.circular(Mono.radiusSmall),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(Mono.radiusSmall),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: extended ? 14 : 0,
              vertical: extended ? 12 : 10,
            ),
            child: extended
                ? Row(
                    children: [
                      Icon(icon, color: fg, size: 22),
                      const SizedBox(width: 14),
                      Text(
                        label,
                        style: TextStyle(
                          color: selected ? scheme.onPrimary : scheme.onSurface,
                          fontWeight: weight,
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Icon(icon, color: fg, size: 22),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 11,
                          color: fg,
                          fontWeight: weight,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
    return SizedBox(width: extended ? null : 64, child: item);
  }
}

/// Small sync indicator at the bottom of the side navigation.
class _SyncDot extends StatelessWidget {
  const _SyncDot();

  @override
  Widget build(BuildContext context) {
    final sync = Services.of(context).sync;
    if (sync == null) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;
    return StreamBuilder<SyncStatus>(
      stream: sync.status,
      initialData: sync.lastStatus,
      builder: (context, snap) {
        final s = snap.data!;
        final syncing = s.phase == SyncPhase.syncing;
        return Tooltip(
          message: syncing
              ? context.l10n.syncing
              : context.l10n.synced(when(s.lastSynced)),
          child: syncing
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scheme.primary,
                  ),
                ),
        );
      },
    );
  }
}
