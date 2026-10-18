import 'package:flutter/material.dart';

import '../../app/format.dart';
import '../../app/services.dart';
import '../../app/theme.dart';
import '../../app/ui.dart';
import '../../app/widgets.dart';
import '../../data/local/database.dart';
import '../../domain/enums.dart';
import 'asset_detail_page.dart';

/// A new asset: what it is, how it's counted, what it costs. Units of a
/// serial asset are typed (or scanned) one by one, or numbered in a batch.
class NewAssetPage extends StatefulWidget {
  const NewAssetPage({super.key});

  @override
  State<NewAssetPage> createState() => _NewAssetPageState();
}

class _NewAssetPageState extends State<NewAssetPage> {
  final _name = TextEditingController();
  final _code = TextEditingController();
  final _qty = TextEditingController(text: '1');
  final _price = TextEditingController();
  final _value = TextEditingController();
  final _notes = TextEditingController();
  final _unit = TextEditingController();
  final _unitFocus = FocusNode();

  Tracking _tracking = Tracking.serial;
  final List<String> _units = [];
  List<Category> _categories = const [];
  List<Location> _locations = const [];
  String? _categoryId;
  String? _locationId;
  bool _busy = false;

  /// Marks the "new category" entry of the dropdown.
  static const _newCategory = '__new__';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_categories.isEmpty && _locations.isEmpty) _loadLists();
  }

  @override
  void dispose() {
    for (final c in [_name, _code, _qty, _price, _value, _notes, _unit]) {
      c.dispose();
    }
    _unitFocus.dispose();
    super.dispose();
  }

  Future<void> _loadLists() async {
    final repo = Services.of(context).repo;
    final categories = await repo.categories();
    final locations = await repo.locations();
    if (!mounted) return;
    setState(() {
      _categories = categories;
      _locations = locations;
    });
  }

  void _addUnit() {
    final name = _unit.text.trim();
    if (name.isEmpty) return;
    setState(() {
      if (!_units.any((u) => u.toLowerCase() == name.toLowerCase())) {
        _units.add(name);
      }
      _unit.clear();
    });
    _unitFocus.requestFocus();
  }

  Future<void> _numberUnits() async {
    final prefix = _code.text.trim().isEmpty
        ? '${_name.text.trim().split(' ').first.toUpperCase()}-'
        : '${_code.text.trim()}-';
    final made = await showDialog<List<String>>(
      context: context,
      builder: (_) => _NumberDialog(prefix: prefix, from: _units.length + 1),
    );
    if (made == null) return;
    setState(() {
      for (final n in made) {
        if (!_units.contains(n)) _units.add(n);
      }
    });
  }

  Future<void> _pickCategory(String? id) async {
    if (id != _newCategory) {
      setState(() => _categoryId = id);
      return;
    }
    final l = context.l10n;
    final name = await _prompt(l.newCategory, l.name);
    if (name == null || !mounted) return;
    final repo = Services.of(context).repo;
    String? created;
    await attempt(context, () async {
      created = await repo.createCategory(name);
    });
    if (created == null) return;
    await _loadLists();
    setState(() => _categoryId = created);
  }

  Future<String?> _prompt(String title, String label) {
    final c = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: Text(title),
        content: TextField(
          key: const Key('prompt-field'),
          controller: c,
          autofocus: true,
          decoration: InputDecoration(labelText: label),
          onSubmitted: (v) => Navigator.pop(dialog, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialog, c.text),
            child: Text(context.l10n.save),
          ),
        ],
      ),
    ).whenComplete(c.dispose);
  }

  Future<void> _save() async {
    final l = context.l10n;
    final price = _price.text.trim().isEmpty ? 0.0 : parseNumber(_price.text);
    final value = _value.text.trim().isEmpty ? 0.0 : parseNumber(_value.text);
    final quantity = parseNumber(_qty.text);
    if (price == null ||
        value == null ||
        (_tracking == Tracking.none && quantity == null)) {
      await showProblems(context, [l.checkNumbers]);
      return;
    }
    // A unit typed but not added yet still counts.
    if (_unit.text.trim().isNotEmpty) _addUnit();
    final services = Services.of(context);
    setState(() => _busy = true);
    String? id;
    final ok = await attempt(context, () async {
      id = await services.repo.createAsset(
        name: _name.text,
        code: _code.text,
        categoryId: _categoryId,
        locationId: _locationId,
        tracking: _tracking,
        quantity: quantity ?? 1,
        units: _units,
        priceDay: price,
        declaredValue: value,
        notes: _notes.text,
      );
    });
    if (!mounted) return;
    setState(() => _busy = false);
    if (!ok) return;
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => services.wrap(AssetDetailPage(assetId: id!)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    const number = TextInputType.numberWithOptions(decimal: true);
    return Scaffold(
      appBar: AppBar(title: Text(l.newAsset)),
      body: ContentWidth(
        max: 720,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            SectionCard(
              title: l.details,
              child: Column(
                children: [
                  TextField(
                    key: const Key('asset-name'),
                    controller: _name,
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(labelText: l.nameRequired),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    key: const Key('asset-code'),
                    controller: _code,
                    textDirection: TextDirection.ltr,
                    decoration: InputDecoration(
                      labelText: l.codeOrBarcode,
                      helperText: l.codeHint,
                      prefixIcon: const Icon(Icons.qr_code),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String?>(
                    key: const Key('asset-category'),
                    initialValue: _categoryId,
                    decoration: InputDecoration(labelText: l.category),
                    items: [
                      DropdownMenuItem(value: null, child: Text(l.none)),
                      for (final c in _categories)
                        DropdownMenuItem(value: c.id, child: Text(c.name)),
                      DropdownMenuItem(
                        value: _newCategory,
                        child: Text('+ ${l.newCategory}'),
                      ),
                    ],
                    onChanged: _pickCategory,
                  ),
                  if (_locations.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String?>(
                      initialValue: _locationId,
                      decoration: InputDecoration(labelText: l.location),
                      items: [
                        DropdownMenuItem(value: null, child: Text(l.none)),
                        for (final x in _locations)
                          DropdownMenuItem(value: x.id, child: Text(x.name)),
                      ],
                      onChanged: (v) => setState(() => _locationId = v),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            SectionCard(
              title: l.stock,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SegmentedButton<Tracking>(
                    key: const Key('asset-tracking'),
                    showSelectedIcon: false,
                    segments: [
                      ButtonSegment(
                        value: Tracking.serial,
                        icon: const Icon(Icons.qr_code_2),
                        label: Text(l.trackByUnit),
                      ),
                      ButtonSegment(
                        value: Tracking.none,
                        icon: const Icon(Icons.numbers),
                        label: Text(l.trackByQuantity),
                      ),
                    ],
                    selected: {_tracking},
                    onSelectionChanged: (s) =>
                        setState(() => _tracking = s.first),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _tracking == Tracking.serial
                        ? l.trackByUnitHint
                        : l.trackByQuantityHint,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimatedSize(
                    duration: Mono.medium,
                    curve: Mono.ease,
                    alignment: Alignment.topCenter,
                    child: _tracking == Tracking.serial
                        ? _unitsEditor(l)
                        : TextField(
                            key: const Key('asset-qty'),
                            controller: _qty,
                            keyboardType: number,
                            decoration: InputDecoration(labelText: l.quantity),
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SectionCard(
              title: l.pricing,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          key: const Key('asset-price'),
                          controller: _price,
                          keyboardType: number,
                          decoration: InputDecoration(labelText: l.pricePerDay),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          key: const Key('asset-value'),
                          controller: _value,
                          keyboardType: number,
                          decoration: InputDecoration(
                            labelText: l.declaredValue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _notes,
                    minLines: 2,
                    maxLines: 5,
                    decoration: InputDecoration(labelText: l.notes),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomActionBar(
        child: FilledButton.icon(
          key: const Key('save-asset'),
          onPressed: _busy ? null : _save,
          icon: const Icon(Icons.check),
          label: Text(l.createAsset),
        ),
      ),
    );
  }

  Widget _unitsEditor(AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                key: const Key('asset-unit'),
                controller: _unit,
                focusNode: _unitFocus,
                textDirection: TextDirection.ltr,
                decoration: InputDecoration(
                  labelText: l.unitName,
                  hintText: l.unitNameHint,
                ),
                onSubmitted: (_) => _addUnit(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              key: const Key('add-unit'),
              tooltip: l.add,
              onPressed: _addUnit,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            key: const Key('number-units'),
            onPressed: _numberUnits,
            icon: const Icon(Icons.format_list_numbered, size: 18),
            label: Text(l.numberUnits),
          ),
        ),
        if (_units.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            l.unitsCount(_units.length),
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final u in _units)
                InputChip(
                  label: Text(u, textDirection: TextDirection.ltr),
                  onDeleted: () => setState(() => _units.remove(u)),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

/// "Make 5 units: CAM-001 to CAM-005."
class _NumberDialog extends StatefulWidget {
  const _NumberDialog({required this.prefix, required this.from});
  final String prefix;
  final int from;

  @override
  State<_NumberDialog> createState() => _NumberDialogState();
}

class _NumberDialogState extends State<_NumberDialog> {
  late final _prefix = TextEditingController(text: widget.prefix);
  int _count = 3;

  List<String> get _names => [
    for (var i = 0; i < _count; i++)
      '${_prefix.text}${(widget.from + i).toString().padLeft(3, '0')}',
  ];

  @override
  void dispose() {
    _prefix.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final names = _names;
    return AlertDialog(
      title: Text(l.numberUnits),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: const Key('number-prefix'),
              controller: _prefix,
              textDirection: TextDirection.ltr,
              decoration: InputDecoration(labelText: l.prefix),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: Text(l.howMany)),
                IconButton.outlined(
                  onPressed: _count > 1 ? () => setState(() => _count--) : null,
                  icon: const Icon(Icons.remove),
                ),
                SizedBox(
                  width: 44,
                  child: Text(
                    '$_count',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton.outlined(
                  key: const Key('number-more'),
                  onPressed: _count < 99
                      ? () => setState(() => _count++)
                      : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              names.length <= 2
                  ? names.join(', ')
                  : '${names.first} … ${names.last}',
              textDirection: TextDirection.ltr,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        FilledButton(
          key: const Key('number-confirm'),
          onPressed: () => Navigator.pop(context, names),
          child: Text(l.add),
        ),
      ],
    );
  }
}
