import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../app/format.dart';
import '../../app/services.dart';
import '../../data/local/database.dart';
import '../orders/order_detail_page.dart';

/// Scan a unit to open the order it is on. A USB scanner on PC types the code
/// and presses Enter into the field; phones also get the camera.
class ScanPage extends StatefulWidget {
  const ScanPage({super.key, this.camera});

  /// Whether to offer the camera. Defaults to phones only.
  final bool? camera;

  @override
  State<ScanPage> createState() => _ScanPageState();
}

typedef _Hit = ({String code, Asset? asset, Serial? serial, String? orderId});

class _ScanPageState extends State<ScanPage> {
  final _field = TextEditingController();
  final _focus = FocusNode();
  _Hit? _last;
  bool _busy = false;

  bool get _camera => widget.camera ?? (Platform.isAndroid || Platform.isIOS);

  @override
  void dispose() {
    _field.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _lookUp(String raw) async {
    final code = raw.trim();
    if (code.isEmpty || _busy) return;
    final repo = Services.of(context).repo;
    setState(() => _busy = true);
    final found = await repo.findByCode(code);
    final orderId = found.asset == null
        ? null
        : await repo.currentOrderFor(
            serialId: found.serial?.id,
            assetId: found.serial == null ? found.asset!.id : null,
          );
    if (!mounted) return;
    setState(() {
      _busy = false;
      _last = (
        code: code,
        asset: found.asset,
        serial: found.serial,
        orderId: orderId,
      );
      _field.clear();
    });
    if (orderId != null) await _openOrder(orderId);
    if (mounted) _focus.requestFocus();
  }

  Future<void> _openOrder(String id) =>
      Services.push<void>(context, OrderDetailPage(orderId: id));

  Future<void> _openCamera() async {
    final code = await Navigator.of(
      context,
    ).push<String>(MaterialPageRoute(builder: (_) => const _CameraScanPage()));
    if (code != null) await _lookUp(code);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final text = Theme.of(context).textTheme;
    final hit = _last;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l.scan, style: text.headlineSmall),
        const SizedBox(height: 16),
        TextField(
          key: const Key('scan-field'),
          controller: _field,
          focusNode: _focus,
          autofocus: true,
          textInputAction: TextInputAction.search,
          // Codes are Latin whatever the language.
          textDirection: TextDirection.ltr,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.qr_code_scanner),
            hintText: l.scanHint,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _lookUp(_field.text),
            ),
          ),
          onSubmitted: _lookUp,
        ),
        if (_camera) ...[
          const SizedBox(height: 12),
          FilledButton.icon(
            key: const Key('scan-camera'),
            icon: const Icon(Icons.photo_camera_outlined),
            onPressed: _openCamera,
            label: Text(l.scanWithCamera),
          ),
        ],
        const SizedBox(height: 24),
        if (_busy) const Center(child: CircularProgressIndicator()),
        if (hit != null && !_busy) _result(l, text, hit),
      ],
    );
  }

  Widget _result(AppLocalizations l, TextTheme text, _Hit hit) {
    if (hit.asset == null) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.help_outline),
        title: Text(l.notFound(hit.code)),
      );
    }
    final s = hit.serial;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(hit.asset!.name, style: text.titleMedium),
            if (s != null) Text(s.name, textDirection: TextDirection.ltr),
            if (s != null) Text(l.serialState(s.state)),
            const SizedBox(height: 12),
            if (hit.orderId != null)
              FilledButton(
                key: const Key('scan-open-order'),
                onPressed: () => _openOrder(hit.orderId!),
                child: Text(l.openOrder),
              )
            else
              Text(l.notOnAnyOrder),
          ],
        ),
      ),
    );
  }
}

class _CameraScanPage extends StatefulWidget {
  const _CameraScanPage();

  @override
  State<_CameraScanPage> createState() => _CameraScanPageState();
}

class _CameraScanPageState extends State<_CameraScanPage> {
  bool _done = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.scanWithCamera)),
      body: MobileScanner(
        onDetect: (capture) {
          if (_done) return;
          final code = capture.barcodes
              .map((b) => b.rawValue)
              .whereType<String>()
              .firstOrNull;
          if (code == null) return;
          _done = true;
          Navigator.pop(context, code);
        },
      ),
    );
  }
}
