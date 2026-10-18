import 'package:flutter/material.dart';

import '../../app/format.dart';
import '../../app/language.dart';
import '../../app/services.dart';
import '../../data/demo_seed.dart';
import '../../data/sync/sync_engine.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _loadDemo(BuildContext context) async {
    final services = Services.of(context);
    final sync = services.sync;
    final seed = DemoSeed(services.db, services.repo);
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    void say(String m) => messenger.showSnackBar(SnackBar(content: Text(m)));
    try {
      // Pull first: another device may have loaded it already.
      if (sync != null) await sync.syncNow();
      if (!await seed.isEmpty()) {
        say(l.dataAlready);
        return;
      }
      await seed.run();
      if (sync != null) await sync.syncNow();
      say(l.demoLoaded);
    } catch (e) {
      say('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final services = Services.of(context);
    final sync = services.sync;
    final l = context.l10n;
    final language = LanguageScope.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l.settings, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.cloud_outlined),
          title: Text(l.sharedWithTeam),
          subtitle: Text(l.signedInAs(services.userEmail ?? '')),
        ),
        if (sync != null) _SyncTile(sync),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.translate),
          title: Text(l.language),
          trailing: DropdownButton<String>(
            key: const Key('language'),
            value: language.value?.languageCode ?? '',
            underline: const SizedBox(),
            items: [
              DropdownMenuItem(value: '', child: Text(l.languageDevice)),
              const DropdownMenuItem(value: 'en', child: Text('English')),
              const DropdownMenuItem(value: 'ar', child: Text('العربية')),
            ],
            onChanged: (code) => language.choose(
              code == null || code.isEmpty ? null : Locale(code),
            ),
          ),
        ),
        const Divider(height: 32),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.inventory_outlined),
          title: Text(l.loadDemo),
          subtitle: Text(l.loadDemoHint),
          onTap: () => _loadDemo(context),
        ),
        if (services.onSignOut != null)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.logout),
            title: Text(l.signOut),
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
        final l = context.l10n;
        final label = switch (s.phase) {
          SyncPhase.syncing => l.syncing,
          SyncPhase.offline => l.offline,
          SyncPhase.error => l.syncProblem(s.message ?? ''),
          SyncPhase.idle =>
            s.lastSynced == null ? l.notSynced : l.synced(when(s.lastSynced)),
        };
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.sync),
          title: Text(label),
          trailing: TextButton(
            onPressed: s.phase == SyncPhase.syncing ? null : sync.syncNow,
            child: Text(l.syncNow),
          ),
        );
      },
    );
  }
}
