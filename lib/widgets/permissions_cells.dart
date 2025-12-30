import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';

class HeaderCell extends StatelessWidget {
  final String text;
  final int flex;
  final TextAlign? align;

  const HeaderCell(this.text, this.align, {this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
        textAlign: align ?? TextAlign.center,
      ),
    );
  }
}

class TextCell extends StatelessWidget {
  final String text;
  final int flex;

  const TextCell(this.text, {this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Text(
          text,
          style: fontFamilyBold.size14.black,
        ),
      ),
    );
  }
}

class CheckCell extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final bool enabled;

  const CheckCell({
    required this.value,
    required this.onChanged,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Checkbox(
          value: enabled ? value : false,
          onChanged: enabled ? onChanged : null, // 👈 disable
        ),
      ),
    );
  }
}

InputDecoration decoration(String label) => InputDecoration(
      labelText: label,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: disableColor, width: 1.5)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: disableColor, width: 1.5)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: appGreen400, width: 1.5),
      ),
    );
