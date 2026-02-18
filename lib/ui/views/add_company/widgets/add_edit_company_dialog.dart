import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webapp/core/helper/permission_helper.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/add_company/model/company_model.dart'
    as company_model;
import 'package:webapp/ui/views/influencers/widgets/icon_text_form_field.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/initial_textform.dart';
import 'package:webapp/widgets/profile_image.dart';
import 'package:webapp/widgets/state_city_drop_down.dart';

class AddEditCompanyPage {
  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    company_model.Datum? initial,
    vm,
  }) async {
    String? stateValue = initial?.state;
    String? cityValue = initial?.city;

    bool isStateError = false;
    bool isCityError = false;

    bool isView = initial != null; // 👈 view mode if data exists
    bool isEdit = false;

    Uint8List? pickedBytes;
    String? pickedPath;

    String? companyName;
    String? clientName;
    String? phone;
    String? altPhone;

    String? gstNo;
    String? projectCount;
    String? accountNo;
    String? holderName;
    String? ifscCode;
    String? upiId;

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
                      if (isView &&
                          !isEdit &&
                          PermissionHelper.instance.canEdit('company'))
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
                          child: Center(
                            child: ProfileImageEdit(
                              isView: isEdit &&
                                      PermissionHelper.instance
                                              .canEdit('company') ==
                                          true
                                  ? true
                                  : false,
                              imageUrl: initial?.companyImage,
                              imageBytes: pickedBytes,
                              imagePath: pickedPath,
                              onImageSelected: (bytes, path) {
                                setDialogState(() {
                                  pickedBytes = bytes;
                                  pickedPath = path;
                                });
                              },
                            ),
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
                            onSaved: (value) {
                              setDialogState(() {
                                companyName = value;
                              });
                            },
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
                            onSaved: (value) {
                              setDialogState(() {
                                clientName = value;
                              });
                            },
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
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            initialValue: initial?.phone,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter phone number'
                                : null,
                            onSaved: (value) {
                              setDialogState(() {
                                phone = value;
                              });
                            },
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
                            initialValue: initial?.altPhoneNo,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter alternative phone number'
                                : null,
                            onSaved: (value) {
                              setDialogState(() {
                                altPhone = value;
                              });
                            },
                          ),
                        ),

                        verticalSpacing10,

                        // -------- STATE & CITY --------
                        buildField(
                          label: 'State & City',
                          child: IgnorePointer(
                            ignoring: isReadOnly,
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
                            onSaved: (value) {
                              setDialogState(() {
                                gstNo = value;
                              });
                            },
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
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            initialValue: initial?.projectCount?.toString(),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter project count'
                                : null,
                            onSaved: (value) {
                              setDialogState(() {
                                projectCount = value;
                              });
                            },
                          ),
                        ),

                        const Text("Bank Details",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        verticalSpacing16,

                        buildField(
                          label: 'Account number',
                          child: InitialTextForm(
                            radius: 12,
                            readOnly: isReadOnly,
                            fillColor: white,
                            hintText: 'Account number',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(20),
                            ],
                            initialValue: initial?.bankDetails != null &&
                                    initial!.bankDetails != null
                                ? initial.bankDetails!.accountNo?.toString()
                                : null,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter Account number'
                                : null,
                            onSaved: (value) {
                              setDialogState(() {
                                accountNo = value;
                              });
                            },
                          ),
                        ),
                        verticalSpacing10,
                        buildField(
                          label: 'Account Holder Name',
                          child: InitialTextForm(
                            radius: 12,
                            readOnly: isReadOnly,
                            fillColor: white,
                            hintText: 'Account Holder Name',
                            initialValue: initial?.bankDetails != null
                                ? initial?.bankDetails!.accountName?.toString()
                                : null,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter Account Holder Name'
                                : null,
                            onSaved: (value) {
                              setDialogState(() {
                                holderName = value;
                              });
                            },
                          ),
                        ),
                        horizontalSpacing12,
                        buildField(
                          label: 'IFSC Code',
                          child: InitialTextForm(
                            radius: 12,
                            readOnly: isReadOnly,
                            fillColor: white,
                            hintText: 'Enter IFSC code',
                            initialValue: initial?.bankDetails != null
                                ? initial!.bankDetails!.ifscCode?.toString()
                                : null,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter IFSC code'
                                : null,
                            onSaved: (value) {
                              setDialogState(() {
                                ifscCode = value;
                              });
                            },
                          ),
                        ),
                        verticalSpacing12,
                        buildField(
                          label: 'Upi id',
                          child: InitialTextForm(
                            radius: 12,
                            readOnly: isReadOnly,
                            fillColor: white,
                            hintText: 'upi id',
                            initialValue: initial?.bankDetails != null
                                ? initial?.bankDetails!.upi?.toString()
                                : null,
                            // validator: (value) => value == null || value.isEmpty
                            //     ? 'Please enter upi id'
                            //     : null,
                            onSaved: (value) {
                              setDialogState(() {
                                upiId = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
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
                    padding: defaultPadding8 - leftPadding4,
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
                      formKey.currentState!.save();
                      Navigator.pop(context, {
                        "state": stateValue,
                        "city": cityValue,
                        "companyName": companyName,
                        "clientName": clientName,
                        "phone": phone,
                        "altPhone": altPhone,
                        "gstNo": gstNo,
                        "projectCount": projectCount,
                        "imageBytes": pickedBytes,
                        if (pickedBytes == null)
                          "existing_image": initial?.companyImage,
                        "bank_details": {
                          "account_no": accountNo,
                          "holder_name": holderName,
                          "ifsc_code": ifscCode,
                          if (upiId != null) "upi_id": upiId
                        }
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
