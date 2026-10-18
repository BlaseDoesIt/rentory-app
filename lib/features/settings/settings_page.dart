import 'package:flutter/material.dart';

import '../../app/format.dart';
import '../../app/language.dart';
import '../../app/services.dart';
import '../../app/widgets.dart';
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
    final email = services.userEmail ?? '';
    return ContentWidth(
      max: 720,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          PageHeader(title: l.settings),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SectionCard(
                  title: l.account,
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Monogram(email.isEmpty ? '?' : email),
                        title: Text(l.sharedWithTeam),
                        subtitle: Text(l.signedInAs(email)),
                      ),
                      if (sync != null) _SyncTile(sync),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SectionCard(
                  title: l.language,
                  child: SegmentedButton<String>(
                    key: const Key('language'),
                    showSelectedIcon: false,
                    segments: [
                      ButtonSegment(value: '', label: Text(l.languageDevice)),
                      const ButtonSegment(value: 'en', label: Text('English')),
                      const ButtonSegment(value: 'ar', label: Text('العربية')),
                    ],
                    selected: {language.value?.languageCode ?? ''},
                    onSelectionChanged: (s) => language.choose(
                      s.first.isEmpty ? null : Locale(s.first),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SectionCard(
                  title: l.data,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.auto_awesome_outlined),
                    title: Text(l.loadDemo),
                    subtitle: Text(l.loadDemoHint),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _loadDemo(context),
                  ),
                ),
                if (services.onSignOut != null) ...[
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.logout),
                    onPressed: services.onSignOut,
                    label: Text(l.signOut),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
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
          leading: s.phase == SyncPhase.syncing
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: Padding(
                    padding: EdgeInsets.all(3),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : const Icon(Icons.cloud_done_outlined),
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
