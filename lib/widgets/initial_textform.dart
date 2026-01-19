import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';

class InitialTextForm extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? initialValue;
  final int? maxLines;
  final double? radius;
  final Widget? suffixIcon;
  final Widget? preffixIcon;
  final Widget? preffix;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool readOnly;
  final Color? fillColor;
  final Color? borderColor;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final Function(TapDownDetails)? onTap;
  final void Function()? onTapped;
  final TextInputType keyboardType;
  final TextStyle? textStyle;
  final List<TextInputFormatter>? inputFormatters;
  final Key? keys;

  const InitialTextForm({
    super.key,
    this.keys,
    this.controller,
    this.maxLines = 1,
    this.fillColor,
    this.borderColor,
    this.onSaved,
    this.onTap,
    this.onTapped,
    this.onChanged,
    this.suffixIcon,
    this.preffixIcon,
    this.preffix,
    this.radius,
    this.hintText,
    this.initialValue,
    this.validator,
    this.readOnly = false,
    this.obscureText = false,
    this.inputFormatters,
    this.keyboardType = TextInputType.text,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onTap,
      child: TextFormField(
        key: keys,
        maxLines: maxLines,
        initialValue: initialValue,
        onSaved: onSaved,
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        readOnly: readOnly,
        onChanged: onChanged,
        style: textStyle ?? fontFamilyRegular.size12,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          hintText: hintText ?? "Enter name",
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          filled: true,
          fillColor: fillColor ?? backgroundColor,
          suffixIcon: suffixIcon,
          prefixIcon: preffixIcon,
          prefix: preffix,
          errorStyle: fontFamilyMedium.size10.red,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 30),
            borderSide: BorderSide(color: borderColor ?? disableColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 30),
            borderSide: BorderSide(color: borderColor ?? disableColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 30),
            borderSide: const BorderSide(color: Colors.green, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 30),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 30),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
        onTap: onTapped,
      ),
    );
  }
}
