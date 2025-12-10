import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/widgets/initial_textform.dart';
import 'package:webapp/widgets/label_text.dart';

class IconTextFormField extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final String? hintText;
  final Color? iconColor;
  final Color? textColor;
  final double? fontSize;
  final double? iconSize;
  final FontWeight? fontWeight;
  final bool? isView;
  final String? Function(String?)? validator;

  IconTextFormField({
    super.key,
    required this.icon,
    required this.label,
    required this.controller,
    this.isView,
    this.hintText,
    this.iconColor,
    this.textColor,
    this.fontSize,
    this.iconSize,
    this.fontWeight,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconTextLabel(
          icon: icon,
          text: label,
          iconColor: iconColor ?? Colors.black,
          textColor: textColor ?? Colors.black,
          iconSize: iconSize ?? 16,
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? FontWeight.w500,
        ),
        verticalSpacing8,
        InitialTextForm(
          validator: validator,
          readOnly: isView!,
          radius: 10,
          controller: controller,
          hintText: hintText ?? label,
        ),
      ],
    );
  }
}
