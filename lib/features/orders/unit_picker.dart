import 'package:flutter/material.dart';

import '../../app/format.dart';
import '../../app/services.dart';
import '../../app/ui.dart';
import '../../app/widgets.dart';
import '../../data/repository.dart';
import '../../domain/rules/availability.dart';

/// Which units go out on a serial line. Overdue units are shown with a tag
/// and can be picked by hand, but Autofill never takes them.
class UnitPickerPage extends StatefulWidget {
  const UnitPickerPage({
    super.key,
    required this.orderId,
    required this.lineId,
  });
  final String orderId;
  final String lineId;

  @override
  State<UnitPickerPage> createState() => _UnitPickerPageState();
}

class _UnitPickerPageState extends State<UnitPickerPage> {
  List<SerialOption>? _options;

  /// Units already on the line that are no longer free (taken elsewhere).
  List<({String id, String name})> _stuck = const [];
  final Set<String> _selected = {};
  int _wanted = 0;
  bool _busy = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_options == null) _load();
  }

  Future<void> _load() async {
    final repo = Services.of(context).repo;
    final options = await repo.serialOptions(widget.lineId);
    final view = await _view(repo);
    if (!mounted) return;
    final free = {for (final o in options) o.serial.id};
    setState(() {
      _options = options;
      _wanted = view?.line.quantity.round() ?? 0;
      _selected
        ..clear()
        ..addAll(view?.serials.map((s) => s.id) ?? const []);
      _stuck = [
        for (final s in view?.serials ?? const [])
          if (!free.contains(s.id)) (id: s.id, name: s.name),
      ];
    });
  }

  Future<LineView?> _view(RentoryRepository repo) async {
    final d = await repo.loadOrder(widget.orderId);
    return d.lines.where((v) => v.line.id == widget.lineId).firstOrNull;
  }

  Future<void> _autofill() async {
    final l = context.l10n;
    final repo = Services.of(context).repo;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    var missing = 0;
    await attempt(context, () async {
      missing = await repo.autofillSerials(widget.lineId);
    });
    await _load();
    if (!mounted) return;
    setState(() => _busy = false);
    messenger.showSnackBar(
      SnackBar(
        content: Text(missing == 0 ? l.autofillDone : l.autofillShort(missing)),
      ),
    );
  }

  Future<void> _save() async {
    final repo = Services.of(context).repo;
    setState(() => _busy = true);
    final ok = await attempt(
      context,
      () => repo.setLineSerials(widget.lineId, _selected.toList()),
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final options = _options;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.pickUnits),
        actions: [
          TextButton.icon(
            key: const Key('autofill'),
            onPressed: _busy || options == null ? null : _autofill,
            icon: const Icon(Icons.auto_fix_high),
            label: Text(l.autofill),
          ),
        ],
      ),
      body: options == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(l.unitsChosen(_selected.length, _wanted)),
                ),
                if (options.isEmpty && _stuck.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(l.noFreeUnits),
                  ),
                for (final o in options)
                  CheckboxListTile(
                    value: _selected.contains(o.serial.id),
                    title: Row(
                      children: [
                        Flexible(child: Text(o.serial.name)),
                        if (o.overdue) ...[
                          const SizedBox(width: 8),
                          Tag(l.overdue, inverted: true),
                        ],
                      ],
                    ),
                    subtitle: o.overdue ? Text(l.overdueHint) : null,
                    onChanged: (v) => setState(
                      () => v == true
                          ? _selected.add(o.serial.id)
                          : _selected.remove(o.serial.id),
                    ),
                  ),
                for (final s in _stuck)
                  CheckboxListTile(
                    value: _selected.contains(s.id),
                    title: Row(
                      children: [
                        Flexible(child: Text(s.name)),
                        const SizedBox(width: 8),
                        Tag(l.notFree),
                      ],
                    ),
                    onChanged: (v) => setState(
                      () => v == true
                          ? _selected.add(s.id)
                          : _selected.remove(s.id),
                    ),
                  ),
              ],
            ),
      bottomNavigationBar: BottomActionBar(
        child: FilledButton(
          key: const Key('save-units'),
          onPressed: _busy || options == null ? null : _save,
          child: Text(l.save),
        ),
      ),
    );
  }
}
