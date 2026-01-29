import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/promote_projects/model/promote_project_model.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/drop_down_widget.dart';
import 'package:webapp/widgets/image_picker.dart';
import 'package:webapp/widgets/initial_textform.dart';
import 'package:webapp/widgets/search_drop_down_widget.dart';
import 'package:webapp/widgets/state_city_drop_down.dart';
import 'package:webapp/widgets/web_image_loading.dart';
import 'package:webapp/ui/views/influencers/model/influencers_model.dart'
    as influencer_model;

class ProjectDetailsDialog extends StatefulWidget {
  final ProjectModel model;
  final bool isEdit;
  final ValueChanged<dynamic>? onSave;
  final List<influencer_model.Datum>? influencers;

  const ProjectDetailsDialog({
    super.key,
    required this.model,
    this.isEdit = false,
    this.influencers,
    this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    required ProjectModel model,
    bool isEdit = false,
    ValueChanged<dynamic>? onSave,
    List<influencer_model.Datum>? influencers,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ProjectDetailsDialog(
        model: model,
        isEdit: isEdit,
        onSave: onSave,
        influencers: influencers,
      ),
    );
  }

  @override
  State<ProjectDetailsDialog> createState() => _ProjectDetailsDialogState();
}

class _ProjectDetailsDialogState extends State<ProjectDetailsDialog> {
  int selectedImageIndex = 0;
  bool isView = false;
  bool isEdit = false;

  bool isInfluencerSelected = false;
  bool isStateError = false;
  bool isCityError = false;
  bool isGenderError = false;
  bool isImageError = false;

  late TextEditingController codeCtrl;
  late TextEditingController companyCtrl;
  late TextEditingController serviceCtrl;
  late TextEditingController noteCtrl;
  late TextEditingController paymentCtrl;
  late TextEditingController commissionCtrl;

  late String gender;
  late String state = "Tamil Nadu";
  late String city = "Coimbatore";

  late List<String> images;

  final List<String> genders = ['Male', 'Female', 'Other'];
  final ScrollController thumbnailScrollController = ScrollController();

  final List<String> influencerOptions = [
    'Influencer 0',
    'Influencer 1',
    'Influencer 2',
    'Influencer 3',
    'Influencer 4',
  ];

  List<dynamic> selectedInfluencers = [];
  List<dynamic> selectedInfluencerIds = [];

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    isView = !widget.isEdit;

    codeCtrl = TextEditingController(text: widget.model.projectCode);
    companyCtrl = TextEditingController(text: widget.model.companyName);
    serviceCtrl = TextEditingController(text: widget.model.service);
    noteCtrl = TextEditingController(text: widget.model.note);
    paymentCtrl = TextEditingController(text: widget.model.payment.toString());
    commissionCtrl =
        TextEditingController(text: widget.model.commission.toString());

    gender = widget.model.gender ?? genders.first;
    state = widget.model.state;
    city = widget.model.city;

    if (widget.influencers != null &&
        widget.model.influencers != null &&
        widget.model.influencers!.isNotEmpty) {
      final List<int> influencerIds =
          widget.model.influencers!.map((e) => e['id'] as int).toList();

      selectedInfluencers = widget.influencers!
          .where((influencer_model.Datum influencer) =>
              influencerIds.contains(influencer.id))
          .map((influencer_model.Datum influencer) => {
                'id': influencer.id,
                'name': influencer.name,
              })
          .toList();
      print("selectedInfluencers: $selectedInfluencers");

      selectedInfluencerIds =
          selectedInfluencers.map((e) => e['id'] as int).toList();
    }

    images = List.from(widget.model.projectImages);

