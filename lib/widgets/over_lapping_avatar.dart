import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';

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
              child: CircleAvatar(
                radius: size / 2,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: (size / 2) - 2,
                  backgroundImage: NetworkImage(visibleImages[i]),
                ),
              ),
            ),
          if (remainingCount > 0)
            Positioned(
              left: visibleImages.length * (size * 0.6),
              child: CircleAvatar(
                radius: size / 2,
                backgroundColor: Colors.green,
                child: Text('+$remainingCount',
                    style: fontFamilySemiBold.size10.white),
              ),
            ),
        ],
      ),
    );
  }
}
