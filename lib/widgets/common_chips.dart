import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';

class CommonStatusChip extends StatelessWidget {
  final String text;
  final String imagePath;
  final Color bgColor;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final TextStyle? textStyle;
  final bool? isSelected;
  final Color? imageColor;
  final double? imageheight;
  final double? imagewidth;
  final EdgeInsetsGeometry? padding;

  const CommonStatusChip({
    super.key,
    required this.text,
    required this.imagePath,
    required this.bgColor,
    this.margin,
    this.textStyle,
    this.onTap,
    this.isSelected,
    this.imageColor,
    this.imageheight,
    this.imagewidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 1. Resolve Background Color
    // If background is hardcoded white/backwhite, adapt it to the theme surface in dark mode
    Color resolvedBgColor = bgColor;
    if (isDark) {
      if (bgColor == Colors.white || bgColor == white || bgColor == backwhite) {
        resolvedBgColor = Theme.of(context).colorScheme.surface;
      }
    }

    // 2. Resolve Text Color
    TextStyle resolvedTextStyle = textStyle ?? fontFamilySemiBold.size14.white;
    if (isDark) {
      // If text style specifies standard black, black45, or dark grey, adapt to theme's onSurface
      final textStyleColor = resolvedTextStyle.color;
      if (textStyleColor == Colors.black ||
          textStyleColor == const Color(0xFF262626) ||
          textStyleColor == appSecond950 ||
          textStyleColor == appSecond900) {
        resolvedTextStyle = resolvedTextStyle.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        );
      }
    }

    // 3. Resolve Image Color
    Color? resolvedImageColor = imageColor;
    if (isDark && imageColor != null) {
      if (imageColor == Colors.black ||
          imageColor == appSecond950 ||
          imageColor == appSecond900 ||
          imageColor == const Color(0xFF262626)) {
        resolvedImageColor =
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.85);
      }
    }

    // 4. Resolve Shadow Color
    final resolvedShadowColor = isDark
        ? Colors.black.withValues(alpha: 0.3)
        : Colors.grey.withValues(alpha: 0.2);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        padding: padding ?? defaultPadding4 + rightPadding10,
        decoration: BoxDecoration(
          color: resolvedBgColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: resolvedShadowColor,
              spreadRadius: isDark ? 1 : 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: imageheight ?? 40,
              width: imagewidth ?? 40,
              child: SvgPicture.asset(
                imagePath,
                color: resolvedImageColor,
              ),
            ),
            horizontalSpacing4,
            Flexible(
              child: Text(
                text,
                style: resolvedTextStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
