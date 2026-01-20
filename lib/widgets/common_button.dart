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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        padding: padding,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: buttonColor ?? backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor ?? disableColor)),
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
              Text(
                overflow: TextOverflow.ellipsis,
                text,
                style: textStyle ??
                    fontFamilyMedium.size14.black
                        .copyWith(overflow: TextOverflow.ellipsis),
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
