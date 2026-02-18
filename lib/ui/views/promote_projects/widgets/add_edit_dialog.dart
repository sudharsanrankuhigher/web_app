import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webapp/core/helper/dialog_state.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/promote_projects/model/promote_project_model.dart'
    as project_model;
import 'package:webapp/ui/views/promote_projects/widgets/image_items.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/drop_down_widget.dart';
import 'package:webapp/widgets/image_picker.dart';
import 'package:webapp/widgets/initial_textform.dart';
import 'package:webapp/widgets/search_drop_down_widget.dart';
import 'package:webapp/widgets/state_city_drop_down.dart';
import 'package:webapp/widgets/web_image_loading.dart';
import 'package:webapp/ui/views/influencers/model/influencers_model.dart'
    as influencer_model;
import 'package:webapp/ui/views/services/model/service_model.dart'
    as service_model;
import 'package:webapp/ui/views/add_company/model/company_model.dart'
    as company_model;
import 'package:webapp/widgets/web_image_two.dart';

class ProjectDetailsDialog extends StatefulWidget {
  final project_model.Message model;
  final bool isEdit;
  final ValueChanged<Map<String, dynamic>>? onSave;
  final List<influencer_model.Datum>? influencers;
  final List<service_model.Datum>? service;
  final List<company_model.Datum>? companies;

  const ProjectDetailsDialog(
      {super.key,
      required this.model,
      this.isEdit = false,
      this.influencers,
      this.onSave,
      this.service,
      this.companies});

  static Future<void> show(
    BuildContext context, {
    required project_model.Message model,
    bool isEdit = false,
    ValueChanged<Map<String, dynamic>>? onSave, // ✅
    List<influencer_model.Datum>? influencers,
    List<service_model.Datum>? service,
    List<company_model.Datum>? companies,
  }) {
    Map<String, dynamic>? selectedCompany;
    print("model.companyId: ${model.id}");
    if (isEdit && model.companyId != null && companies != null) {
      final company = companies.firstWhere(
        (c) => c.id.toString() == model.companyId.toString(),
        orElse: () => company_model.Datum(),
      );

      selectedCompany = {
        'id': company.id,
        'name': company.companyName,
      };
    }

    DialogState.isDialogOpen = true;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ProjectDetailsDialog(
        model: model,
        isEdit: isEdit,
        onSave: onSave,
        influencers: influencers,
        companies: companies,
        service: service,
      ),
    ).then((_) {
      DialogState.isDialogOpen = false;
    });
  }

  @override
  State<ProjectDetailsDialog> createState() => _ProjectDetailsDialogState();
}

class _ProjectDetailsDialogState extends State<ProjectDetailsDialog> {
  int selectedImageIndex = 0;
  bool isView = false;
  bool isEdit = false;
  bool formSubmitted = false;

  bool isInfluencerSelected = false;
  bool isStateError = false;
  bool isCityError = false;
  bool isGenderError = false;
  bool isImageError = false;

  bool instagram = false;
  bool facebook = false;
  bool youtube = false;
  bool allInfluencersSelected = false;

  String? checkboxError;

  late TextEditingController codeCtrl;
  late TextEditingController titleCtrl;
  late TextEditingController companyCtrl;
  late TextEditingController noteCtrl;
  late TextEditingController paymentCtrl;
  late TextEditingController commissionCtrl;

  late String gender;
  late String state = "Tamil Nadu";
  late String city = "Coimbatore";

  late List<ImageItem> images;

  final List<String> genders = ['Male', 'Female', 'Other'];
  final ScrollController thumbnailScrollController = ScrollController();

  List<dynamic> selectedInfluencers = [];
  List<dynamic> selectedInfluencerIds = [];

  List<Map<String, dynamic>> allInfluencers = [];
  List<Map<String, dynamic>> filteredInfluencers = [];

  int? serviceId;
  int? companyId;

  Map<String, dynamic>? selectedCompany;
  bool isCompanyError = false;

  List<dynamic> selectedServices = [];
  List<dynamic> selectedService = [];

  final formKey = GlobalKey<FormState>();

