import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/plans/model/plans_model.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/initial_textform.dart';
import 'package:webapp/widgets/label_text.dart';

class CommonPlanDialog {
  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    PlanModel? initial,
    bool isView = false,
  }) async {
    String? planName = initial?.planName;
    String? conn = initial?.connections.toString();
    String? amt = initial?.amount.toString();
    String? badge = initial?.badge;

    return showDialog<Map<String, dynamic>>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
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
              ],
            ),
          ),
          actions: [
            if (!isView)
              CommonButton(
                width: 200,
                onTap: () {
                  Navigator.pop(context, {
                    'planName': planName,
                    'connections': int.tryParse(conn ?? "0") ?? 0,
                    'amount': int.tryParse(amt ?? "0") ?? 0,
                    'badge': badge ?? "",
                  });
                },
                text: "Save",
                buttonColor: continueButton,
                padding: defaultPadding10,
                textStyle: fontFamilyMedium.size14.white,
              ),
            CommonButton(
              width: 200,
              text: "close",
              onTap: () => Navigator.pop(context),
              buttonColor: red,
              padding: defaultPadding10,
              textStyle: fontFamilyMedium.size14.white,
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
      padding: EdgeInsets.only(bottom: 12),
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
