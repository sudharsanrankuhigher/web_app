import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:webapp/widgets/web_image_loading.dart';

class FilePreview extends StatelessWidget {
  final Uint8List? bytes;
  final String? path;
  final String? imageUrl;
  final bool isPdf;
  final bool isEdit;
  final VoidCallback? onRemove;

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
    // ✅ Detect PDF automatically
    final bool isPdfFile = isPdf ||
        (path?.toLowerCase().endsWith('.pdf') ?? false) ||
        (imageUrl?.toLowerCase().endsWith('.pdf') ?? false);

    Widget preview;

    // 🔴 PDF Preview
    if (isPdfFile) {
      preview = Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Icon(
          Icons.picture_as_pdf,
          size: 30,
          color: Colors.red,
        ),
      );
    }

    // 🖼️ Memory Image
    else if (bytes != null) {
      preview = ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.memory(
          bytes!,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      );
    }

    // 🌐 Network Image (using your WebImage)
    else if (imageUrl != null && imageUrl!.isNotEmpty) {
      preview = ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: WebImage(
          imageUrl: imageUrl!,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      );
    }

    // ⚪ Fallback
    else {
      preview = const Icon(
        Icons.insert_drive_file,
        size: 40,
        color: Colors.grey,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          preview,
          const SizedBox(width: 10),

          // 📄 File name
          if (path != null && path!.isNotEmpty)
            Expanded(
              child: Text(
                path!.split('/').last,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          // ❌ Remove button
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
