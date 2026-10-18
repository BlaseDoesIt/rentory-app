import 'package:flutter/material.dart';

import '../../app/format.dart';
import '../../app/services.dart';
import '../../app/widgets.dart';
import '../../data/repository.dart';
import '../../domain/enums.dart';
import 'new_order_page.dart';
import 'order_detail_page.dart';
import 'order_widgets.dart';

/// What the list shows. The stat tiles and the chips both set it.
sealed class _Filter {
  const _Filter();
  bool keep(OrderSummary s);
}

class _All extends _Filter {
  const _All();
  @override
  bool keep(OrderSummary s) => true;
}

class _ByState extends _Filter {
  const _ByState(this.states);
  final Set<OrderState> states;
  @override
  bool keep(OrderSummary s) => states.contains(s.order.state);
  @override
  bool operator ==(Object other) =>
      other is _ByState &&
      other.states.length == states.length &&
      other.states.containsAll(states);
  @override
  int get hashCode => Object.hashAllUnordered(states);
}

class _Overdue extends _Filter {
  const _Overdue();
  @override
  bool keep(OrderSummary s) => s.overdue;
}

const _out = _ByState({OrderState.pickedUp, OrderState.partialReturn});

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  _Filter _filter = const _All();
  String _search = '';
  Stream<List<OrderSummary>>? _stream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // One subscription; filtering happens here, so switching is instant.
    _stream ??= Services.of(context).repo.watchOrders();
  }

  void _set(_Filter f) =>
      setState(() => _filter = _filter == f ? const _All() : f);

  bool _matches(OrderSummary s) {
    final q = _search.trim().toLowerCase();
    if (q.isEmpty) return true;
    final o = s.order;
    return [
      s.customerLabel,
      o.number ?? '',
      o.customerPhone ?? '',
    ].any((x) => x.toLowerCase().contains(q));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: GradientFab(
        key: const Key('new-order'),
        icon: Icons.add,
        label: l.newOrder,
        onPressed: () => Services.push<void>(context, const NewOrderPage()),
      ),
      body: StreamBuilder<List<OrderSummary>>(
        stream: _stream,
        builder: (context, snap) {
          if (snap.hasError) return Center(child: Text('${snap.error}'));
          final all = snap.data;
          if (all == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return _content(context, l, all);
        },
      ),
    );
  }

  Widget _content(
    BuildContext context,
    AppLocalizations l,
    List<OrderSummary> all,
  ) {
    final shown = [
      for (final s in all)
        if (_filter.keep(s) && _matches(s)) s,
    ];
    final out = all.where(_out.keep).length;
    final overdue = all.where((s) => s.overdue).length;
    final booked = all.where((s) => s.order.state == OrderState.booked).length;
    final drafts = all.where((s) => s.order.state == OrderState.draft).length;
    final wide = MediaQuery.sizeOf(context).width >= 720;

    final stats = [
      StatTile(
        key: const Key('stat-out'),
        label: l.statOut,
        value: '$out',
        icon: Icons.outbox_outlined,
        compact: !wide,
        selected: _filter == _out,
        onTap: () => _set(_out),
      ),
      StatTile(
        key: const Key('stat-overdue'),
        label: l.overdue,
        value: '$overdue',
        icon: Icons.schedule,
        compact: !wide,
        selected: _filter is _Overdue,
        onTap: () => _set(const _Overdue()),
      ),
      StatTile(
        label: l.stateBooked,
        value: '$booked',
        icon: Icons.event_available_outlined,
        compact: !wide,
        selected: _filter == const _ByState({OrderState.booked}),
        onTap: () => _set(const _ByState({OrderState.booked})),
      ),
      StatTile(
        label: l.statDrafts,
        value: '$drafts',
        icon: Icons.edit_note,
        compact: !wide,
        selected: _filter == const _ByState({OrderState.draft}),
        onTap: () => _set(const _ByState({OrderState.draft})),
      ),
    ];

    return ContentWidth(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PageHeader(
              title: l.orders,
              subtitle: l.ordersSummary(out, overdue),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: wide ? 4 : 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                mainAxisExtent: wide ? 120 : 78,
              ),
              delegate: SliverChildListDelegate(stats),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: TextField(
                key: const Key('order-search'),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: l.searchOrders,
                ),
                onChanged: (v) => setState(() => _search = v),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Row(
                children: [
                  _chip(l.all, const _All()),
                  for (final s in OrderState.values)
                    _chip(l.orderState(s), _ByState({s})),
                ],
              ),
            ),
          ),
          if (shown.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyState(
                icon: Icons.receipt_long_outlined,
                title: all.isEmpty ? l.noOrders : l.nothingFound,
                message: all.isEmpty ? l.noOrdersHint : null,
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 96),
              sliver: SliverList.separated(
                itemCount: shown.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, i) => FadeSlideIn(
                  key: ValueKey(shown[i].order.id),
                  index: i,
                  child: OrderCard(
                    shown[i],
                    onTap: () => Services.push<void>(
                      context,
                      OrderDetailPage(orderId: shown[i].order.id),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _chip(String label, _Filter f) => Padding(
    padding: const EdgeInsetsDirectional.only(end: 8),
    child: MonoChip(
      label: label,
      selected: _filter == f,
      onTap: () => setState(() => _filter = f),
    ),
  );
}
