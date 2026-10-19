import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/drift.dart' show Value, Variable;

import '../../domain/enums.dart';
import '../billing.dart';
import '../local/database.dart';
import '../local/local_repository.dart';
import '../repository.dart';
import 'odoo_client.dart';
import 'odoo_sync.dart';

/// Odoo mode. Reads come from the local copy of Odoo's data. Changes that
/// are supported go to Odoo first, and the copy is pulled again, so Odoo's
/// own rules have the last word. The rest are refused until they are built.
/// Order photos are the exception: they never leave the phone in any mode.
class OdooRepository extends LocalRepository {
  OdooRepository(super.db, this.engine, {super.clock})
    : super(
        gateway: const OdooBookingGateway(),
        currentUserId: () => engine.currentUserId,
      );

  final OdooSyncEngine engine;
  OdooClient get client => engine.client;

  static const message =
      'Connected to Odoo: this change is not sent to Odoo from the app yet. '
      'Make it in Odoo for now.';

  static Never _no() => throw RuleException.one(message);

  // ---------------------------------------------------------- writes

  @override
  Future<void> updateOrder(String orderId, OrdersCompanion changes) async {
    final vals = orderValues(changes);
    final id = await odooIdOf(db, 'orders', orderId);
    await odooCall(
      engine,
      order: id,
      () => client.call('rentory.order', 'write', {
        'ids': [id],
        'vals': vals,
      }),
    );
  }

  @override
  Future<void> setLateDays(String orderId, int? days) async {
    if (days != null && days < 0) {
      throw RuleException.one('Late days cannot be below zero.');
    }
    final id = await odooIdOf(db, 'orders', orderId);
    await odooCall(
      engine,
      order: id,
      () => client.call('rentory.order', 'write', {
        'ids': [id],
        'vals': days == null
            ? {'late_days_edited': false}
            : {
                'late_fee_manual': true,
                'late_days_override': days,
                'late_days_edited': true,
              },
      }),
    );
  }

  @override
  Future<void> setItemsExamined(String orderId, bool examined) =>
      updateOrder(orderId, OrdersCompanion(itemsExamined: Value(examined)));

  /// Odoo field values for the order fields the app edits. Anything else in
  /// [changes] is refused rather than silently dropped.
  static Map<String, Object?> orderValues(OrdersCompanion c) {
    final vals = <String, Object?>{};
    void put<T>(String field, Value<T> v, [Object? Function(T)? to]) {
      if (v.present) vals[field] = to == null ? v.value : to(v.value);
    }

    put('discount_type', c.discountType, (DiscountType t) => t.key);
    put('discount_value', c.discountValue);
    put('amount_deposit', c.amountDeposit);
    put('amount_paid', c.amountPaid);
    put('note', c.note, (String? n) => n ?? false);
    put('customer_name', c.customerName, (String? n) => n ?? false);
    put('customer_phone', c.customerPhone, (String? n) => n ?? false);
    put('date_start', c.dateStart, odooDateTime);
    put('date_end', c.dateEnd, odooDateTime);
    put('allow_line_dates_outside', c.allowLineDatesOutside);
    put('sig_rental_contract', c.sigRentalContract);
    put('sig_pickup_return_receipt', c.sigPickupReturnReceipt);
    put('sig_loan_contract', c.sigLoanContract);
    put('items_captured', c.itemsCaptured);
    put('items_examined', c.itemsExamined);
    put('late_fee_manual', c.lateFeeManual);
    put('late_days_edited', c.lateDaysEdited);
    put('late_days_override', c.lateDaysOverride);
    put('photos_url', c.photosUrl, (String? n) => n ?? false);
    put(
      'capture_method',
      c.captureMethod,
      (CaptureMethod? m) => m?.key ?? false,
    );

    const handled = {
      'discount_type', 'discount_value', 'amount_deposit', 'amount_paid',
      'note', 'customer_name', 'customer_phone', 'date_start', 'date_end',
      'allow_line_dates_outside', 'sig_rental_contract',
      'sig_pickup_return_receipt', 'sig_loan_contract', 'items_captured',
      'items_examined', 'late_fee_manual', 'late_days_edited',
      'late_days_override', 'photos_url', 'capture_method',
      // Bookkeeping the local repository adds; meaningless to Odoo.
      'updated_at', 'dirty',
    };
    final other = c.toColumns(false).keys.where((k) => !handled.contains(k));
    if (other.isNotEmpty) _no();
    if (vals.isEmpty) _no();
    return vals;
  }

