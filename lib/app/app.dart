import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/local/database.dart';
import '../data/sync/sync_engine.dart';
import '../features/assets/assets_page.dart';
import '../features/auth/sign_in_page.dart';
import '../features/orders/orders_page.dart';
import '../features/scan/scan_page.dart';
import '../features/settings/settings_page.dart';
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
    this.files = const AppFiles(),
    this.backend,
  });

  final AppConfig config;
  final RentoryDatabase db;

  /// The Settings language choice. Null follows the device.
  final LanguageController? language;
  final AppFiles files;

  /// Skips sign-in and uses this backend as is (tests).
  @visibleForTesting
  final Backend? backend;

  @override
  State<RentoryApp> createState() => _RentoryAppState();
}

class _RentoryAppState extends State<RentoryApp> {
  late final LanguageController _language =
      widget.language ?? LanguageController();

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
    return LanguageScope(
      controller: _language,
      child: ValueListenableBuilder<Locale?>(
        valueListenable: _language,
        builder: (context, locale, _) => _app(locale),
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
    if (!widget.config.hasServer) return const _NotConfigured();
    return _SignedInRoot(db: widget.db, files: widget.files, sync: _sync);
  }

  Widget _app(Locale? locale) {
    return MaterialApp(
      onGenerateTitle: (context) => context.l10n.appName,
      debugShowCheckedModeBanner: false,
      theme: rentoryTheme(Brightness.light),
      darkTheme: rentoryTheme(Brightness.dark),
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
        return ConnectionGate(sync: _sync, child: child!);
      },
      home: _home(),
    );
  }
}

/// A build made without the server's address. Nothing works offline, so say
/// so instead of opening an empty app.
class _NotConfigured extends StatelessWidget {
  const _NotConfigured();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(l.notConfigured, textAlign: TextAlign.center),
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
    _backend?.sync?.stop();
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
          child: AnimatedContainer(
            duration: Mono.medium,
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: syncing ? scheme.onSurfaceVariant : scheme.primary,
            ),
          ),
        );
      },
    );
  }
}
