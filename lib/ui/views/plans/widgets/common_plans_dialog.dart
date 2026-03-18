import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/plans/model/plans_model.dart' as plan_model;
import 'package:webapp/widgets/initial_textform.dart';
import 'package:webapp/widgets/label_text.dart';
import 'package:webapp/widgets/search_drop_down_widget.dart';

class CommonPlanDialog {
  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    plan_model.Datum? initial,
    bool isView = false,
    bool isAdd = false,
  }) async {
    String? planName = initial?.name ?? '';
    String? conn = initial?.connections.toString();
    String? amt = initial?.amount.toString();
    String? saleAmt = initial?.saleAmount.toString();
    String? gst = initial?.gst.toString();
    String? badge = initial?.badge ?? '';

    /// ---------------- CATEGORY DROPDOWN DATA ----------------
    dynamic selectedCategory;
    bool isCategoryError = false;

    final List<Map<String, dynamic>> categoryList = [
      {'id': 1, 'name': 'Influencers'},
      {'id': 2, 'name': 'Movie Stars'},
      {'id': 3, 'name': 'TV Stars'},
      {'id': 4, 'name': 'Sports Stars'},
    ];

    /// Preselect category (Edit / View)
    if (initial?.category != null) {
      selectedCategory = categoryList.firstWhere(
        (e) => e['id'].toString() == initial!.category,
        orElse: () => categoryList.first,
      );
    } else {
      selectedCategory = categoryList.first; // default
    }

    /// ---------------- INPUT DECORATION ----------------
    InputDecoration decoration(String label) => InputDecoration(
          labelText: label,
          fillColor: Colors.white,
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey, width: 1.5),
          ),
        );

    return showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                isView
                    ? "View Plan"
                    : initial == null
                        ? "Add Plan"
                        : "Edit Plan",
              ),
              content: SizedBox(
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _field("Plan Name", planName, (v) => planName = v,
                          isView: isView),
                      _field("Connections", conn, (v) => conn = v,
                          isView: isView, isNumber: true),
                      _field("Regular Amount", amt, (v) => amt = v,
                          isView: isView, isNumber: true),
                      _field("Sale Amount", saleAmt, (v) => saleAmt = v,
                          isView: isView, isNumber: true),
                      _field("Gst", gst, (v) => gst = v,
                          suffix: const Icon(Icons.percent),
                          isView: isView,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            TextInputFormatter.withFunction(
                                (oldValue, newValue) {
                              if (newValue.text.isEmpty) return newValue;

                              final intValue = int.tryParse(newValue.text);
                              if (intValue != null && intValue <= 100) {
                                return newValue;
                              }
                              return oldValue; // Prevent values > 100
                            }),
                          ],
                          isNumber: true),
                      _field("Badge", badge, (v) => badge = v, isView: isView),

                      const SizedBox(height: 8),

                      /// ---------------- CATEGORY DROPDOWN ----------------
                      IgnorePointer(
                        ignoring: isView,
                        child: SizedBox(
                          width: 400,
                          child: DynamicSingleSearchDropdown(
                            label: "Category",
                            items: categoryList,
                            selectedItem: selectedCategory,
                            isError: isCategoryError,
                            errorText: "Please select a category",
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value;
                                isCategoryError = false;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// ---------------- ACTIONS ----------------
              actions: [
                if (!isView)
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(continueButton),
                    ),
                    onPressed: () {
                      if (selectedCategory == null) {
                        setState(() => isCategoryError = true);
                        return;
                      }

                      Navigator.pop(
                        StackedService.navigatorKey!.currentContext!,
                        {
                          'planName': planName,
                          'connections': int.tryParse(conn ?? "0") ?? 0,
                          'regular_price':
                              int.tryParse(amt ?? "0") ?? initial!.amount,
                          'sale_price': int.tryParse(saleAmt ?? "0") ??
                              initial!.saleAmount,
                          'gst': int.tryParse(gst ?? "0") ?? initial!.gst,
                          'badge': badge ?? "",
                          'category': selectedCategory['id'], // ✅ numeric
                        },
                      );
                    },
                    child: Text(
                      initial == null ? "Save" : "Update",
                      style: fontFamilySemiBold.size13.white,
                    ),
                  ),
                TextButton(
                  onPressed: () => Navigator.pop(
                    StackedService.navigatorKey!.currentContext!,
                  ),
                  child: const Text("Close"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// ---------------- COMMON TEXT FIELD ----------------
  static Widget _field(
    String label,
    String? initial,
    Function(String) onChanged, {
    bool isView = false,
    bool isNumber = false,
    Widget? suffix,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconTextLabel(
            icon: null,
            text: label,
            iconColor: Colors.black,
            textColor: Colors.black,
            iconSize: 16,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          verticalSpacing8,
          InitialTextForm(
            readOnly: isView,
            radius: 10,
            hintText: label,
            suffixIcon: suffix,
            initialValue: initial ?? '',
            onChanged: (val) => onChanged(val!),
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            inputFormatters: inputFormatters,
          ),
        ],
      ),
    );
  }
}
