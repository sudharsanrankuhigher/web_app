import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/core/model/cities_model.dart';
import 'package:webapp/ui/views/city/model/city_model.dart' as city_model;
import 'package:webapp/ui/views/city/widget/state_city_dropdown.dart';
import 'package:webapp/ui/views/state/model/state_model.dart' as state_model;

class AddEditCityPage {
  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    city_model.Datum? initial,
    List<state_model.Datum>? states,
    List<city_model.Datum>? cities,
    int? initialStateId,
    int? initialCityId,
  }) async {
    String? stateValue = initial?.stateName;
    String? cityValue = initial?.name;

    bool isStateError = false;
    bool isCityError = false;

    int? stateId = initialStateId;
    String? cityName;

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
                    StateCityDropdownWidget(
                      states: states ?? [], // List<StateModel.Datum>
                      showCity: true,
                      initialStateId: initialStateId, // Tamil Nadu
                      initialCityName: cityValue,
                      onStateChanged: (stateIds) {
                        print("Selected stateId: $stateIds");
                        stateId = stateIds;
                      },
                      onCityChanged: (cityNames) {
                        print("Selected cityName: $cityNames");
                        cityName = cityNames;
                      },
                      stateValidator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Please select state";
                        }
                        return null;
                      },
                      cityValidator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Please select a city";
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
                  if (stateId == null || stateId!.toString().isEmpty) {
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
                  if (cityName == null || cityName!.isEmpty) {
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
                    "name": cityName,
                    "stateId": stateId ?? initialStateId,
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
