import 'package:flutter/material.dart';

import '../../app/format.dart';
import '../../app/photo_image.dart';
import '../../app/theme.dart';
import '../../app/services.dart';
import '../../app/ui.dart';
import '../../data/local/database.dart';
import '../../data/local/tables.dart' show rowUuid;

/// Notes the photos are filed under.
abstract final class PhotoNote {
  static const pickup = 'pickup';
  static const returned = 'return';
  static const signature = 'signature';
}

/// Condition photos of an order taken at one moment ([note]), with a button
/// to add more. Files are kept on the device and uploaded by the sync.
class PhotoStrip extends StatefulWidget {
  const PhotoStrip({super.key, required this.orderId, required this.note});
  final String orderId;
  final String note;

  @override
  State<PhotoStrip> createState() => _PhotoStripState();
}

class _PhotoStripState extends State<PhotoStrip> {
  Future<List<Photo>>? _photos;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _photos ??= _load();
  }

  Future<List<Photo>> _load() async => [
    for (final p in await Services.of(context).repo.photos(widget.orderId))
      if (p.note == widget.note) p,
  ];

  Future<void> _add() async {
    final services = Services.of(context);
    await attempt(context, () async {
      final picked = await choosePhoto(context);
      if (picked == null) return;
      final path = await services.files.keep(picked, rowUuid.v4());
      await services.repo.addPhoto(
        localPath: path,
        orderId: widget.orderId,
        note: widget.note,
      );
    });
    if (!mounted) return;
    final next = _load();
    setState(() {
      _photos = next;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FutureBuilder<List<Photo>>(
      future: _photos,
      builder: (context, snap) {
        final photos = snap.data ?? const [];
        return SizedBox(
          height: 96,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              SizedBox(
                width: 96,
                child: OutlinedButton(
                  key: Key('add-photo-${widget.note}'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: _add,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_a_photo_outlined),
                      const SizedBox(height: 4),
                      Text(l.addPhoto, textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
              for (final p in photos)
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Mono.radiusSmall),
                    child: PhotoImage(p, width: 96, height: 96),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
