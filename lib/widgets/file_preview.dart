import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:webapp/widgets/web_image_loading.dart';

class FilePreview extends StatelessWidget {
  final Uint8List? bytes; // For new upload
  final String? path; // File path
  final String? imageUrl; // For existing image
  final bool isPdf;
  final bool isEdit; // true = editing, don't show clear
  final VoidCallback? onRemove; // only needed for new upload

  const FilePreview({
    super.key,
    this.bytes,
    this.path,
    this.imageUrl,
    this.isPdf = false,
    this.isEdit = false,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    Widget preview;

    if (isPdf) {
      // PDF preview
      preview = const Icon(Icons.picture_as_pdf, size: 40, color: Colors.red);
    } else if (bytes != null) {
      // New image upload preview
      preview = ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.memory(
          bytes!,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      // Existing image from URL (WebImage)
      preview = WebImage(
        imageUrl: imageUrl!,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    } else {
      // fallback placeholder
      preview =
          const Icon(Icons.insert_drive_file, size: 40, color: Colors.grey);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          preview,
          const SizedBox(width: 10),
          if (path != null)
            Expanded(
              child: Text(
                path!.split('/').last,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          if (!isEdit && onRemove != null)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }
}
