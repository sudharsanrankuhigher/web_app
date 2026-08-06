import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color? buttonColor;
  final Color? borderColor;
  final double borderRadius;
  final Widget? icon;
  final Widget? icon1;
  final double? width;
  final double? height;

  const CommonButton(
      {super.key,
      required this.text,
      this.onTap,
      this.gradient,
      this.textStyle,
      this.buttonColor,
      this.borderColor,
      this.margin,
      this.icon,
      this.icon1,
      this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      this.borderRadius = 30,
      this.height,
      this.width});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Resolve themed defaults if not custom specified
    final defaultBg = isDark ? const Color(0xFF1E293B) : backgroundColor;
    final resolvedBgColor = buttonColor ?? defaultBg;

    final resolvedBorderColor = borderColor ??
        (isDark ? Colors.grey.withValues(alpha: 0.2) : disableColor);

    TextStyle resolvedTextStyle = textStyle ??
        fontFamilyMedium.size14.black.copyWith(overflow: TextOverflow.ellipsis);
    if (isDark && textStyle == null) {
      resolvedTextStyle = fontFamilyMedium.size14.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
        overflow: TextOverflow.ellipsis,
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        padding: padding,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: resolvedBgColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: resolvedBorderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              text.isNotEmpty || textStyle != null
                  ? horizontalSpacing10
                  : Container(),
            ],
            if (text.isNotEmpty || textStyle != null)
              Flexible(
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  text,
                  style: resolvedTextStyle,
                ),
              ),
            if (icon1 != null) ...[
              horizontalSpacing10,
              icon1!,
            ],
          ],
        ),
      ),
    );
  }
}
