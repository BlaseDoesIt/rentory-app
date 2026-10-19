import 'dart:async';

import 'package:flutter/material.dart';

import '../data/activity.dart';

/// A turning circle over the whole app while the user waits on something:
/// a button's action, a call to Odoo, an upload or a download. It also stops
/// a second tap from starting the same thing twice.
///
/// Shown only after a short moment, so quick local actions don't flash.
class BusyOverlay extends StatefulWidget {
  const BusyOverlay({super.key, required this.child});
  final Widget child;

  @override
  State<BusyOverlay> createState() => _BusyOverlayState();
}

class _BusyOverlayState extends State<BusyOverlay> {
  static const _delay = Duration(milliseconds: 150);
  Timer? _timer;
  bool _shown = false;

  @override
  void initState() {
    super.initState();
    Activity.busy.addListener(_changed);
  }

  @override
  void dispose() {
    Activity.busy.removeListener(_changed);
    _timer?.cancel();
    super.dispose();
  }

  void _changed() {
    if (Activity.busy.value > 0) {
      _timer ??= Timer(_delay, () {
        if (mounted && Activity.busy.value > 0) setState(() => _shown = true);
      });
      return;
    }
    _timer?.cancel();
    _timer = null;
    if (_shown && mounted) setState(() => _shown = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_shown)
          Positioned.fill(
            child: AbsorbPointer(
              child: ColoredBox(
                key: const Key('busy-overlay'),
                color: Colors.black.withValues(alpha: 0.12),
                child: Center(
                  child: Material(
                    elevation: 6,
                    shape: const CircleBorder(),
                    color: Theme.of(context).colorScheme.surface,
                    child: const Padding(
                      padding: EdgeInsets.all(14),
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(strokeWidth: 3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
