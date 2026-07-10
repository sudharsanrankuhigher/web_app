import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webapp/core/helper/permission_helper.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/add_company/widgets/add_edit_company_dialog.dart';
import 'package:webapp/ui/views/promote_projects/widgets/image_items.dart';
import 'package:webapp/widgets/dob_field.dart';
import 'package:webapp/widgets/image_picker.dart';
import 'package:webapp/widgets/initial_textform.dart';
import 'package:webapp/widgets/label_text.dart';
import 'package:webapp/widgets/search_drop_down_widget.dart';
import 'package:webapp/widgets/web_image_two.dart';
import 'package:webapp/widgets/state_city_drop_down.dart';
import 'package:webapp/ui/views/influencers/model/influencers_model.dart'
    as influencer_model;
import 'package:webapp/ui/views/banner/model/all_banner_model.dart'
    as banner_model;

class AddEditBannerDialog {
  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    banner_model.Datum? initial,
    final List<influencer_model.Datum>? influencers,
    bool isView = false,
  }) async {
    bool isEdit = false;

    String? title;
    String? amount;
    bool isPromote = false;

    DateTime? startDate = DateTime.now();
    String? startDateString;
    bool? startDateError = false;
    DateTime? endDate = DateTime.now().add(const Duration(days: 3));
    String? endDateString;
    bool? endDateError = false;

    String? stateValue;
    String? cityValue;
    bool isStateError = false;
    bool isCityError = false;

    final formKey = GlobalKey<FormState>();

    ImageItem? imageItem;

    bool isInfluencerSelected = true;

    List<Map<String, dynamic>> allInfluencers = [];
    List<Map<String, dynamic>> filteredInfluencers = [];

    List<Map<String, dynamic>> selectedInfluencers = [];
    List<int> selectedInfluencerIds = [];

    /// ================= PREPARE INFLUENCERS =================
    if (influencers != null) {
      allInfluencers = influencers
          .map((e) => {
                "id": e.id,
                "name": e.name,
                "image": e.image,
              })
          .toList();

      filteredInfluencers = List.from(allInfluencers);
    }

    /// ================= PRESELECT (EDIT MODE) =================
    if (initial != null) {
      isPromote = initial.isPromote ?? false;

      final infId = initial.infId;

      if (infId != null) {
        selectedInfluencerIds = [infId];

        selectedInfluencers =
            allInfluencers.where((inf) => inf["id"] == infId).toList();

        isInfluencerSelected = true;
      }

      title = initial.priority?.toString();
      amount = initial.amount;
      stateValue = initial.state;
      cityValue = initial.city;
    }

    /// ================= LOAD INITIAL IMAGE =================
    if (initial != null && initial.image != null) {
      imageItem = ImageItem(
        url: initial.image,
      );
    }

    return showDialog<Map<String, dynamic>>(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final bool isReadOnly = isView && !isEdit;

            Future<void> pickImage() async {
              final result = await UniversalImagePicker.pickImage();
              if (result == null) return;

              ImageItem? picked;

              if (kIsWeb) {
                final bytes = result['bytes'];
                if (bytes is Uint8List && bytes.isNotEmpty) {
                  picked = ImageItem(bytes: bytes);
                }
              } else {
                final path = result['path'];
                if (path is String && path.isNotEmpty) {
                  picked = ImageItem(path: path);
                }
              }

              if (picked == null) return;

              setDialogState(() {
                imageItem = picked;
              });
            }

            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isView
                        ? "View Banner"
                        : isEdit
                            ? "Edit Banner"
                            : "Add Banner",
                  ),
                  Row(
                    children: [
                      if (PermissionHelper.instance.canEdit('banner'))
                        if (isView && !isEdit)
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              setDialogState(() {
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

              // ================= CONTENT =================
              content: Form(
                key: formKey,
                child: SizedBox(
                  width: 450,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// PROMOTE TOGGLE
                        SwitchListTile(
                          title: Text(
                            "Promote",
                            style: fontFamilyMedium.size13.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          value: isPromote,
                          activeThumbColor: continueButton,
                          contentPadding: EdgeInsets.zero,
                          onChanged: isReadOnly
                              ? null
                              : (val) {
                                  setDialogState(() {
                                    isPromote = val;
                                  });
                                },
                        ),

                        verticalSpacing20,

                        /// ================= INFLUENCER DROPDOWN =================
                        buildField(
                          label: 'Influencer',
                          child: DynamicSingleSearchDropdown(
                            enabled: !isReadOnly && !isPromote,
                            label: 'Influencers',
                            items: filteredInfluencers,
                            selectedItem: selectedInfluencers.isNotEmpty
                                ? selectedInfluencers.first
                                : null,
                            onChanged: (value) {
                              setDialogState(() {
                                if (value != null) {
                                  selectedInfluencers = [
                                    value
                                  ]; // wrap inside list
                                  selectedInfluencerIds = [value["id"] as int];
                                  isInfluencerSelected = true;
                                } else {
                                  selectedInfluencers = [];
                                  selectedInfluencerIds = [];
                                  isInfluencerSelected = false;
                                }
                              });
                            },
                            isError: !isPromote && !isInfluencerSelected,
                            errorText: "Please select an influencer",
                          ),
                        ),

                        verticalSpacing20,

                        /// AMOUNT
                        buildField(
                          label: 'Amount',
                          child: InitialTextForm(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            readOnly: isReadOnly || isPromote,
                            radius: 14,
                            keyboardType: TextInputType.number,
                            initialValue: initial?.amount?.toString() ?? "",
                            validator: (v) {
                              if (isPromote) return null;
                              return v == null || v.isEmpty
                                  ? "Enter amount"
                                  : null;
                            },
                            onSaved: (v) => amount = v,
                          ),
                        ),

                        verticalSpacing20,

                        /// Priority count
                        buildField(
                          label: 'Priority count',
                          child: InitialTextForm(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            radius: 14,
                            hintText: 'Priority count',
                            readOnly: isReadOnly || isPromote,
                            initialValue: title,
                            validator: (v) {
                              if (isPromote) return null;
                              if (v == null || v.isEmpty) {
                                return "Enter Priority";
                              }
                              if (v == "1") {
                                return "Priority cannot be 1";
                              }
                              return null;
                            },
                            onSaved: (v) => title = v,
                          ),
                        ),

                        verticalSpacing20,

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
                                  isStateError = false;
                                });
                              },
                              onCityChanged: (city) {
                                setDialogState(() {
                                  cityValue = city;
                                  isCityError = false;
                                });
                              },
                            ),
                          ),
                        ),

                        verticalSpacing20,

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const IconTextLabel(
                              icon: Icons.calendar_month,
                              text: "Start Date",
                              iconColor: Colors.black,
                              textColor: Colors.black,
                              iconSize: 16,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            verticalSpacing10,
                            DOBField(
                              label: "Start Date",
                              selectedDate: startDate ?? DateTime.now(),
                              isError: startDateError ?? false,
                              fistDate: DateTime.now(),
                              lastdate: DateTime(2100),
                              onDateSelected: (date) {
                                setDialogState(() {
                                  startDateString = "${date.year}"
                                      "${date.month.toString().padLeft(2, '0')}-"
                                      "${date.day.toString().padLeft(2, '0')}-";
                                  startDate = date;
                                  print(startDate);
                                  startDateError = false;
                                });
                              },
                            )
                          ],
                        ),
                        verticalSpacing16,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const IconTextLabel(
                              icon: Icons.calendar_month,
                              text: "End Date",
                              iconColor: Colors.black,
                              textColor: Colors.black,
                              iconSize: 16,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            verticalSpacing10,
                            DOBField(
                              label: "End Date",
                              fistDate:
                                  DateTime.now().add(const Duration(days: 3)),
                              lastdate: DateTime(2100),
                              selectedDate: endDate ??
                                  DateTime.now().add(const Duration(days: 3)),
                              isError: endDateError ?? false,
                              onDateSelected: (date) {
                                setDialogState(() {
                                  endDateString = "${date.year}"
                                      "${date.month.toString().padLeft(2, '0')}-"
                                      "${date.day.toString().padLeft(2, '0')}-";
                                  endDate = date;
                                  endDateError = false;
                                });
                              },
                            )
                          ],
                        ),
                        verticalSpacing16,

                        /// IMAGE PREVIEW
                        if (imageItem != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: buildImage(
                              imageItem!,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text("No Image Selected"),
                            ),
                          ),

                        const SizedBox(height: 12),

                        /// UPLOAD BUTTON
                        if (!isReadOnly)
                          ElevatedButton.icon(
                            style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(continueButton)),
                            onPressed: pickImage,
                            icon: const Icon(
                              Icons.image,
                              color: white,
                            ),
                            label: Text(
                              "Upload Banner Image",
                              style: fontFamilySemiBold.size13.white,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // ================= ACTIONS =================
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                if (!isReadOnly)
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(continueButton),
                    ),
                    onPressed: () {
                      if (!isPromote && selectedInfluencerIds.isEmpty) {
                        setDialogState(() {
                          isInfluencerSelected = false;
                        });
                        return;
                      }
                      if (!formKey.currentState!.validate()) return;

                      if (stateValue == null || stateValue!.isEmpty) {
                        setDialogState(() => isStateError = true);
                        return;
                      }

                      if (cityValue == null || cityValue!.isEmpty) {
                        setDialogState(() => isCityError = true);
                        return;
                      }

                      formKey.currentState!.save();

                      if (isPromote) {
                        title = "1";
                      }

                      Navigator.pop(context, {
                        "is_promote": isPromote,
                        "priority": isPromote ? "1" : title,
                        "amount": isPromote ? null : amount,
                        if (imageItem != null) "image": imageItem,
                        if (imageItem?.url != null)
                          "existing_image": imageItem!.url,
                        "inf_id":
                            (!isPromote && selectedInfluencerIds.isNotEmpty)
                                ? selectedInfluencerIds.first
                                : null,
                        if (initial != null) "id": initial.id,
                        "start_date": startDate,
                        "end_date": endDate,
                        "state": stateValue,
                        "city": cityValue,
                      });
                    },
                    child: Text(
                      initial == null ? "Save" : "Update",
                      style: fontFamilySemiBold.size13.white,
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  /// ================= IMAGE BUILDER =================
  static Widget buildImage(ImageItem item,
      {double? width, double? height, BoxFit fit = BoxFit.cover}) {
    if (item.isNetwork && item.url != null) {
      return WebImageTwo(
        imageUrl: item.url!,
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        fit: BoxFit.cover,
      );
    }

    if (item.isWeb && item.bytes != null) {
      return Image.memory(
        item.bytes!,
        width: width ?? double.infinity,
        height: height ?? 400,
        fit: fit,
      );
    }

    if (item.isFile && item.path != null) {
      return Image.file(
        File(item.path!),
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        fit: fit,
      );
    }

    return const Icon(Icons.image_not_supported, color: Colors.grey);
  }
}
