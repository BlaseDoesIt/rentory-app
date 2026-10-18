import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/local/database.dart';
import '../features/assets/assets_page.dart';
import '../features/auth/sign_in_page.dart';
import '../features/orders/orders_page.dart';
import '../features/scan/scan_page.dart';
import '../features/settings/settings_page.dart';
import 'format.dart';
import 'language.dart';
import 'services.dart';
import 'theme.dart';

class RentoryApp extends StatelessWidget {
  const RentoryApp({
    super.key,
    required this.config,
    required this.db,
    this.language,
    this.files = const AppFiles(),
  });

  final AppConfig config;
  final RentoryDatabase db;

  /// The Settings language choice. Null follows the device.
  final LanguageController? language;
  final AppFiles files;

  @override
  Widget build(BuildContext context) {
    final language = this.language ?? LanguageController();
    return LanguageScope(
      controller: language,
      child: ValueListenableBuilder<Locale?>(
        valueListenable: language,
        builder: (context, locale, _) => _app(locale),
      ),
    );
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
      builder: (context, child) {
        Intl.defaultLocale = Localizations.localeOf(context).languageCode;
        return child!;
      },
      home: config.hasServer
          ? _SharedRoot(db: db, files: files)
          : Services(
              db: db,
              backend: Services.standalone(db),
              userEmail: null,
              onSignOut: null,
              files: files,
              child: const AppShell(),
            ),
    );
  }
}

/// Shared mode: sign in first, then sync for as long as the session lasts.
class _SharedRoot extends StatefulWidget {
  const _SharedRoot({required this.db, required this.files});
  final RentoryDatabase db;
  final AppFiles files;

  @override
  State<_SharedRoot> createState() => _SharedRootState();
}

class _SharedRootState extends State<_SharedRoot> {
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
      if (mounted) {
        setState(() => _backend = null);
      } else {
        _backend = null;
      }
      return;
    }
    if (_backend != null) return;
    final backend = Services.shared(widget.db, _client);
    backend.sync!.start();
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
  const _Destination(this.label, this.icon, this.page);
  final String Function(AppLocalizations) label;
  final IconData icon;
  final Widget page;
}

final _destinations = [
  _Destination(
    (l) => l.orders,
    Icons.receipt_long_outlined,
    const OrdersPage(),
  ),
  _Destination((l) => l.scan, Icons.qr_code_scanner, const ScanPage()),
  _Destination((l) => l.assets, Icons.inventory_2_outlined, const AssetsPage()),
  _Destination(
    (l) => l.settings,
    Icons.settings_outlined,
    const SettingsPage(),
  ),
];

/// Bottom tabs on phones, a side rail on PC and tablets.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final wide = MediaQuery.sizeOf(context).width >= 720;
    final page = _destinations[_index].page;

    if (!wide) {
      return Scaffold(
        body: SafeArea(child: page),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            for (final d in _destinations)
              NavigationDestination(icon: Icon(d.icon), label: d.label(l)),
          ],
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            labelType: NavigationRailLabelType.all,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                l.appName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            destinations: [
              for (final d in _destinations)
                NavigationRailDestination(
                  icon: Icon(d.icon),
                  label: Text(d.label(l)),
                ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: page),
        ],
      ),
    );
  }
}
