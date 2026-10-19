import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/format.dart';
import '../../app/services.dart';
import '../../app/ui.dart';
import '../../app/widgets.dart';
import '../../data/billing.dart';
import '../../data/local/database.dart';
import '../../data/repository.dart';
import '../../domain/enums.dart';

/// Late days and what they cost. The counter can charge a different number
/// of days (0 waives the fee) and go back to the counted ones, as in Odoo.
class LateFeeCard extends StatelessWidget {
  const LateFeeCard({
    super.key,
    required this.detail,
    required this.busy,
    required this.onAct,
  });

  final OrderDetail detail;
  final bool busy;
  final Future<void> Function(Future<void> Function(RentoryRepository)) onAct;

  /// Worth a card once anything ran late, or somebody set the days.
  static bool shows(OrderDetail d) =>
      d.lateDaysCounted > 0 || d.order.lateDaysEdited;

  Future<void> _change(BuildContext context) async {
    final l = context.l10n;
    final text = await promptText(
      context,
      title: l.changeLateDays,
      label: '${l.lateDaysCharged} (${l.lateDaysHint})',
      initial: '${detail.lateDaysCharged}',
      fieldKey: const Key('late-days-field'),
      saveKey: const Key('late-days-save'),
    );
    if (text == null || !context.mounted) return;
    final days = int.tryParse(latinDigits(text.trim()));
    if (days == null || days < 0) {
      await showProblems(context, [l.checkNumbers]);
      return;
    }
    await onAct((r) => r.setLateDays(detail.order.id, days));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final o = detail.order;
    final a = detail.summary.amounts;
    final edited = o.lateFeeManual && o.lateDaysEdited;
    return SectionCard(
      key: const Key('late-fee-card'),
      title: l.lateFee,
      trailing: o.state == OrderState.cancelled
          ? null
          : TextButton(
              key: const Key('change-late-days'),
              onPressed: busy ? null : () => _change(context),
              child: Text(l.edit),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AmountRow(l.lateDaysCounted, '${detail.lateDaysCounted}'),
          Row(
            children: [
              Expanded(child: Text(l.lateDaysCharged)),
              if (edited) ...[
                StatusPill(l.setByHand, tone: PillTone.muted),
                const SizedBox(width: 8),
              ],
              Text('${detail.lateDaysCharged}'),
            ],
          ),
          if (detail.lateDailyRate > 0)
            AmountRow(l.nextLateDay, money(detail.lateDailyRate)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1),
          ),
          AmountRow(l.lateFee, money(a.lateFee), bold: true),
          if (edited)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                key: const Key('use-counted-days'),
                onPressed: busy
                    ? null
                    : () => onAct((r) => r.setLateDays(o.id, null)),
                child: Text(l.useCountedDays),
              ),
            ),
        ],
      ),
    );
  }
}

/// The order's invoices in Odoo, with what can be done to them: create one,
/// invoice and pay in one go, post a draft, register a payment.
class InvoicesCard extends StatefulWidget {
  const InvoicesCard({
    super.key,
    required this.billing,
    required this.detail,
    required this.onChanged,
  });

  final BillingService billing;
  final OrderDetail detail;

  /// Something changed in Odoo: reload the order.
  final VoidCallback onChanged;

  /// Odoo invoices booked orders and later, never drafts or cancelled ones.
  static bool shows(OrderDetail d) =>
      d.order.state != OrderState.draft &&
      d.order.state != OrderState.cancelled;

  @override
  State<InvoicesCard> createState() => _InvoicesCardState();
}

class _InvoicesCardState extends State<InvoicesCard> {
  late Future<List<InvoiceInfo>> _invoices = _load();
  bool _busy = false;

