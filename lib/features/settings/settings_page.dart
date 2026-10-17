import 'package:flutter/material.dart';

import '../../app/format.dart';
import '../../app/services.dart';
import '../../data/demo_seed.dart';
import '../../data/sync/sync_engine.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _loadDemo(BuildContext context) async {
    final services = Services.of(context);
    final sync = services.sync;
    final seed = DemoSeed(services.db, services.repo);
    final messenger = ScaffoldMessenger.of(context);
    void say(String m) => messenger.showSnackBar(SnackBar(content: Text(m)));
    try {
      // Pull first: another device may have loaded it already.
      if (sync != null) await sync.syncNow();
      if (!await seed.isEmpty()) {
        say('There is data already.');
        return;
      }
      await seed.run();
      if (sync != null) await sync.syncNow();
      say('Demo data loaded.');
    } catch (e) {
      say('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final services = Services.of(context);
    final sync = services.sync;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Settings', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.cloud_outlined),
          title: Text(sync == null ? 'This device only' : 'Shared with team'),
          subtitle: Text(
            sync == null
                ? 'No server configured. Data stays on this device.'
                : 'Signed in as ${services.userEmail ?? ''}',
          ),
        ),
        if (sync != null) _SyncTile(sync),
        const Divider(height: 32),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.inventory_outlined),
          title: const Text('Load demo data'),
          subtitle: const Text(
            'Cameras, lights and a few sample orders. Only when empty.',
          ),
          onTap: () => _loadDemo(context),
        ),
        if (services.onSignOut != null)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.logout),
            title: const Text('Sign out'),
            onTap: services.onSignOut,
          ),
      ],
    );
  }
}

class _SyncTile extends StatelessWidget {
  const _SyncTile(this.sync);
  final SyncEngine sync;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SyncStatus>(
      stream: sync.status,
      initialData: sync.lastStatus,
      builder: (context, snap) {
        final s = snap.data!;
        final label = switch (s.phase) {
          SyncPhase.syncing => 'Syncing…',
          SyncPhase.offline => 'Offline. Changes will sync later.',
          SyncPhase.error => 'Sync problem: ${s.message ?? ''}',
          SyncPhase.idle =>
            s.lastSynced == null
                ? 'Not synced yet'
                : 'Synced ${when(s.lastSynced)}',
        };
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.sync),
          title: Text(label),
          trailing: TextButton(
            onPressed: s.phase == SyncPhase.syncing ? null : sync.syncNow,
            child: const Text('Sync now'),
          ),
        );
      },
    );
  }
}
