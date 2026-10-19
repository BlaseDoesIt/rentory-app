import 'dart:io';

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
import '../../domain/rules/order_rules.dart';
import '../scan/scan_page.dart';
import 'customer_picker.dart';
import 'line_sheets.dart';
import 'order_photos.dart';
import 'billing_widgets.dart';
import 'order_widgets.dart';
import 'pickup_page.dart';
import 'return_page.dart';
import 'unit_picker.dart';

/// One order: customer, dates, lines, money and the lifecycle buttons. Lines
/// can be added, edited, moved, booked, picked up and returned one by one,
/// whatever state the order is in.
class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key, required this.orderId});
  final String orderId;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  Future<OrderDetail>? _detail;
  bool _busy = false;

  /// Lines in the order just dragged, shown until the reload lands.
  List<LineView>? _moved;

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
    next.whenComplete(() {
      if (mounted && _detail == next) setState(() => _moved = null);
    });
  }

  static bool get _phone => Platform.isAndroid || Platform.isIOS;

  Future<void> _reorder(List<LineView> lines, int from, int to) async {
    final next = [...lines];
    final moved = next.removeAt(from);
    next.insert(to, moved);
    setState(() => _moved = next);
    await _act(
      (r) => r.moveLines(widget.orderId, [for (final v in next) v.line.id]),
    );
  }

  /// Phones: scan a unit or an asset straight onto the order.
  Future<void> _scanAdd(Order o) async {
    final l = context.l10n;
    final repo = Services.of(context).repo;
    final messenger = ScaffoldMessenger.of(context);
    final code = await Navigator.of(
      context,
    ).push<String>(MaterialPageRoute(builder: (_) => const CameraScanPage()));
    if (code == null || !mounted) return;
    ScanAdd? result;
    await attempt(context, () async {
      result = await repo.addScanned(o.id, code);
    });
    if (!mounted) return;
    _reload();
    final r = result;
    if (r == null) return;
    switch (r.outcome) {
      case ScanOutcome.added:
        messenger.showSnackBar(
          SnackBar(content: Text(l.scanAdded(r.name ?? code))),
        );
      case ScanOutcome.alreadyOnOrder:
        messenger.showSnackBar(
          SnackBar(content: Text(l.scanAlready(r.name ?? code))),
        );
      case ScanOutcome.notFound:
        messenger.showSnackBar(SnackBar(content: Text(l.notFound(code))));
      case ScanOutcome.pickUnits:
        await _open(UnitPickerPage(orderId: o.id, lineId: r.lineId!));
    }
  }

  Future<void> _remove(Order o) async {
    final l = context.l10n;
    final repo = Services.of(context).repo;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    if (!await confirm(context, l.deleteOrderQuestion) || !mounted) return;
    Removal? done;
    await attempt(context, () async {
      done = await repo.removeOrder(o.id);
    });
    if (done == null) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          done == Removal.deleted ? l.orderDeleted : l.orderArchived,
        ),
      ),
    );
    await navigator.maybePop();
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
            actions: [
              if (d != null) ...[
                if (!d.order.active)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: Tag(l.archived),
                  ),
                OrderStatusPill(d.summary),
                if (Services.of(context).billing case final billing?)
                  IconButton(
                    key: const Key('print-order'),
                    tooltip: l.printDocument,
                    icon: const Icon(Icons.print_outlined),
                    onPressed: () => printOrder(context, billing, d),
                  ),
                PopupMenuButton<String>(
                  key: const Key('order-menu'),
                  onSelected: (v) => v == 'delete'
                      ? _remove(d.order)
                      : _act((r) => r.restoreOrder(d.order.id)),
                  itemBuilder: (_) => [
                    if (d.order.active)
                      PopupMenuItem(
                        key: const Key('delete-order'),
                        value: 'delete',
                        child: ListTile(
                          leading: const Icon(Icons.delete_outline),
                          title: Text(l.deleteOrder),
                        ),
                      )
                    else
                      PopupMenuItem(
                        key: const Key('restore-order'),
                        value: 'restore',
                        child: ListTile(
                          leading: const Icon(Icons.unarchive_outlined),
                          title: Text(l.restore),
                        ),
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
                : _body(context, d),
          ),
          bottomNavigationBar: d == null ? null : _actionBar(d),
        );
      },
    );
  }

  Widget _body(BuildContext context, OrderDetail d) {
    final l = context.l10n;
    final o = d.order;
    final draft = o.state == OrderState.draft;
    final lines = _moved ?? d.lines;
    return ContentWidth(
      max: 880,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          _header(l, d, draft),
          const SizedBox(height: 12),
          SectionCard(
            title: l.items,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            trailing: o.state == OrderState.cancelled
                ? null
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_phone)
                        TextButton.icon(
                          key: const Key('scan-add'),
                          icon: const Icon(Icons.qr_code_scanner, size: 18),
                          onPressed: _busy ? null : () => _scanAdd(o),
                          label: Text(l.scan),
                        ),
                      TextButton.icon(
                        key: const Key('add-line'),
                        icon: const Icon(Icons.add, size: 18),
                        onPressed: _busy
                            ? null
                            : () async {
                                final id = await showAddLine(context, o.id);
                                if (id != null) _reload();
                              },
                        label: Text(l.addLine),
                      ),
                    ],
                  ),
            child: lines.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      l.noLinesYet,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    buildDefaultDragHandles: false,
                    itemCount: lines.length,
                    onReorderItem: (from, to) => _reorder(lines, from, to),
                    itemBuilder: (context, i) {
                      final v = lines[i];
                      final divider =
                          i > 0 &&
                          v.line.lineType != LineType.section &&
                          lines[i - 1].line.lineType != LineType.section;
                      return Column(
                        key: ValueKey(v.line.id),
                        children: [
                          if (divider) const Divider(height: 1),
                          _line(v, l, d.order, i),
                        ],
                      );
                    },
                  ),
          ),
          if (OrderPhotosCard.available) ...[
            const SizedBox(height: 12),
            OrderPhotosCard(orderId: o.id),
          ],
          const SizedBox(height: 12),
          _money(l, d),
          if (LateFeeCard.shows(d)) ...[
            const SizedBox(height: 12),
            LateFeeCard(detail: d, busy: _busy, onAct: _act),
          ],
          if (Services.of(context).billing case final billing?
              when InvoicesCard.shows(d)) ...[
            const SizedBox(height: 12),
            InvoicesCard(
              key: ValueKey('invoices-${d.order.updatedAt}'),
              billing: billing,
              detail: d,
              onChanged: _reload,
            ),
          ],
          const SizedBox(height: 12),
          _notes(l, o),
          if (draft) ...[
            const SizedBox(height: 12),
            SectionCard(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: SwitchListTile(
                key: const Key('allow-outside'),
                title: Text(l.allowLinesOutside),
                subtitle: Text(l.allowLinesOutsideHint),
                value: o.allowLineDatesOutside,
                onChanged: _busy
                    ? null
                    : (v) => _act(
                        (r) => r.updateOrder(
                          o.id,
                          OrdersCompanion(allowLineDatesOutside: Value(v)),
                        ),
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _header(AppLocalizations l, OrderDetail d, bool draft) {
    final o = d.order;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final name = d.summary.customerLabel.isEmpty
        ? l.noCustomer
        : d.summary.customerLabel;
    final days = d.lines.isEmpty
        ? null
        : d.lines.map((v) => v.days).fold<int>(0, (a, b) => a > b ? a : b);
    return SectionCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            key: const Key('order-customer'),
            onTap: draft && !_busy ? () => _changeCustomer(o) : null,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Monogram(name, size: 52),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: text.titleLarge),
                        if (o.customerPhone != null)
                          Text(
                            o.customerPhone!,
                            textDirection: TextDirection.ltr,
                            style: text.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (draft)
                    Icon(Icons.edit_outlined, color: scheme.onSurfaceVariant),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: _dateCell(l.start, o.dateStart, draft, true, o),
                ),
                Column(
                  children: [
                    Icon(
                      Directionality.of(context) == TextDirection.rtl
                          ? Icons.arrow_back
                          : Icons.arrow_forward,
                      size: 18,
                      color: scheme.onSurfaceVariant,
                    ),
                    if (days != null && days > 0)
                      Text(
                        l.daysCount(days),
                        style: text.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
                Expanded(child: _dateCell(l.end, o.dateEnd, draft, false, o)),
              ],
            ),
          ),
          if (d.summary.overdue)
            Container(
              decoration: BoxDecoration(gradient: Mono.ink(context)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Icon(Icons.schedule, size: 18, color: scheme.onPrimary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      d.summary.amounts.lateFee > 0
                          ? '${l.daysLate(d.summary.daysLate)}  ·  '
                                '${l.lateFee} ${money(d.summary.amounts.lateFee)}'
                          : l.daysLate(d.summary.daysLate),
                      style: TextStyle(
                        color: scheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _dateCell(
    String label,
    DateTime? value,
    bool editable,
    bool isStart,
    Order o,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(Mono.radiusSmall),
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
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: LabeledValue(label: label, value: when(value), end: !isStart),
      ),
    );
  }

  Widget _money(AppLocalizations l, OrderDetail d) {
    final o = d.order;
    final a = d.summary.amounts;
    final text = Theme.of(context).textTheme;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return SectionCard(
      title: l.payment,
      trailing: TextButton(
        key: const Key('edit-money'),
        onPressed: _busy ? null : () => _editMoney(o),
        child: Text(l.edit),
      ),
      child: Column(
        children: [
          AmountRow(l.linesTotal, money(a.lines)),
          if (a.discount > 0) AmountRow(l.discount, '- ${money(a.discount)}'),
          if (a.lateFee > 0) AmountRow(l.lateFee, money(a.lateFee)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1),
          ),
          Row(
            children: [
              Expanded(child: Text(l.total, style: text.titleMedium)),
              Text(money(a.charged), style: text.headlineSmall),
            ],
          ),
          const SizedBox(height: 8),
          AmountRow(l.paid, money(a.paid)),
          AmountRow(l.due, money(a.due), bold: true),
          if (o.amountDeposit > 0)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Icon(Icons.shield_outlined, size: 16, color: muted),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(l.depositHeld, style: TextStyle(color: muted)),
                  ),
                  Text(money(o.amountDeposit), style: TextStyle(color: muted)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Internal notes: never printed for the customer.
  Widget _notes(AppLocalizations l, Order o) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return SectionCard(
      title: l.internalNotes,
      trailing: TextButton(
        key: const Key('edit-notes'),
        onPressed: _busy ? null : () => _editNotes(o),
        child: Text(l.edit),
      ),
      child: Text(
        (o.note ?? '').isEmpty ? l.noNotes : o.note!,
        style: (o.note ?? '').isEmpty ? TextStyle(color: muted) : null,
      ),
    );
  }

  Future<void> _editNotes(Order o) async {
    final l = context.l10n;
    final text = await promptText(
      context,
      title: l.internalNotes,
      initial: o.note,
      multiline: true,
      fieldKey: const Key('notes-field'),
      saveKey: const Key('save-notes'),
    );
    if (text == null) return;
    final clean = text.trim();
    await _act(
      (r) => r.updateOrder(
        o.id,
        OrdersCompanion(note: Value(clean.isEmpty ? null : clean)),
      ),
    );
  }

  Widget? _actionBar(OrderDetail d) {
    final actions = _actions(d.order, d);
    if (actions.isEmpty) return null;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(top: BorderSide(color: scheme.outline)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: ContentWidth(
            max: 840,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.end,
              children: actions,
            ),
          ),
        ),
      ),
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
      IconData icon,
      VoidCallback action, {
      bool primary = true,
    }) {
      final onPressed = _busy ? null : action;
      return primary
          ? FilledButton.icon(
              key: key,
              onPressed: onPressed,
              icon: Icon(icon, size: 18),
              label: Text(label),
            )
          : OutlinedButton(key: key, onPressed: onPressed, child: Text(label));
    }

    final s = o.state;
    final unbooked = d.lines.any(
      (v) =>
          v.line.lineType != LineType.section &&
          v.line.rentalState == RentalState.none,
    );
    final out = d.lines.any((v) => v.line.rentalState == RentalState.pickedUp);
    final waiting = d.lines.any(
      (v) =>
          v.line.lineType != LineType.section &&
          v.line.rentalState == RentalState.booked,
    );
    // Secondary actions first, so the main one sits at the end.
    return [
      if (s == OrderState.draft || s == OrderState.booked)
        button(const Key('cancel-order'), l.cancelOrder, Icons.close, () async {
          if (await confirm(context, l.cancelOrderQuestion)) {
            await _act((r) => r.cancel(o.id));
          }
        }, primary: false),
      if (s == OrderState.booked)
        button(
          const Key('to-draft'),
          l.backToDraft,
          Icons.undo,
          () => _act((r) => r.resetToDraft(o.id)),
          primary: false,
        ),
      if (unbooked || s == OrderState.draft || s == OrderState.cancelled)
        button(
          const Key('book'),
          l.book,
          Icons.event_available,
          () => _act((r) => r.book(o.id)),
        ),
      if (waiting)
        button(
          const Key('pickup'),
          l.pickup,
          Icons.outbox_outlined,
          () => _open(PickupPage(orderId: o.id)),
        ),
      if (out)
        button(
          const Key('return'),
          l.returnItems,
          Icons.move_to_inbox_outlined,
          () => _open(ReturnPage(orderId: o.id)),
        ),
    ];
  }

  Widget _line(LineView v, AppLocalizations l, Order order, int index) {
    final line = v.line;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final out = line.rentalState.goneOut;
    void edit() async {
      final changed = await showEditLine(context, v, order);
      if (changed == true) _reload();
    }

    final handle = ReorderableDragStartListener(
      index: index,
      child: Tooltip(
        message: l.moveLine,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(end: 4),
          child: Icon(
            Icons.drag_indicator,
            key: Key('drag-${line.id}'),
            color: scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
    final menu = _lineMenu(v, l, edit);

    if (line.lineType == LineType.section) {
      return InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: _busy ? null : edit,
        child: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 2),
          child: Row(
            children: [
              handle,
              Text(
                line.name.toUpperCase(),
                style: text.labelSmall?.copyWith(color: scheme.onSurface),
              ),
              const SizedBox(width: 8),
              const Expanded(child: Divider(height: 1)),
              menu,
            ],
          ),
        ),
      );
    }
    final byUnit = v.asset?.tracking == Tracking.serial;
    final missing = byUnit && v.serials.length != line.quantity.round();
    final discount = line.discount > 0 ? '  -${qty(line.discount)}%' : '';
    final muted = text.bodySmall?.copyWith(color: scheme.onSurfaceVariant);
    // Full width under the line: on a phone the line's own column is narrow.
    final units = byUnit && !out
        ? Padding(
            padding: const EdgeInsetsDirectional.only(start: 80, top: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (missing)
                  StatusPill(
                    l.unitsMissing,
                    tone: PillTone.solid,
                    icon: Icons.priority_high,
                  ),
                // A framed button of its own, so a tap on it never falls
                // through to the line's editor.
                OutlinedButton.icon(
                  key: Key('units-${line.id}'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    side: BorderSide(color: scheme.onSurface),
                    foregroundColor: scheme.onSurface,
                  ),
                  icon: const Icon(Icons.qr_code_2, size: 18),
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
          )
        : null;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: _busy ? null : edit,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: const EdgeInsets.only(top: 10), child: handle),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    line.lineType == LineType.service
                        ? Icons.handyman_outlined
                        : byUnit
                        ? Icons.qr_code_2
                        : Icons.inventory_2_outlined,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(line.name, style: text.titleSmall),
                      const SizedBox(height: 2),
                      Text(
                        '${qty(line.quantity)} × ${money(line.priceDay)} × '
                        '${l.daysCount(v.days)}$discount',
                        style: muted,
                      ),
                      if (v.serials.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            for (final s in v.serials)
                              StatusPill(s.name, tone: PillTone.muted),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(money(v.subtotal), style: text.titleSmall),
                    const SizedBox(height: 6),
                    Text(l.rentalState(line.rentalState), style: muted),
                  ],
                ),
                menu,
              ],
            ),
            ?units,
          ],
        ),
      ),
    );
  }

  /// What can be done to one line, whatever state the order is in.
  Widget _lineMenu(LineView v, AppLocalizations l, VoidCallback edit) {
    final line = v.line;
    final item = line.lineType != LineType.section;
    final state = line.rentalState;
    final byUnit = v.asset?.tracking == Tracking.serial;
    PopupMenuItem<VoidCallback> entry(
      String key,
      IconData icon,
      String label,
      VoidCallback action,
    ) => PopupMenuItem(
      key: Key('$key-${line.id}'),
      value: action,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon),
        title: Text(label),
      ),
    );
    return PopupMenuButton<VoidCallback>(
      key: Key('line-menu-${line.id}'),
      enabled: !_busy,
      icon: const Icon(Icons.more_vert),
      onSelected: (action) => action(),
      itemBuilder: (_) => [
        if (item && state == RentalState.none)
          entry(
            'book-line',
            Icons.event_available,
            l.book,
            () => _act((r) => r.book(line.orderId, lineIds: [line.id])),
          ),
        if (state == RentalState.booked) ...[
          entry(
            'pickup-line',
            Icons.outbox_outlined,
            l.pickup,
            () => _open(PickupPage(orderId: line.orderId, lineIds: [line.id])),
          ),
          entry(
            'unbook-line',
            Icons.event_busy_outlined,
            l.unbook,
            () => _act((r) => r.unbookLine(line.id)),
          ),
        ],
        if (state == RentalState.pickedUp && v.qtyOutstanding > 0)
          entry(
            'return-line',
            Icons.move_to_inbox_outlined,
            l.returnItems,
            () => _open(ReturnPage(orderId: line.orderId, lineId: line.id)),
          ),
        if (byUnit && !state.goneOut)
          entry(
            'pick-units',
            Icons.qr_code_2,
            l.pickUnits,
            () => _open(UnitPickerPage(orderId: line.orderId, lineId: line.id)),
          ),
        entry('edit-line', Icons.edit_outlined, l.editLine, edit),
        if (!state.goneOut)
          entry('remove-line', Icons.delete_outline, l.removeLine, () async {
            if (await confirm(context, l.removeLineQuestion(line.name))) {
              await _act((r) => r.removeLine(line.id));
            }
          }),
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
