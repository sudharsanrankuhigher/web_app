import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';

class InfFilter extends StatelessWidget {
  final bool initialCheckbox;
  final String initialSort;

  final List<Map<String, dynamic>> categoryList;
  final List<dynamic> services; // your service model

  final void Function(bool checkbox, String sort) onApply;
  final void Function(int? categoryId, int? serviceId)? onFilter;

  const InfFilter({
    Key? key,
    this.initialCheckbox = false,
    this.initialSort = "A-Z",
    required this.onApply,
    required this.categoryList,
    required this.services,
    this.onFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool checkStatus = initialCheckbox;
    String selectedSort = initialSort;

    int? selectedCategory;
    int? selectedService;

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

                /// ✅ CATEGORY DROPDOWN
                const Text("Category",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                DropdownButtonFormField<int>(
                  initialValue: selectedCategory,
                  hint: const Text("Select Category"),
                  items: categoryList.map((cat) {
                    return DropdownMenuItem<int>(
                      value: cat['id'],
                      child: Text(cat['name']),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => selectedCategory = val),
                  decoration: InputDecoration(
                    hintText: "Select Category",
                    hintStyle: const TextStyle(color: Colors.grey),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    filled: true,
                    fillColor: backgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: disableColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: disableColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// ✅ SERVICE DROPDOWN
                const Text("Service",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                DropdownButtonFormField<int>(
                  initialValue: selectedService,
                  hint: const Text("Select Service"),
                  items: services.map<DropdownMenuItem<int>>((srv) {
                    return DropdownMenuItem<int>(
                      value: srv.id,
                      child: Text(srv.name ?? ''),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => selectedService = val),
                  decoration: InputDecoration(
                    hintText: "Select Category",
                    hintStyle: const TextStyle(color: Colors.grey),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    filled: true,
                    fillColor: backgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: disableColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: disableColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// ✅ SORT
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

                const SizedBox(height: 16),

                /// ✅ BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel")),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        onApply(checkStatus, selectedSort);

                        /// 🔥 send filter values
                        if (onFilter != null) {
                          onFilter!(selectedCategory, selectedService);
                        }

                        Navigator.pop(context);
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

  /// ✅ SHOW FUNCTION UPDATED
  static Future<void> show(
    BuildContext context, {
    bool initialCheckbox = false,
    String initialSort = "A-Z",
    required List<Map<String, dynamic>> categoryList,
    required List<dynamic> services,
    required void Function(bool checkbox, String sort) onApply,
    void Function(int? categoryId, int? serviceId)? onFilter,
  }) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Filter",
      barrierColor: Colors.black.withOpacity(0.3),
      pageBuilder: (_, __, ___) {
        return Center(
          child: InfFilter(
            initialCheckbox: initialCheckbox,
            initialSort: initialSort,
            onApply: onApply,
            categoryList: categoryList,
            services: services,
            onFilter: onFilter,
          ),
        );
      },
    );
  }
}
