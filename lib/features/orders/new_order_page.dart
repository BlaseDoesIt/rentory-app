import 'package:flutter/material.dart';

import '../../app/format.dart';
import '../../app/services.dart';
import '../../app/ui.dart';
import '../../domain/rules/order_rules.dart';
import 'customer_picker.dart';
import 'order_detail_page.dart';

/// Customer and dates; lines are added on the order itself.
class NewOrderPage extends StatefulWidget {
  const NewOrderPage({super.key});

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  PickedCustomer? _customer;
  late DateTime _start;
  late DateTime _end;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    // Tomorrow 09:00 to the day after, the usual one-day job.
    final now = DateTime.now();
    _start = DateTime(now.year, now.month, now.day + 1, 9).toUtc();
    _end = DateTime(now.year, now.month, now.day + 2, 9).toUtc();
  }

  Future<void> _create() async {
    final l = context.l10n;
    if (datesProblem(_start, _end) != null) {
      await showProblems(context, [l.endAfterStart]);
      return;
    }
    final repo = Services.of(context).repo;
    setState(() => _busy = true);
    String? id;
    final ok = await attempt(context, () async {
      id = await repo.createOrder(
        customerId: _customer?.id,
        customerName: _customer?.name,
        customerPhone: _customer?.phone,
        start: _start,
        end: _end,
      );
    });
    if (!mounted) return;
    setState(() => _busy = false);
    if (!ok) return;
    final services = Services.of(context);
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => services.wrap(OrderDetailPage(orderId: id!)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.newOrder)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            key: const Key('pick-customer'),
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.person_outline),
            title: Text(_customer?.name ?? l.chooseCustomer),
            subtitle: Text(l.customer),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final c = await pickCustomer(context);
              if (c != null) setState(() => _customer = c);
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.event_outlined),
            title: Text(when(_start)),
            subtitle: Text(l.start),
            onTap: () async {
              final d = await pickDateTime(context, _start);
              if (d == null) return;
              setState(() {
                final length = _end.difference(_start);
                _start = d;
                if (!_end.isAfter(_start)) _end = _start.add(length);
              });
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.event_available_outlined),
            title: Text(when(_end)),
            subtitle: Text(l.end),
            onTap: () async {
              final d = await pickDateTime(context, _end);
              if (d != null) setState(() => _end = d);
            },
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _busy ? null : _create,
            child: Text(l.createOrder),
          ),
        ],
      ),
    );
  }
}
