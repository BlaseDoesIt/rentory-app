import 'package:flutter/material.dart';

import '../features/assets/assets_page.dart';
import '../features/orders/orders_page.dart';
import '../features/scan/scan_page.dart';
import '../features/settings/settings_page.dart';
import 'theme.dart';

class RentoryApp extends StatelessWidget {
  const RentoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rentory',
      debugShowCheckedModeBanner: false,
      theme: rentoryTheme(Brightness.light),
      darkTheme: rentoryTheme(Brightness.dark),
      home: const AppShell(),
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
              child: Text('Rentory',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            destinations: [
              for (final d in _destinations)
                NavigationRailDestination(
                    icon: Icon(d.icon), label: Text(d.label)),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: page),
        ],
      ),
    );
  }
}
