import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import '../../app/format.dart';
import '../../app/services.dart';
import '../../app/ui.dart';
import '../../data/local/database.dart';
import '../../data/repository.dart';
import '../../domain/enums.dart';
import '../../domain/rules/order_rules.dart';
import 'customer_picker.dart';
import 'line_sheets.dart';
import 'pickup_page.dart';
import 'return_page.dart';
import 'unit_picker.dart';

/// One order: customer, dates, lines, money and the lifecycle buttons. A
/// draft is edited here directly.
class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key, required this.orderId});
  final String orderId;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  Future<OrderDetail>? _detail;
  bool _busy = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _detail ??= Services.of(context).repo.loadOrder(widget.orderId);
  }

  void _reload() {
    final next = Services.of(context).repo.loadOrder(widget.orderId);
    setState(() {
      _detail = next;
    });
  }

  Future<void> _act(Future<void> Function(RentoryRepository) action) async {
    final repo = Services.of(context).repo;
    setState(() => _busy = true);
    await attempt(context, () => action(repo));
    if (!mounted) return;
    setState(() => _busy = false);
    _reload();
  }

  /// Opens [page] and reloads when it comes back.
  Future<void> _open(Widget page) async {
    await Services.push<Object?>(context, page);
    if (mounted) _reload();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FutureBuilder<OrderDetail>(
      future: _detail,
      builder: (context, snap) {
        final d = snap.data;
        return Scaffold(
          appBar: AppBar(
            title: Text(d == null ? l.order : (d.order.number ?? l.stateDraft)),
          ),
          body: d == null
              ? Center(
                  child: snap.hasError
                      ? Text('${snap.error}')
                      : const CircularProgressIndicator(),
                )
              : _body(context, d),
        );
      },
    );
  }

  Widget _body(BuildContext context, OrderDetail d) {
    final l = context.l10n;
    final o = d.order;
    final a = d.summary.amounts;
    final text = Theme.of(context).textTheme;
    final draft = o.state == OrderState.draft;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          key: const Key('order-customer'),
          contentPadding: EdgeInsets.zero,
          title: Text(
            d.summary.customerLabel.isEmpty
                ? l.noCustomer
                : d.summary.customerLabel,
            style: text.titleLarge,
          ),
          subtitle: o.customerPhone == null
              ? null
              : Text(o.customerPhone!, textDirection: TextDirection.ltr),
          trailing: draft ? const Icon(Icons.edit_outlined) : null,
          onTap: draft && !_busy ? () => _changeCustomer(o) : null,
        ),
        Row(
          children: [
            Expanded(child: _dateTile(l.start, o.dateStart, draft, true, o)),
            Expanded(child: _dateTile(l.end, o.dateEnd, draft, false, o)),
          ],
        ),
        Row(
          children: [
            Tag(l.orderState(o.state), inverted: true),
            if (d.summary.overdue) ...[
              const SizedBox(width: 8),
              Tag(l.daysLate(d.summary.daysLate)),
            ],
          ],
        ),
        const SizedBox(height: 16),
        for (final v in d.lines) _line(v, text, l),
        if (draft)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              key: const Key('add-line'),
              icon: const Icon(Icons.add),
              onPressed: _busy
                  ? null
                  : () async {
                      final id = await showAddLine(context, o.id);
                      if (id != null) _reload();
                    },
              label: Text(l.addLine),
            ),
          ),
        const Divider(height: 32),
        AmountRow(l.linesTotal, money(a.lines)),
        if (a.discount > 0) AmountRow(l.discount, '- ${money(a.discount)}'),
        if (a.lateFee > 0) AmountRow(l.lateFee, money(a.lateFee)),
        AmountRow(l.total, money(a.charged), bold: true),
        AmountRow(l.paid, money(a.paid)),
        AmountRow(l.due, money(a.due), bold: true),
        AmountRow(l.depositHeld, money(o.amountDeposit)),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            key: const Key('edit-money'),
            icon: const Icon(Icons.payments_outlined),
            onPressed: _busy ? null : () => _editMoney(o),
            label: Text(l.discountAndPayment),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: _actions(o, d)),
      ],
    );
  }

  Widget _dateTile(
    String label,
    DateTime? value,
    bool editable,
    bool isStart,
    Order o,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(when(value)),
      subtitle: Text(label),
      onTap: editable && !_busy
          ? () async {
              final l = context.l10n;
              final picked = await pickDateTime(context, value);
              if (picked == null || !mounted) return;
              final start = isStart ? picked : o.dateStart;
              final end = isStart ? o.dateEnd : picked;
              if (datesProblem(start, end) != null) {
                await showProblems(context, [l.endAfterStart]);
                return;
              }
              await _act(
                (r) => r.updateOrder(
                  o.id,
                  isStart
                      ? OrdersCompanion(dateStart: Value(picked))
                      : OrdersCompanion(dateEnd: Value(picked)),
                ),
              );
            }
          : null,
    );
  }

  Future<void> _changeCustomer(Order o) async {
    final c = await pickCustomer(context);
    if (c == null) return;
    await _act(
      (r) => r.updateOrder(
        o.id,
        OrdersCompanion(
          customerId: Value(c.id),
          customerName: Value(c.name),
          customerPhone: Value(c.phone),
        ),
      ),
    );
  }

  Future<void> _editMoney(Order o) async {
    final changes = await showDialog<OrdersCompanion>(
      context: context,
      builder: (_) => _MoneyDialog(o),
    );
    if (changes != null) await _act((r) => r.updateOrder(o.id, changes));
  }

  List<Widget> _actions(Order o, OrderDetail d) {
    final l = context.l10n;
    Widget button(
      Key key,
      String label,
      VoidCallback action, {
      bool primary = true,
    }) {
      final onPressed = _busy ? null : action;
      return primary
          ? FilledButton(key: key, onPressed: onPressed, child: Text(label))
          : OutlinedButton(key: key, onPressed: onPressed, child: Text(label));
    }

    final s = o.state;
    final out = d.lines.any((v) => v.line.rentalState == RentalState.pickedUp);
    final waiting = d.lines.any(
      (v) =>
          v.line.lineType != LineType.section &&
          v.line.rentalState == RentalState.booked,
    );
    return [
      if (s == OrderState.draft || s == OrderState.cancelled)
        button(const Key('book'), l.book, () => _act((r) => r.book(o.id))),
      if (OrderState.committed.contains(s) && waiting)
        button(
          const Key('pickup'),
          l.pickup,
          () => _open(PickupPage(orderId: o.id)),
        ),
      if (out)
        button(
          const Key('return'),
          l.returnItems,
          () => _open(ReturnPage(orderId: o.id)),
        ),
      if (s == OrderState.booked)
        button(
          const Key('to-draft'),
          l.backToDraft,
          () => _act((r) => r.resetToDraft(o.id)),
          primary: false,
        ),
      if (s == OrderState.draft || s == OrderState.booked)
        button(const Key('cancel-order'), l.cancelOrder, () async {
          if (await confirm(context, l.cancelOrderQuestion)) {
            await _act((r) => r.cancel(o.id));
          }
        }, primary: false),
    ];
  }

  Widget _line(LineView v, TextTheme text, AppLocalizations l) {
    final line = v.line;
    final editable = !line.rentalState.goneOut;
    void edit() async {
      final changed = await showEditLine(context, v);
      if (changed == true) _reload();
    }

    if (line.lineType == LineType.section) {
      return InkWell(
        onTap: editable && !_busy ? edit : null,
        child: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 4),
          child: Text(line.name, style: text.titleSmall),
        ),
      );
    }
    final byUnit = v.asset?.tracking == Tracking.serial;
    final units = v.serials.map((s) => s.name).join(', ');
    final missing = byUnit && v.serials.length != line.quantity.round();
    final discount = line.discount > 0 ? '  -${qty(line.discount)}%' : '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(line.name),
          subtitle: Text(
            '${qty(line.quantity)} × ${money(line.priceDay)} × '
            '${l.daysCount(v.days)}$discount'
            '${units.isEmpty ? '' : '\n$units'}',
          ),
          isThreeLine: units.isNotEmpty,
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(money(v.subtotal)),
              Text(l.rentalState(line.rentalState), style: text.bodySmall),
            ],
          ),
          onTap: editable && !_busy ? edit : null,
        ),
        if (byUnit && line.rentalState == RentalState.none)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                if (missing) ...[Tag(l.unitsMissing), const SizedBox(width: 8)],
                OutlinedButton.icon(
                  key: Key('units-${line.id}'),
                  icon: const Icon(Icons.qr_code_2),
                  onPressed: _busy
                      ? null
                      : () => _open(
                          UnitPickerPage(
                            orderId: v.line.orderId,
                            lineId: line.id,
                          ),
                        ),
                  label: Text(l.pickUnits),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Order discount, deposit and what was paid.
class _MoneyDialog extends StatefulWidget {
  const _MoneyDialog(this.order);
  final Order order;

  @override
  State<_MoneyDialog> createState() => _MoneyDialogState();
}

class _MoneyDialogState extends State<_MoneyDialog> {
  late DiscountType _type = widget.order.discountType;
  late final _discount = TextEditingController(
    text: qty(widget.order.discountValue),
  );
  late final _deposit = TextEditingController(
    text: qty(widget.order.amountDeposit),
  );
  late final _paid = TextEditingController(text: qty(widget.order.amountPaid));

  @override
  void dispose() {
    for (final c in [_discount, _deposit, _paid]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final l = context.l10n;
    final d = parseNumber(_discount.text);
    final dep = parseNumber(_deposit.text);
    final paid = parseNumber(_paid.text);
    if (d == null ||
        dep == null ||
        paid == null ||
        d < 0 ||
        dep < 0 ||
        paid < 0) {
      await showProblems(context, [l.checkNumbers]);
      return;
    }
    if (_type == DiscountType.percent && d > 100) {
      await showProblems(context, [l.percentMax]);
      return;
    }
    if (!mounted) return;
    Navigator.pop(
      context,
      OrdersCompanion(
        discountType: Value(_type),
        discountValue: Value(d),
        amountDeposit: Value(dep),
        amountPaid: Value(paid),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final number = const TextInputType.numberWithOptions(decimal: true);
    return AlertDialog(
      title: Text(l.discountAndPayment),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SegmentedButton<DiscountType>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: DiscountType.percent,
                  label: Text(l.percent),
                ),
                ButtonSegment(value: DiscountType.fixed, label: Text(l.fixed)),
              ],
              selected: {_type},
              onSelectionChanged: (s) => setState(() => _type = s.first),
            ),
            TextField(
              key: const Key('order-discount'),
              controller: _discount,
              keyboardType: number,
              decoration: InputDecoration(labelText: l.orderDiscount),
            ),
            TextField(
              key: const Key('order-deposit'),
              controller: _deposit,
              keyboardType: number,
              decoration: InputDecoration(labelText: l.deposit),
            ),
            TextField(
              key: const Key('order-paid'),
              controller: _paid,
              keyboardType: number,
              decoration: InputDecoration(labelText: l.paid),
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
          key: const Key('save-money'),
          onPressed: _save,
          child: Text(l.save),
        ),
      ],
    );
  }
}
