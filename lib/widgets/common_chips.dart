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
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        padding: defaultPadding4 + rightPadding10,
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ]),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: SvgPicture.asset(
                imagePath,
                color: imageColor,
              ),
            ),
            horizontalSpacing4,
            //
            Text(text, style: textStyle ?? fontFamilySemiBold.size14.white),
          ],
        ),
      ),
    );
  }
}
