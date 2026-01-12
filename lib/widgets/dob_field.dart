import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';

class DOBField extends StatelessWidget {
  final DateTime? selectedDate;
  final String label;
  final bool isError;
  final String? errorText;
  final void Function(DateTime) onDateSelected;

  const DOBField({
    super.key,
    required this.label,
    required this.onDateSelected,
    this.selectedDate,
    this.isError = false,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      style: const TextStyle(fontSize: 12),
      controller: TextEditingController(
        text: selectedDate == null
            ? ""
            : "${selectedDate!.day.toString().padLeft(2, '0')}-"
                "${selectedDate!.month.toString().padLeft(2, '0')}-"
                "${selectedDate!.year}",
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: fontFamilyMedium.size12.greyColor,
        suffixIcon: const Icon(Icons.calendar_today, size: 20),
        isDense: true,
        fillColor: backgroundColor,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isError ? Colors.red : disableColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isError ? Colors.red : Colors.blue,
            width: 2,
          ),
        ),
        errorText: isError ? errorText ?? "Please select DOB" : null,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      ),
      onTap: () async {
        FocusScope.of(context).unfocus();

        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime(2000),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                textTheme: TextTheme(
                  bodyMedium: fontFamilyMedium.size12.black,
                ),
              ),
              child: child!,
            );
          },
        );

        if (picked != null) {
          onDateSelected(picked);
        }
      },
    );
  }
}
