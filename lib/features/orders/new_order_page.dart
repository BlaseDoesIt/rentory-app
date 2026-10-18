import 'package:flutter/material.dart';

import '../../app/format.dart';
import '../../app/services.dart';
import '../../app/ui.dart';
import '../../app/widgets.dart';
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
    final c = _customer;
    return Scaffold(
      appBar: AppBar(title: Text(l.newOrder)),
      body: ContentWidth(
        max: 640,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            SectionCard(
              title: l.customer,
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
              child: ListTile(
                key: const Key('pick-customer'),
                leading: c == null
                    ? const CircleAvatar(child: Icon(Icons.person_add_alt))
                    : Monogram(c.name),
                title: Text(c?.name ?? l.chooseCustomer),
                subtitle: c?.phone == null
                    ? null
                    : Text(c!.phone!, textDirection: TextDirection.ltr),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final picked = await pickCustomer(context);
                  if (picked != null) setState(() => _customer = picked);
                },
              ),
            ),
            const SizedBox(height: 12),
            SectionCard(
              title: l.dates,
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.event_outlined),
                    title: Text(when(_start)),
                    subtitle: Text(l.start),
                    trailing: const Icon(Icons.edit_calendar_outlined),
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
                    leading: const Icon(Icons.event_available_outlined),
                    title: Text(when(_end)),
                    subtitle: Text(l.end),
                    trailing: const Icon(Icons.edit_calendar_outlined),
                    onTap: () async {
                      final d = await pickDateTime(context, _end);
                      if (d != null) setState(() => _end = d);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomActionBar(
        child: FilledButton.icon(
          onPressed: _busy ? null : _create,
          icon: const Icon(Icons.arrow_forward),
          label: Text(l.createOrder),
        ),
      ),
    );
  }
}
