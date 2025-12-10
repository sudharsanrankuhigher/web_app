import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/initial_textform.dart';

class CommonUserDialog {
  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    Map<String, dynamic>? existingUser,
  }) async {
    final formKey = GlobalKey<FormState>();

    // Local variables to hold values
    String name = existingUser?['name'] ?? '';
    String email = existingUser?['email'] ?? '';
    String phone = existingUser?['phone'] ?? '';
    String type = existingUser?['type'] ?? '';
    String city = existingUser?['city'] ?? '';
    String state = existingUser?['state'] ?? '';
    String plan = existingUser?['plan'] ?? '';
    String connections = existingUser?['connections']?.toString() ?? '';

    return showDialog<Map<String, dynamic>>(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return Dialog(
          insetPadding: const EdgeInsets.all(30),
          child: Container(
            padding: defaultPadding16,
            width: 400,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: zeroPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      verticalSpacing10,
                      Text(
                        existingUser == null ? "Add User" : "Edit User",
                        style: fontFamilyBold.size20.black,
                      ),
                      verticalSpacing16,
                      InitialTextForm(
                        radius: 12,
                        initialValue: name,
                        hintText: "Name",
                        onChanged: (val) => name = val ?? '',
                        onSaved: (val) => name = val ?? '',
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? "Name is required"
                                : null,
                      ),
                      const SizedBox(height: 12),
                      InitialTextForm(
                        radius: 12,
                        initialValue: email,
                        hintText: "Email",
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (val) => email = val ?? '',
                        onSaved: (val) => email = val ?? '',
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? "Email is required"
                                : null,
                      ),
                      const SizedBox(height: 12),
                      InitialTextForm(
                        radius: 12,
                        initialValue: phone,
                        hintText: "Phone",
                        keyboardType: TextInputType.phone,
                        onChanged: (val) => phone = val ?? '',
                        onSaved: (val) => phone = val ?? '',
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? "Phone is required"
                                : null,
                      ),
                      const SizedBox(height: 12),
                      InitialTextForm(
                        radius: 12,
                        initialValue: type,
                        hintText: "Type",
                        onChanged: (val) => type = val ?? '',
                        onSaved: (val) => type = val ?? '',
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? "Type is required"
                                : null,
                      ),
                      const SizedBox(height: 12),
                      InitialTextForm(
                        radius: 12,
                        initialValue: city,
                        hintText: "City",
                        onChanged: (val) => city = val ?? '',
                        onSaved: (val) => city = val ?? '',
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? "City is required"
                                : null,
                      ),
                      const SizedBox(height: 12),
                      InitialTextForm(
                        radius: 12,
                        initialValue: state,
                        hintText: "State",
                        onChanged: (val) => state = val ?? '',
                        onSaved: (val) => state = val ?? '',
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? "State is required"
                                : null,
                      ),
                      const SizedBox(height: 12),
                      InitialTextForm(
                        radius: 12,
                        initialValue: plan,
                        hintText: "Plan",
                        onChanged: (val) => plan = val ?? '',
                        onSaved: (val) => plan = val ?? '',
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? "Plan is required"
                                : null,
                      ),
                      const SizedBox(height: 12),
                      InitialTextForm(
                        radius: 12,
                        initialValue: connections,
                        hintText: "Connections",
                        keyboardType: TextInputType.number,
                        onChanged: (val) => connections = val ?? '',
                        onSaved: (val) => connections = val ?? '',
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? "Connections is required"
                                : null,
                      ),
                      verticalSpacing20,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          CommonButton(
                            buttonColor: continueButton,
                            textStyle: fontFamilyMedium.size14.white,
                            borderRadius: 10,
                            width: 150,
                            onTap: () {
                              if (!formKey.currentState!.validate()) return;
                              Navigator.pop(context, {
                                "name": name.trim(),
                                "email": email.trim(),
                                "phone": phone.trim(),
                                "type": type.trim(),
                                "city": city.trim(),
                                "state": state.trim(),
                                "plan": plan.trim(),
                                "connections":
                                    int.tryParse(connections.trim()) ?? 0,
                              });
                            },
                            text: existingUser == null ? "Save" : "Update",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
