import 'package:flutter/material.dart';

import '../../app/format.dart';
import '../../app/services.dart';
import '../../data/repository.dart';
import '../../domain/enums.dart';

class AssetsPage extends StatefulWidget {
  const AssetsPage({super.key});

  @override
  State<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  String _search = '';
  Stream<List<AssetSummary>>? _stream;
  String? _streamFor;

  /// One subscription per search, not one per rebuild.
  Stream<List<AssetSummary>> _assets(BuildContext context) {
    if (_stream == null || _streamFor != _search) {
      _streamFor = _search;
      _stream = Services.of(context).repo.watchAssets(search: _search);
    }
    return _stream!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            context.l10n.assets,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: context.l10n.searchAssets,
            ),
            onChanged: (v) => setState(() => _search = v),
          ),
        ),
        Expanded(
          child: StreamBuilder<List<AssetSummary>>(
            stream: _assets(context),
            builder: (context, snap) {
              final assets = snap.data;
              if (assets == null) {
                return const Center(child: CircularProgressIndicator());
              }
              if (assets.isEmpty) {
                return Center(child: Text(context.l10n.noAssets));
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: assets.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, i) => _AssetTile(assets[i]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AssetTile extends StatelessWidget {
  const _AssetTile(this.s);
  final AssetSummary s;

  @override
  Widget build(BuildContext context) {
    final a = s.asset;
    final l = context.l10n;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      title: Text(a.name),
      subtitle: Text(
        [
          if (a.code != null) a.code!,
          if (s.categoryName != null) s.categoryName!,
          '${money(a.rentalPriceDay)} ${l.perDay}',
          if (a.tracking == Tracking.serial) l.byUnit,
        ].join('  ·  '),
      ),
      trailing: Text(
        '${qty(s.available)} / ${qty(s.total)}\n${l.available}',
        textAlign: TextAlign.end,
      ),
    );
  }
}
