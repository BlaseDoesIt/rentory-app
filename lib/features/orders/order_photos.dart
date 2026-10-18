import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/format.dart';
import '../../app/services.dart';
import '../../app/theme.dart';
import '../../app/ui.dart';
import '../../app/widgets.dart';
import '../../data/local/database.dart';
import '../../data/local/tables.dart' show rowUuid;

/// Phones only: photos of an order. Each one goes to the phone's gallery
/// (album "Rentory") and the app remembers which belong to the order. They
/// are never uploaded; only this phone has them.
class OrderPhotosCard extends StatefulWidget {
  const OrderPhotosCard({super.key, required this.orderId});
  final String orderId;

  /// Whether this device gets the card at all.
  static bool get available => Platform.isAndroid || Platform.isIOS;

  @override
  State<OrderPhotosCard> createState() => _OrderPhotosCardState();
}

class _OrderPhotosCardState extends State<OrderPhotosCard> {
  Future<List<OrderPhoto>>? _photos;
  bool _busy = false;

  static const _album = 'Rentory';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _photos ??= Services.of(context).repo.orderPhotos(widget.orderId);
  }

  void _reload() {
    final next = Services.of(context).repo.orderPhotos(widget.orderId);
    setState(() => _photos = next);
  }

  /// The app's own copy, which it shows and shares.
  Future<String> _keep(String shot) async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, 'order_photos'));
    await dir.create(recursive: true);
    final target = p.join(dir.path, '${rowUuid.v4()}.jpg');
    await File(shot).copy(target);
    return target;
  }

  /// Opens the camera again after each shot, until it is closed.
  Future<void> _take() async {
    final repo = Services.of(context).repo;
    setState(() => _busy = true);
    await attempt(context, () async {
      if (!await Gal.hasAccess(toAlbum: true) &&
          !await Gal.requestAccess(toAlbum: true)) {
        throw Exception('No access to the gallery.');
      }
      while (mounted) {
        final shot = await ImagePicker().pickImage(
          source: ImageSource.camera,
          maxWidth: 2400,
          imageQuality: 85,
        );
        if (shot == null) break;
        final path = await _keep(shot.path);
        await Gal.putImage(path, album: _album);
        await repo.addOrderPhoto(widget.orderId, path);
        if (mounted) _reload();
      }
    });
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _share(List<OrderPhoto> photos) async {
    final files = [
      for (final ph in photos)
        if (File(ph.path).existsSync()) XFile(ph.path, mimeType: 'image/jpeg'),
    ];
    if (files.isEmpty) return;
    final box = context.findRenderObject() as RenderBox?;
    await SharePlus.instance.share(
      ShareParams(
        files: files,
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      ),
    );
  }

  Future<void> _open(OrderPhoto photo) async {
    final l = context.l10n;
    final repo = Services.of(context).repo;
    final remove = await showDialog<bool>(
      context: context,
      builder: (dialog) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Positioned.fill(
              child: InteractiveViewer(
                child: File(photo.path).existsSync()
                    ? Image.file(File(photo.path))
                    : Center(
                        child: Text(
                          l.photoNotFound,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
              ),
            ),
            SafeArea(
              child: Row(
                children: [
                  IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(dialog, false),
                  ),
                  const Spacer(),
                  IconButton(
                    key: const Key('remove-order-photo'),
                    color: Colors.white,
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => Navigator.pop(dialog, true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    if (remove != true || !mounted) return;
    if (!await confirm(context, l.removeOrderPhotoQuestion)) return;
    await repo.removeOrderPhoto(photo.id);
    if (mounted) _reload();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return FutureBuilder<List<OrderPhoto>>(
      future: _photos,
      builder: (context, snap) {
        final photos = snap.data ?? const <OrderPhoto>[];
        return SectionCard(
          title: l.orderPhotos,
          trailing: photos.isEmpty
              ? null
              : TextButton.icon(
                  key: const Key('share-order-photos'),
                  icon: const Icon(Icons.share_outlined, size: 18),
                  onPressed: () => _share(photos),
                  label: Text(l.share),
                ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.orderPhotosHint, style: TextStyle(color: muted)),
              const SizedBox(height: 12),
              SizedBox(
                height: 96,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    SizedBox(
                      width: 96,
                      child: OutlinedButton(
                        key: const Key('take-order-photo'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              Mono.radiusSmall,
                            ),
                          ),
                        ),
                        onPressed: _busy ? null : _take,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.photo_camera_outlined),
                            const SizedBox(height: 4),
                            Text(l.takePhoto, textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                    for (final ph in photos.reversed)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 8),
                        child: GestureDetector(
                          onTap: () => _open(ph),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              Mono.radiusSmall,
                            ),
                            child: File(ph.path).existsSync()
                                ? Image.file(
                                    File(ph.path),
                                    width: 96,
                                    height: 96,
                                    fit: BoxFit.cover,
                                    cacheWidth: 288,
                                  )
                                : Container(
                                    width: 96,
                                    height: 96,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainer,
                                    child: const Icon(
                                      Icons.broken_image_outlined,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
