import 'package:flutter/material.dart';

/// Reusable dialog for sorting/filter
class CommonFilterDialog extends StatelessWidget {
  final bool initialCheckbox;
  final String initialSort;
  final void Function(bool checkbox, String sort) onApply;

  const CommonFilterDialog({
    Key? key,
    this.initialCheckbox = false,
    this.initialSort = "A-Z",
    required this.onApply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool checkStatus = initialCheckbox;
    String selectedSort = initialSort;

    return Dialog(
      constraints: const BoxConstraints(maxWidth: 400),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Filters & Sorting",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 12),

                // Sort options
                const Text("Sort By",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                RadioListTile(
                    value: "A-Z",
                    groupValue: selectedSort,
                    title: const Text("A - Z"),
                    onChanged: (v) => setState(() => selectedSort = v!)),
                RadioListTile(
                    value: "newer",
                    groupValue: selectedSort,
                    title: const Text("Newer First"),
                    onChanged: (v) => setState(() => selectedSort = v!)),
                RadioListTile(
                    value: "older",
                    groupValue: selectedSort,
                    title: const Text("Older First"),
                    onChanged: (v) => setState(() => selectedSort = v!)),
                RadioListTile(
                    value: "clientAsc",
                    groupValue: selectedSort,
                    title: const Text("Client ID (Asc → Desc)"),
                    onChanged: (v) => setState(() => selectedSort = v!)),

                const SizedBox(height: 16),

                // // Checkbox example if needed
                // Row(
                //   children: [
                //     Checkbox(
                //       value: checkStatus,
                //       onChanged: (v) => setState(() => checkStatus = v!),
                //     ),
                //     const Text("Special Filter"),
                //   ],
                // ),

                // const SizedBox(height: 16),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel")),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        onApply(checkStatus, selectedSort); // return result
                        Navigator.pop(context); // close dialog
                      },
                      child: const Text("Apply"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Helper function to show the dialog
  static Future<void> show(
    BuildContext context, {
    bool initialCheckbox = false,
    String initialSort = "A-Z",
    required void Function(bool checkbox, String sort) onApply,
  }) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Filter",
      barrierColor: Colors.black.withOpacity(0.3), // semi-transparent overlay
      pageBuilder: (_, __, ___) {
        return Center(
          child: CommonFilterDialog(
            initialCheckbox: initialCheckbox,
            initialSort: initialSort,
            onApply: onApply,
          ),
        );
      },
    );
  }
}
