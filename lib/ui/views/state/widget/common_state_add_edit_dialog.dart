import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/ui/views/state/model/state_model.dart';
import 'package:webapp/widgets/state_city_drop_down.dart';

class AddEditStatePage {
  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    StateModel? initial,
  }) async {
    String? stateValue = initial?.name;
    bool? statusValue = initial?.status == "true" ? true : false;

    final formKey = GlobalKey<FormState>();

    return showDialog<Map<String, dynamic>>(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(initial == null ? "Add State" : "Edit State"),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // -------- STATE DROPDOWN --------
                  StateCityDropdown(
                    showCity: false,
                    initialState: stateValue,
                    onStateChanged: (state) {
                      stateValue = state;
                    },
                    stateValidator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select a state";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // -------- STATUS SWITCH --------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Status",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Switch(
                        value: statusValue!,
                        onChanged: (value) {
                          statusValue = value;
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // -------- ACTIONS --------
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(StackedService.navigatorKey!.currentContext!),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (stateValue == null || stateValue!.isEmpty) {
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(content: Text("Please select a state")),
                  // );

                  return;
                }

                Navigator.pop(context, {
                  "name": stateValue,
                  "status": statusValue,
                });
              },
              child: Text(initial == null ? "Save" : "Update"),
            ),
          ],
        );
      },
    );
  }
}
