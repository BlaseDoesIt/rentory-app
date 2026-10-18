import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import '../../app/format.dart';
import '../../app/services.dart';
import '../../app/theme.dart';
import '../../app/ui.dart';
import '../../app/widgets.dart';
import '../../data/local/database.dart';
import '../../domain/enums.dart';
import '../orders/customer_picker.dart';
import 'asset_detail_page.dart';

/// The page was first only for new assets.
typedef NewAssetPage = AssetFormPage;

/// Create an asset, or edit one ([asset] given): what it is, how it is
/// counted, what it costs, where it came from, and whether it is ours or on
/// loan from a supplier. Every field is one of Rentory's own.
class AssetFormPage extends StatefulWidget {
  const AssetFormPage({super.key, this.asset});

  /// The asset being edited; null for a new one.
  final Asset? asset;

  @override
  State<AssetFormPage> createState() => _AssetFormPageState();
}

class _AssetFormPageState extends State<AssetFormPage> {
  late final Asset? _a = widget.asset;
  bool get _editing => _a != null;

  TextEditingController _text(String? v) => TextEditingController(text: v);
  String _num(double? v) => v == null || v == 0 ? '' : qty(v);

  late final _name = _text(_a?.name);
  late final _code = _text(_a?.code);
  late final _barcode = _text(_a?.barcode == _a?.code ? null : _a?.barcode);
  late final _qty = _text(_a == null ? '1' : qty(_a.qtyManual));
  late final _price = _text(_num(_a?.rentalPriceDay));
  late final _value = _text(_num(_a?.declaredValue));
  late final _notes = _text(_a?.notes);
  late final _cost = _text(_num(_a?.unitCost));
  late final _url = _text(_a?.evaluationUrl);
  late final _supplier = _text(_a?.supplierName);
  late final _supplierPhone = _text(_a?.supplierPhone);
  late final _supplierRef = _text(_a?.supplierReference);
  late final _loanCost = _text(_num(_a?.rentedInCostDay));
  late final _loanDeposit = _text(_num(_a?.rentedInDeposit));
  late final _loanNote = _text(_a?.rentedInNote);
  final _unit = TextEditingController();
  final _unitFocus = FocusNode();

  late Tracking _tracking = _a?.tracking ?? Tracking.serial;
  late bool _rentalOk = _a?.rentalOk ?? true;
  late Ownership _ownership = _a?.ownership ?? Ownership.owned;
  late String? _categoryId = _a?.categoryId;
  late String? _locationId = _a?.locationId;
  late String? _sourceId = _a?.sourceId;
  String? _sourceName;
  late DateTime? _acquired = _a?.acquisitionDate;
  late DateTime? _heldFrom = _a?.rentedInDateStart;
  late DateTime? _dueBack = _a?.rentedInDateEnd;
  late LoanCondition _conditionIn =
      _a?.rentedInConditionIn ?? LoanCondition.good;

  final List<String> _units = [];
  List<Category> _categories = const [];
  List<Location> _locations = const [];
  bool _loaded = false;
  bool _busy = false;

