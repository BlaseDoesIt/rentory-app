import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/local/database.dart';
import '../features/assets/assets_page.dart';
import '../features/auth/sign_in_page.dart';
import '../features/orders/orders_page.dart';
import '../features/scan/scan_page.dart';
import '../features/settings/settings_page.dart';
import 'services.dart';
import 'theme.dart';

class RentoryApp extends StatelessWidget {
  const RentoryApp({super.key, required this.config, required this.db});

  final AppConfig config;
  final RentoryDatabase db;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rentory',
      debugShowCheckedModeBanner: false,
      theme: rentoryTheme(Brightness.light),
      darkTheme: rentoryTheme(Brightness.dark),
      home: config.hasServer
          ? _SharedRoot(db: db)
          : Services(
              db: db,
              backend: Services.standalone(db),
              userEmail: null,
              onSignOut: null,
              child: const AppShell(),
            ),
    );
  }
}

/// Shared mode: sign in first, then sync for as long as the session lasts.
class _SharedRoot extends StatefulWidget {
  const _SharedRoot({required this.db});
  final RentoryDatabase db;

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
      child: const AppShell(),
    );
  }
}

class _Destination {
  const _Destination(this.label, this.icon, this.page);
  final String label;
  final IconData icon;
  final Widget page;
}

const _destinations = [
  _Destination('Orders', Icons.receipt_long_outlined, OrdersPage()),
  _Destination('Scan', Icons.qr_code_scanner, ScanPage()),
  _Destination('Assets', Icons.inventory_2_outlined, AssetsPage()),
  _Destination('Settings', Icons.settings_outlined, SettingsPage()),
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
              NavigationDestination(icon: Icon(d.icon), label: d.label),
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
            leading: const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Rentory',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            destinations: [
              for (final d in _destinations)
                NavigationRailDestination(
                  icon: Icon(d.icon),
                  label: Text(d.label),
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
