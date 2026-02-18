import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';

class MonthYearPickerField extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onChanged;
  final String label;

  const MonthYearPickerField({
    super.key,
    required this.selectedDate,
    required this.onChanged,
    this.label = "Select Month",
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 200),
      child: InkWell(
        onTap: () async {
          final picked = await showMonthYearPicker(context, selectedDate);
          if (picked != null) {
            onChanged(picked);
          }
        },
        child: Container(
          padding: defaultPadding8 + rightPadding12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
            color: Colors.white,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.calendar_month, size: 12),
              horizontalSpacing8,
              Text(
                DateFormat('MMM yyyy').format(selectedDate),
                style: fontFamilySemiBold.size10.black,
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<DateTime?> showMonthYearPicker(
  BuildContext context,
  DateTime initialDate,
) {
  DateTime selectedDate = initialDate;

  return showDialog<DateTime>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Select Month & Year"),
        content: SizedBox(
          height: 200,
          child: Column(
            children: [
              DropdownButton<int>(
                value: selectedDate.year,
                isExpanded: true,
                items: List.generate(10, (index) {
                  final year = DateTime.now().year - 5 + index;
                  return DropdownMenuItem(
                    value: year,
                    child: Text(year.toString()),
                  );
                }),
                onChanged: (value) {
                  selectedDate = DateTime(value!, selectedDate.month);
                },
              ),
              const SizedBox(height: 12),
              DropdownButton<int>(
                value: selectedDate.month,
                isExpanded: true,
                items: List.generate(12, (index) {
                  return DropdownMenuItem(
                    value: index + 1,
                    child: Text(
                      DateFormat.MMMM().format(DateTime(0, index + 1)),
                    ),
                  );
                }),
                onChanged: (value) {
                  selectedDate = DateTime(selectedDate.year, value!);
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, selectedDate),
            child: const Text("Apply"),
          ),
        ],
      );
    },
  );
}
