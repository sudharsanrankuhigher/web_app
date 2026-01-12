import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/sub_admin/model/sub_admin_model.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/initial_textform.dart';
import 'package:webapp/widgets/multi_select_form_field.dart';
import 'package:webapp/widgets/profile_image.dart';
import 'package:webapp/widgets/state_city_drop_down.dart';

class CommonSubAdminDialog {
  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    SubAdminModel? model,
  }) async {
    final formKey = GlobalKey<FormState>();
    final bool isEdit = model != null;

    String name = model?.name ?? '';
    String phone = model?.phone ?? '';
    String email = model?.email ?? '';
    String password = '';

    String gender = model?.gender ?? 'Male';
    DateTime dob = model?.dob ?? DateTime(2000);

    String state = model?.state ?? '';
    String city = model?.city ?? '';

    List<String> access = model?.access ?? [];
    bool status = model?.isActive ?? true;

    String profileImage = model?.imageUrl ?? '';
    String idImage = model?.idImageUrl ?? '';

    bool? isStateError = false;
    bool? isCityError = false;

    final states = ["Tamil Nadu", "Kerala", "Karnataka"];
    final cities = {
      "Tamil Nadu": ["Chennai", "Coimbatore"],
      "Kerala": ["Kochi", "Trivandrum"],
      "Karnataka": ["Bangalore", "Mysore"],
    };

    Uint8List? pickedBytes;
    String? pickedPath;

    InputDecoration _decoration(String label) => InputDecoration(
          labelText: label,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: disableColor, width: 1.5)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: disableColor, width: 1.5)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: appGreen400, width: 1.5),
          ),
        );

    return showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (_) => StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: Text(isEdit ? "Edit Sub Admin" : "Add Sub Admin"),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: SizedBox(
                width: 420,
                child: Column(
                  children: [
                    /// ---------------- PROFILE IMAGE ----------------
                    GestureDetector(
                      onTap: () async {
                        // TODO: image picker
                      },
                      child: Center(
                        child: ProfileImageEdit(
                          imageUrl: profileImage,
                          imageBytes: pickedBytes,
                          imagePath: pickedPath,
                          onImageSelected: (bytes, path) {
                            setState(() {
                              pickedBytes = bytes;
                              pickedPath = path;
                            });
                          },
                        ),
                      ),
                    ),

                    verticalSpacing16,

                    /// Name

                    InitialTextForm(
                      radius: 12,
                      hintText: "Name",
                      initialValue: name,
                      onChanged: (v) => name = v ?? '',
                      validator: (v) =>
                          v == null || v.isEmpty ? "Required" : null,
                    ),
                    verticalSpacing12,

                    /// Phone
                    InitialTextForm(
                      radius: 12,
                      hintText: "Phone",
                      initialValue: phone,
                      onChanged: (v) => phone = v ?? '',
                      validator: (v) =>
                          v == null || v.length < 10 ? "Invalid phone" : null,
                    ),
                    verticalSpacing12,

                    /// Email
                    InitialTextForm(
                      radius: 12,
                      hintText: "Email",
                      initialValue: email,
                      onChanged: (v) => email = v ?? '',
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return "Email is required";
                        }

                        final emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        );

                        if (!emailRegex.hasMatch(v.trim())) {
                          return "Enter a valid email address";
                        }

                        return null;
                      },
                    ),
                    verticalSpacing12,

                    /// Password
                    InitialTextForm(
                      radius: 12,
                      hintText:
                          isEdit ? "Change Password (Optional)" : "Password",
                      obscureText: true,
                      onChanged: (v) => password = v ?? '',
                      validator: (v) {
                        if (!isEdit && (v == null || v.length < 6)) {
                          return "Min 6 characters";
                        }
                        return null;
                      },
                    ),

                    verticalSpacing16,

                    /// Gender
                    DropdownButtonFormField<String>(
                      value: gender,
                      decoration: _decoration("Gender"),
                      items: const [
                        DropdownMenuItem(value: "Male", child: Text("Male")),
                        DropdownMenuItem(
                            value: "Female", child: Text("Female")),
                        DropdownMenuItem(
                            value: "Others", child: Text("Others")),
                      ],
                      onChanged: (v) => gender = v!,
                    ),

                    verticalSpacing10,

                    /// DOB
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1970),
                          lastDate: DateTime.now(),
                          initialDate: dob,
                        );
                        if (picked != null) dob = picked;
                      },
                      child: InputDecorator(
                        decoration: _decoration("Date of Birth").copyWith(
                            suffixIcon: const Icon(Icons.calendar_today)),
                        child: Text(
                          dob.toLocal().toString().split(' ')[0],
                        ),
                      ),
                    ),

                    verticalSpacing10,

                    /// State
                    // DropdownButtonFormField<String>(
                    //   value: state.isEmpty ? null : state,
                    //   decoration: _decoration("State"),
                    //   items: states
                    //       .map(
                    //         (e) => DropdownMenuItem(value: e, child: Text(e)),
                    //       )
                    //       .toList(),
                    //   onChanged: (v) {
                    //     setState(() {
                    //       state = v!;
                    //       city = ''; // reset city when state changes
                    //     });
                    //   },
                    //   validator: (v) => v == null ? "Select state" : null,
                    // ),

                    StateCityDropdown(
                      showCity: true,
                      initialState: state.isEmpty ? null : state,
                      initialCity: city.isEmpty ? null : city,
                      isStateError: isStateError,
                      isCityError: isCityError,
                      onStateChanged: (state) {
                        model?.state = state;
                      },
                      onCityChanged: (city) {
                        model?.city = city!;
                      },
                      stateValidator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select a states";
                        }
                        return null;
                      },
                    ),

                    // verticalSpacing10,

                    /// City
                    // DropdownButtonFormField<String>(
                    //   value: city.isEmpty ? null : city,
                    //   decoration: _decoration("City"),
                    //   items: state.isEmpty
                    //       ? []
                    //       : cities[state]!
                    //           .map(
                    //             (e) =>
                    //                 DropdownMenuItem(value: e, child: Text(e)),
                    //           )
                    //           .toList(),
                    //   onChanged: state.isEmpty
                    //       ? null
                    //       : (v) {
                    //           setState(() {
                    //             city = v!;
                    //           });
                    //         },
                    //   validator: (v) => v == null ? "Select city" : null,
                    // ),

                    verticalSpacing16,

                    /// ---------------- ID PROOF IMAGE ----------------
                    GestureDetector(
                      onTap: () async {
                        // TODO: ID image picker
                      },
                      child: Container(
                        height: 80,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.upload_file),
                              SizedBox(width: 8),
                              Text("Upload ID Proof"),
                            ],
                          ),
                        ),
                      ),
                    ),

                    verticalSpacing16,

                    /// Access
                    MultiSelectFormField(
                      hintText: "Access",
                      items: const [
                        "Payment",
                        "Add Project",
                        "Add Call",
                        "Add Company",
                      ],
                      initialValue: access,
                      onChanged: (v) => access = v,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Select access" : null,
                    ),

                    SwitchListTile(
                      title: const Text("Active"),
                      value: status,
                      onChanged: (v) => status = v,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(StackedService.navigatorKey!.currentContext!);
                state = '';
                city = '';
                gender = '';
              },
              child: const Text("Cancel"),
            ),
            CommonButton(
              width: 100,
              padding: defaultPadding8,
              buttonColor: continueButton,
              text: isEdit ? "Update" : "Create",
              textStyle: fontFamilyBold.size14.white,
              onTap: () {
                if (state == null || state.isEmpty) {
                  setState(() {
                    isStateError = true;
                  });
                  return;
                } else {
                  setState(() {
                    isStateError = false;
                  });
                }
                if (city == null || city.isEmpty) {
                  setState(() {
                    isCityError = true;
                  });
                  return;
                } else {
                  setState(() {
                    isCityError = false;
                  });
                }
                if (!formKey.currentState!.validate()) return;

                Navigator.pop(StackedService.navigatorKey!.currentContext!, {
                  "name": name,
                  "phone": phone,
                  "email": email,
                  "password": password.isEmpty ? null : password,
                  "gender": gender,
                  "dob": dob,
                  "state": state,
                  "city": city,
                  "access": access,
                  "image": profileImage,
                  "idImage": idImage,
                  "status": status,
                });
                state = '';
                city = '';
                gender = '';
              },
            ),
          ],
        );
      }),
    );
  }
}