  Future<List<InvoiceInfo>> _load() =>
      widget.billing.invoices(widget.detail.order.id);

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    final ok = await attempt(context, action);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _invoices = _load();
    });
    if (ok) widget.onChanged();
  }

  Future<void> _create() async {
    final l = context.l10n;
    final a = widget.detail.summary.amounts;
    if (!await confirm(context, l.createInvoiceQuestion(money(a.charged)))) {
      return;
    }
    await _run(() => widget.billing.createInvoice(widget.detail.order.id));
  }

  Future<void> _invoiceAndPay() async {
    final l = context.l10n;
    final a = widget.detail.summary.amounts;
    if (!await confirm(context, l.invoiceAndPayQuestion(money(a.paid)))) {
      return;
    }
    await _run(() => widget.billing.invoiceAndPay(widget.detail.order.id));
  }

  Future<void> _post(InvoiceInfo invoice) async {
    final l = context.l10n;
    if (!await confirm(context, l.postInvoiceQuestion(invoice.name))) return;
    await _run(() => widget.billing.postInvoice(invoice.id));
  }

  Future<void> _pay(InvoiceInfo invoice) async {
    final l = context.l10n;
    final services = Services.of(context);
    List<JournalInfo> journals = const [];
    if (!await attempt(context, () async {
      journals = await widget.billing.paymentJournals(invoice.id);
    })) {
      return;
    }
    if (!mounted) return;
    if (journals.isEmpty) {
      await showProblems(context, [l.noJournals]);
      return;
    }
    final payment = await showDialog<_Payment>(
      context: context,
      builder: (_) => _PaymentDialog(invoice: invoice, journals: journals),
    );
    if (payment == null || !mounted) return;
    final order = widget.detail.order;
    await _run(() async {
      await widget.billing.registerPayment(
        invoice.id,
        amount: payment.amount,
        journalId: payment.journalId,
      );
      if (payment.addToOrder) {
        await services.repo.updateOrder(
          order.id,
          OrdersCompanion(amountPaid: Value(order.amountPaid + payment.amount)),
        );
      }
    });
  }

  String _status(AppLocalizations l, InvoiceInfo i) {
    if (i.isDraft) return l.invoiceDraft;
    if (i.isCancelled) return l.invoiceCancelled;
    return switch (i.paymentState) {
      'paid' => l.invoicePaid,
      'partial' => l.invoicePartial,
      'in_payment' => l.invoiceInPayment,
      _ => l.invoiceNotPaid,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final paidInFull =
        widget.detail.summary.amounts.paymentState == PaymentState.paid;
    return SectionCard(
      key: const Key('invoices-card'),
      title: l.invoices,
      child: FutureBuilder<List<InvoiceInfo>>(
        future: _invoices,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Padding(
              padding: EdgeInsets.all(12),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (snap.hasError) {
            final e = snap.error;
            return Text(
              e is RuleException ? e.problems.join('\n') : '$e',
              style: TextStyle(color: muted),
            );
          }
          final invoices = snap.data!;
          final live = invoices.where((i) => !i.isCancelled);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (invoices.isEmpty)
                Text(l.noInvoices, style: TextStyle(color: muted)),
              for (final i in invoices)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              i.name.isEmpty ? l.invoiceDraft : i.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          StatusPill(
                            _status(l, i),
                            tone: i.paymentState == 'paid'
                                ? PillTone.muted
                                : PillTone.outline,
                          ),
                        ],
                      ),
                      AmountRow(l.total, money(i.amountTotal)),
                      if (i.isPosted) AmountRow(l.due, money(i.amountResidual)),
                      Wrap(
                        spacing: 8,
                        children: [
                          if (i.isDraft)
                            OutlinedButton(
                              key: Key('post-invoice-${i.id}'),
                              onPressed: _busy ? null : () => _post(i),
                              child: Text(l.postInvoice),
                            ),
                          if (i.canTakePayment)
                            OutlinedButton(
                              key: Key('pay-invoice-${i.id}'),
                              onPressed: _busy ? null : () => _pay(i),
                              child: Text(l.registerPayment),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              if (live.isEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.icon(
                      key: const Key('create-invoice'),
                      icon: const Icon(Icons.receipt_outlined, size: 18),
                      onPressed: _busy ? null : _create,
                      label: Text(l.createInvoice),
                    ),
                    if (paidInFull)
                      OutlinedButton.icon(
                        key: const Key('invoice-and-pay'),
                        icon: const Icon(Icons.price_check, size: 18),
                        onPressed: _busy ? null : _invoiceAndPay,
                        label: Text(l.invoiceAndPay),
                      ),
                  ],
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _Payment {
  const _Payment(this.amount, this.journalId, this.addToOrder);
  final double amount;
  final int journalId;
  final bool addToOrder;
}

class _PaymentDialog extends StatefulWidget {
  const _PaymentDialog({required this.invoice, required this.journals});
  final InvoiceInfo invoice;
  final List<JournalInfo> journals;

  @override
  State<_PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<_PaymentDialog> {
  late final _amount = TextEditingController(
    text: qty(widget.invoice.amountResidual),
  );
  late int _journal = widget.journals.first.id;
  bool _addToOrder = true;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l = context.l10n;
    final amount = parseNumber(_amount.text);
    if (amount == null || amount <= 0) {
      await showProblems(context, [l.checkNumbers]);
      return;
    }
    if (!mounted) return;
    Navigator.pop(context, _Payment(amount, _journal, _addToOrder));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(l.registerPayment),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: const Key('payment-amount'),
              controller: _amount,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(labelText: l.amount),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              key: const Key('payment-journal'),
              initialValue: _journal,
              decoration: InputDecoration(labelText: l.journal),
              items: [
                for (final j in widget.journals)
                  DropdownMenuItem(value: j.id, child: Text(j.name)),
              ],
              onChanged: (v) => setState(() => _journal = v ?? _journal),
            ),
            CheckboxListTile(
              key: const Key('payment-add-to-order'),
              contentPadding: EdgeInsets.zero,
              value: _addToOrder,
              onChanged: (v) => setState(() => _addToOrder = v ?? true),
              title: Text(l.addToOrderPaid),
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
          key: const Key('payment-save'),
          onPressed: _save,
          child: Text(l.registerPayment),
        ),
      ],
    );
  }
}

/// Picks one of Odoo's documents for the order, fetches the PDF, saves it
/// (Downloads on a PC) and opens it, or shares it on a phone.
Future<void> printOrder(
  BuildContext context,
  BillingService billing,
  OrderDetail detail,
) async {
  final l = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  List<ReportInfo> reports = const [];
  if (!await attempt(context, () async {
    reports = await billing.reports();
  })) {
    return;
  }
  if (!context.mounted || reports.isEmpty) return;
  final report = await showModalBottomSheet<ReportInfo>(
    context: context,
    showDragHandle: true,
    builder: (sheet) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          for (final r in reports)
            ListTile(
              key: Key('report-${r.reportName}'),
              leading: const Icon(Icons.picture_as_pdf_outlined),
              title: Text(r.title),
              subtitle: r.subtitle == null ? null : Text(r.subtitle!),
              onTap: () => Navigator.pop(sheet, r),
            ),
        ],
      ),
    ),
  );
  if (report == null || !context.mounted) return;
  final phone = Platform.isAndroid || Platform.isIOS;
  File? file;
  // Only the fetch from Odoo shows the turning circle; the share sheet and
  // the PDF viewer are the user's own time.
  await attempt(context, () async {
    final bytes = await billing.reportPdf(detail.order.id, report.reportName);
    final dir = phone
        ? await getTemporaryDirectory()
        : (await getDownloadsDirectory() ??
              await getApplicationDocumentsDirectory());
    final title = report.subtitle ?? report.title;
    final name = '${detail.order.number ?? 'order'} $title'.replaceAll(
      RegExp(r'[\/:*?"<>|]'),
      '-',
    );
    file = File(p.join(dir.path, '$name.pdf'));
    await file!.writeAsBytes(bytes, flush: true);
  });
  final saved = file;
  if (saved == null || !await saved.exists()) return;
  if (phone) {
    await SharePlus.instance.share(
      ShareParams(files: [XFile(saved.path, mimeType: 'application/pdf')]),
    );
    return;
  }
  messenger.showSnackBar(SnackBar(content: Text(l.savedTo(saved.path))));
  if (Platform.isWindows) {
    await Process.start('explorer', [saved.path]);
  } else if (Platform.isMacOS) {
    await Process.start('open', [saved.path]);
  } else if (Platform.isLinux) {
    await Process.start('xdg-open', [saved.path]);
  }
}