  // ------------------------------------------------- not built yet

  @override
  Future<String> createOrder({
    String? customerId,
    String? customerName,
    String? customerPhone,
    required DateTime start,
    required DateTime end,
  }) async => _no();

  @override
  Future<String> addLine(
    String orderId, {
    required LineType type,
    String? assetId,
    String? name,
    double quantity = 1,
    double? priceDay,
    double discount = 0,
    List<String> serialIds = const [],
  }) async => _no();

  @override
  Future<void> removeLine(String lineId) async => _no();

  @override
  Future<void> moveLines(String orderId, List<String> lineIds) async => _no();

  @override
  Future<ScanAdd> addScanned(String orderId, String code) async => _no();

  @override
  Future<void> setLineSerials(String lineId, List<String> serialIds) async =>
      _no();

  @override
  Future<int> autofillSerials(String lineId) async => _no();

  @override
  Future<void> book(String orderId, {List<String>? lineIds}) async => _no();

  @override
  Future<void> unbookLine(String lineId) async => _no();

  @override
  Future<void> pickupAll(
    String orderId, {
    bool force = false,
    List<String>? lineIds,
  }) async => _no();

  @override
  Future<void> returnLine(
    String lineId, {
    Map<String, UnitReturn>? units,
    Condition fallback = Condition.good,
  }) async => _no();

  @override
  Future<void> returnAll(String orderId) async => _no();

  @override
  Future<void> cancel(String orderId) async => _no();

  @override
  Future<void> resetToDraft(String orderId) async => _no();

  @override
  Future<Removal> removeOrder(String orderId) async => _no();

  @override
  Future<void> restoreOrder(String orderId) async => _no();

  @override
  Future<String> createCustomer({required String name, String? phone}) async =>
      _no();

  @override
  Future<void> updateLine(
    String lineId, {
    String? name,
    double? quantity,
    double? priceDay,
    double? discount,
  }) async => _no();

  @override
  Future<void> setLineDates(
    String lineId,
    DateTime? start,
    DateTime? end,
  ) async => _no();

  @override
  Future<String> createCategory(String name) async => _no();

  @override
  Future<String> createLocation(String name) async => _no();

  @override
  Future<String> createAsset({
    required String name,
    String? code,
    String? barcode,
    String? categoryId,
    String? locationId,
    required Tracking tracking,
    double quantity = 1,
    List<String> units = const [],
    double priceDay = 0,
    double declaredValue = 0,
    String? notes,
    AssetsCompanion more = const AssetsCompanion(),
  }) async => _no();

  @override
  Future<void> updateAsset(String assetId, AssetsCompanion changes) async =>
      _no();

  @override
  Future<void> changeTracking(
    String assetId,
    Tracking tracking, {
    List<String> units = const [],
    double? quantity,
  }) async => _no();

  @override
  Future<Removal> removeAsset(String assetId) async => _no();

  @override
  Future<void> restoreAsset(String assetId) async => _no();

  @override
  Future<void> setAssetStatus(String assetId, AssetManualState? state) async =>
      _no();

  @override
  Future<void> giveBack(
    String assetId, {
    required LoanCondition condition,
    String? note,
  }) async => _no();

  @override
  Future<void> updateUnit(String serialId, SerialsCompanion changes) async =>
      _no();

  @override
  Future<void> setUnitState(String serialId, SerialState state) async => _no();

  @override
  Future<void> addUnits(String assetId, List<String> names) async => _no();

  @override
  Future<void> setOrderDocuments(
    String orderId,
    Set<String> documentTypeIds,
  ) async => _no();

  @override
  Future<void> markDocumentsReturned(String orderId) async => _no();

  @override
  Future<String> addPhoto({
    required String localPath,
    String? assetId,
    String? orderId,
    String? lineId,
    String? serialId,
    String? note,
  }) async => _no();

  @override
  Future<void> setCoverPhoto(String photoId) async => _no();

  @override
  Future<void> removePhoto(String photoId) async => _no();
}

