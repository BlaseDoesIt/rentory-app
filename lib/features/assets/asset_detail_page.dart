import 'package:flutter/material.dart';

import '../../app/format.dart';
import '../../app/services.dart';
import '../../app/theme.dart';
import '../../app/ui.dart';
import '../../app/widgets.dart';
import '../../data/local/database.dart';
import '../../data/repository.dart';
import '../../domain/enums.dart';
import '../orders/order_detail_page.dart';
import 'assets_page.dart';

/// One asset: what it is, how many are free, and its units.
class AssetDetailPage extends StatefulWidget {
  const AssetDetailPage({super.key, required this.assetId});
  final String assetId;

  @override
  State<AssetDetailPage> createState() => _AssetDetailPageState();
}

class _AssetDetailPageState extends State<AssetDetailPage> {
  Future<AssetDetail>? _detail;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _detail ??= Services.of(context).repo.loadAsset(widget.assetId);
  }

  void _reload() {
    final next = Services.of(context).repo.loadAsset(widget.assetId);
    setState(() {
      _detail = next;
    });
  }

  Future<void> _addUnits(Asset a) async {
    final names = await showDialog<List<String>>(
      context: context,
      builder: (_) => const _AddUnitsDialog(),
    );
    if (names == null || names.isEmpty || !mounted) return;
    final repo = Services.of(context).repo;
    final ok = await attempt(context, () => repo.addUnits(a.id, names));
    if (ok) _reload();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FutureBuilder<AssetDetail>(
      future: _detail,
      builder: (context, snap) {
        final d = snap.data;
        return Scaffold(
          appBar: AppBar(title: Text(d?.asset.name ?? l.asset)),
          body: AnimatedSwitcher(
            duration: Mono.medium,
            child: d == null
                ? Center(
                    child: snap.hasError
                        ? Text('${snap.error}')
                        : const CircularProgressIndicator(),
                  )
                : _body(l, d),
          ),
        );
      },
    );
  }

  Widget _body(AppLocalizations l, AssetDetail d) {
    final a = d.asset;
    final s = d.summary;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final byUnit = a.tracking == Tracking.serial;
    final details = [?a.code, ?s.categoryName, ?d.locationName].join('  ·  ');
    return ContentWidth(
      max: 880,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: scheme.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        byUnit ? Icons.qr_code_2 : Icons.inventory_2_outlined,
                        color: scheme.onPrimary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a.name, style: text.titleLarge),
                          if (details.isNotEmpty)
                            Text(
                              details,
                              style: text.bodyMedium?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: LabeledValue(
                        label: l.availableNow,
                        value: qty(s.available),
                      ),
                    ),
                    Expanded(
                      child: LabeledValue(label: l.statOut, value: qty(s.out)),
                    ),
                    Expanded(
                      child: LabeledValue(
                        label: l.totalStock,
                        value: qty(s.total),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                AvailabilityBar(s),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SectionCard(
            title: l.pricing,
            child: Column(
              children: [
                AmountRow(l.pricePerDay, money(a.rentalPriceDay), bold: true),
                AmountRow(l.declaredValue, money(a.declaredValue)),
                if (a.barcode != null && a.barcode != a.code)
                  AmountRow(l.barcode, a.barcode!),
              ],
            ),
          ),
          if (a.notes != null) ...[
            const SizedBox(height: 12),
            SectionCard(title: l.notes, child: Text(a.notes!)),
          ],
          if (byUnit) ...[
            const SizedBox(height: 12),
            SectionCard(
              title: l.unitsCount(d.serials.length),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              trailing: TextButton.icon(
                key: const Key('add-units'),
                icon: const Icon(Icons.add, size: 18),
                onPressed: () => _addUnits(a),
                label: Text(l.addUnits),
              ),
              child: Column(
                children: [
                  for (final (i, u) in d.serials.indexed) ...[
                    if (i > 0) const Divider(height: 1),
                    _unit(l, u),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _unit(AppLocalizations l, Serial u) {
    final tone = switch (u.state) {
      SerialState.out || SerialState.mandatoryOut => PillTone.solid,
      SerialState.reserved => PillTone.outline,
      _ => PillTone.muted,
    };
    final order = u.currentOrderId;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.qr_code_2),
      title: Text(u.name, textDirection: TextDirection.ltr),
      trailing: StatusPill(l.serialState(u.state), tone: tone),
      onTap: order == null
          ? null
          : () => Services.push<void>(context, OrderDetailPage(orderId: order)),
    );
  }
}

class _AddUnitsDialog extends StatefulWidget {
  const _AddUnitsDialog();

  @override
  State<_AddUnitsDialog> createState() => _AddUnitsDialogState();
}

class _AddUnitsDialogState extends State<_AddUnitsDialog> {
  final _names = TextEditingController();

  @override
  void dispose() {
    _names.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(l.addUnits),
      content: SizedBox(
        width: 360,
        child: TextField(
          key: const Key('units-input'),
          controller: _names,
          autofocus: true,
          minLines: 3,
          maxLines: 8,
          textDirection: TextDirection.ltr,
          decoration: InputDecoration(hintText: l.unitsOnePerLine),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        FilledButton(
          key: const Key('save-units-dialog'),
          onPressed: () => Navigator.pop(
            context,
            _names.text.split(RegExp(r'[\n,]')).toList(),
          ),
          child: Text(l.add),
        ),
      ],
    );
  }
}
