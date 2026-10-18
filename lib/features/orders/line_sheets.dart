import 'package:flutter/material.dart';

import '../../app/format.dart';
import '../../app/services.dart';
import '../../app/ui.dart';
import '../../data/local/database.dart';
import '../../data/repository.dart';
import '../../domain/enums.dart';

/// Adds an asset, service or section line. Returns the new line id.
Future<String?> showAddLine(BuildContext context, String orderId) =>
    showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => Services.of(context).wrap(_AddLineSheet(orderId)),
    );

/// Edits or removes a line still in draft. Returns true when it changed.
Future<bool?> showEditLine(BuildContext context, LineView view, Order order) =>
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => Services.of(context).wrap(_EditLineSheet(view, order)),
    );

/// Something the add sheet can put on a line.
typedef _Item = ({
  String id,
  String name,
  String? detail,
  double price,
  bool byUnit,
});

class _AddLineSheet extends StatefulWidget {
  const _AddLineSheet(this.orderId);
  final String orderId;

  @override
  State<_AddLineSheet> createState() => _AddLineSheetState();
}

class _AddLineSheetState extends State<_AddLineSheet> {
  LineType _type = LineType.asset;
  String _search = '';
  Future<List<_Item>>? _items;
  _Item? _picked;
  final _name = TextEditingController();
  final _qty = TextEditingController(text: '1');
  final _price = TextEditingController(text: '0');
  final _discount = TextEditingController(text: '0');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _items ??= _load();
  }

  @override
  void dispose() {
    for (final c in [_name, _qty, _price, _discount]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<List<_Item>> _load() async {
    final repo = Services.of(context).repo;
    switch (_type) {
      case LineType.asset:
        final assets = await repo.watchAssets(search: _search).first;
        return [
          for (final a in assets)
            if (a.asset.rentalOk)
              (
                id: a.asset.id,
                name: a.asset.name,
                detail:
                    '${a.asset.code ?? ''}  ${qty(a.available)} / ${qty(a.total)}',
                price: a.asset.rentalPriceDay,
                byUnit: a.asset.tracking == Tracking.serial,
              ),
        ];
      case LineType.service:
      case LineType.section:
        return const [];
    }
  }

  void _setType(LineType t) => setState(() {
    _type = t;
    _picked = null;
    _search = '';
    _items = _load();
  });

  void _pick(_Item item) => setState(() {
    _picked = item;
    _name.text = item.name;
    _price.text = qty(item.price);
  });

  Future<void> _add() async {
    final l = context.l10n;
    final repo = Services.of(context).repo;
    final section = _type == LineType.section;
    final quantity = section ? 0.0 : parseNumber(_qty.text);
    final price = section ? 0.0 : parseNumber(_price.text);
    final discount = section ? 0.0 : parseNumber(_discount.text);
    if (quantity == null || price == null || discount == null) {
      await showProblems(context, [l.checkNumbers]);
      return;
    }
    if (!section && quantity <= 0) {
      await showProblems(context, [l.quantityPositive]);
      return;
    }
    final needsPick = _type == LineType.asset;
    if (needsPick && _picked == null) {
      await showProblems(context, [l.pickItemFirst]);
      return;
    }
    if (!needsPick && _name.text.trim().isEmpty) {
      await showProblems(context, [l.nameNeeded]);
      return;
    }
    String? id;
    final ok = await attempt(context, () async {
      id = await repo.addLine(
        widget.orderId,
        type: _type,
        assetId: _type == LineType.asset ? _picked!.id : null,
        name: _name.text.trim(),
        quantity: quantity,
        priceDay: price,
        discount: discount,
      );
    });
    if (ok && mounted) Navigator.pop(context, id);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final pickList = _type == LineType.asset;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.75,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.addLine, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            SegmentedButton<LineType>(
              showSelectedIcon: false,
              segments: [
                for (final t in LineType.values)
                  ButtonSegment(value: t, label: Text(l.lineType(t))),
              ],
              selected: {_type},
              onSelectionChanged: (s) => _setType(s.first),
            ),
            const SizedBox(height: 12),
            if (pickList && _picked == null) ...[
              TextField(
                key: const Key('line-search'),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: l.searchNameOrCode,
                ),
                onChanged: (v) => setState(() {
                  _search = v;
                  _items = _load();
                }),
              ),
              Expanded(child: _itemList(l)),
            ] else
              Expanded(child: _form(l, pickList)),
          ],
        ),
      ),
    );
  }

  Widget _itemList(AppLocalizations l) => FutureBuilder<List<_Item>>(
    future: _items,
    builder: (context, snap) {
      final items = snap.data;
      if (items == null) {
        return const Center(child: CircularProgressIndicator());
      }
      if (items.isEmpty) return Center(child: Text(l.nothingFound));
      return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, i) {
          final it = items[i];
          return ListTile(
            title: Text(it.name),
            subtitle: it.detail == null || it.detail!.trim().isEmpty
                ? null
                : Text(it.detail!.trim()),
            trailing: Text('${money(it.price)} ${l.perDay}'),
            onTap: () => _pick(it),
          );
        },
      );
    },
  );

  Widget _form(AppLocalizations l, bool picked) {
    final section = _type == LineType.section;
    return ListView(
      children: [
        if (picked)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(_picked!.name),
            subtitle: _picked!.byUnit ? Text(l.byUnitHint) : null,
            trailing: TextButton(
              onPressed: () => setState(() => _picked = null),
              child: Text(l.change),
            ),
          )
        else
          TextField(
            key: const Key('line-name'),
            controller: _name,
            autofocus: true,
            decoration: InputDecoration(
              labelText: section ? l.sectionTitle : l.description,
            ),
          ),
        if (!section) ...[
          const SizedBox(height: 8),
          _NumberFields(qty: _qty, price: _price, discount: _discount),
        ],
        const SizedBox(height: 16),
        FilledButton(
          key: const Key('add-line-confirm'),
          onPressed: _add,
          child: Text(l.add),
        ),
      ],
    );
  }
}