/// Odoo's UTC "YYYY-MM-DD HH:MM:SS", or false for "empty".
Object odooDateTime(DateTime? t) => t == null
    ? false
    : t.toUtc().toIso8601String().substring(0, 19).replaceFirst('T', ' ');

/// The Odoo id behind a local row; refused for rows Odoo never had.
Future<int> odooIdOf(RentoryDatabase db, String table, String id) async {
  final row = await db
      .customSelect(
        'SELECT odoo_id FROM "$table" WHERE id = ?',
        variables: [Variable.withString(id)],
      )
      .getSingleOrNull();
  final odooId = row?.read<int?>('odoo_id');
  if (odooId == null) {
    throw RuleException.one('This record is not in Odoo yet.');
  }
  return odooId;
}

/// Runs a change in Odoo, shows Odoo's refusal like any rule's, and pulls
/// the copy again so the screen shows what Odoo made of it.
/// [order] is re-read whatever its `write_date` says.
Future<T> odooCall<T>(
  OdooSyncEngine engine,
  Future<T> Function() call, {
  int? order,
}) async {
  final T result;
  try {
    result = await call();
  } on OdooException catch (e) {
    throw RuleException.one(e.message);
  }
  await engine.syncAfterChange();
  if (order != null) await engine.refetch('rentory.order', [order]);
  return result;
}

/// Bookings go through Odoo's own `action_book` once writes exist.
class OdooBookingGateway implements BookingGateway {
  const OdooBookingGateway();

  @override
  Future<String> confirmBooking(
    String orderId,
    DateTime bookedAt, {
    List<String>? lineIds,
  }) async => throw RuleException.one(OdooRepository.message);
}

/// Invoices and payments through Odoo Accounting, reports through the
/// `rentory_app_api` add-on.
class OdooBilling implements BillingService {
  OdooBilling(this.engine);
  final OdooSyncEngine engine;
  OdooClient get _client => engine.client;

  Future<int> _order(String orderId) => odooIdOf(engine.db, 'orders', orderId);

  /// Reads that fail on rights are shown, not thrown as crashes.
  Future<T> _read<T>(Future<T> Function() read) async {
    try {
      return await read();
    } on OdooException catch (e) {
      throw RuleException.one(e.message);
    }
  }

  @override
  Future<List<InvoiceInfo>> invoices(String orderId) async {
    final id = await _order(orderId);
    return _read(() async {
      final order = await _client.read(
        'rentory.order',
        [id],
        fields: const ['invoice_ids'],
      );
      final ids = [
        for (final i in OdooMapper.many(order.firstOrNull?['invoice_ids']))
          (i as num).toInt(),
      ];
      final rows = await _client.read(
        'account.move',
        ids,
        fields: const [
          'name',
          'state',
          'payment_state',
          'amount_total',
          'amount_residual',
          'invoice_date',
        ],
      );
      final list = [
        for (final r in rows)
          InvoiceInfo(
            id: (r['id'] as num).toInt(),
            name: r['name'] is String && r['name'] != '/'
                ? r['name'] as String
                : '',
            state: r['state'] as String? ?? 'draft',
            paymentState: r['payment_state'] is String
                ? r['payment_state'] as String
                : 'not_paid',
            amountTotal: OdooMapper.number(r['amount_total']),
            amountResidual: OdooMapper.number(r['amount_residual']),
            date: switch (OdooMapper.when(r['invoice_date'])) {
              final s? => DateTime.parse(s),
              null => null,
            },
          ),
      ]..sort((a, b) => b.id.compareTo(a.id));
      return list;
    });
  }

  @override
  Future<void> createInvoice(String orderId) async {
    final id = await _order(orderId);
    await odooCall(
      engine,
      order: id,
      () => _client.call('rentory.order', 'action_create_invoice', {
        'ids': [id],
      }),
    );
  }

  @override
  Future<void> invoiceAndPay(String orderId) async {
    final id = await _order(orderId);
    await odooCall(
      engine,
      order: id,
      () => _client.call('rentory.order', 'action_invoice_and_pay', {
        'ids': [id],
      }),
    );
  }

