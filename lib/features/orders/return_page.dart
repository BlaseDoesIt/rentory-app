import 'package:flutter/material.dart';

import '../../app/format.dart';
import '../../app/services.dart';
import '../../app/ui.dart';
import '../../data/repository.dart';
import '../../domain/enums.dart';
import 'photo_strip.dart';

/// Checking kit back in: each unit gets its own condition and note, untracked
/// lines one condition, and the customer's documents can be handed back.
class ReturnPage extends StatefulWidget {
  const ReturnPage({super.key, required this.orderId});
  final String orderId;

  @override
  State<ReturnPage> createState() => _ReturnPageState();
}

/// What the user set for one unit (or a whole untracked line).
class _Unit {
  Condition condition = Condition.good;
  final note = TextEditingController();
}

class _ReturnPageState extends State<ReturnPage> {
  OrderDetail? _detail;
  bool _busy = false;
  bool _giveDocuments = false;
  bool _hasDocuments = false;

  /// Lines being checked in now.
  final Set<String> _lines = {};

  /// Keyed by serial id, or by line id for lines without units.
  final Map<String, _Unit> _units = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_detail == null) _load();
  }

  @override
  void dispose() {
    for (final u in _units.values) {
      u.note.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    final repo = Services.of(context).repo;
    final d = await repo.loadOrder(widget.orderId);
    final docs = await repo.orderDocuments(widget.orderId);
    if (!mounted) return;
    setState(() {
      _detail = d;
      _hasDocuments = docs.isNotEmpty;
      _giveDocuments = docs.isNotEmpty && d.order.documentsReturnedAt == null;
      for (final v in _out(d)) {
        _lines.add(v.line.id);
        for (final key in _keys(v)) {
          _units.putIfAbsent(key, _Unit.new);
        }
      }
    });
  }

  static Iterable<LineView> _out(OrderDetail d) => d.lines.where(
    (v) => v.line.rentalState == RentalState.pickedUp && v.qtyOutstanding > 0,
  );

  /// Serials still out on [v], or the line itself when it has none.
  static List<String> _keys(LineView v) {
    if (v.serials.isEmpty) return [v.line.id];
    final back = {for (final c in v.returnChecks) c.serialId};
    return [
      for (final s in v.serials)
        if (!back.contains(s.id)) s.id,
    ];
  }

  String? _note(_Unit u) {
    final t = u.note.text.trim();
    return t.isEmpty ? null : t;
  }

  Future<void> _checkIn() async {
    final l = context.l10n;
    final d = _detail!;
    final repo = Services.of(context).repo;
    if (_lines.isEmpty && !_giveDocuments) {
      await showProblems(context, [l.nothingSelected]);
      return;
    }
    setState(() => _busy = true);
    final ok = await attempt(context, () async {
      for (final v in _out(d)) {
        if (!_lines.contains(v.line.id)) continue;
        if (v.serials.isEmpty) {
          await repo.returnLine(
            v.line.id,
            fallback: _units[v.line.id]!.condition,
          );
        } else {
          await repo.returnLine(
            v.line.id,
            units: {
              for (final id in _keys(v))
                id: (
                  condition: _units[id]!.condition,
                  note: _note(_units[id]!),
                ),
            },
          );
        }
      }
      if (_giveDocuments) await repo.markDocumentsReturned(widget.orderId);
    });
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final d = _detail;
    return Scaffold(
      appBar: AppBar(title: Text(l.returnItems)),
      body: d == null
          ? const Center(child: CircularProgressIndicator())
          : _body(l, d),
      bottomNavigationBar: d == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.icon(
                  key: const Key('check-in'),
                  icon: const Icon(Icons.move_to_inbox_outlined),
                  onPressed: _busy ? null : _checkIn,
                  label: Text(l.checkIn),
                ),
              ),
            ),
    );
  }

  Widget _body(AppLocalizations l, OrderDetail d) {
    final text = Theme.of(context).textTheme;
    final o = d.order;
    final serialNames = {
      for (final v in d.lines)
        for (final s in v.serials) s.id: s.name,
    };
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          '${o.number ?? ''}  ${d.summary.customerLabel}',
          style: text.titleMedium,
        ),
        if (d.summary.overdue) ...[
          const SizedBox(height: 4),
          Tag(l.daysLate(d.summary.daysLate), inverted: true),
        ],
        for (final v in _out(d)) ...[
          const Divider(height: 32),
          CheckboxListTile(
            key: Key('return-line-${v.line.id}'),
            contentPadding: EdgeInsets.zero,
            title: Text(v.line.name, style: text.titleSmall),
            subtitle: Text(l.stillOut(qty(v.qtyOutstanding))),
            value: _lines.contains(v.line.id),
            onChanged: (on) => setState(
              () =>
                  on == true ? _lines.add(v.line.id) : _lines.remove(v.line.id),
            ),
          ),
          if (_lines.contains(v.line.id))
            for (final key in _keys(v))
              _unitRow(
                l,
                key,
                v.serials.isEmpty ? null : serialNames[key],
                withNote: v.serials.isNotEmpty,
              ),
        ],
        const Divider(height: 32),
        if (o.documentsReturnedAt != null)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.assignment_turned_in_outlined),
            title: Text(l.documentsReturnedOn(when(o.documentsReturnedAt))),
          )
        else if (_hasDocuments)
          CheckboxListTile(
            key: const Key('documents-returned'),
            contentPadding: EdgeInsets.zero,
            title: Text(l.documentsReturned),
            value: _giveDocuments,
            onChanged: (v) => setState(() => _giveDocuments = v ?? false),
          ),
        const SizedBox(height: 8),
        Text(l.conditionPhotos, style: text.titleMedium),
        const SizedBox(height: 8),
        PhotoStrip(orderId: o.id, note: PhotoNote.returned),
      ],
    );
  }

  Widget _unitRow(
    AppLocalizations l,
    String key,
    String? name, {
    required bool withNote,
  }) {
    final u = _units[key]!;
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 16, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (name != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SegmentedButton<Condition>(
              key: Key('condition-$key'),
              showSelectedIcon: false,
              segments: [
                for (final c in const [
                  Condition.good,
                  Condition.minor,
                  Condition.damaged,
                  Condition.missing,
                ])
                  ButtonSegment(value: c, label: Text(l.condition(c))),
              ],
              selected: {u.condition},
              onSelectionChanged: (s) => setState(() => u.condition = s.first),
            ),
          ),
          if (withNote)
            TextField(
              key: Key('note-$key'),
              controller: u.note,
              decoration: InputDecoration(labelText: l.note),
            ),
        ],
      ),
    );
  }
}
