import 'dart:io';

import 'package:flutter/material.dart';

import '../data/local/database.dart';
import 'format.dart';
import 'services.dart';
import 'theme.dart';

/// A photo from the photos table, wherever it lives: the file this device
/// took, or the upload, downloaded once and cached.
class PhotoImage extends StatefulWidget {
  const PhotoImage(
    this.photo, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });
  final Photo photo;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  State<PhotoImage> createState() => _PhotoImageState();
}

class _PhotoImageState extends State<PhotoImage> {
  Future<File?>? _file;
  String? _for;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolve();
  }

  @override
  void didUpdateWidget(PhotoImage old) {
    super.didUpdateWidget(old);
    _resolve();
  }

  void _resolve() {
    final p = widget.photo;
    final key = '${p.id}|${p.localPath}|${p.storagePath}';
    if (key == _for) return;
    _for = key;
    final services = Services.of(context);
    _file = services.files
        .photoFile(p, services.sync?.downloadPhoto)
        .catchError((Object _) => null);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget placeholder(IconData icon) => Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(gradient: Mono.soft(context)),
      child: Icon(icon, color: scheme.onSurfaceVariant),
    );
    return FutureBuilder<File?>(
      future: _file,
      builder: (context, snap) {
        final file = snap.data;
        if (file == null) {
          return placeholder(
            snap.connectionState == ConnectionState.done
                ? Icons.image_not_supported_outlined
                : Icons.image_outlined,
          );
        }
        return Image.file(
          file,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          // Fades in rather than popping.
          frameBuilder: (context, child, frame, sync) => sync
              ? child
              : AnimatedOpacity(
                  opacity: frame == null ? 0 : 1,
                  duration: Mono.medium,
                  child: child,
                ),
          errorBuilder: (_, _, _) =>
              placeholder(Icons.image_not_supported_outlined),
        );
      },
    );
  }
}

/// On a phone: camera or gallery? On PC straight to the file picker.
/// Returns the picked file's path, or null.
Future<String?> choosePhoto(BuildContext context) async {
  final files = Services.of(context).files;
  if (!(Platform.isAndroid || Platform.isIOS)) return files.pickPhoto();
  final l = context.l10n;
  final camera = await showModalBottomSheet<bool>(
    context: context,
    builder: (sheet) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: Text(l.takePhoto),
            onTap: () => Navigator.pop(sheet, true),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: Text(l.fromGallery),
            onTap: () => Navigator.pop(sheet, false),
          ),
        ],
      ),
    ),
  );
  if (camera == null) return null;
  return files.pickPhoto(camera: camera);
}