  /// The company an invoice belongs to. Calls on it run in that company:
  /// Rentory's orders sit in their own company, which is often not the one
  /// the user has open in Odoo.
  Future<Map<String, Object?>> _companyContext(int invoiceId) async {
    final move = await _client.read(
      'account.move',
      [invoiceId],
      fields: const ['company_id'],
    );
    final company = OdooIds.odooId(move.firstOrNull?['company_id']);
    return {
      'allowed_company_ids': ?(company == null ? null : [company]),
    };
  }

  @override
  Future<void> postInvoice(int invoiceId) async {
    final context = await _read(() => _companyContext(invoiceId));
    await odooCall(
      engine,
      () => _client.call('account.move', 'action_post', {
        'ids': [invoiceId],
        'context': context,
      }),
    );
  }

  @override
  Future<List<JournalInfo>> paymentJournals(int invoiceId) => _read(() async {
    final move = await _client.read(
      'account.move',
      [invoiceId],
      fields: const ['company_id'],
    );
    final company = OdooIds.odooId(move.firstOrNull?['company_id']);
    int? preferred;
    if (company != null) {
      try {
        final c = await _client.read(
          'res.company',
          [company],
          fields: const ['rentory_receipt_journal_id'],
        );
        preferred = OdooIds.odooId(
          c.firstOrNull?['rentory_receipt_journal_id'],
        );
      } on OdooException {
        // No rights on the company: no preference.
      }
    }
    final journals = await _client.searchRead(
      'account.journal',
      domain: [
        [
          'type',
          'in',
          ['bank', 'cash'],
        ],
        if (company != null) ['company_id', '=', company],
      ],
      fields: const ['name'],
      order: 'sequence, id',
    );
    final list = [
      for (final j in journals)
        JournalInfo(
          id: (j['id'] as num).toInt(),
          name: j['name'] as String? ?? '',
        ),
    ];
    // The Rentory receipts journal first; the rest keep Odoo's order.
    list.sort(
      (a, b) => (a.id == preferred ? 0 : 1) - (b.id == preferred ? 0 : 1),
    );
    return list;
  });

  @override
  Future<void> registerPayment(
    int invoiceId, {
    required double amount,
    required int journalId,
  }) async {
    if (amount <= 0) throw RuleException.one('Enter an amount above zero.');
    final context = {
      ...await _read(() => _companyContext(invoiceId)),
      'active_model': 'account.move',
      'active_ids': [invoiceId],
    };
    await odooCall(engine, () async {
      final created = await _client.call('account.payment.register', 'create', {
        'vals_list': [
          {
            'journal_id': journalId,
            'amount': amount,
            'payment_difference_handling': 'open',
          },
        ],
        'context': context,
      });
      final ids = created is List ? created : [created];
      await _client.call('account.payment.register', 'action_create_payments', {
        'ids': ids,
        'context': context,
      });
    });
  }

  @override
  Future<List<ReportInfo>> reports() => _read(() async {
    final rows = await _client.searchRead(
      'ir.actions.report',
      domain: const [
        ['model', '=', 'rentory.order'],
        ['report_type', '=', 'qweb-pdf'],
      ],
      fields: const ['name', 'report_name'],
      order: 'id',
    );
    return [
      for (final r in rows)
        if ((r['report_name'] as String? ?? '').startsWith('rentory.'))
          ReportInfo(
            reportName: r['report_name'] as String,
            title: r['name'] as String? ?? r['report_name'] as String,
          ),
    ];
  });

  /// What the app asks the add-on for. Kept in step with
  /// `odoo_addons/rentory_app_api`.
  static const reportMethod = 'rentory_app_report_pdf';

  @override
  Future<Uint8List> reportPdf(String orderId, String reportName) async {
    final id = await _order(orderId);
    try {
      final data = await _client.call('rentory.order', reportMethod, {
        'ids': [id],
        'report_name': reportName,
      });
      if (data is! String || data.isEmpty) {
        throw RuleException.one('Odoo sent back an empty document.');
      }
      return base64Decode(data);
    } on OdooException catch (e) {
      // An Odoo without the add-on doesn't know the method.
      if (e.message.contains(reportMethod) || e.status == 404) {
        throw RuleException.one(
          'Printing from the app needs the "Rentory App API" add-on in '
          'Odoo. Ask whoever runs Odoo to install rentory_app_api.',
        );
      }
      throw RuleException.one(e.message);
    }
  }
}
