import 'package:flutter/material.dart';

class IconTextLabel extends StatelessWidget {
  final IconData? icon;
  final String text;
  final Color iconColor;
  final Color textColor;
  final double iconSize;
  final double fontSize;
  final FontWeight fontWeight;
  final double spacing;

  const IconTextLabel({
    super.key,
    this.icon,
    required this.text,
    this.iconColor = Colors.black,
    this.textColor = Colors.black,
    this.iconSize = 16,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w500,
    this.spacing = 6,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Icon(icon, size: iconSize, color: iconColor),
          ),
          WidgetSpan(child: SizedBox(width: spacing)),
          TextSpan(
            text: text,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        ],
      ),
    );
  }
}
