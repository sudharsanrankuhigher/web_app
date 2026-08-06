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

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg =
        isDark ? Theme.of(context).colorScheme.surface : Colors.white;
    final fieldBg = isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9);
    final borderCol = isDark ? const Color(0xFF475569) : disableColor;

    return Dialog(
      constraints: const BoxConstraints(maxWidth: 400),
      backgroundColor: dialogBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Filters & Sorting",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 12),

                /// ✅ CATEGORY DROPDOWN
                Text(
                  "Category",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<int>(
                  dropdownColor: dialogBg,
                  initialValue: selectedCategory,
                  hint: Text(
                    "Select Category",
                    style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey),
                  ),
                  items: categoryList.map((cat) {
                    return DropdownMenuItem<int>(
                      value: cat['id'],
                      child: Text(
                        cat['name'],
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => selectedCategory = val),
                  decoration: InputDecoration(
                    hintText: "Select Category",
                    hintStyle: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    filled: true,
                    fillColor: fieldBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: borderCol),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: borderCol),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// ✅ SERVICE DROPDOWN
                Text(
                  "Service",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<int>(
                  dropdownColor: dialogBg,
                  initialValue: selectedService,
                  hint: Text(
                    "Select Service",
                    style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey),
                  ),
                  items: services.map<DropdownMenuItem<int>>((srv) {
                    return DropdownMenuItem<int>(
                      value: srv.id,
                      child: Text(
                        srv.name ?? '',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => selectedService = val),
                  decoration: InputDecoration(
                    hintText: "Select Category",
                    hintStyle: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    filled: true,
                    fillColor: fieldBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: borderCol),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: borderCol),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// ✅ SORT
                Text(
                  "Sort By",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                RadioListTile(
                    value: "A-Z",
                    groupValue: selectedSort,
                    title: Text(
                      "A - Z",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                    onChanged: (v) => setState(() => selectedSort = v!)),
                RadioListTile(
                    value: "newer",
                    groupValue: selectedSort,
                    title: Text(
                      "Newer First",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                    onChanged: (v) => setState(() => selectedSort = v!)),
                RadioListTile(
                    value: "older",
                    groupValue: selectedSort,
                    title: Text(
                      "Older First",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
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
      barrierColor: Colors.black.withValues(alpha: 0.3),
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
