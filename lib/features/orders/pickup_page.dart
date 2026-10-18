import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import '../../app/format.dart';
import '../../app/services.dart';
import '../../app/theme.dart';
import '../../app/ui.dart';
import '../../app/widgets.dart';
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

  /// Which document the next signature signs.
  SignatureTarget _target = SignatureTarget.rentalContract;
  final _photosUrl = TextEditingController();
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
    _photosUrl.dispose();
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
        _target =
            detail.order.signatureTarget ?? SignatureTarget.rentalContract;
        _photosUrl.text = detail.order.photosUrl ?? '';
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
          signatureTarget: Value(_target),
          // Signing a document ticks it, as in Rentory.
          sigRentalContract: _target == SignatureTarget.rentalContract
              ? const Value(true)
              : const Value.absent(),
          sigPickupReturnReceipt: _target == SignatureTarget.pickupReturnReceipt
              ? const Value(true)
              : const Value.absent(),
          sigLoanContract: _target == SignatureTarget.loanContract
              ? const Value(true)
              : const Value.absent(),
        ),
      );
    });
    _pad.clear();
    await _load();
  }

  /// The photos link is kept as typed; empty clears it.
  Future<bool> _savePhotosUrl() async {
    final l = context.l10n;
    final url = _photosUrl.text.trim();
    if (url == (_detail?.order.photosUrl ?? '')) return true;
    if (url.isNotEmpty && !RegExp(r'^https?://').hasMatch(url)) {
      await showProblems(context, [l.linkMustBeHttp]);
      return false;
    }
    await _set(OrdersCompanion(photosUrl: Value(url.isEmpty ? null : url)));
    return true;
  }

  Future<void> _handOver() async {
    final repo = Services.of(context).repo;
    if (!await _savePhotosUrl()) return;
    if (!mounted) return;
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
          : BottomActionBar(
              child: FilledButton.icon(
                key: const Key('hand-over'),
                icon: const Icon(Icons.outbox_outlined),
                onPressed: _busy ? null : _handOver,
                label: Text(l.handOver),
              ),
            ),
    );
  }

  Widget _body(AppLocalizations l, OrderDetail d) {
    final o = d.order;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final going = [
      for (final v in d.lines)
        if (v.line.lineType != LineType.section &&
            v.line.rentalState == RentalState.booked)
          v,
    ];
    final checks = [
      o.sigRentalContract,
      o.sigPickupReturnReceipt,
      o.sigLoanContract,
      o.itemsCaptured,
    ];
    final done = checks.where((c) => c).length;
    Widget check(
      Key key,
      String title,
      bool value,
      OrdersCompanion Function(bool) set, {
      String? subtitle,
    }) => CheckboxListTile(
      key: key,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle),
      value: value,
      onChanged: (v) => _set(set(v ?? false)),
    );
    return ContentWidth(
      max: 760,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          SectionCard(
            title: l.goingOut,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Monogram(d.summary.customerLabel, size: 40),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d.summary.customerLabel,
                            style: text.titleMedium,
                          ),
                          Text(
                            o.number ?? '',
                            style: text.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                for (final v in going)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 36,
                          child: Text(
                            '${qty(v.line.quantity)}×',
                            style: text.titleSmall,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(v.line.name),
                              if (v.serials.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Wrap(
                                    spacing: 4,
                                    runSpacing: 4,
                                    children: [
                                      for (final s in v.serials)
                                        StatusPill(
                                          s.name,
                                          tone: PillTone.muted,
                                        ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: l.checklist,
            trailing: StatusPill(
              '$done / ${checks.length}',
              tone: done == checks.length ? PillTone.solid : PillTone.muted,
            ),
            child: Column(
              children: [
                check(
                  const Key('check-contract'),
                  l.rentalContractSigned,
                  o.sigRentalContract,
                  (v) => OrdersCompanion(sigRentalContract: Value(v)),
                  subtitle: l.requiredForPickup,
                ),
                check(
                  const Key('check-receipt'),
                  l.pickupReturnReceipt,
                  o.sigPickupReturnReceipt,
                  (v) => OrdersCompanion(sigPickupReturnReceipt: Value(v)),
                ),
                check(
                  const Key('check-loan'),
                  l.loanContract,
                  o.sigLoanContract,
                  (v) => OrdersCompanion(sigLoanContract: Value(v)),
                ),
                check(
                  const Key('check-captured'),
                  l.itemsCaptured,
                  o.itemsCaptured,
                  (v) => OrdersCompanion(itemsCaptured: Value(v)),
                ),
              ],
            ),
          ),
          if (_docTypes.isNotEmpty) ...[
            const SizedBox(height: 12),
            SectionCard(
              title: l.documentsLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final t in _docTypes)
                    MonoChip(
                      icon: _docs.contains(t.id) ? Icons.check : null,
                      label: t.name,
                      selected: _docs.contains(t.id),
                      onTap: () => _toggleDoc(t.id, !_docs.contains(t.id)),
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          SectionCard(
            title: l.signature,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (o.signaturePath != null) ...[
                  if (File(o.signaturePath!).existsSync())
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Mono.radiusSmall),
                      child: Container(
                        color: Colors.white,
                        height: 100,
                        child: Image.file(File(o.signaturePath!)),
                      ),
                    ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.verified_outlined,
                        size: 16,
                        color: scheme.onSurface,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          l.signedBy(
                            o.signatureName ?? '',
                            when(o.signatureDate),
                          ),
                          style: text.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
                MonoDropdown<SignatureTarget>(
                  key: const Key('signature-target'),
                  label: l.signs,
                  value: _target,
                  leading: const Icon(Icons.description_outlined),
                  options: [
                    for (final t in SignatureTarget.values)
                      (t, l.signatureTarget(t)),
                  ],
                  onSelected: (v) => setState(() => _target = v ?? _target),
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('signer-name'),
                  controller: _signer,
                  decoration: InputDecoration(labelText: l.signerName),
                ),
                const SizedBox(height: 12),
                SignaturePad(key: const Key('signature-pad'), controller: _pad),
                const SizedBox(height: 8),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: _pad.clear,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: Text(l.clear),
                    ),
                    const Spacer(),
                    OutlinedButton.icon(
                      key: const Key('save-signature'),
                      onPressed: _saveSignature,
                      icon: const Icon(Icons.draw_outlined, size: 18),
                      label: Text(l.saveSignature),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: l.conditionPhotos,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SegmentedButton<CaptureMethod?>(
                  key: const Key('capture-method'),
                  showSelectedIcon: false,
                  emptySelectionAllowed: true,
                  segments: [
                    for (final m in CaptureMethod.values)
                      ButtonSegment(
                        value: m,
                        icon: Icon(
                          m == CaptureMethod.phone
                              ? Icons.smartphone
                              : Icons.camera_outlined,
                        ),
                        label: Text(l.captureMethod(m)),
                      ),
                  ],
                  selected: {?o.captureMethod},
                  onSelectionChanged: (s) => _set(
                    OrdersCompanion(captureMethod: Value(s.firstOrNull)),
                  ),
                ),
                const SizedBox(height: 12),
                PhotoStrip(orderId: o.id, note: PhotoNote.pickup),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('photos-url'),
                  controller: _photosUrl,
                  keyboardType: TextInputType.url,
                  textDirection: TextDirection.ltr,
                  decoration: InputDecoration(
                    labelText: l.photosLink,
                    hintText: 'https://',
                    prefixIcon: const Icon(Icons.link),
                  ),
                  onSubmitted: (_) => _savePhotosUrl(),
                ),
              ],
            ),
          ),
          if (_role == Role.admin && !o.sigRentalContract) ...[
            const SizedBox(height: 12),
            SectionCard(
              child: SwitchListTile(
                key: const Key('force-pickup'),
                contentPadding: EdgeInsets.zero,
                secondary: const Icon(Icons.admin_panel_settings_outlined),
                title: Text(l.forcePickup),
                subtitle: Text(l.forcePickupHint),
                value: _force,
                onChanged: (v) => setState(() => _force = v),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
