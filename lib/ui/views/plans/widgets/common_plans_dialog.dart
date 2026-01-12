import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/views/plans/model/plans_model.dart' as plan_model;
import 'package:webapp/widgets/initial_textform.dart';
import 'package:webapp/widgets/label_text.dart';

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
    String? badge = initial?.badge;

    int categoryCode = initial?.category == "1"
        ? 1
        : initial?.category == "2"
            ? 2
            : initial?.category == "3"
                ? 3
                : 1; // default to TV Stars

    InputDecoration _decoration(String label) => InputDecoration(
          labelText: label,
          fillColor: Colors.white,
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey, width: 1.5)),
        );

    return showDialog<Map<String, dynamic>>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        isAdd == true ? categoryCode = 1 : categoryCode;
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _field("Plan Name", planName, (v) => planName = v,
                    isView: isView),
                _field("Connections", conn, (v) => conn = v,
                    isView: isView, isNumber: true),
                _field("Amount", amt, (v) => amt = v,
                    isView: isView, isNumber: true),
                _field("Badge", badge, (v) => badge = v, isView: isView),
                const SizedBox(height: 8),
                IgnorePointer(
                  ignoring: isView,
                  child: DropdownButtonFormField<int>(
                    value: categoryCode,
                    decoration: _decoration("Category"),
                    items: const [
                      DropdownMenuItem(value: 1, child: Text("Influencers")),
                      DropdownMenuItem(value: 2, child: Text("Movie Stars")),
                      DropdownMenuItem(value: 3, child: Text("TV Stars")),
                    ],
                    onChanged: (v) => categoryCode = v ?? 1,
                    validator: (v) =>
                        v == null ? "Please select a category" : null,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            if (!isView)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(StackedService.navigatorKey!.currentContext!, {
                    'planName': planName,
                    'connections': int.tryParse(conn ?? "0") ?? 0,
                    'amount': int.tryParse(amt ?? "0") ?? 0,
                    'badge': badge ?? "",
                    'category': categoryCode, // returns numeric code
                  });
                },
                child: Text(initial == null ? "Save" : "Update"),
              ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(StackedService.navigatorKey!.currentContext!),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  static Widget _field(
    String label,
    String? initial,
    Function(String) onChanged, {
    bool isView = false,
    bool isNumber = false,
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
            initialValue: initial ?? '',
            onChanged: (val) => onChanged(val!),
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          ),
        ],
      ),
      // child: TextFormField(
      //   initialValue: initial,
      //   readOnly: isView,
      //   keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      //   onChanged: onChanged,
      //   decoration: InputDecoration(
      //     labelText: label,
      //     border: const OutlineInputBorder(
      //       borderRadius: BorderRadius.all(Radius.circular(10)),
      //     ),
      //   ),
      // ),
    );
  }
}
