import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/roles/model/roles_model.dart' as roles_model;
import 'package:webapp/ui/views/sub_admin/model/sub_admin_model.dart'
    as sub_admin_model;
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/file_preview.dart';
import 'package:webapp/widgets/image_picker.dart';
import 'package:webapp/widgets/initial_textform.dart';
import 'package:webapp/widgets/profile_image.dart';
import 'package:webapp/widgets/search_drop_down_widget.dart';
import 'package:webapp/widgets/state_city_drop_down.dart';

class CommonSubAdminDialog {
  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    sub_admin_model.Datum? model,
    List<Map<String, dynamic>>? rolesModel,
    List<roles_model.Datum>? roles,
  }) async {
    final formKey = GlobalKey<FormState>();
    final bool isEdit = model != null;

    String name = model?.name ?? '';
    String phone = model?.mobileNumber ?? '';
    String email = model?.email ?? '';
    String password = '';

    String gender = model?.gender ?? 'Male';
    int? role;
    DateTime dob = model?.dateOfBirth ?? DateTime(2000);

    String state = model?.state ?? '';
    String city = model?.city ?? '';

    Map<String, dynamic>? selectedRole;
    if (isEdit && model.roleId != null && rolesModel != null) {
      selectedRole = rolesModel.firstWhere(
        (r) => r['id'] == model.roleId,
        orElse: () => {}, // return empty map if not found
      );
    }

    String getRoleName(int? roleId) {
      if (roleId == null) return '-';

      try {
        final role = roles!.firstWhere(
          (r) => r.id == roleId,
          orElse: () => roles_model.Datum(),
        );

        return role.name ?? '-';
      } catch (e) {
        return '-';
      }
    }

    // List<String> access = model?.access ?? [];
    bool status = model?.status == 1 ? true : true;

    String profileImage = model?.profileImage ?? '';
    String idImage = model?.docImg ?? '';
    bool? isIdProofError = false;
    bool? isprofileImageError = false;

    bool? isStateError = false;
    bool? isCityError = false;

    bool? isRoleError = false;

    Uint8List? pickedBytes;
    String? pickedPath;

    Uint8List? idProofBytes;
    String? idProofPath = model?.docImg;
    ;
    bool isPdf = false;

    Widget _uploadPlaceholder() {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.upload_file),
            SizedBox(width: 8),
            Text("Upload ID Proof"),
          ],
        ),
      );
    }

    InputDecoration _decoration(String label) => InputDecoration(
          labelText: label,
          labelStyle: fontFamilyMedium.size13.greyColor,
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
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () async {},
                          child: Center(
                            child: ProfileImageEdit(
                              isView: isEdit == true ? true : false,
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
                        if (isprofileImageError == true)
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              "Please upload profile image",
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
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
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      keyboardType: TextInputType.number,
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
                    DynamicSingleSearchDropdown(
                      items: [
                        "Male",
                        "Female",
                        "Others",
                      ],
                      selectedItem: gender,
                      onChanged: (v) => gender = v,
                      label: "Gender",
                      isError: false,
                      nameKey: "name",
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
                    StateCityDropdown(
                      showCity: true,
                      initialState: state.isEmpty ? null : state,
                      initialCity: city.isEmpty ? null : city,
                      isStateError: isStateError,
                      isCityError: isCityError,
                      onStateChanged: (states) {
                        model?.state = states;
                        state = states;
                      },
                      onCityChanged: (citys) {
                        model?.city = citys!;
                        city = citys!;
                      },
                      stateValidator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select a states";
                        }
                        isStateError = false;
                        return null;
                      },
                      cityValidator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Please select a city";
                        }
                        isCityError = false;
                        return null;
                      },
                    ),
                    verticalSpacing16,

                    /// ---------------- ID PROOF IMAGE ----------------
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final result =
                                await UniversalImagePicker.pickImageOrPdf();
                            if (result == null) return;

                            setState(() {
                              idProofBytes = result['bytes'] as Uint8List?;
                              idProofPath = result['path'] as String?;
                              if (idProofPath != null) {
                                isPdf =
                                    idProofPath!.toLowerCase().endsWith('.pdf');
                              }
                              print(idProofBytes);
                              print(idProofPath);
                              print(isPdf);
                            });
                          },
                          child: Container(
                              height: 80,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey),
                                color: Colors.grey.shade100,
                              ),
                              child: idProofBytes == null && idProofPath == null
                                  ? _uploadPlaceholder()
                                  : FilePreview(
                                      bytes: idProofBytes,
                                      path: idProofPath,
                                      isPdf: isPdf,
                                      isEdit: false,
                                      onRemove: () {
                                        setState(() {
                                          idProofBytes = null;
                                          idProofPath = null;
                                          isPdf = false;
                                        });
                                      },
                                    )),
                        ),
                        if (isIdProofError == true)
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              "Please upload ID proof",
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),

                    verticalSpacing16,

                    /// Access
                    DynamicSingleSearchDropdown(
                      label: "Role",
                      items: rolesModel ?? [],
                      selectedItem: selectedRole,
                      onChanged: (v) {
                        role = v['id']; // update the roleId
                        selectedRole = v; // update the selected map
                      },
                      isError: isRoleError,
                      nameKey: "name",
                    ),

                    // SwitchListTile(
                    //   title: const Text("Active"),
                    //   value: status,
                    //   onChanged: (v) => status = v,
                    // ),
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
                if (isEdit == false) {
                  if (pickedBytes == null &&
                      (pickedPath == null || pickedBytes!.isEmpty)) {
                    setState(() {
                      isprofileImageError = true;
                    });
                    return; // stop form submission
                  } else {
                    setState(() {
                      isprofileImageError = false;
                    });
                  }
                }

                if (!formKey.currentState!.validate()) return;
                if (state.isEmpty) {
                  setState(() {
                    isStateError = true;
                  });
                  return;
                } else {
                  setState(() {
                    isStateError = false;
                  });
                }
                if (city.isEmpty) {
                  setState(() {
                    isCityError = true;
                  });
                  return;
                } else {
                  setState(() {
                    isCityError = false;
                  });
                }

                if (idProofBytes == null &&
                    (idProofPath == null || idProofPath!.isEmpty)) {
                  setState(() {
                    isIdProofError = true;
                  });
                  return; // stop form submission
                } else {
                  setState(() {
                    isIdProofError = false;
                  });
                }

                if (selectedRole == null) {
                  setState(() {
                    isRoleError = true;
                  });
                  return;
                } else {
                  setState(() {
                    isRoleError = false;
                  });
                }

                Navigator.pop(StackedService.navigatorKey!.currentContext!, {
                  "name": name,
                  "phone": phone,
                  "email": email,
                  "password": password.isEmpty ? null : password,
                  "gender": gender.toLowerCase(),
                  "dob": dob,
                  "state": state,
                  "city": city,
                  "roles": selectedRole!['id'],
                  "image": pickedBytes,
                  "existing_image": model?.profileImage,
                  "existing_doc": model?.docImg,
                  "idImage": idProofBytes,
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
