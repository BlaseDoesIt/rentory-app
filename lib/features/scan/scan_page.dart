import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../app/format.dart';
import '../../app/services.dart';
import '../../app/theme.dart';
import '../../app/widgets.dart';
import '../../data/local/database.dart';
import '../../domain/enums.dart';
import '../assets/asset_detail_page.dart';
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
    return ContentWidth(
      max: 640,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          PageHeader(title: l.scan, subtitle: l.scanSubtitle),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ScannerArt(active: _busy),
                const SizedBox(height: 16),
                TextField(
                  key: const Key('scan-field'),
                  controller: _field,
                  focusNode: _focus,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  // Codes are Latin whatever the language.
                  textDirection: TextDirection.ltr,
                  style: text.titleMedium,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.qr_code_scanner),
                    hintText: l.scanHint,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.arrow_forward),
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
                const SizedBox(height: 20),
                AnimatedSwitcher(
                  duration: Mono.medium,
                  switchInCurve: Mono.ease,
                  transitionBuilder: (child, a) => FadeTransition(
                    opacity: a,
                    child: SizeTransition(
                      sizeFactor: a,
                      alignment: Alignment.topCenter,
                      child: child,
                    ),
                  ),
                  child: _busy
                      ? const Padding(
                          key: ValueKey('busy'),
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : hit == null
                      ? const SizedBox(key: ValueKey('none'))
                      : KeyedSubtree(
                          key: ValueKey(hit),
                          child: _result(l, text, hit),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _result(AppLocalizations l, TextTheme text, _Hit hit) {
    final scheme = Theme.of(context).colorScheme;
    if (hit.asset == null) {
      return SectionCard(
        child: Row(
          children: [
            Icon(Icons.search_off, color: scheme.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(child: Text(l.notFound(hit.code))),
          ],
        ),
      );
    }
    final s = hit.serial;
    final a = hit.asset!;
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: Mono.ink(context),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  s != null ? Icons.qr_code_2 : Icons.inventory_2_outlined,
                  color: scheme.onPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a.name, style: text.titleMedium),
                    if (s != null)
                      Text(
                        s.name,
                        textDirection: TextDirection.ltr,
                        style: text.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              if (s != null)
                StatusPill(
                  l.serialState(s.state),
                  tone: s.state == SerialState.out
                      ? PillTone.solid
                      : PillTone.outline,
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Services.push<void>(
                    context,
                    AssetDetailPage(assetId: a.id),
                  ),
                  child: Text(l.viewAsset),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: hit.orderId != null
                    ? FilledButton(
                        key: const Key('scan-open-order'),
                        onPressed: () => _openOrder(hit.orderId!),
                        child: Text(l.openOrder),
                      )
                    : Center(
                        child: Text(
                          l.notOnAnyOrder,
                          textAlign: TextAlign.center,
                          style: text.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A viewfinder with a sweeping line: says "ready to scan" at a glance.
class _ScannerArt extends StatefulWidget {
  const _ScannerArt({required this.active});
  final bool active;

  @override
  State<_ScannerArt> createState() => _ScannerArtState();
}

class _ScannerArtState extends State<_ScannerArt>
    with SingleTickerProviderStateMixin {
  late final _sweep = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _sweep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: 168,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(Mono.radius),
        border: Border.all(color: scheme.outline),
      ),
      child: Center(
        child: SizedBox(
          width: 200,
          height: 112,
          child: AnimatedBuilder(
            animation: _sweep,
            builder: (context, _) => CustomPaint(
              painter: _Viewfinder(
                ink: scheme.onSurface,
                faint: scheme.outline,
                t: Curves.easeInOut.transform(_sweep.value),
                active: widget.active,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Viewfinder extends CustomPainter {
  _Viewfinder({
    required this.ink,
    required this.faint,
    required this.t,
    required this.active,
  });
  final Color ink;
  final Color faint;
  final double t;
  final bool active;

  @override
  void paint(Canvas canvas, Size size) {
    final corner = Paint()
      ..color = ink
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    const c = 18.0;
    final w = size.width, h = size.height;
    for (final (x, y, dx, dy) in [
      (0.0, 0.0, 1.0, 1.0),
      (w, 0.0, -1.0, 1.0),
      (0.0, h, 1.0, -1.0),
      (w, h, -1.0, -1.0),
    ]) {
      canvas.drawLine(Offset(x, y), Offset(x + c * dx, y), corner);
      canvas.drawLine(Offset(x, y), Offset(x, y + c * dy), corner);
    }
    // Barcode bars, faint.
    final bars = Paint()..color = faint;
    var x = 24.0;
    var i = 0;
    while (x < w - 24) {
      final bw = (i % 3 == 0) ? 4.0 : (i % 2 == 0 ? 2.0 : 1.5);
      canvas.drawRect(Rect.fromLTWH(x, 20, bw, h - 40), bars);
      x += bw + (i % 4 == 0 ? 5 : 3);
      i++;
    }
    // The sweeping line.
    final y = 12 + (h - 24) * t;
    final line = Paint()
      ..color = ink.withValues(alpha: active ? 1 : 0.85)
      ..strokeWidth = 2;
    canvas.drawLine(Offset(10, y), Offset(w - 10, y), line);
  }

  @override
  bool shouldRepaint(_Viewfinder old) =>
      old.t != t || old.ink != ink || old.active != active;
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
