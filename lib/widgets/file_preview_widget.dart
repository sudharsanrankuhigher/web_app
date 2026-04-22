import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/widgets/pdf_view.dart';
import 'package:webapp/widgets/web_image_loading.dart';

class FullPreviewWidget extends StatelessWidget {
  final String url;

  const FullPreviewWidget({
    super.key,
    required this.url,
  });

  bool get isPdf => url.toLowerCase().endsWith(".pdf");

  bool get isImage {
    final u = url.toLowerCase();
    return u.endsWith(".png") ||
        u.endsWith(".jpg") ||
        u.endsWith(".jpeg") ||
        u.endsWith(".webp");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 400,
          height: 450,
          color: Colors.white,
          child: Stack(
            children: [
              Padding(
                padding: topPadding40,
                child: _buildPreview(),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreview() {
    /// ✅ PDF VIEW (REAL RENDER)
    if (isPdf) {
      return PdfWebView(
        url: url,
      );
    }

    /// ✅ IMAGE VIEW
    if (isImage) {
      return WebImage(
        imageUrl: url,
        fit: BoxFit.contain,
      );
      // Image.network(
      //   url,
      //   fit: BoxFit.contain,
      //   errorBuilder: (_, __, ___) => const Icon(
      //     Icons.broken_image,
      //     color: Colors.white,
      //   ),
      // );
    }

    /// ❌ OTHER FILE
    return const Center(
      child: Icon(Icons.insert_drive_file, color: Colors.grey),
    );
  }
}
