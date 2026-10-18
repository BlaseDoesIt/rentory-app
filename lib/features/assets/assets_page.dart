import 'package:flutter/material.dart';

import '../../app/format.dart';
import '../../app/services.dart';
import '../../app/theme.dart';
import '../../app/widgets.dart';
import '../../data/repository.dart';
import '../../data/local/database.dart';
import '../../domain/enums.dart';
import '../../domain/rules/rented_in.dart';
import 'asset_detail_page.dart';
import 'asset_form_page.dart';

class AssetsPage extends StatefulWidget {
  const AssetsPage({super.key});

  @override
  State<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  String _search = '';
  String? _category;
  Stream<List<AssetSummary>>? _stream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // One subscription; search and category filter here, as you type.
    _stream ??= Services.of(context).repo.watchAssets();
  }

  bool _matches(AssetSummary s) {
    if (_category != null && s.categoryName != _category) return false;
    final q = _search.trim().toLowerCase();
    if (q.isEmpty) return true;
    final a = s.asset;
    return [
      a.name,
      a.code ?? '',
      a.barcode ?? '',
    ].any((x) => x.toLowerCase().contains(q));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('new-asset'),
        icon: const Icon(Icons.add),
        label: Text(l.newAsset),
        onPressed: () => Services.push<void>(context, const NewAssetPage()),
      ),
      body: StreamBuilder<List<AssetSummary>>(
        stream: _stream,
        builder: (context, snap) {
          final all = snap.data;
          if (all == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final shown = all.where(_matches).toList();
          final categories = {
            for (final s in all)
              if (s.categoryName != null) s.categoryName!,
          }.toList()..sort();
          final out = all.fold<double>(0, (a, s) => a + s.out);
          return ContentWidth(
            max: 1200,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: PageHeader(
                    title: l.assets,
                    subtitle: l.assetsSummary(all.length, out.round()),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                    child: TextField(
                      key: const Key('asset-search'),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: l.searchAssets,
                      ),
                      onChanged: (v) => setState(() => _search = v),
                    ),
                  ),
                ),
                if (categories.isNotEmpty)
                  SliverToBoxAdapter(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                      child: Row(
                        children: [
                          _chip(l.all, null),
                          for (final c in categories) _chip(c, c),
                        ],
                      ),
                    ),
                  ),
                if (shown.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyState(
                      icon: Icons.inventory_2_outlined,
                      title: all.isEmpty ? l.noAssets : l.nothingFound,
                      message: all.isEmpty ? l.noAssetsHint : null,
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 96),
                    sliver: SliverGrid.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 380,
                            mainAxisExtent: 168,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                          ),
                      itemCount: shown.length,
                      itemBuilder: (context, i) => FadeSlideIn(
                        key: ValueKey(shown[i].asset.id),
                        index: i,
                        child: AssetCard(
                          shown[i],
                          onTap: () => Services.push<void>(
                            context,
                            AssetDetailPage(assetId: shown[i].asset.id),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _chip(String label, String? category) => Padding(
    padding: const EdgeInsetsDirectional.only(end: 8),
    child: ChoiceChip(
      label: Text(label),
      selected: _category == category,
      onSelected: (_) => setState(() => _category = category),
    ),
  );
}

/// Availability as a thin bar plus "2 / 3 available".
class AvailabilityBar extends StatelessWidget {
  const AvailabilityBar(this.s, {super.key});
  final AssetSummary s;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final share = s.total <= 0 ? 0.0 : (s.available / s.total).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: share),
            duration: Mono.medium,
            curve: Mono.ease,
            builder: (context, v, _) =>
                LinearProgressIndicator(value: v, minHeight: 6),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l.availableOf(qty(s.available), qty(s.total)),
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class AssetCard extends StatelessWidget {
  const AssetCard(this.s, {super.key, required this.onTap});
  final AssetSummary s;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final a = s.asset;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final byUnit = a.tracking == Tracking.serial;
    final details = [?a.code, ?s.categoryName].join('  ·  ');
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: Mono.soft(context),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      byUnit ? Icons.qr_code_2 : Icons.inventory_2_outlined,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: text.titleSmall,
                        ),
                        if (details.isNotEmpty)
                          Text(
                            details,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Text(money(a.rentalPriceDay), style: text.titleMedium),
                  const SizedBox(width: 4),
                  Text(
                    l.perDay,
                    style: text.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  _pill(context, l, a, byUnit),
                ],
              ),
              const SizedBox(height: 10),
              AvailabilityBar(s),
            ],
          ),
        ),
      ),
    );
  }

  /// The one thing worth knowing at a glance: parked, on loan, or by unit.
  Widget _pill(BuildContext context, AppLocalizations l, Asset a, bool byUnit) {
    if (a.stateManual != null) {
      return StatusPill(
        l.manualState(a.stateManual!),
        tone: PillTone.solid,
        icon: Icons.build_outlined,
      );
    }
    if (a.ownership == Ownership.rentedIn) {
      final status = rentedInStatus(
        heldFrom: a.rentedInDateStart,
        dueBack: a.rentedInDateEnd,
        givenBackAt: a.rentedInReturnedAt,
        now: DateTime.now().toUtc(),
      );
      return StatusPill(
        status == RentedInStatus.inHouse
            ? l.rentedIn
            : l.rentedInStatus(status),
        tone: status == RentedInStatus.overdue
            ? PillTone.solid
            : PillTone.outline,
        icon: Icons.handshake_outlined,
      );
    }
    if (byUnit) return StatusPill(l.byUnit, tone: PillTone.muted);
    return const SizedBox.shrink();
  }
}
