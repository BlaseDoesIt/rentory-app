import 'package:flutter/material.dart';

import '../../app/format.dart';
import '../../app/services.dart';
import '../../data/repository.dart';
import '../../domain/enums.dart';
import 'order_detail_page.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  OrderState? _filter;
  Stream<List<OrderSummary>>? _stream;
  OrderState? _streamFor;

  /// One subscription per filter, not one per rebuild.
  Stream<List<OrderSummary>> _orders(BuildContext context) {
    if (_stream == null || _streamFor != _filter) {
      _streamFor = _filter;
      _stream = Services.of(context).repo.watchOrders(state: _filter);
    }
    return _stream!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Orders',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              for (final s in <OrderState?>[null, ...OrderState.values])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(s == null ? 'All' : orderStateLabel(s)),
                    selected: _filter == s,
                    onSelected: (_) => setState(() => _filter = s),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<OrderSummary>>(
            stream: _orders(context),
            builder: (context, snap) {
              if (snap.hasError) {
                return Center(child: Text('${snap.error}'));
              }
              final orders = snap.data;
              if (orders == null) {
                return const Center(child: CircularProgressIndicator());
              }
              if (orders.isEmpty) {
                return const Center(child: Text('No orders yet.'));
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, i) => _OrderTile(orders[i]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _OrderTile extends StatelessWidget {
  const _OrderTile(this.s);
  final OrderSummary s;

  @override
  Widget build(BuildContext context) {
    final o = s.order;
    final customer = s.customerLabel.isEmpty ? 'No customer' : s.customerLabel;
    final late = s.overdue ? '  ·  ${s.daysLate} day(s) late' : '';
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      title: Text('${o.number ?? 'Draft'}  ·  $customer'),
      subtitle: Text(
        '${when(o.dateStart)} → ${when(o.dateEnd)}  ·  '
        '${s.itemCount} item(s)$late',
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            money(s.amounts.charged),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(orderStateLabel(o.state)),
        ],
      ),
      onTap: () {
        final services = Services.of(context);
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => Services(
              db: services.db,
              backend: services.backend,
              userEmail: services.userEmail,
              onSignOut: services.onSignOut,
              child: OrderDetailPage(orderId: o.id),
            ),
          ),
        );
      },
    );
  }
}
