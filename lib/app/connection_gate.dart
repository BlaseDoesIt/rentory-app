import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../data/sync/sync_engine.dart';
import 'format.dart';

/// Rentory only works online. Covers every screen, open orders included,
/// until the first sync has finished and whenever the server can't be
/// reached. Nothing is shown from a stale copy.
class ConnectionGate extends StatelessWidget {
  const ConnectionGate({super.key, required this.sync, required this.child});

  /// The signed-in session's engine; null before sign-in (nothing to gate).
  final ValueListenable<SyncEngine?> sync;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SyncEngine?>(
      valueListenable: sync,
      builder: (context, engine, _) {
        if (engine == null) return child;
        return StreamBuilder<SyncStatus>(
          stream: engine.status,
          initialData: engine.lastStatus,
          builder: (context, snap) {
            final s = snap.data!;
            // A server error after the first sync doesn't block: Settings
            // shows it, and the data on screen is still current.
            final blocked = engine.unreachable || s.lastSynced == null;
            return Stack(
              children: [
                child,
                if (blocked) _Blocker(status: s, engine: engine),
              ],
            );
          },
        );
      },
    );
  }
}

class _Blocker extends StatelessWidget {
  const _Blocker({required this.status, required this.engine});
  final SyncStatus status;
  final SyncEngine engine;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final text = Theme.of(context).textTheme;
    final working = status.phase == SyncPhase.syncing;
    final (icon, title, detail) = switch (status.phase) {
      _ when engine.unreachable => (
        Icons.wifi_off,
        l.noConnection,
        l.noConnectionHint,
      ),
      SyncPhase.error => (
        Icons.error_outline,
        l.serverProblem,
        status.message ?? '',
      ),
      _ => (Icons.cloud_sync_outlined, l.connecting, ''),
    };
    return Positioned.fill(
      child: Material(
        key: const Key('connection-gate'),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, size: 36),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: text.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    if (detail.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(detail, textAlign: TextAlign.center),
                    ],
                    const SizedBox(height: 24),
                    if (working)
                      const CircularProgressIndicator()
                    else
                      FilledButton(
                        onPressed: engine.syncNow,
                        child: Text(l.tryAgain),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
