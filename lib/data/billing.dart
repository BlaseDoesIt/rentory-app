/// Invoices, payments and printed reports. These live in Odoo's Accounting
/// and report engine, so only the Odoo backend has them; the screens show
/// them when `Services.billing` is set.
library;

import 'dart:typed_data';

/// One customer invoice raised from an order.
class InvoiceInfo {
  const InvoiceInfo({
    required this.id,
    required this.name,
    required this.state,
    required this.paymentState,
    required this.amountTotal,
    required this.amountResidual,
    this.date,
  });

  final int id;

  /// INV/2026/00012, or empty while a draft.
  final String name;

  /// Odoo's `state`: draft, posted or cancel.
  final String state;

  /// Odoo's `payment_state`: not_paid, partial, in_payment, paid, reversed...
  final String paymentState;
  final double amountTotal;

  /// What is still owed on it.
  final double amountResidual;
  final DateTime? date;

  bool get isDraft => state == 'draft';
  bool get isPosted => state == 'posted';
  bool get isCancelled => state == 'cancel';
  bool get canTakePayment => isPosted && amountResidual > 0.005;
}

/// A cash or bank journal a payment can be registered in.
class JournalInfo {
  const JournalInfo({required this.id, required this.name});
  final int id;
  final String name;
}

/// A document Odoo can print for an order.
class ReportInfo {
  const ReportInfo({
    required this.reportName,
    required this.title,
    this.subtitle,
  });

  /// Odoo names them "عرض سعر — Price Review": the Arabic name is the
  /// title, the English one the subtitle, and the dash goes.
  factory ReportInfo.fromOdoo(String reportName, String name) {
    final parts = name
        .split(RegExp(r'\s*[—–]\s*'))
        .where((p) => p.trim().isNotEmpty)
        .toList();
    return ReportInfo(
      reportName: reportName,
      title: parts.isEmpty ? name : parts.first.trim(),
      subtitle: parts.length > 1 ? parts.skip(1).join(' ').trim() : null,
    );
  }

  /// `rentory.report_invoice`, as Odoo names it.
  final String reportName;
  final String title;
  final String? subtitle;
}

abstract interface class BillingService {
  /// The order's invoices, newest first.
  Future<List<InvoiceInfo>> invoices(String orderId);

  /// A draft invoice for the whole order (it must be booked or later).
  Future<void> createInvoice(String orderId);

  /// For an order paid in full: invoice, post and register what was paid in
  /// the Rental Receipts journal, in one step.
  Future<void> invoiceAndPay(String orderId);

  /// Confirms a draft invoice, so payments can be registered on it.
  Future<void> postInvoice(int invoiceId);

  /// Journals a payment on [invoiceId] can go to (its company's), the
  /// Rentory receipts journal first.
  Future<List<JournalInfo>> paymentJournals(int invoiceId);

  /// Registers a payment of [amount] on a posted invoice.
  Future<void> registerPayment(
    int invoiceId, {
    required double amount,
    required int journalId,
  });

  /// The documents that can be printed for an order.
  Future<List<ReportInfo>> reports();

  /// One printed document, as PDF.
  Future<Uint8List> reportPdf(String orderId, String reportName);
}
