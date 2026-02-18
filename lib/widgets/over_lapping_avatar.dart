import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/widgets/web_image_loading.dart';

class OverlappingAvatars extends StatelessWidget {
  final List<String> imageUrls;
  final int maxVisible;
  final double size;

  const OverlappingAvatars({
    super.key,
    required this.imageUrls,
    this.maxVisible = 2,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    final visibleImages = imageUrls.take(maxVisible).toList();
    final remainingCount = imageUrls.length - visibleImages.length;

    return SizedBox(
      height: size,
      width: size + (visibleImages.length * (size * 0.6)),
      child: Stack(
        children: [
          for (int i = 0; i < visibleImages.length; i++)
            Positioned(
              left: i * (size * 0.6),
              child: Container(
                width: size,
                height: size,
                padding: const EdgeInsets.all(0.8), // border thickness
                decoration: BoxDecoration(
                  color: Colors.black, // 👈 border color (change as needed)
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(size / 2),
                  child: WebImage(
                    fit: BoxFit.cover,
                    imageUrl: visibleImages[i],
                    width: size - 4,
                    height: size - 4,
                  ),
                ),
              ),
            ),
          if (remainingCount > 0)
            Positioned(
              left: visibleImages.length * (size * 0.6),
              child: CircleAvatar(
                radius: size / 2,
                backgroundColor: Colors.black87,
                child: Text('+$remainingCount',
                    style: fontFamilySemiBold.size10.white),
              ),
            ),
        ],
      ),
    );
  }
}
