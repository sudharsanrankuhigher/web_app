import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/add_company/model/company_model.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/initial_textform.dart';
import 'package:webapp/widgets/profile_image.dart';
import 'package:webapp/widgets/state_city_drop_down.dart';

class AddEditCompanyPage {
  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    CompanyModel? initial,
  }) async {
    String? stateValue = initial?.state;
    String? cityValue = initial?.city;

    bool isStateError = false;
    bool isCityError = false;

    bool isView = initial != null; // 👈 view mode if data exists
    bool isEdit = false;

    final formKey = GlobalKey<FormState>();

    return showDialog<Map<String, dynamic>>(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final bool isReadOnly = isView && !isEdit;

            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isView
                        ? "View Company"
                        : isEdit
                            ? "Edit Company"
                            : "Add Company",
                  ),
                  Row(
                    children: [
                      if (isView && !isEdit)
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            setDialogState(() {
                              isView = false;
                              isEdit = true;
                            });
                          },
                        ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),

              // ---------- CONTENT ----------
              content: Form(
                key: formKey,
                child: SizedBox(
                  width: 400,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IgnorePointer(
                          ignoring: isReadOnly,
                          child: ProfileImageEdit(
                            imageUrl: initial?.companyImage,
                            radius: 60,
                            onImageSelected: (_, __) {},
                          ),
                        ),

                        verticalSpacing10,

                        buildField(
                          label: 'Company Name',
                          child: InitialTextForm(
                            radius: 12,
                            readOnly: isReadOnly,
                            fillColor: white,
                            hintText: 'Company Name',
                            initialValue: initial?.companyName,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter company name'
                                : null,
                          ),
                        ),

                        verticalSpacing10,

                        buildField(
                          label: 'Client Name',
                          child: InitialTextForm(
                            readOnly: isReadOnly,
                            radius: 12,
                            fillColor: white,
                            hintText: 'Client Name',
                            initialValue: initial?.clientName,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter client name'
                                : null,
                          ),
                        ),

                        verticalSpacing10,

                        buildField(
                          label: 'Phone',
                          child: InitialTextForm(
                            readOnly: isReadOnly,
                            radius: 12,
                            fillColor: white,
                            hintText: 'Phone',
                            keyboardType: TextInputType.phone,
                            initialValue: initial?.phone,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter phone number'
                                : null,
                          ),
                        ),

                        verticalSpacing10,

                        buildField(
                          label: 'Alternative Phone',
                          child: InitialTextForm(
                            readOnly: isReadOnly,
                            radius: 12,
                            fillColor: white,
                            hintText: 'Alternative Phone',
                            keyboardType: TextInputType.phone,
                            initialValue: initial?.alterNativePhone,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter alternative phone number'
                                : null,
                          ),
                        ),

                        verticalSpacing10,

                        // -------- STATE & CITY --------
                        buildField(
                          label: 'State & City',
                          child: StateCityDropdown(
                            showCity: true,
                            initialState: stateValue,
                            initialCity: cityValue,
                            isStateError: isStateError,
                            isCityError: isCityError,
                            onStateChanged: (state) {
                              setDialogState(() {
                                stateValue = state;
                                cityValue = null;
                              });
                            },
                            onCityChanged: (city) {
                              cityValue = city;
                            },
                          ),
                        ),

                        verticalSpacing12,

                        buildField(
                          label: 'GST Number',
                          child: InitialTextForm(
                            radius: 12,
                            readOnly: isReadOnly,
                            fillColor: white,
                            hintText: 'GST Number',
                            initialValue: initial?.gstNo,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter GST number'
                                : null,
                          ),
                        ),

                        verticalSpacing10,

                        buildField(
                          label: 'Project Count',
                          child: InitialTextForm(
                            radius: 12,
                            readOnly: isReadOnly,
                            fillColor: white,
                            hintText: 'Project Count',
                            keyboardType: TextInputType.number,
                            initialValue: initial?.projectCount?.toString(),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter project count'
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ---------- ACTIONS ----------
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                if (!isReadOnly)
                  CommonButton(
                    width: 200,
                    buttonColor: continueButton,
                    margin: EdgeInsets.zero,
                    padding: defaultPadding4 - leftPadding4,
                    borderRadius: 10,
                    text: (initial == null ? "Save" : "Update"),
                    textStyle: fontFamilySemiBold.size13.white,
                    onTap: () {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }

                      if (stateValue == null || stateValue!.isEmpty) {
                        setDialogState(() => isStateError = true);
                        return;
                      }

                      if (cityValue == null || cityValue!.isEmpty) {
                        setDialogState(() => isCityError = true);
                        return;
                      }

                      Navigator.pop(context, {
                        "state": stateValue,
                        "city": cityValue,
                      });
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

Widget buildField({required String label, required Widget child}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 4),
      child,
    ],
  );
}