class _NumberFields extends StatelessWidget {
  const _NumberFields({
    required this.qty,
    required this.price,
    required this.discount,
  });
  final TextEditingController qty;
  final TextEditingController price;
  final TextEditingController discount;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    Widget field(Key key, TextEditingController c, String label) => Expanded(
      child: TextField(
        key: key,
        controller: c,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(labelText: label),
      ),
    );
    return Row(
      children: [
        field(const Key('line-qty'), qty, l.quantity),
        const SizedBox(width: 8),
        field(const Key('line-price'), price, l.pricePerDay),
        const SizedBox(width: 8),
        field(const Key('line-discount'), discount, l.discountPercent),
      ],
    );
  }
}

class _EditLineSheet extends StatefulWidget {
  const _EditLineSheet(this.view, this.order);
  final LineView view;
  final Order order;

  @override
  State<_EditLineSheet> createState() => _EditLineSheetState();
}

class _EditLineSheetState extends State<_EditLineSheet> {
  late final OrderLine _line = widget.view.line;
  late final _name = TextEditingController(text: _line.name);
  late final _qty = TextEditingController(text: qty(_line.quantity));
  late final _price = TextEditingController(text: qty(_line.priceDay));
  late final _discount = TextEditingController(text: qty(_line.discount));

  /// The line runs on its own dates instead of the order's.
  late bool _ownDates = _line.dateStart != null || _line.dateEnd != null;
  late DateTime? _start = _line.dateStart ?? widget.order.dateStart;
  late DateTime? _end = _line.dateEnd ?? widget.order.dateEnd;

  @override
  void dispose() {
    for (final c in [_name, _qty, _price, _discount]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final l = context.l10n;
    final repo = Services.of(context).repo;
    final section = _line.lineType == LineType.section;
    final q = parseNumber(_qty.text);
    final p = parseNumber(_price.text);
    final d = parseNumber(_discount.text);
    if (!section && (q == null || p == null || d == null)) {
      await showProblems(context, [l.checkNumbers]);
      return;
    }
    final ok = await attempt(context, () async {
      await repo.updateLine(
        _line.id,
        name: _name.text.trim(),
        quantity: section ? null : q,
        priceDay: section ? null : p,
        discount: section ? null : d,
      );
      if (!section) {
        await repo.setLineDates(
          _line.id,
          _ownDates ? _start : null,
          _ownDates ? _end : null,
        );
      }
    });
    if (ok && mounted) Navigator.pop(context, true);
  }

  Future<void> _remove() async {
    final l = context.l10n;
    final repo = Services.of(context).repo;
    if (!await confirm(context, l.removeLineQuestion(_line.name))) return;
    if (!mounted) return;
    final ok = await attempt(context, () => repo.removeLine(_line.id));
    if (ok && mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final section = _line.lineType == LineType.section;
    final editable = _line.rentalState == RentalState.none;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.editLine, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          TextField(
            key: const Key('edit-name'),
            controller: _name,
            enabled: editable,
            decoration: InputDecoration(labelText: l.description),
          ),
          if (!section) ...[
            const SizedBox(height: 8),
            _NumberFields(qty: _qty, price: _price, discount: _discount),
          ],
          if (!section && editable) ...[
            const SizedBox(height: 4),
            SwitchListTile(
              key: const Key('line-own-dates'),
              contentPadding: EdgeInsets.zero,
              title: Text(l.ownDates),
              subtitle: Text(
                _ownDates
                    ? l.dateRange(when(_start), when(_end))
                    : l.followsOrderDates,
              ),
              value: _ownDates,
              onChanged: (v) => setState(() => _ownDates = v),
            ),
            if (_ownDates)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      key: const Key('line-start'),
                      icon: const Icon(Icons.event_outlined, size: 18),
                      onPressed: () async {
                        final v = await pickDateTime(context, _start);
                        if (v != null) setState(() => _start = v);
                      },
                      label: Text(when(_start)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      key: const Key('line-end'),
                      icon: const Icon(
                        Icons.event_available_outlined,
                        size: 18,
                      ),
                      onPressed: () async {
                        final v = await pickDateTime(context, _end);
                        if (v != null) setState(() => _end = v);
                      },
                      label: Text(when(_end)),
                    ),
                  ),
                ],
              ),
          ],
          if (!editable) ...[
            const SizedBox(height: 8),
            Text(l.bookedLinesFixed),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              OutlinedButton.icon(
                key: const Key('remove-line'),
                icon: const Icon(Icons.delete_outline),
                onPressed: _line.rentalState.goneOut ? null : _remove,
                label: Text(l.removeLine),
              ),
              const Spacer(),
              FilledButton(
                key: const Key('save-line'),
                onPressed: editable ? _save : null,
                child: Text(l.save),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
