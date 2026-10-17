import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import '../../app/format.dart';
import '../../app/services.dart';
import '../../data/local/database.dart';
import '../../data/repository.dart';
import '../../domain/enums.dart';

/// One order: its lines, money, and the lifecycle buttons. Full editing
/// (adding lines, the unit picker, pickup and return screens) comes next.
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

  Future<void> _act(Future<void> Function(RentoryRepository) action) async {
    final repo = Services.of(context).repo;
    setState(() => _busy = true);
    try {
      await action(repo);
    } on RuleException catch (e) {
      if (mounted) {
        await showDialog<void>(
          context: context,
          builder: (dialog) => AlertDialog(
            title: const Text('Not yet'),
            content: Text(e.problems.join('\n')),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialog),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _detail = repo.loadOrder(widget.orderId);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<OrderDetail>(
      future: _detail,
      builder: (context, snap) {
        final d = snap.data;
        return Scaffold(
          appBar: AppBar(
            title: Text(d == null ? 'Order' : (d.order.number ?? 'Draft')),
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
    final o = d.order;
    final a = d.summary.amounts;
    final text = Theme.of(context).textTheme;
    final late = d.summary.overdue
        ? '  ·  ${d.summary.daysLate} day(s) late'
        : '';
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          d.summary.customerLabel.isEmpty
              ? 'No customer'
              : d.summary.customerLabel,
          style: text.titleLarge,
        ),
        Text('${when(o.dateStart)} → ${when(o.dateEnd)}'),
        const SizedBox(height: 4),
        Text(
          '${orderStateLabel(o.state)}$late',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        for (final v in d.lines) _line(v, text),
        const Divider(height: 32),
        _row('Lines', money(a.lines)),
        if (a.discount > 0) _row('Discount', '− ${money(a.discount)}'),
        if (a.lateFee > 0) _row('Late fee', money(a.lateFee)),
        _row('Total', money(a.charged), bold: true),
        _row('Paid', money(a.paid)),
        _row('Due', money(a.due), bold: true),
        if (o.amountDeposit > 0) _row('Deposit held', money(o.amountDeposit)),
        const SizedBox(height: 8),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Rental contract signed'),
          value: o.sigRentalContract,
          onChanged: _busy
              ? null
              : (v) => _act(
                  (r) => r.updateOrder(
                    o.id,
                    OrdersCompanion(sigRentalContract: Value(v ?? false)),
                  ),
                ),
        ),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: _actions(o)),
      ],
    );
  }

  List<Widget> _actions(Order o) {
    Widget button(
      String label,
      Future<void> Function(RentoryRepository) f, {
      bool primary = true,
    }) {
      final onPressed = _busy ? null : () => _act(f);
      return primary
          ? FilledButton(onPressed: onPressed, child: Text(label))
          : OutlinedButton(onPressed: onPressed, child: Text(label));
    }

    final s = o.state;
    return [
      if (s == OrderState.draft || s == OrderState.cancelled)
        button('Book', (r) => r.book(o.id)),
      if (s == OrderState.booked)
        button('Pick up all', (r) => r.pickupAll(o.id)),
      if (s == OrderState.pickedUp || s == OrderState.partialReturn)
        button('Return all', (r) => r.returnAll(o.id)),
      if (s == OrderState.booked)
        button('Back to draft', (r) => r.resetToDraft(o.id), primary: false),
      if (s == OrderState.draft || s == OrderState.booked)
        button('Cancel order', (r) => r.cancel(o.id), primary: false),
    ];
  }

  Widget _line(LineView v, TextTheme text) {
    final l = v.line;
    if (l.lineType == LineType.section) {
      return Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 4),
        child: Text(l.name, style: text.titleSmall),
      );
    }
    final units = v.serials.map((s) => s.name).join(', ');
    final discount = l.discount > 0 ? ' − ${qty(l.discount)}%' : '';
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(l.name),
      subtitle: Text(
        '${qty(l.quantity)} × ${money(l.priceDay)} × ${v.days} day(s)'
        '$discount${units.isEmpty ? '' : '\n$units'}',
      ),
      isThreeLine: units.isNotEmpty,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(money(v.subtotal)),
          Text(rentalStateLabel(l.rentalState), style: text.bodySmall),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    final style = bold ? const TextStyle(fontWeight: FontWeight.bold) : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(value, style: style),
        ],
      ),
    );
  }
}
