import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/ui/views/roles/roles_viewmodel.dart';
import 'package:webapp/ui/views/services/services_viewmodel.dart';
import 'package:webapp/widgets/initial_textform.dart';

class CommonRoleDialog {
  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    String? existingName,
  }) async {
    final formKey = GlobalKey<FormState>(); // ✅ Added formKey

    String? name;

    return showDialog<Map<String, dynamic>>(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return ViewModelBuilder<RolesViewModel>.reactive(
          viewModelBuilder: () => RolesViewModel(
            initialName: existingName,
          ),
          builder: (context, model, _) {
            return AlertDialog(
              title: Text(existingName == null ? "Add Roles" : "Edit Roles"),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey, // ✅ Attach key
                  child: Column(
                    children: [
                      // ----- Service Name -----
                      InitialTextForm(
                        hintText: "Roles Name",
                        radius: 12,
                        initialValue: model.name,
                        onChanged: (value) => model.setname(value ?? ''),
                        validator: (value) {
                          // ✅ Add validation
                          if (value == null || value.trim().isEmpty) {
                            return "Service name is required";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          model.setname(value!);
                          name = value;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // -------- Buttons --------
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // VALIDATE BEFORE SAVE
                    if (!formKey.currentState!.validate()) return;

                    Navigator.pop(context, {
                      "name": name ?? model.name,
                    });
                  },
                  child: Text(existingName == null ? "Save" : "Update"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
