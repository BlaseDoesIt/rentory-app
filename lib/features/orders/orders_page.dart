import 'package:flutter/material.dart';

import '../../app/format.dart';
import '../../app/services.dart';
import '../../data/repository.dart';
import '../../domain/enums.dart';
import 'new_order_page.dart';
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
    final l = context.l10n;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('new-order'),
        icon: const Icon(Icons.add),
        label: Text(l.newOrder),
        onPressed: () => Services.push<void>(context, const NewOrderPage()),
      ),
      body: _list(context, l),
    );
  }

  Widget _list(BuildContext context, AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            l.orders,
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
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: ChoiceChip(
                    label: Text(s == null ? l.all : l.orderState(s)),
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
                return Center(child: Text(l.noOrders));
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
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
    final l = context.l10n;
    final customer = s.customerLabel.isEmpty ? l.noCustomer : s.customerLabel;
    final late = s.overdue ? '  ·  ${l.daysLate(s.daysLate)}' : '';
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      title: Text('${o.number ?? l.stateDraft}  ·  $customer'),
      subtitle: Text(
        '${l.dateRange(when(o.dateStart), when(o.dateEnd))}  ·  '
        '${l.itemCount(s.itemCount)}$late',
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            money(s.amounts.charged),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(l.orderState(o.state)),
        ],
      ),
      onTap: () => Services.push<void>(context, OrderDetailPage(orderId: o.id)),
    );
  }
}
