import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import '../../app/format.dart';
import '../../app/services.dart';
import '../../app/theme.dart';
import '../../app/ui.dart';
import '../../app/widgets.dart';
import '../../data/local/database.dart';
import '../../data/repository.dart';
import '../../domain/enums.dart';
import '../../domain/rules/rented_in.dart';
import '../orders/order_detail_page.dart';
import 'asset_form_page.dart';
import 'assets_page.dart';

/// One asset: stock, pricing, where it came from, the loan if it is rented
/// in, its status, and its units.
class AssetDetailPage extends StatefulWidget {
  const AssetDetailPage({super.key, required this.assetId});
  final String assetId;

  @override
  State<AssetDetailPage> createState() => _AssetDetailPageState();
}

enum _Action { edit, maintenance, retire, reset }

class _AssetDetailPageState extends State<AssetDetailPage> {
  Future<AssetDetail>? _detail;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _detail ??= Services.of(context).repo.loadAsset(widget.assetId);
  }

  void _reload() {
    final next = Services.of(context).repo.loadAsset(widget.assetId);
    setState(() {
      _detail = next;
    });
  }

  Future<void> _run(Future<void> Function(RentoryRepository r) f) async {
    final repo = Services.of(context).repo;
    final ok = await attempt(context, () => f(repo));
    if (ok && mounted) _reload();
  }

  Future<void> _act(_Action a, Asset asset) async {
    switch (a) {
      case _Action.edit:
        final changed = await Services.push<bool>(
          context,
          AssetFormPage(asset: asset),
        );
        if (changed == true && mounted) _reload();
      case _Action.maintenance:
        await _run(
          (r) => r.setAssetStatus(asset.id, AssetManualState.maintenance),
        );
      case _Action.retire:
        if (!await confirm(context, context.l10n.retireQuestion(asset.name))) {
          return;
        }
        await _run((r) => r.setAssetStatus(asset.id, AssetManualState.retired));
      case _Action.reset:
        await _run((r) => r.setAssetStatus(asset.id, null));
    }
  }

  Future<void> _giveBack(Asset a) async {
    final result = await showDialog<(LoanCondition, String)>(
      context: context,
      builder: (_) => _GiveBackDialog(supplier: a.supplierName),
    );
    if (result == null) return;
    await _run((r) => r.giveBack(a.id, condition: result.$1, note: result.$2));
  }

  Future<void> _addUnits(Asset a) async {
    final names = await showDialog<List<String>>(
      context: context,
      builder: (_) => const _AddUnitsDialog(),
    );
    if (names == null || names.isEmpty || !mounted) return;
    await _run((r) => r.addUnits(a.id, names));
  }

  Future<void> _openUnit(Serial u) async {
    final changed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => Services.of(context).wrap(_UnitSheet(u)),
    );
    if (changed == true && mounted) _reload();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FutureBuilder<AssetDetail>(
      future: _detail,
      builder: (context, snap) {
        final d = snap.data;
        return Scaffold(
          appBar: AppBar(
            title: Text(d?.asset.name ?? l.asset),
            actions: [
              if (d != null) ...[
                IconButton(
                  key: const Key('edit-asset'),
                  tooltip: l.edit,
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _act(_Action.edit, d.asset),
                ),
                PopupMenuButton<_Action>(
                  key: const Key('asset-menu'),
                  onSelected: (a) => _act(a, d.asset),
                  itemBuilder: (_) => [
                    if (d.asset.stateManual != AssetManualState.maintenance)
                      PopupMenuItem(
                        value: _Action.maintenance,
                        child: Text(l.setMaintenance),
                      ),
                    if (d.asset.stateManual != AssetManualState.retired)
                      PopupMenuItem(
                        value: _Action.retire,
                        child: Text(l.setRetired),
                      ),
                    if (d.asset.stateManual != null)
                      PopupMenuItem(
                        value: _Action.reset,
                        child: Text(l.backInService),
                      ),
                  ],
                ),
              ],
            ],
          ),
          body: AnimatedSwitcher(
            duration: Mono.medium,
            child: d == null
                ? Center(
                    child: snap.hasError
                        ? Text('${snap.error}')
                        : const CircularProgressIndicator(),
                  )
                : _body(l, d),
          ),
        );
      },
    );
  }

  Widget _body(AppLocalizations l, AssetDetail d) {
    final a = d.asset;
    final s = d.summary;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final byUnit = a.tracking == Tracking.serial;
    final details = [?a.code, ?s.categoryName, ?d.locationName].join('  ·  ');
    final rentedIn = a.ownership == Ownership.rentedIn;
    const gap = SizedBox(height: 12);
    return ContentWidth(
      max: 880,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: Mono.ink(context),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        byUnit ? Icons.qr_code_2 : Icons.inventory_2_outlined,
                        color: scheme.onPrimary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a.name, style: text.titleLarge),
                          if (details.isNotEmpty)
                            Text(
                              details,
                              style: text.bodyMedium?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (a.stateManual != null || !a.rentalOk || rentedIn) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (a.stateManual != null)
                        StatusPill(
                          l.manualState(a.stateManual!),
                          tone: PillTone.solid,
                          icon: Icons.build_outlined,
                        ),
                      if (!a.rentalOk)
                        StatusPill(l.notForRent, tone: PillTone.muted),
                      if (rentedIn)
                        StatusPill(
                          l.rentedIn,
                          tone: PillTone.outline,
                          icon: Icons.handshake_outlined,
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: LabeledValue(
                        label: l.availableNow,
                        value: qty(s.available),
                      ),
                    ),
                    Expanded(
                      child: LabeledValue(label: l.statOut, value: qty(s.out)),
                    ),
                    Expanded(
                      child: LabeledValue(
                        label: l.totalStock,
                        value: qty(s.total),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                AvailabilityBar(s),
              ],
            ),
          ),
          if (rentedIn) ...[gap, _loan(l, a)],
          gap,
          SectionCard(
            title: l.pricing,
            child: Column(
              children: [
                AmountRow(l.pricePerDay, money(a.rentalPriceDay), bold: true),
                AmountRow(l.declaredValuePerUnit, money(a.declaredValue)),
                if (a.barcode != null && a.barcode != a.code)
                  AmountRow(l.barcode, a.barcode!),
              ],
            ),
          ),
          if (d.sourceName != null ||
              a.acquisitionDate != null ||
              a.unitCost > 0 ||
              a.evaluationUrl != null) ...[
            gap,
            SectionCard(
              title: l.acquisition,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (d.sourceName != null) AmountRow(l.source, d.sourceName!),
                  if (a.acquisitionDate != null)
                    AmountRow(l.acquisitionDate, day(a.acquisitionDate)),
                  if (a.unitCost > 0)
                    AmountRow(l.costPerUnit, money(a.unitCost)),
                  if (a.evaluationUrl != null) ...[
                    const SizedBox(height: 6),
                    SelectableText(
                      a.evaluationUrl!,
                      textDirection: TextDirection.ltr,
                      style: text.bodySmall?.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
          if (a.notes != null) ...[
            gap,
            SectionCard(title: l.notes, child: Text(a.notes!)),
          ],
          if (byUnit) ...[
            gap,
            SectionCard(
              title: l.unitsCount(d.serials.length),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              trailing: TextButton.icon(
                key: const Key('add-units'),
                icon: const Icon(Icons.add, size: 18),
                onPressed: () => _addUnits(a),
                label: Text(l.addUnits),
              ),
              child: Column(
                children: [
                  for (final (i, u) in d.serials.indexed) ...[
                    if (i > 0) const Divider(height: 1),
                    _unit(l, u),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// The loan of a rented-in asset: who from, until when, and how it went.
  Widget _loan(AppLocalizations l, Asset a) {
    final scheme = Theme.of(context).colorScheme;
    final now = DateTime.now().toUtc();
    final status = rentedInStatus(
      heldFrom: a.rentedInDateStart,
      dueBack: a.rentedInDateEnd,
      givenBackAt: a.rentedInReturnedAt,
      now: now,
    );
    final due = a.rentedInDateEnd;
    final alert = switch (status) {
      RentedInStatus.overdue => l.loanOverdueBy(
        formatSpan(now.difference(due!)),
        a.supplierName ?? l.theSupplier,
      ),
      RentedInStatus.dueSoon => l.loanDueIn(
        formatSpan(due!.difference(now)),
        a.supplierName ?? l.theSupplier,
      ),
      RentedInStatus.inHouse when due == null => l.loanNoDueDate,
      _ => null,
    };
    final returned = status == RentedInStatus.returned;
    return SectionCard(
      title: l.loan,
      trailing: StatusPill(
        l.rentedInStatus(status),
        tone: status == RentedInStatus.overdue
            ? PillTone.solid
            : returned
            ? PillTone.muted
            : PillTone.outline,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (alert != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: Mono.ink(context),
                borderRadius: BorderRadius.circular(Mono.radiusSmall),
              ),
              child: Row(
                children: [
                  Icon(Icons.schedule, color: scheme.onPrimary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      alert,
                      style: TextStyle(
                        color: scheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (a.supplierName != null) AmountRow(l.rentedFrom, a.supplierName!),
          if (a.supplierPhone != null)
            AmountRow(l.supplierPhone, a.supplierPhone!),
          if (a.supplierReference != null)
            AmountRow(l.theirReference, a.supplierReference!),
          if (a.rentedInDateStart != null)
            AmountRow(l.heldFrom, when(a.rentedInDateStart)),
          if (due != null) AmountRow(l.dueBack, when(due), bold: true),
          if (a.rentedInCostDay > 0)
            AmountRow(l.costPerDay, money(a.rentedInCostDay)),
          if (a.rentedInDeposit > 0)
            AmountRow(l.depositPaid, money(a.rentedInDeposit)),
          AmountRow(
            l.conditionReceived,
            l.loanCondition(a.rentedInConditionIn),
          ),
          if (returned) ...[
            AmountRow(l.givenBackOn, when(a.rentedInReturnedAt), bold: true),
            if (a.rentedInConditionOut != null)
              AmountRow(
                l.conditionReturned,
                l.loanCondition(a.rentedInConditionOut!),
              ),
          ],
          if (a.rentedInNote != null) ...[
            const SizedBox(height: 8),
            Text(
              a.rentedInNote!,
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
          ],
          if (!returned) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              key: const Key('give-back'),
              icon: const Icon(Icons.assignment_return_outlined),
              onPressed: () => _giveBack(a),
              label: Text(l.giveBack),
            ),
          ],
        ],
      ),
    );
  }

  Widget _unit(AppLocalizations l, Serial u) {
    final tone = switch (u.state) {
      SerialState.out || SerialState.mandatoryOut => PillTone.solid,
      SerialState.reserved => PillTone.outline,
      _ => PillTone.muted,
    };
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.qr_code_2),
      title: Text(u.name, textDirection: TextDirection.ltr),
      subtitle: u.note == null
          ? null
          : Text(u.note!, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: StatusPill(l.serialState(u.state), tone: tone),
      onTap: () => _openUnit(u),
    );
  }
}

/// One unit: its details, its state, and its order if it is on one.
class _UnitSheet extends StatefulWidget {
  const _UnitSheet(this.unit);
  final Serial unit;

  @override
  State<_UnitSheet> createState() => _UnitSheetState();
}

class _UnitSheetState extends State<_UnitSheet> {
  late final Serial _u = widget.unit;
  late final _name = TextEditingController(text: _u.name);
  late final _note = TextEditingController(text: _u.note);
  late final _cost = TextEditingController(
    text: _u.unitCost == 0 ? '' : qty(_u.unitCost),
  );
  late final _value = TextEditingController(
    text: _u.declaredValue == 0 ? '' : qty(_u.declaredValue),
  );
  late final _url = TextEditingController(text: _u.evaluationUrl);
  late DateTime? _acquired = _u.acquisitionDate;
  late SerialState _state = _u.state;

  static const _manual = [
    SerialState.available,
    SerialState.maintenance,
    SerialState.retired,
    SerialState.lost,
  ];

  @override
  void dispose() {
    for (final c in [_name, _note, _cost, _value, _url]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final l = context.l10n;
    final cost = _cost.text.trim().isEmpty ? 0.0 : parseNumber(_cost.text);
    final value = _value.text.trim().isEmpty ? 0.0 : parseNumber(_value.text);
    if (cost == null || value == null) {
      await showProblems(context, [l.checkNumbers]);
      return;
    }
    final repo = Services.of(context).repo;
    String? opt(TextEditingController c) =>
        c.text.trim().isEmpty ? null : c.text.trim();
    final ok = await attempt(context, () async {
      await repo.updateUnit(
        _u.id,
        SerialsCompanion(
          name: Value(_name.text),
          note: Value(opt(_note)),
          unitCost: Value(cost),
          declaredValue: Value(value),
          evaluationUrl: Value(opt(_url)),
          acquisitionDate: Value(_acquired),
        ),
      );
      if (_state != _u.state) await repo.setUnitState(_u.id, _state);
    });
    if (ok && mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    const number = TextInputType.numberWithOptions(decimal: true);
    final manual = _manual.contains(_u.state);
    final order = _u.currentOrderId;
    const gap = SizedBox(height: 12);
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.unit, style: Theme.of(context).textTheme.titleLarge),
            gap,
            TextField(
              key: const Key('unit-name'),
              controller: _name,
              textDirection: TextDirection.ltr,
              decoration: InputDecoration(labelText: l.unitName),
            ),
            gap,
            if (manual)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final s in _manual)
                    ChoiceChip(
                      key: Key('unit-state-${s.key}'),
                      label: Text(l.serialState(s)),
                      selected: _state == s,
                      onSelected: (_) => setState(() => _state = s),
                    ),
                ],
              )
            else
              Row(
                children: [
                  StatusPill(l.serialState(_u.state), tone: PillTone.solid),
                  const Spacer(),
                  if (order != null)
                    TextButton(
                      onPressed: () => Services.push<void>(
                        context,
                        OrderDetailPage(orderId: order),
                      ),
                      child: Text(l.openOrder),
                    ),
                ],
              ),
            gap,
            TextField(
              key: const Key('unit-note'),
              controller: _note,
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(labelText: l.note),
            ),
            gap,
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cost,
                    keyboardType: number,
                    decoration: InputDecoration(labelText: l.costPerUnit),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _value,
                    keyboardType: number,
                    decoration: InputDecoration(labelText: l.declaredValue),
                  ),
                ),
              ],
            ),
            gap,
            InkWell(
              borderRadius: BorderRadius.circular(Mono.radiusSmall),
              onTap: () async {
                final d = await pickDate(context, _acquired);
                if (d != null) setState(() => _acquired = d);
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l.acquisitionDate,
                  prefixIcon: const Icon(Icons.event_outlined),
                ),
                isEmpty: _acquired == null,
                child: _acquired == null ? null : Text(day(_acquired)),
              ),
            ),
            gap,
            TextField(
              controller: _url,
              textDirection: TextDirection.ltr,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                labelText: l.evaluationLink,
                hintText: 'https://',
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              key: const Key('save-unit'),
              onPressed: _save,
              child: Text(l.save),
            ),
          ],
        ),
      ),
    );
  }
}

