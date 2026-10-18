import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Finger or mouse signature. [SignaturePadController.toPng] gives the
/// picture, black on white.
class SignaturePadController extends ChangeNotifier {
  final List<List<Offset>> _strokes = [];
  Size _size = const Size(400, 160);

  bool get isEmpty => _strokes.every((s) => s.isEmpty);

  void clear() {
    _strokes.clear();
    notifyListeners();
  }

  void _start(Offset p) {
    _strokes.add([p]);
    notifyListeners();
  }

  void _extend(Offset p) {
    if (_strokes.isEmpty) _strokes.add([]);
    _strokes.last.add(p);
    notifyListeners();
  }

  Future<Uint8List> toPng() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawRect(Offset.zero & _size, Paint()..color = Colors.white);
    _paint(canvas, _strokes, Colors.black);
    final image = await recorder.endRecording().toImage(
      _size.width.ceil(),
      _size.height.ceil(),
    );
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }
}

void _paint(Canvas canvas, List<List<Offset>> strokes, Color color) {
  final pen = Paint()
    ..color = color
    ..strokeWidth = 2.5
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..style = PaintingStyle.stroke;
  for (final s in strokes) {
    if (s.length == 1) {
      canvas.drawCircle(s.first, 1.5, pen..style = PaintingStyle.fill);
      pen.style = PaintingStyle.stroke;
      continue;
    }
    final path = Path()..moveTo(s.first.dx, s.first.dy);
    for (final p in s.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path, pen);
  }
}

class SignaturePad extends StatelessWidget {
  const SignaturePad({super.key, required this.controller, this.height = 160});
  final SignaturePadController controller;
  final double height;

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).colorScheme.onSurface;
    return Container(
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: ink),
        borderRadius: BorderRadius.circular(4),
      ),
      // Signatures are drawn left to right whatever the language.
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: LayoutBuilder(
          builder: (context, box) {
            controller._size = Size(box.maxWidth, box.maxHeight);
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanStart: (d) => controller._start(d.localPosition),
              onPanUpdate: (d) => controller._extend(d.localPosition),
              child: ClipRect(
                child: CustomPaint(
                  size: Size(box.maxWidth, box.maxHeight),
                  painter: _Painter(controller, ink),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Painter extends CustomPainter {
  _Painter(this.c, this.ink) : super(repaint: c);
  final SignaturePadController c;
  final Color ink;

  @override
  void paint(Canvas canvas, Size size) => _paint(canvas, c._strokes, ink);

  @override
  bool shouldRepaint(_Painter old) => true;
}
