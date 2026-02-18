import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/add_company/widgets/add_edit_company_dialog.dart';
import 'package:webapp/ui/views/promote_projects/widgets/image_items.dart';
import 'package:webapp/widgets/drop_down_widget.dart';
import 'package:webapp/widgets/image_picker.dart';
import 'package:webapp/widgets/initial_textform.dart';
import 'package:webapp/widgets/search_drop_down_widget.dart';
import 'package:webapp/widgets/web_image_two.dart';
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
      final infId = initial.infId;

      if (infId != null) {
        selectedInfluencerIds = [infId];

        selectedInfluencers =
            allInfluencers.where((inf) => inf["id"] == infId).toList();

        isInfluencerSelected = true;
      }

      title = initial.priority?.toString();
      amount = initial.amount;
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

            Future<void> _pickImage() async {
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
                        /// ================= INFLUENCER DROPDOWN =================
                        buildField(
                          label: 'Influencer',
                          child: DynamicSingleSearchDropdown(
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
                            isError: !isInfluencerSelected,
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
                            readOnly: isReadOnly,
                            radius: 14,
                            keyboardType: TextInputType.number,
                            initialValue: initial?.amount?.toString() ?? "",
                            validator: (v) =>
                                v == null || v.isEmpty ? "Enter amount" : null,
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
                            readOnly: isReadOnly,
                            initialValue: initial?.priority?.toString() ?? "",
                            validator: (v) => v == null || v.isEmpty
                                ? "Enter Priority"
                                : null,
                            onSaved: (v) => title = v,
                          ),
                        ),

                        verticalSpacing20,

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
                            style: ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(continueButton)),
                            onPressed: _pickImage,
                            icon: Icon(
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
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(continueButton),
                    ),
                    onPressed: () {
                      if (selectedInfluencerIds.isEmpty) {
                        setDialogState(() {
                          isInfluencerSelected = false;
                        });
                        return;
                      }
                      if (!formKey.currentState!.validate()) return;

                      formKey.currentState!.save();

                      Navigator.pop(context, {
                        "priority": title,
                        "amount": amount,
                        if (imageItem != null) "image": imageItem,
                        if (imageItem?.url != null)
                          "existing_image": imageItem!.url,
                        "inf_id": selectedInfluencerIds.isNotEmpty
                            ? selectedInfluencerIds.first
                            : null,
                        if (initial != null) "id": initial.id
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