class _GiveBackDialog extends StatefulWidget {
  const _GiveBackDialog({required this.supplier});
  final String? supplier;

  @override
  State<_GiveBackDialog> createState() => _GiveBackDialogState();
}

class _GiveBackDialogState extends State<_GiveBackDialog> {
  LoanCondition _condition = LoanCondition.good;
  final _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(l.giveBackTo(widget.supplier ?? l.theSupplier)),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MonoDropdown<LoanCondition>(
              label: l.conditionReturned,
              value: _condition,
              options: [
                for (final c in LoanCondition.values) (c, l.loanCondition(c)),
              ],
              onSelected: (v) => setState(() => _condition = v ?? _condition),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _note,
              decoration: InputDecoration(labelText: l.note),
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
          key: const Key('give-back-confirm'),
          onPressed: () => Navigator.pop(context, (_condition, _note.text)),
          child: Text(l.giveBack),
        ),
      ],
    );
  }
}

class _AddUnitsDialog extends StatefulWidget {
  const _AddUnitsDialog();

  @override
  State<_AddUnitsDialog> createState() => _AddUnitsDialogState();
}

class _AddUnitsDialogState extends State<_AddUnitsDialog> {
  final _names = TextEditingController();

  @override
  void dispose() {
    _names.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(l.addUnits),
      content: SizedBox(
        width: 360,
        child: TextField(
          key: const Key('units-input'),
          controller: _names,
          autofocus: true,
          minLines: 3,
          maxLines: 8,
          textDirection: TextDirection.ltr,
          decoration: InputDecoration(hintText: l.unitsOnePerLine),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        FilledButton(
          key: const Key('save-units-dialog'),
          onPressed: () => Navigator.pop(
            context,
            _names.text.split(RegExp(r'[\n,]')).toList(),
          ),
          child: Text(l.add),
        ),
      ],
    );
  }
}
