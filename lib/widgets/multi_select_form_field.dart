import 'package:flutter/material.dart';

class MultiSelectFormField extends FormField<List<String>> {
  MultiSelectFormField({
    Key? key,
    required List<String> items,
    required List<String> initialValue,
    required String hintText,
    required Function(List<String>) onChanged,
    FormFieldValidator<List<String>>? validator,
  }) : super(
          key: key,
          initialValue: initialValue,
          validator: validator,
          builder: (FormFieldState<List<String>> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    final result = await showDialog<List<String>>(
                      context: state.context,
                      builder: (_) => _MultiSelectDialog(
                        items: items,
                        selectedValues: List.from(state.value ?? []),
                      ),
                    );

                    if (result != null) {
                      state.didChange(result);
                      onChanged(result);
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      hintText: hintText,
                      errorText: state.errorText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                    child: Text(
                      (state.value == null || state.value!.isEmpty)
                          ? hintText
                          : state.value!.join(", "),
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: (state.value == null || state.value!.isEmpty)
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
}

class _MultiSelectDialog extends StatefulWidget {
  final List<String> items;
  final List<String> selectedValues;

  const _MultiSelectDialog({
    required this.items,
    required this.selectedValues,
  });

  @override
  State<_MultiSelectDialog> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<_MultiSelectDialog> {
  late List<String> tempSelected;

  @override
  void initState() {
    tempSelected = widget.selectedValues;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select Options"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.items.map((item) {
            return CheckboxListTile(
              value: tempSelected.contains(item),
              title: Text(item),
              onChanged: (checked) {
                setState(() {
                  checked! ? tempSelected.add(item) : tempSelected.remove(item);
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, tempSelected),
          child: const Text("Done"),
        ),
      ],
    );
  }
}
