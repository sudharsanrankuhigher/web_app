import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/ui/views/city/model/city_model.dart';
import 'package:webapp/widgets/state_city_drop_down.dart';

class AddEditCityPage {
  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    CityShowModel? initial,
  }) async {
    String? stateValue = initial?.stateName;
    String? cityValue = initial?.cityName;
    bool? statusValue = initial?.status == "true" ? true : false;

    bool isStateError = false;
    bool isCityError = false;

    final formKey = GlobalKey<FormState>();

    return showDialog<Map<String, dynamic>>(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(initial == null ? "Add City " : "Edit City"),
            content: Form(
              key: formKey,
              child: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // -------- STATE DROPDOWN --------
                    StateCityDropdown(
                      showCity: true,
                      initialState: stateValue,
                      initialCity: cityValue,
                      isCityError: isCityError,
                      isStateError: isStateError,
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select a state")),
                    );
                    setDialogState(() {
                      isStateError = true;
                    });
                    return;
                  } else {
                    setDialogState(() {
                      isStateError = false;
                    });
                  }
                  if (cityValue == null || cityValue!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select a city")),
                    );
                    setDialogState(() {
                      isCityError = true;
                    });

                    return;
                  } else {
                    setDialogState(() {
                      isCityError = false;
                    });
                  }

                  Navigator.pop(StackedService.navigatorKey!.currentContext!, {
                    "name": stateValue,
                    "status": statusValue,
                  });
                  isStateError = false;
                  isCityError = false;
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