    // Default to 10th image if available
    if (images.length > 9) {
      selectedImageIndex = 9;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        thumbnailScrollController.animateTo(
          9 * (80 + 8), // thumbnail width + spacing
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: SizedBox(
        width: 700,
        height: 650,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isView
                        ? 'View Project'
                        : isEdit == true
                            ? 'Edit Project'
                            : 'Add Project',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Row(
                    children: [
                      if (isView)
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              isView = false;
                              isEdit = true;
                            });
                          },
                        ),
                      // if (isView)
                      //   IconButton(
                      //     icon: const Icon(Icons.delete, color: Colors.red),
                      //     onPressed: () => Navigator.pop(context, 'delete'),
                      //   ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              /// MAIN CONTENT
              Expanded(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// LEFT: Image Section
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            /// MAIN IMAGE
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: images.isEmpty
                                    ? const Center(child: Text('No Image'))
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: buildImage(
                                            images[selectedImageIndex]),
                                      ),
                              ),
                            ),

                            verticalSpacing12,
                            if (isImageError == true)
                              const Padding(
                                padding: EdgeInsets.only(top: 4),
                                child: Text(
                                  "Please upload atleast one image",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                          ],
                        ),
                      ),

                      verticalSpacing12,

                      /// RIGHT: Form Section
                      Expanded(
                        flex: 6,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// THUMBNAILS
                              SizedBox(
                                height: 80,
                                child: ListView.separated(
                                  controller: thumbnailScrollController,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: images.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 8),
                                  itemBuilder: (_, index) {
                                    final selected =
                                        index == selectedImageIndex;

                                    return Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedImageIndex = index;
                                            });
                                          },
                                          child: Container(
                                            width: 80,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: selected
                                                    ? Colors.blue
                                                    : Colors.grey,
                                                width: selected ? 2 : 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: buildImage(images[index]),
                                            ),
                                          ),
                                        ),

                                        /// ❌ REMOVE ICON
                                        if (!isView) // hide remove in view mode
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  images.removeAt(index);

                                                  // Fix selected index
                                                  if (selectedImageIndex >=
                                                      images.length) {
                                                    selectedImageIndex =
                                                        images.isEmpty
                                                            ? 0
                                                            : images.length - 1;
                                                  }
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  size: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ),

                              verticalSpacing16,
                              ElevatedButton.icon(
                                onPressed: isView ? null : _pickImages,
                                icon: const Icon(Icons.upload),
                                label: const Text('Upload Image'),
                              ),

                              /// Project Code & Company
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildField(
                                      label: 'Project Code',
                                      child: InitialTextForm(
                                        radius: 10,
                                        controller: codeCtrl,
                                        hintText: 'Project Code',
                                        readOnly: isView,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Project Code is required';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildField(
                                      label: 'Company Name',
                                      child: InitialTextForm(
                                        radius: 10,
                                        controller: companyCtrl,
                                        hintText: 'Company',
                                        readOnly: isView,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Company Name is required';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              verticalSpacing12,
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildField(
                                      label: 'Project Title',
                                      child: InitialTextForm(
                                        radius: 10,
                                        controller: codeCtrl,
                                        hintText: 'Project Title',
                                        readOnly: isView,
                                        validator: (val) {
                                          if (val == null || val.isEmpty) {
                                            return 'Project Title is required';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildField(
                                      label: 'Influencers',
                                      child: DynamicMultiSearchDropdown(
                                        label: 'Influencers',
                                        selectedItems: selectedInfluencers,
                                        items: (widget.influencers ?? [])
                                            .map((e) => {
                                                  'id': e.id,
                                                  'name': e.name,
                                                })
                                            .toList(),
                                        onChanged: isView
                                            ? (_) {} // 🔒 view mode
                                            : (values) {
                                                setState(() {
                                                  selectedInfluencers = values;
                                                  selectedInfluencerIds = values
                                                      .map((e) => e['id'])
                                                      .toList();
                                                });

                                                debugPrint(
                                                    "Selected Influencer IDs: $selectedInfluencerIds");
                                              },
                                        isError: isInfluencerSelected,
                                        errorText:
                                            "Please select at least one influencer",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              verticalSpacing12,

                              /// Gender & Service
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildField(
                                      label: 'Gender',
                                      child: DynamicSingleSearchDropdown(
                                        items: [
                                          "Male",
                                          "Female",
                                          "Others",
                                        ],
                                        selectedItem: gender,
                                        onChanged: (v) => gender = v,
                                        label: "Gender",
                                        isError: isGenderError,
                                        nameKey: "name",
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildField(
                                      label: 'Service',
                                      child: InitialTextForm(
                                        radius: 10,
                                        controller: serviceCtrl,
                                        hintText: 'Service',
                                        readOnly: isView,
                                        validator: (val) {
                                          if (val == null || val.isEmpty) {
                                            return 'Service is required';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              /// Location (FULL WIDTH)
                              IgnorePointer(
                                ignoring: isView,
                                child: _buildField(
                                  label: 'Location',
                                  child: StateCityDropdown(
                                    isVertical: true,
                                    showCity: true,
                                    initialState: state,
                                    initialCity: city,
                                    isStateError: isStateError,
                                    isCityError: isCityError,
                                    onStateChanged: (val) => state = val,
                                    onCityChanged: (val) => city = val ?? '',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              /// Payment & Commission
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildField(
                                      label: 'Payment',
                                      child: InitialTextForm(
                                        radius: 10,
                                        controller: paymentCtrl,
                                        hintText: 'Payment',
                                        readOnly: isView,
                                        keyboardType: TextInputType.number,
                                        validator: (val) {
                                          if (val == null || val.isEmpty) {
                                            return 'Payment is required';
                                          } else if (paymentCtrl.text == "0") {
                                            return 'Payment cannot be 0';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildField(
                                      label: 'Commission',
                                      child: InitialTextForm(
                                        radius: 10,
                                        controller: commissionCtrl,
                                        hintText: 'Commission',
                                        readOnly: isView,
                                        keyboardType: TextInputType.number,
                                        validator: (val) {
                                          if (val == null || val.isEmpty) {
                                            return 'Commission is required';
                                          } else if (commissionCtrl.text ==
                                              "0") {
                                            return 'Commission cannot be 0';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              /// Description (FULL WIDTH)
                              _buildField(
                                label: 'Description',
                                child: InitialTextForm(
                                  radius: 10,
                                  controller: noteCtrl,
                                  hintText: 'Description',
                                  readOnly: isView,
                                  maxLines: 4,
                                ),
                              ),

                              const SizedBox(height: 16),

                              /// ACTION BUTTONS
                              if (!isView)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CommonButton(
                                      text: 'Save',
                                      buttonColor: continueButton,
                                      onTap: _save,
                                      padding: defaultPadding8 +
                                          rightPadding8 +
                                          leftPadding8,
                                      textStyle:
                                          fontFamilySemiBold.size14.white,
                                    )
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    if (images.length >= 10) return;

    final result = await UniversalImagePicker.pickImage();
    if (result == null) return;

    setState(() {
      // MOBILE
      if (result['path'] != null && !kIsWeb) {
        images.add(result['path']);
      }
      // WEB
      else if (result['bytes'] != null && kIsWeb) {
        images.add(
          base64Encode(result['bytes']),
        );
      }

      selectedImageIndex = images.length - 1;
    });
  }

  Widget _buildField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        child,
      ],
    );
  }

  Widget buildImage(
    String pathOrData, {
    double width = double.infinity,
    double height = double.infinity,
    BoxFit fit = BoxFit.cover,
  }) {
    bool isBase64(String value) {
      final base64Regex = RegExp(r'^[A-Za-z0-9+/=]+$');
      return base64Regex.hasMatch(value) && value.length % 4 == 0;
    }

    // ===================== WEB =====================
    if (kIsWeb) {
      // ✅ HTTP images → use HtmlElementView (WebImage)
      if (pathOrData.startsWith('http')) {
        return WebImage(
          imageUrl: pathOrData,
          width: width,
          height: height,
          fit: fit,
        );
      }

      // ✅ Base64 images
      if (isBase64(pathOrData)) {
        try {
          return Image.memory(
            base64Decode(pathOrData),
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.broken_image, color: Colors.red),
          );
        } catch (_) {
          return const Icon(Icons.broken_image, color: Colors.red);
        }
      }

      // ❌ Unsupported web format
      return const Icon(Icons.image_not_supported, color: Colors.grey);
    }

    // ===================== MOBILE =====================
    if (pathOrData.startsWith('http')) {
      return Image.network(
        pathOrData,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.broken_image, color: Colors.red),
      );
    }

    return Image.file(
      File(pathOrData),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.broken_image, color: Colors.red),
    );
  }

  void _save() {
    final isFormValid = formKey.currentState!.validate();

    setState(() {
      isInfluencerSelected = selectedInfluencerIds.isEmpty;
      isStateError = state.isEmpty;
      isCityError = city.isEmpty;
      isGenderError = gender.isEmpty;
      isImageError = images.isEmpty;
    });

    // ❌ Stop if any validation fails
    if (!isFormValid ||
        isInfluencerSelected ||
        isStateError ||
        isCityError ||
        isGenderError ||
        isImageError) {
      return;
    }

    final updated = {
      "projectCode": codeCtrl.text,
      "companyName": companyCtrl.text,
      "service": serviceCtrl.text,
      "gender": gender,
      "state": state,
      "city": city,
      "payment": double.tryParse(paymentCtrl.text) ?? 0,
      "commission": double.tryParse(commissionCtrl.text) ?? 0,
      "note": noteCtrl.text,
      "projectImages": images,
      "selectedInfluencerIds": selectedInfluencerIds,
    };

    widget.onSave?.call(updated);
    Navigator.pop(context);
  }
}
