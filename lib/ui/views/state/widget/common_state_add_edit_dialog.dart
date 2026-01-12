import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/ui/views/state/model/state_model.dart' as state_model;
import 'package:webapp/widgets/state_city_drop_down.dart';

class AddEditStatePage {
  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    state_model.Datum? initial,
  }) async {
    String? stateValue = initial?.name;

    bool isStateError = false;
    bool isCityError = false;

    final formKey = GlobalKey<FormState>();

    return showDialog<Map<String, dynamic>>(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return StatefulBuilder(builder: (context, setDialogState) {
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
                      isStateError: isStateError,
                      isCityError: isCityError,
                      onStateChanged: (state) {
                        stateValue = state;
                      },
                      stateValidator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select a states";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),
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
                    setDialogState(() {
                      isStateError = true;
                    });
                    return;
                  }

                  Navigator.pop(context, {
                    "name": stateValue,
                  });
                  isStateError = false;
                },
                child: Text(initial == null ? "Save" : "Update"),
              ),
            ],
          );
        });
      },
    );
  }
}
