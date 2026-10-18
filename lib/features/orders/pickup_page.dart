import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import '../../app/format.dart';
import '../../app/services.dart';
import '../../app/ui.dart';
import '../../data/local/database.dart';
import '../../data/local/tables.dart' show rowUuid;
import '../../data/repository.dart';
import '../../domain/enums.dart';
import 'photo_strip.dart';
import 'signature_pad.dart';

/// Handing the kit over: paperwork, signature, condition photos, then every
/// booked line goes out. Only the signed rental contract is required; an
/// admin may hand over without it.
class PickupPage extends StatefulWidget {
  const PickupPage({super.key, required this.orderId});
  final String orderId;

  @override
  State<PickupPage> createState() => _PickupPageState();
}

class _PickupPageState extends State<PickupPage> {
  OrderDetail? _detail;
  Role _role = Role.office;
  List<DocumentType> _docTypes = const [];
  Set<String> _docs = {};
  bool _force = false;
  bool _busy = false;
  final _pad = SignaturePadController();
  final _signer = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_detail == null) _load();
  }

  @override
  void dispose() {
    _pad.dispose();
    _signer.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final repo = Services.of(context).repo;
    final detail = await repo.loadOrder(widget.orderId);
    final role = await repo.currentRole();
    final types = await repo.documentTypes();
    final docs = await repo.orderDocuments(widget.orderId);
    if (!mounted) return;
    setState(() {
      _detail = detail;
      _role = role;
      _docTypes = types;
      _docs = docs;
      if (_signer.text.isEmpty) {
        _signer.text =
            detail.order.signatureName ?? detail.summary.customerLabel;
      }
    });
  }

  Future<void> _set(OrdersCompanion changes) async {
    final repo = Services.of(context).repo;
    await attempt(context, () => repo.updateOrder(widget.orderId, changes));
    await _load();
  }

  Future<void> _toggleDoc(String id, bool on) async {
    final repo = Services.of(context).repo;
    final next = {..._docs};
    on ? next.add(id) : next.remove(id);
    await attempt(context, () => repo.setOrderDocuments(widget.orderId, next));
    await _load();
  }

  Future<void> _saveSignature() async {
    final l = context.l10n;
    if (_pad.isEmpty) {
      await showProblems(context, [l.signFirst]);
      return;
    }
    final services = Services.of(context);
    await attempt(context, () async {
      final png = await _pad.toPng();
      final path = await services.files.write(png, '${rowUuid.v4()}.png');
      await services.repo.addPhoto(
        localPath: path,
        orderId: widget.orderId,
        note: PhotoNote.signature,
      );
      await services.repo.updateOrder(
        widget.orderId,
        OrdersCompanion(
          signaturePath: Value(path),
          signatureName: Value(_signer.text.trim()),
          signatureDate: Value(DateTime.now().toUtc()),
        ),
      );
    });
    _pad.clear();
    await _load();
  }

  Future<void> _handOver() async {
    final repo = Services.of(context).repo;
    setState(() => _busy = true);
    final ok = await attempt(
      context,
      () => repo.pickupAll(widget.orderId, force: _force),
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final d = _detail;
    return Scaffold(
      appBar: AppBar(title: Text(l.pickup)),
      body: d == null
          ? const Center(child: CircularProgressIndicator())
          : _body(l, d),
      bottomNavigationBar: d == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.icon(
                  key: const Key('hand-over'),
                  icon: const Icon(Icons.outbox_outlined),
                  onPressed: _busy ? null : _handOver,
                  label: Text(l.handOver),
                ),
              ),
            ),
    );
  }

  Widget _body(AppLocalizations l, OrderDetail d) {
    final o = d.order;
    final text = Theme.of(context).textTheme;
    final going = [
      for (final v in d.lines)
        if (v.line.lineType != LineType.section &&
            v.line.rentalState == RentalState.booked)
          v,
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          '${o.number ?? ''}  ${d.summary.customerLabel}',
          style: text.titleMedium,
        ),
        const SizedBox(height: 8),
        for (final v in going)
          Text(
            '${qty(v.line.quantity)} × ${v.line.name}'
            '${v.serials.isEmpty ? '' : '  (${v.serials.map((s) => s.name).join(', ')})'}',
          ),
        const Divider(height: 32),
        Text(l.checklist, style: text.titleMedium),
        CheckboxListTile(
          key: const Key('check-contract'),
          contentPadding: EdgeInsets.zero,
          title: Text(l.rentalContractSigned),
          subtitle: Text(l.requiredForPickup),
          value: o.sigRentalContract,
          onChanged: (v) =>
              _set(OrdersCompanion(sigRentalContract: Value(v ?? false))),
        ),
        CheckboxListTile(
          key: const Key('check-receipt'),
          contentPadding: EdgeInsets.zero,
          title: Text(l.pickupReturnReceipt),
          value: o.sigPickupReturnReceipt,
          onChanged: (v) =>
              _set(OrdersCompanion(sigPickupReturnReceipt: Value(v ?? false))),
        ),
        CheckboxListTile(
          key: const Key('check-loan'),
          contentPadding: EdgeInsets.zero,
          title: Text(l.loanContract),
          value: o.sigLoanContract,
          onChanged: (v) =>
              _set(OrdersCompanion(sigLoanContract: Value(v ?? false))),
        ),
        CheckboxListTile(
          key: const Key('check-captured'),
          contentPadding: EdgeInsets.zero,
          title: Text(l.itemsCaptured),
          value: o.itemsCaptured,
          onChanged: (v) =>
              _set(OrdersCompanion(itemsCaptured: Value(v ?? false))),
        ),
        if (_docTypes.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(l.documentsLeft, style: text.titleSmall),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            children: [
              for (final t in _docTypes)
                FilterChip(
                  label: Text(t.name),
                  selected: _docs.contains(t.id),
                  onSelected: (on) => _toggleDoc(t.id, on),
                ),
            ],
          ),
        ],
        const Divider(height: 32),
        Text(l.signature, style: text.titleMedium),
        if (o.signaturePath != null) ...[
          const SizedBox(height: 8),
          if (File(o.signaturePath!).existsSync())
            Image.file(File(o.signaturePath!), height: 100),
          Text(
            l.signedBy(o.signatureName ?? '', when(o.signatureDate)),
            style: text.bodySmall,
          ),
        ],
        const SizedBox(height: 8),
        TextField(
          key: const Key('signer-name'),
          controller: _signer,
          decoration: InputDecoration(labelText: l.signerName),
        ),
        const SizedBox(height: 8),
        SignaturePad(key: const Key('signature-pad'), controller: _pad),
        Row(
          children: [
            TextButton(onPressed: _pad.clear, child: Text(l.clear)),
            const Spacer(),
            OutlinedButton(
              key: const Key('save-signature'),
              onPressed: _saveSignature,
              child: Text(l.saveSignature),
            ),
          ],
        ),
        const Divider(height: 32),
        Text(l.conditionPhotos, style: text.titleMedium),
        const SizedBox(height: 8),
        PhotoStrip(orderId: o.id, note: PhotoNote.pickup),
        if (_role == Role.admin && !o.sigRentalContract) ...[
          const Divider(height: 32),
          SwitchListTile(
            key: const Key('force-pickup'),
            contentPadding: EdgeInsets.zero,
            title: Text(l.forcePickup),
            subtitle: Text(l.forcePickupHint),
            value: _force,
            onChanged: (v) => setState(() => _force = v),
          ),
        ],
      ],
    );
  }
}