  /// Marks the "new category" entry of the dropdown.
  static const _newCategory = '__new__';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      _loadLists();
    }
  }

  @override
  void dispose() {
    for (final c in [
      _name,
      _code,
      _barcode,
      _qty,
      _price,
      _value,
      _notes,
      _cost,
      _url,
      _supplier,
      _supplierPhone,
      _supplierRef,
      _loanCost,
      _loanDeposit,
      _loanNote,
      _unit,
    ]) {
      c.dispose();
    }
    _unitFocus.dispose();
    super.dispose();
  }

  Future<void> _loadLists() async {
    final repo = Services.of(context).repo;
    final categories = await repo.categories();
    final locations = await repo.locations();
    String? source;
    if (_sourceId != null) {
      source = (await repo.customers())
          .where((c) => c.id == _sourceId)
          .firstOrNull
          ?.name;
    }
    if (!mounted) return;
    setState(() {
      _categories = categories;
      _locations = locations;
      _sourceName = source;
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
    final name = await promptText(
      context,
      title: l.newCategory,
      label: l.name,
      fieldKey: const Key('prompt-field'),
    );
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

  Future<void> _pickSource() async {
    final c = await pickCustomer(context);
    if (c == null) return;
    setState(() {
      _sourceId = c.id;
      _sourceName = c.name;
    });
  }

  /// Empty means zero; null means "not a number".
  double? _number(TextEditingController c) =>
      c.text.trim().isEmpty ? 0.0 : parseNumber(c.text);

  String? _opt(TextEditingController c) =>
      c.text.trim().isEmpty ? null : c.text.trim();

  Future<void> _save() async {
    final l = context.l10n;
    final price = _number(_price);
    final value = _number(_value);
    final cost = _number(_cost);
    final loanCost = _number(_loanCost);
    final deposit = _number(_loanDeposit);
    final quantity = parseNumber(_qty.text);
    if ([price, value, cost, loanCost, deposit].contains(null) ||
        (_tracking == Tracking.none && quantity == null)) {
      await showProblems(context, [l.checkNumbers]);
      return;
    }
    // A unit typed but not added yet still counts.
    if (_unit.text.trim().isNotEmpty) _addUnit();
    final rentedIn = _ownership == Ownership.rentedIn;
    final more = AssetsCompanion(
      rentalOk: Value(_rentalOk),
      sourceId: Value(_sourceId),
      acquisitionDate: Value(_acquired),
      unitCost: Value(cost!),
      evaluationUrl: Value(_opt(_url)),
      ownership: Value(_ownership),
      supplierName: Value(rentedIn ? _opt(_supplier) : null),
      supplierPhone: Value(rentedIn ? _opt(_supplierPhone) : null),
      supplierReference: Value(rentedIn ? _opt(_supplierRef) : null),
      rentedInDateStart: Value(rentedIn ? _heldFrom : null),
      rentedInDateEnd: Value(rentedIn ? _dueBack : null),
      rentedInCostDay: Value(rentedIn ? loanCost! : 0),
      rentedInDeposit: Value(rentedIn ? deposit! : 0),
      rentedInConditionIn: Value(_conditionIn),
      rentedInNote: Value(rentedIn ? _opt(_loanNote) : null),
    );
    final services = Services.of(context);
    setState(() => _busy = true);
    String? id = _a?.id;
    final ok = await attempt(context, () async {
      if (_editing) {
        await services.repo.updateAsset(
          id!,
          more.copyWith(
            name: Value(_name.text.trim()),
            code: Value(_opt(_code)),
            barcode: Value(_opt(_barcode) ?? _opt(_code)),
            categoryId: Value(_categoryId),
            locationId: Value(_locationId),
            qtyManual: _tracking == Tracking.none
                ? Value(quantity!)
                : const Value.absent(),
            rentalPriceDay: Value(price!),
            declaredValue: Value(value!),
            notes: Value(_opt(_notes)),
          ),
        );
      } else {
        id = await services.repo.createAsset(
          name: _name.text,
          code: _code.text,
          barcode: _barcode.text,
          categoryId: _categoryId,
          locationId: _locationId,
          tracking: _tracking,
          quantity: quantity ?? 1,
          units: _units,
          priceDay: price!,
          declaredValue: value!,
          notes: _notes.text,
          more: more,
        );
      }
    });
    if (!mounted) return;
    setState(() => _busy = false);
    if (!ok) return;
    if (_editing) {
      Navigator.pop(context, true);
      return;
    }
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
    Widget gap() => const SizedBox(height: 12);
    return Scaffold(
      appBar: AppBar(title: Text(_editing ? l.editAsset : l.newAsset)),
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
                    autofocus: !_editing,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(labelText: l.nameRequired),
                  ),
                  gap(),
                  FieldPair(
                    TextField(
                      key: const Key('asset-code'),
                      controller: _code,
                      textDirection: TextDirection.ltr,
                      decoration: InputDecoration(
                        labelText: l.internalReference,
                        prefixIcon: const Icon(Icons.tag),
                      ),
                    ),
                    TextField(
                      key: const Key('asset-barcode'),
                      controller: _barcode,
                      textDirection: TextDirection.ltr,
                      decoration: InputDecoration(
                        labelText: l.barcode,
                        hintText: l.barcodeSameAsCode,
                        prefixIcon: const Icon(Icons.qr_code),
                      ),
                    ),
                  ),
                  gap(),
                  MonoDropdown<String?>(
                    key: const Key('asset-category'),
                    label: l.category,
                    value: _categoryId,
                    leading: const Icon(Icons.folder_outlined),
                    options: [
                      (null, l.none),
                      for (final c in _categories) (c.id, c.name),
                      (_newCategory, '+ ${l.newCategory}'),
                    ],
                    onSelected: _pickCategory,
                  ),
                  if (_locations.isNotEmpty) ...[
                    gap(),
                    MonoDropdown<String?>(
                      label: l.location,
                      value: _locationId,
                      leading: const Icon(Icons.place_outlined),
                      options: [
                        (null, l.none),
                        for (final x in _locations) (x.id, x.name),
                      ],
                      onSelected: (v) => setState(() => _locationId = v),
                    ),
                  ],
                  const SizedBox(height: 4),
                  SwitchListTile(
                    key: const Key('asset-rental-ok'),
                    contentPadding: EdgeInsets.zero,
                    title: Text(l.availableForRent),
                    subtitle: Text(l.availableForRentHint),
                    value: _rentalOk,
                    onChanged: (v) => setState(() => _rentalOk = v),
                  ),
                ],
              ),
            ),
            gap(),
            SectionCard(title: l.stock, child: _stock(l, number)),
            gap(),
            SectionCard(
              title: l.pricing,
              child: FieldPair(
                TextField(
                  key: const Key('asset-price'),
                  controller: _price,
                  keyboardType: number,
                  decoration: InputDecoration(labelText: l.pricePerDay),
                ),
                TextField(
                  key: const Key('asset-value'),
                  controller: _value,
                  keyboardType: number,
                  decoration: InputDecoration(
                    labelText: l.declaredValuePerUnit,
                  ),
                ),
              ),
            ),
            gap(),
            SectionCard(
              title: l.acquisition,
              child: Column(
                children: [
                  _pickerTile(
                    key: const Key('asset-source'),
                    icon: Icons.storefront_outlined,
                    label: l.source,
                    value: _sourceName,
                    onTap: _pickSource,
                    onClear: _sourceId == null
                        ? null
                        : () => setState(() {
                            _sourceId = null;
                            _sourceName = null;
                          }),
                  ),
                  gap(),
                  FieldPair(
                    _pickerTile(
                      icon: Icons.event_outlined,
                      label: l.acquisitionDate,
                      value: _acquired == null ? null : day(_acquired),
                      onTap: () async {
                        final d = await pickDate(context, _acquired);
                        if (d != null) setState(() => _acquired = d);
                      },
                      onClear: _acquired == null
                          ? null
                          : () => setState(() => _acquired = null),
                    ),
                    TextField(
                      key: const Key('asset-cost'),
                      controller: _cost,
                      keyboardType: number,
                      decoration: InputDecoration(labelText: l.costPerUnit),
                    ),
                  ),
                  gap(),
                  TextField(
                    controller: _url,
                    keyboardType: TextInputType.url,
                    textDirection: TextDirection.ltr,
                    decoration: InputDecoration(
                      labelText: l.evaluationLink,
                      hintText: 'https://',
                      prefixIcon: const Icon(Icons.link),
                    ),
                  ),
                ],
              ),
            ),
            gap(),
            SectionCard(
              title: l.ownership,
              child: _ownershipSection(l, number),
            ),
            gap(),
            SectionCard(
              title: l.notes,
              child: TextField(
                controller: _notes,
                minLines: 2,
                maxLines: 6,
                decoration: InputDecoration(hintText: l.notesHint),
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
          label: Text(_editing ? l.save : l.createAsset),
        ),
      ),
    );
  }

  /// A read-only field that opens a picker, with a clear button.
  Widget _pickerTile({
    Key? key,
    required IconData icon,
    required String label,
    required String? value,
    required VoidCallback onTap,
    VoidCallback? onClear,
  }) {
    return InkWell(
      key: key,
      borderRadius: BorderRadius.circular(Mono.radiusSmall),
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          suffixIcon: onClear == null
              ? null
              : IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: onClear,
                ),
        ),
        isEmpty: value == null,
        child: value == null ? null : Text(value),
      ),
    );
  }

  Widget _stock(AppLocalizations l, TextInputType number) {
    final muted = TextStyle(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
    if (_editing) {
      // How an asset is counted is fixed once it exists.
      return _tracking == Tracking.serial
          ? Row(
              children: [
                const Icon(Icons.qr_code_2),
                const SizedBox(width: 12),
                Expanded(child: Text(l.trackByUnitHint, style: muted)),
              ],
            )
          : TextField(
              key: const Key('asset-qty'),
              controller: _qty,
              keyboardType: number,
              decoration: InputDecoration(labelText: l.quantityOnHand),
            );
    }
    return Column(
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
          onSelectionChanged: (s) => setState(() => _tracking = s.first),
        ),
        const SizedBox(height: 8),
        Text(
          _tracking == Tracking.serial
              ? l.trackByUnitHint
              : l.trackByQuantityHint,
          style: muted,
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
                  decoration: InputDecoration(labelText: l.quantityOnHand),
                ),
        ),
      ],
    );
  }

  Widget _ownershipSection(AppLocalizations l, TextInputType number) {
    final rentedIn = _ownership == Ownership.rentedIn;
    Widget field(
      TextEditingController c,
      String label, {
      Key? key,
      TextInputType? type,
      IconData? icon,
      bool ltr = false,
    }) => TextField(
      key: key,
      controller: c,
      keyboardType: type,
      textDirection: ltr ? TextDirection.ltr : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon == null ? null : Icon(icon),
      ),
    );
    const gap = SizedBox(height: 12);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<Ownership>(
          key: const Key('asset-ownership'),
          showSelectedIcon: false,
          segments: [
            ButtonSegment(
              value: Ownership.owned,
              icon: const Icon(Icons.home_outlined),
              label: Text(l.owned),
            ),
            ButtonSegment(
              value: Ownership.rentedIn,
              icon: const Icon(Icons.handshake_outlined),
              label: Text(l.rentedIn),
            ),
          ],
          selected: {_ownership},
          onSelectionChanged: (s) => setState(() => _ownership = s.first),
        ),
        const SizedBox(height: 8),
        Text(
          rentedIn ? l.rentedInHint : l.ownedHint,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        AnimatedSize(
          duration: Mono.medium,
          curve: Mono.ease,
          alignment: Alignment.topCenter,
          child: !rentedIn
              ? const SizedBox(width: double.infinity)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    field(
                      _supplier,
                      l.rentedFrom,
                      key: const Key('asset-supplier'),
                      icon: Icons.storefront_outlined,
                    ),
                    gap,
                    FieldPair(
                      field(
                        _supplierPhone,
                        l.supplierPhone,
                        type: TextInputType.phone,
                        ltr: true,
                      ),
                      field(_supplierRef, l.theirReference),
                    ),
                    gap,
                    FieldPair(
                      _pickerTile(
                        key: const Key('asset-held-from'),
                        icon: Icons.login,
                        label: l.heldFrom,
                        value: _heldFrom == null ? null : when(_heldFrom),
                        onTap: () async {
                          final d = await pickDateTime(context, _heldFrom);
                          if (d != null) setState(() => _heldFrom = d);
                        },
                      ),
                      _pickerTile(
                        key: const Key('asset-due-back'),
                        icon: Icons.logout,
                        label: l.dueBack,
                        value: _dueBack == null ? null : when(_dueBack),
                        onTap: () async {
                          final d = await pickDateTime(context, _dueBack);
                          if (d != null) setState(() => _dueBack = d);
                        },
                      ),
                    ),
                    gap,
                    FieldPair(
                      field(_loanCost, l.costPerDay, type: number),
                      field(_loanDeposit, l.depositPaid, type: number),
                    ),
                    gap,
                    MonoDropdown<LoanCondition>(
                      label: l.conditionReceived,
                      value: _conditionIn,
                      options: [
                        for (final c in const [
                          LoanCondition.good,
                          LoanCondition.minor,
                          LoanCondition.damaged,
                        ])
                          (c, l.loanCondition(c)),
                      ],
                      onSelected: (v) =>
                          setState(() => _conditionIn = v ?? _conditionIn),
                    ),
                    gap,
                    TextField(
                      controller: _loanNote,
                      minLines: 2,
                      maxLines: 5,
                      decoration: InputDecoration(labelText: l.loanNotes),
                    ),
                  ],
                ),
        ),
      ],
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
