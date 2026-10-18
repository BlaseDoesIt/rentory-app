import 'package:flutter/material.dart';

import '../../app/format.dart';
import '../../app/widgets.dart';
import '../../data/repository.dart';
import '../../domain/enums.dart';

/// The one pill that says where an order stands. Late beats everything.
class OrderStatusPill extends StatelessWidget {
  const OrderStatusPill(this.summary, {super.key});
  final OrderSummary summary;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (summary.overdue) {
      return StatusPill(
        l.daysLate(summary.daysLate),
        tone: PillTone.solid,
        icon: Icons.schedule,
      );
    }
    final s = summary.order.state;
    return StatusPill(l.orderState(s), tone: toneOf(s));
  }

  static PillTone toneOf(OrderState s) => switch (s) {
    OrderState.pickedUp || OrderState.partialReturn => PillTone.solid,
    OrderState.booked => PillTone.outline,
    OrderState.draft ||
    OrderState.returned ||
    OrderState.cancelled => PillTone.muted,
  };
}

/// An order in a list.
class OrderCard extends StatelessWidget {
  const OrderCard(this.summary, {super.key, required this.onTap});
  final OrderSummary summary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final o = summary.order;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final customer = summary.customerLabel.isEmpty
        ? l.noCustomer
        : summary.customerLabel;
    final muted = text.bodySmall?.copyWith(color: scheme.onSurfaceVariant);
    final cancelled = o.state == OrderState.cancelled;
    return MonoCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Monogram(customer, size: 44),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.titleMedium?.copyWith(
                      decoration: cancelled ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${o.number ?? l.stateDraft}  ·  '
                    '${l.itemCount(summary.itemCount)}',
                    style: muted,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.event_outlined,
                        size: 14,
                        color: scheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          l.dateRange(when(o.dateStart), when(o.dateEnd)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: muted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(money(summary.amounts.charged), style: text.titleMedium),
                const SizedBox(height: 8),
                OrderStatusPill(summary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