  void _filterInfluencers() {
    if (allInfluencersSelected) {
      filteredInfluencers = List.from(allInfluencers);
    } else {
      filteredInfluencers = allInfluencers.where((inf) {
        // 🔹 State filter
        if (state.isNotEmpty && inf['state'] != null && inf['state'] != state) {
          return false;
        }

        // 🔹 City filter
        if (city.isNotEmpty && inf['city'] != null && inf['city'] != city) {
          return false;
        }

        // 🔹 Services filter
        if (selectedService.isNotEmpty) {
          final List<int> influencerServices =
              List<int>.from(inf['services'] ?? []);

          final bool hasMatch =
              selectedService.any((id) => influencerServices.contains(id));

          if (!hasMatch) return false;
        }

        return true;
      }).toList();
    }

    // ❗ Remove invalid selected influencers
    selectedInfluencers = selectedInfluencers
        .where((s) => filteredInfluencers.any((f) => f['id'] == s['id']))
        .toList();

    selectedInfluencerIds = selectedInfluencers.map((e) => e['id']).toList();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    isView = !widget.isEdit;

    codeCtrl = TextEditingController(text: widget.model.projectCode);
    titleCtrl = TextEditingController(text: widget.model.projectName);
    companyCtrl = TextEditingController(text: widget.model.companyName);
    noteCtrl = TextEditingController(text: widget.model.description);
    paymentCtrl = TextEditingController(
        text: widget.model.payment?.payment?.toString() ?? "0");
    commissionCtrl = TextEditingController(
        text: widget.model.payment?.commission?.toString() ?? "0");

    gender = widget.model.gender ?? genders.first;
    state = widget.model.state ?? "Tamil Nadu";
    city = widget.model.city ?? "Coimbatore";
    instagram = (widget.model.link != null)
        ? widget.model.link!.instagram == null
            ? false
            : true
        : false;
    facebook = (widget.model.link != null)
        ? widget.model.link!.facebook == null
            ? false
            : true
        : false;
    youtube = (widget.model.link != null)
        ? widget.model.link!.youtube == null
            ? false
            : true
        : false;

    if (widget.influencers != null &&
        widget.model.influencers != null &&
        widget.model.influencers!.isNotEmpty) {
      final List<int> influencerIds =
          widget.model.influencers!.map((e) => e.id as int).toList();

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

    if (widget.influencers != null) {
      allInfluencers = widget.influencers!
          .map((e) => {
                'id': e.id,
                'name': e.name,
                // 'gender': e.gender,
                'state': e.state,
                'city': e.city,
                'services': e.service, // must be List<int>
                'image': e.image,
              })
          .toList();

      filteredInfluencers = List.from(allInfluencers);
      print("test filteredInfluencers: ${filteredInfluencers}");
    }

    if (widget.model.service != null && widget.service != null) {
      List<int> influencerServiceIds = [];

      final rawService = widget.model.service;

      if (rawService is String && rawService!.isNotEmpty) {
        // Case 1: stored as JSON string
        influencerServiceIds = List<int>.from(jsonDecode(rawService as String));
      } else if (rawService is List) {
        // Case 2: already a List
        influencerServiceIds =
            rawService!.map((e) => int.parse(e.toString())).toList();
      }

      selectedServices = widget.service!
          .where((s) => influencerServiceIds.contains(s.id))
          .map((s) => {
                'id': s.id,
                'name': s.name,
              })
          .toList();

      selectedService = selectedServices.map((e) => e['id']).toList();
    }

    if (widget.model.companyId != null && widget.companies != null) {
      final company = widget.companies!.firstWhere(
        (c) => c.id == int.tryParse(widget.model.companyId.toString() ?? '0'),
        orElse: () => company_model.Datum(),
      );

      selectedCompany = {
        'id': company.id,
        'name': company.companyName,
      };

      companyId = company.id;
    }
    images = [];

    // If you already have API images
    if (widget.model.image != null) {
      // images = widget.model.image!
      //     .where((e) => e.image != null && e.image!.isNotEmpty)

      //     .map((e) => ImageItem(url: e.image!)) // String URL

      //     .toList();
      images = widget.model.image!
          .where((e) => e.image != null && e.image!.isNotEmpty)
          .map((e) {
        print(e.image); // ✅ valid here
        return ImageItem(url: e.image!);
      }).toList();
      print(images);
    }
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: disableColor,
          width: 700,
          height: 650,
          child: Stack(
            children: [
              WebImage(
                imageUrl: "https://dummyimage.com/600x400/eeeeee/eeeeee.png",
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width * 0.9,
                fit: BoxFit.cover,
              ),
              Padding(
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
                                          ? const Center(
                                              child: Text('No Image'))
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    child: IgnorePointer(
                                                      child: buildImage(
                                                        images[index],
                                                      ),
                                                    ),
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
                                                                  : images.length -
                                                                      1;
                                                        }
                                                      });
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4),
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
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Project Code is required';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        horizontalSpacing12,
                                        Expanded(
                                            child: IgnorePointer(
                                          ignoring: isView,
                                          child: _buildField(
                                            label: 'Company Name',
                                            child: DynamicSingleSearchDropdown(
                                              label: "Company",
                                              items: widget.companies!
                                                  .map((c) => {
                                                        'id': c.id,
                                                        'name': c.companyName,
                                                      })
                                                  .toList(),
                                              selectedItem: selectedCompany,
                                              onChanged: (v) {
                                                setState(() {
                                                  selectedCompany = v;
                                                  companyId = v['id'];
                                                  isCompanyError = false;
                                                });
                                              },
                                              isError: isCompanyError,
                                              nameKey: "name",
                                            ),
                                          ),
                                        )),
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
                                              controller: titleCtrl,
                                              hintText: 'Project Title',
                                              readOnly: isView,
                                              validator: (val) {
                                                if (val == null ||
                                                    val.isEmpty) {
                                                  return 'Project Title is required';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        horizontalSpacing12,
                                        Expanded(
                                          child: IgnorePointer(
                                            ignoring: isView,
                                            child: _buildField(
                                              label: 'Services',
                                              child: DynamicMultiSearchDropdown(
                                                label: 'Services',
                                                selectedItems: selectedServices,
                                                items: (widget.service ?? [])
                                                    .map((e) => {
                                                          'id': e.id,
                                                          'name': e.name,
                                                        })
                                                    .toList(),
                                                onChanged: isView
                                                    ? (_) {}
                                                    : (values) {
                                                        setState(() {
                                                          selectedServices = (widget
                                                                      .service ??
                                                                  [])
                                                              .map((e) => {
                                                                    'id': e.id,
                                                                    'name':
                                                                        e.name,
                                                                  })
                                                              .where((item) =>
                                                                  values.any((v) =>
                                                                      v['id'] ==
                                                                      item[
                                                                          'id']))
                                                              .toList();

                                                          selectedService =
                                                              selectedServices
                                                                  .map((e) =>
                                                                      e['id'])
                                                                  .toList();
                                                        });
                                                        _filterInfluencers();
                                                      },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    verticalSpacing12,

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
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (val) {
                                                if (val == null ||
                                                    val.isEmpty) {
                                                  return 'Payment is required';
                                                } else if (paymentCtrl.text ==
                                                    "0") {
                                                  return 'Payment cannot be 0';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        horizontalSpacing12,
                                        Expanded(
                                          child: _buildField(
                                            label: 'Commission',
                                            child: InitialTextForm(
                                              radius: 10,
                                              controller: commissionCtrl,
                                              hintText: 'Commission',
                                              readOnly: isView,
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (val) {
                                                if (val == null ||
                                                    val.isEmpty) {
                                                  return 'Commission is required';
                                                } else if (commissionCtrl
                                                        .text ==
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
                                    verticalSpacing12,

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
                                          onStateChanged: (val) {
                                            state = val;
                                            _filterInfluencers();
                                          },
                                          onCityChanged: (val) {
                                            city = val ?? '';

                                            _filterInfluencers();
                                          },
                                        ),
                                      ),
                                    ),
                                    verticalSpacing12,

                                    /// Gender & influencer
                                    IgnorePointer(
                                      ignoring: isView,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: _buildField(
                                              label: 'Gender',
                                              child:
                                                  DynamicSingleSearchDropdown(
                                                items: [
                                                  "Male",
                                                  "Female",
                                                  "Others",
                                                ],
                                                selectedItem: gender,
                                                onChanged: (v) {
                                                  gender = v;
                                                },
                                                label: "Gender",
                                                isError: isGenderError,
                                                nameKey: "name",
                                              ),
                                            ),
                                          ),
                                          horizontalSpacing12,
                                          Expanded(
                                            child: _buildField(
                                              label: 'Influencers',
                                              child: Builder(
                                                builder: (context) {
                                                  // 🔹 Debug: check the data before passing to dropdown
                                                  (widget.influencers ?? [])
                                                      .forEach((e) {
                                                    debugPrint(
                                                        "id=${e.id}, name=${e.name}, image=${e.image}");
                                                  });

                                                  return DynamicMultiSearchDropdown(
                                                    label: 'Influencers',
                                                    selectedItems:
                                                        selectedInfluencers,
                                                    // items:

                                                    // (widget.influencers ?? [])
                                                    //     .map((e) => {
                                                    //           'id': e.id,
                                                    //           'name': e.name,
                                                    //           // 🔹 Normalize image to full URL if needed
                                                    //           'image': (e.image !=
                                                    //                       null &&
                                                    //                   e.image!
                                                    //                       .isNotEmpty)
                                                    //               ? "${e.image}"
                                                    //               : null,
                                                    //         })
                                                    //     .toList(),
                                                    items: (widget
                                                                .influencers ??
                                                            [])
                                                        .where((e) {
                                                          if (state
                                                                  .isNotEmpty &&
                                                              e.state != state)
                                                            return false;
                                                          if (city.isNotEmpty &&
                                                              e.city != city)
                                                            return false;

                                                          if (selectedService
                                                              .isNotEmpty) {
                                                            final services =
                                                                e.service ?? [];
                                                            if (!selectedService.any(
                                                                (id) => services
                                                                    .contains(
                                                                        id))) {
                                                              return false;
                                                            }
                                                          }

                                                          return true;
                                                        })
                                                        .map((e) => {
                                                              'id': e.id,
                                                              'name': e.name,
                                                              'image': (e.image !=
                                                                          null &&
                                                                      e.image!
                                                                          .isNotEmpty)
                                                                  ? "${e.image}"
                                                                  : null,
                                                            })
                                                        .toList(),

                                                    onChanged: isView
                                                        ? (_) {} // 🔒 view mode
                                                        : (values) {
                                                            setState(() {
                                                              selectedInfluencers = (widget
                                                                          .influencers ??
                                                                      [])
                                                                  .map((e) => {
                                                                        'id': e
                                                                            .id,
                                                                        'name':
                                                                            e.name,
                                                                        'image': (e.image != null &&
                                                                                e.image!.isNotEmpty)
                                                                            ? "https://yourserver.com/${e.image}"
                                                                            : null,
                                                                      })
                                                                  .where((item) =>
                                                                      values.any((v) =>
                                                                          v['id'] ==
                                                                          item[
                                                                              'id']))
                                                                  .toList();

                                                              selectedInfluencerIds =
                                                                  selectedInfluencers
                                                                      .map((e) =>
                                                                          e['id'])
                                                                      .toList();
                                                            });

                                                            debugPrint(
                                                                "Selected Influencer IDs: $selectedInfluencerIds");
                                                          },
                                                    isError:
                                                        isInfluencerSelected,
                                                    errorText:
                                                        "Please select at least one influencer",
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    verticalSpacing12,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IgnorePointer(
                                          ignoring: isView,
                                          child: _buildField(
                                            label: "Social media platforms",
                                            child: Row(
                                              children: [
                                                _checkItem(
                                                  text: "Instagram",
                                                  value: instagram,
                                                  onChanged: (v) {
                                                    setState(() {
                                                      instagram = v;
                                                      checkboxError = null;
                                                    });
                                                  },
                                                ),
                                                _checkItem(
                                                  text: "Facebook",
                                                  value: facebook,
                                                  onChanged: (v) {
                                                    setState(() {
                                                      facebook = v;
                                                      checkboxError = null;
                                                    });
                                                  },
                                                ),
                                                _checkItem(
                                                  text: "Youtube",
                                                  value: youtube,
                                                  onChanged: (v) {
                                                    setState(() {
                                                      youtube = v;
                                                      checkboxError = null;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // checkItem(
                                        //   text: "All Influencers",
                                        //   value: allInfluencersSelected,
                                        //   onChanged: (v) {
                                        //     setState(() {
                                        //       allInfluencersSelected = v;
                                        //       _filterInfluencers();
                                        //       checkboxError = null;
                                        //     });
                                        //   },
                                        // ),
                                      ],
                                    ),

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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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

    ImageItem? imageItem;

    if (kIsWeb) {
      final bytes = result['bytes'];
      if (bytes is Uint8List && bytes.isNotEmpty) {
        imageItem = ImageItem(bytes: bytes);
      }
    } else {
      final path = result['path'];
      if (path is String && path.isNotEmpty) {
        imageItem = ImageItem(path: path);
      }
    }

    if (imageItem == null) return;

    setState(() {
      images.add(imageItem!);
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

  // Widget buildImage(
  //   dynamic pathOrData, {
  //   Key? key,
  //   double width = double.infinity,
  //   double height = double.infinity,
  //   BoxFit fit = BoxFit.cover,
  // }) {
  //   if (pathOrData == null) {
  //     return const Icon(Icons.image_not_supported, color: Colors.grey);
  //   }

  //   // ===================== MEMORY (WEB PICKER) =====================
  //   if (pathOrData is Uint8List) {
  //     return Image.memory(
  //       pathOrData,
  //       width: width,
  //       height: height,
  //       fit: fit,
  //       errorBuilder: (_, __, ___) =>
  //           const Icon(Icons.broken_image, color: Colors.red),
  //     );
  //   }

  //   // From here onward, we are sure it's String
  //   if (pathOrData is! String) {
  //     return const Icon(Icons.image_not_supported, color: Colors.grey);
  //   }

  //   bool isBase64(String value) {
  //     final base64Regex = RegExp(r'^[A-Za-z0-9+/=]+$');
  //     return value.length % 4 == 0 && base64Regex.hasMatch(value);
  //   }

  //   // ===================== WEB =====================
  //   if (kIsWeb) {
  //     if (pathOrData.startsWith('http')) {
  //       return WebImageTwo(
  //         imageUrl: pathOrData,
  //         width: width,
  //         height: height,
  //         fit: BoxFit.cover,
  //       );
  //     }

  //     if (isBase64(pathOrData)) {
  //       try {
  //         return Image.memory(
  //           base64Decode(pathOrData),
  //           width: width,
  //           height: height,
  //           fit: fit,
  //         );
  //       } catch (_) {
  //         return const Icon(Icons.broken_image, color: Colors.red);
  //       }
  //     }

  //     return const Icon(Icons.image_not_supported, color: Colors.grey);
  //   }

  //   // ===================== MOBILE =====================
  //   if (pathOrData.startsWith('http')) {
  //     return Image.network(
  //       pathOrData,
  //       width: width,
  //       height: height,
  //       fit: fit,
  //       errorBuilder: (_, __, ___) =>
  //           const Icon(Icons.broken_image, color: Colors.red),
  //     );
  //   }

  //   return Image.file(
  //     File(pathOrData),
  //     width: width,
  //     height: height,
  //     fit: fit,
  //     errorBuilder: (_, __, ___) =>
  //         const Icon(Icons.broken_image, color: Colors.red),
  //   );
  // }

  Widget buildImage(ImageItem item,
      {double? width, double? height, BoxFit fit = BoxFit.cover}) {
    // ================= NETWORK =================
    if (item.isNetwork && item.url != null) {
      return WebImageTwo(
        imageUrl: item.url!,
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        fit: BoxFit.cover,
      );
    }

    // ================= WEB MEMORY =================
    if (item.isWeb && item.bytes != null) {
      return Image.memory(
        item.bytes!,
        width: width ?? double.infinity,
        height: height ?? 400,
        fit: fit,
      );
    }

    // ================= MOBILE FILE =================
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

  Widget _checkItem({
    required String text,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (v) => onChanged(v ?? false),
          visualDensity: VisualDensity.compact,
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 13),
        ),
      ],
    );
  }

  Widget checkItem({
    required String text,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (v) => onChanged(v ?? false),
          visualDensity: VisualDensity.compact,
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 13),
        ),
      ],
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
      isCompanyError = selectedCompany == null; // ✅ ADD THIS
      checkboxError = !(instagram || facebook || youtube)
          ? "Please select at least one platform"
          : null;

      formSubmitted = true;
    });

    // ❌ Stop if any validation fails
    if (!isFormValid ||
        isInfluencerSelected ||
        isStateError ||
        isCityError ||
        isGenderError ||
        isImageError ||
        isCompanyError) {
      return;
    }

    print("images: $images");

    final updated = {
      if (widget.model.id != null) "id": widget.model.id,
      "projectCode": codeCtrl.text,
      "projectTitle": titleCtrl.text,
      "gender": gender,
      "state": state,
      "city": city,
      "influencers": selectedInfluencerIds,
      "companyId": selectedCompany!['id'],
      "companyName": selectedCompany!['name'],
      "payment": double.tryParse(paymentCtrl.text) ?? 0,
      "commission": double.tryParse(commissionCtrl.text) ?? 0,
      "note": noteCtrl.text,
      "projectImages": images,
      "selectedInfluencerIds": selectedInfluencerIds,
      "selectedServiceIds": selectedService,
      "link": {
        if (instagram == true) "instagram": null,
        if (facebook == true) "facebook": null,
        if (youtube == true) "youtube": null,
      },
    };

    widget.onSave?.call(updated);
    Navigator.pop(context);
  }
}
