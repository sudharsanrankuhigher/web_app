import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/core/helper/permission_helper.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/city/widget/state_city_dropdown.dart';
import 'package:webapp/ui/views/influencers/model/influencers_model.dart'
    as influencer_model;
import 'package:webapp/ui/views/influencers/widgets/icon_text_form_field.dart';
import 'package:webapp/ui/views/services/model/service_model.dart'
    as service_model;
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/dob_field.dart';
import 'package:webapp/widgets/drop_down_widget.dart';
import 'package:webapp/widgets/label_text.dart';
import 'package:webapp/widgets/profile_image.dart';
import 'package:webapp/widgets/state_city_drop_down.dart';

class InfluencerDialog extends StatefulWidget {
  final influencer_model.Datum? influencer;
  final Function(dynamic) onSave;
  final bool? isView;
  final List<service_model.Datum>? service;

  const InfluencerDialog(
      {Key? key,
      this.influencer,
      required this.onSave,
      this.isView,
      this.service})
      : super(key: key);

  @override
  _InfluencerDialogState createState() => _InfluencerDialogState();
}

class _InfluencerDialogState extends State<InfluencerDialog> {
  final formKey = GlobalKey<FormState>();

  Uint8List? pickedBytes;
  String? pickedPath;

  int? serviceId;

  bool? _isView = false;
  bool formSubmitted = false;
  bool _isStateError = false;
  bool _isCityError = false;

  DateTime? dob;
  bool dobError = false;
  List<dynamic> selectedServices = [];
  List<dynamic> selectedService = [];
  String? dobString;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController dobController;
  late TextEditingController altPhoneController;
  late TextEditingController idController;
  late TextEditingController stateController;
  late TextEditingController passwordController;
  late TextEditingController serviceController;
  late TextEditingController descriptionController;
  late TextEditingController cityController;
  late TextEditingController instagramLinkController;
  late TextEditingController instagramFollowersController;
  late TextEditingController instagramDescController;
  late TextEditingController facebookLinkController;
  late TextEditingController facebookFollowersController;
  late TextEditingController youtubeLinkController;
  late TextEditingController youtubeFollowersController;
  late TextEditingController bankAccountController;
  late TextEditingController bankHolderController;
  late TextEditingController ifscController;
  late TextEditingController upiController;

  @override
  void initState() {
    super.initState();
    final inf = widget.influencer;

    nameController = TextEditingController(text: inf?.name ?? '');
    emailController = TextEditingController(text: inf?.email ?? '');
    phoneController = TextEditingController(text: inf?.phone ?? '');
    dobController = TextEditingController(text: inf?.dob.toString() ?? '');
    altPhoneController = TextEditingController(text: inf?.altPhone ?? '');
    idController = TextEditingController(text: inf?.infId.toString() ?? '');
    stateController = TextEditingController(text: inf?.state ?? '');
    passwordController = TextEditingController(text: '');
    serviceController =
        TextEditingController(text: inf?.service.toString() ?? '');
    cityController = TextEditingController(text: inf?.city ?? '');
    instagramLinkController =
        TextEditingController(text: inf?.instagramLink ?? '');
    instagramFollowersController =
        TextEditingController(text: inf?.instagramFollowers.toString() ?? '');
    instagramDescController = facebookLinkController =
        TextEditingController(text: inf?.facebookLink ?? '');
    facebookFollowersController =
        TextEditingController(text: inf?.facebookFollowers.toString() ?? '');
    youtubeLinkController = TextEditingController(text: inf?.youtubeLink ?? '');
    youtubeFollowersController =
        TextEditingController(text: inf?.youtubeFollowers.toString() ?? '');
    bankAccountController = TextEditingController(text: inf?.accountNo ?? '');
    bankHolderController =
        TextEditingController(text: inf?.accountHolderName ?? '');
    ifscController = TextEditingController(text: inf?.ifscCode ?? '');
    upiController = TextEditingController(text: inf?.upiId ?? '');
    descriptionController = TextEditingController();

    // selectedServices = inf?.service ?? [];
    if (widget.influencer != null && widget.service != null) {
      /// influencer.service contains IDs (example: [1, 3, 5])
      final influencerServiceIds = widget.influencer!.service ?? [];

      /// Build selected services list
      selectedServices = widget.service!
          .where((s) => influencerServiceIds.contains(s.id))
          .map((s) => {
                'id': s.id,
                'name': s.name,
              })
          .toList();

      /// Only IDs (for API save)
      selectedService = selectedServices.map((e) => e['id']).toList();
    }

    dob = inf?.dob;
    dobString = inf?.dob.toString();
    dobError = false;

    _isView = widget.isView;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(30),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _isView == true &&
                        PermissionHelper.instance.canEdit('influencers')
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CommonButton(
                            padding: defaultPadding4,
                            text: 'Edit',
                            textStyle: fontFamilySemiBold.size12.black,
                            buttonColor: redShade,
                            width: 70,
                            onTap: () {
                              setState(() {
                                _isView = false;
                              });
                            },
                            icon: Icon(
                              Icons.edit,
                              size: 20,
                            ),
                          )
                        ],
                      )
                    : InkWell(
                        onTap: () {
                          Navigator.pop(
                              StackedService.navigatorKey!.currentContext!);
                        },
                        child: const SizedBox(
                          height: 16,
                          child: Icon(Icons.close),
                        ),
                      ),

                Center(
                  child: Text(
                    widget.influencer == null
                        ? "Add New Influencer"
                        : _isView == true
                            ? "View Influencer"
                            : "Edit Influencer",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                IgnorePointer(
                  ignoring: _isView == true ? true : false,
                  child: Center(
                    child: ProfileImageEdit(
                      imageUrl: widget.influencer?.image,
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

                const SizedBox(height: 20),

                // -------------------------------
                // PERSONAL DETAILS
                // -------------------------------
                const Text("Personal Details",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: IconTextFormField(
                        isView: _isView,
                        icon: Icons.person,
                        label: "Name",
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: IconTextFormField(
                          isView: _isView,
                          icon: Icons.email,
                          label: "Email",
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email address';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              if (emailController.text.isEmpty ||
                                  !RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                      .hasMatch(emailController.text)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            }
                            return null;
                          }),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: IconTextFormField(
                        isView: _isView,
                        icon: Icons.phone,
                        label: "Phone",
                        controller: phoneController,
                        keyBoardType: TextInputType.number,
                        validator: (phone) {
                          if (phoneController.text.isEmpty ||
                              !RegExp(r'^\d{10}$')
                                  .hasMatch(phoneController.text)) {
                            return 'Please enter a valid 10-digit phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconTextLabel(
                          icon: Icons.calendar_month,
                          text: "DOB",
                          iconColor: Colors.black,
                          textColor: Colors.black,
                          iconSize: 16,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        verticalSpacing10,
                        IgnorePointer(
                          ignoring: _isView == true ? true : false,
                          child: DOBField(
                            label: "Date of Birth",
                            selectedDate: dob,
                            isError: dobError,
                            onDateSelected: (date) {
                              setState(() {
                                if (date != null) {
                                  dobString = "${date.year}"
                                      "${date.month.toString().padLeft(2, '0')}-"
                                      "${date.day.toString().padLeft(2, '0')}-";
                                  dob = date;
                                  dobError = false;
                                } else {
                                  dobController.text = '';
                                  dobError = true;
                                  return;
                                }
                              });
                            },
                          ),
                        )
                      ],
                    )
                        //  IconTextFormField(
                        //   validator: (phone) {
                        //     if (phoneController.text.isEmpty ||
                        //         !RegExp(r'^\d{10}$')
                        //             .hasMatch(phoneController.text)) {
                        //       return 'Please enter a valid 10-digit phone number';
                        //     }
                        //     return null;
                        //   },
                        //   isView: _isView,
                        //   icon: Icons.calendar_month,
                        //   label: "DOB",
                        //   controller: dobController,
                        // ),
                        ),
                  ],
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: IconTextFormField(
                        isView: _isView,
                        icon: Icons.phone,
                        label: "Alternative Phone",
                        controller: altPhoneController,
                        keyBoardType: TextInputType.number,
                        validator: (phone) {
                          if (altPhoneController.text.isEmpty ||
                              !RegExp(r'^\d{10}$')
                                  .hasMatch(altPhoneController.text)) {
                            return 'Please enter a valid 10-digit phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: IconTextFormField(
                        validator: (id) {
                          if (idController.text.isEmpty) {
                            return 'Please enter ID Number';
                          }
                          return null;
                        },
                        isView: widget.isView,
                        icon: Icons.perm_identity,
                        label: "ID Number",
                        controller: idController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconTextLabel(
                      icon: Icons.location_on,
                      text: "State / City",
                      iconColor: Colors.black,
                      textColor: Colors.black,
                      iconSize: 16,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    verticalSpacing10,
                    IgnorePointer(
                      ignoring: _isView == true ? true : false,
                      child: StateCityDropdown(
                        initialCity: widget.influencer?.city ?? '',
                        initialState: widget.influencer?.state ?? '',
                        isVertical: true,
                        showCity: true,
                        isCityError: _isCityError,
                        isStateError: _isStateError,
                        onStateChanged: (value) {
                          stateController.text = value ?? '';
                        },
                        onCityChanged: (value) {
                          cityController.text = value ?? '';
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconTextLabel(
                          icon: Icons.design_services,
                          text: "Service",
                          iconColor: Colors.black,
                          textColor: Colors.black,
                          iconSize: 16,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        verticalSpacing10,
                        IgnorePointer(
                          ignoring: _isView == true ? true : false,
                          child: DynamicMultiSearchDropdown(
                            selectedItems: selectedServices,
                            items: widget.service!
                                .map((e) => {
                                      'id': e.id,
                                      'name': e.name,
                                    })
                                .toList(),
                            onChanged: _isView == true
                                ? (_) {} // 🔒 disable in view mode
                                : (values) {
                                    setState(() {
                                      selectedServices = values;
                                      selectedService =
                                          values.map((e) => e['id']).toList();
                                    });

                                    debugPrint(
                                        "Selected IDs: $selectedService");
                                  },
                            label: 'Service',
                            isError: selectedServices.isEmpty &&
                                formSubmitted, // <-- add
                            errorText:
                                "Please select at least one service", // <-- add
                          ),
                        ),
                      ],
                    )

                        //  IconTextFormField(
                        //   isView: _isView,
                        //   icon: Icons.design_services,
                        //   label: "Service",
                        //   controller: serviceController,
                        // ),
                        ),
                    const SizedBox(width: 12),

                    // icon: Icons.design_services,
                    //
                    Expanded(
                      child: IconTextFormField(
                        validator: (value) {
                          if (widget.influencer == null) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Password';
                            } else if (value.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                          }
                          return null; // no validation in edit/view
                        },
                        isView: _isView,
                        icon: Icons.lock,
                        label: "Password",
                        controller: passwordController,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // -------------------------------
                // SOCIAL MEDIA
                // -------------------------------
                const Text("Social Media Links",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                verticalSpacing8,
                Row(
                  children: [
                    Expanded(
                      child: IconTextFormField(
                        isView: _isView,
                        icon: Icons.note,
                        label: "description",
                        controller: descriptionController,
                      ),
                    ),
                  ],
                ),
                verticalSpacing12,
                // Instagram row
                Row(
                  children: [
                    Expanded(
                      child: IconTextFormField(
                        validator: (val) {
                          if (instagramLinkController.text.isEmpty) {
                            return 'Please enter Instagram Link';
                          }
                          final uri = Uri.tryParse(val!.trim());
                          if (uri == null ||
                              !uri.hasScheme ||
                              !uri.hasAuthority) {
                            return 'Please enter a valid URL';
                          }

                          return null;
                        },
                        isView: _isView,
                        icon: Icons.camera,
                        label: "Instagram Link",
                        controller: instagramLinkController,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: IconTextFormField(
                        validator: (val) {
                          if (instagramFollowersController.text.isEmpty) {
                            return 'Please enter Instagram Followers';
                          }
                          return null;
                        },
                        isView: _isView,
                        icon: Icons.camera,
                        label: "Instagram Followers",
                        controller: instagramFollowersController,
                      ),
                    ),
                  ],
                ),

                verticalSpacing8,

                // FB + YT
                Row(
                  children: [
                    Expanded(
                      child: IconTextFormField(
                        isView: _isView,
                        icon: Icons.facebook,
                        label: "facebook Link",
                        controller: facebookLinkController,
                        validator: (val) {
                          if (facebookLinkController.text.isEmpty) {
                            return 'Please enter Facebook Link';
                          }

                          final uri = Uri.tryParse(val!.trim());
                          if (uri == null ||
                              !uri.hasScheme ||
                              !uri.hasAuthority) {
                            return 'Please enter a valid URL';
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: IconTextFormField(
                        validator: (val) {
                          if (facebookFollowersController.text.isEmpty) {
                            return 'Please enter Facebook Followers';
                          }
                          return null;
                        },
                        isView: _isView,
                        icon: Icons.facebook,
                        label: "facebook Followers",
                        controller: facebookFollowersController,
                      ),
                    ),
                  ],
                ),
                verticalSpacing8,
                Row(
                  children: [
                    Expanded(
                      child: IconTextFormField(
                        isView: _isView,
                        icon: Icons.youtube_searched_for,
                        label: "youtube Link",
                        controller: youtubeLinkController,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter YouTube link';
                          }

                          final uri = Uri.tryParse(val.trim());
                          if (uri == null ||
                              !uri.hasScheme ||
                              !uri.hasAuthority) {
                            return 'Please enter a valid URL';
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: IconTextFormField(
                        validator: (val) {
                          if (youtubeFollowersController.text.isEmpty) {
                            return 'Please enter Youtube Followers';
                          }
                          return null;
                        },
                        isView: _isView,
                        icon: Icons.video_label,
                        label: "youtube Followers",
                        controller: youtubeFollowersController,
                      ),
                    ),
                  ],
                ),

                verticalSpacing8,

                // -------------------------------
                // BANK
                // -------------------------------
                const Text("Bank Details",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                verticalSpacing8,
                Row(
                  children: [
                    Expanded(
                      child: IconTextFormField(
                        validator: (_) {
                          if (bankAccountController.text.isEmpty) {
                            return 'Please enter Account Number';
                          }
                          return null;
                        },
                        isView: _isView,
                        icon: Icons.account_balance,
                        label: "Account Number",
                        controller: bankAccountController,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: IconTextFormField(
                        validator: (_) {
                          if (bankHolderController.text.isEmpty) {
                            return 'Please enter Account Holder Name';
                          }
                          return null;
                        },
                        isView: _isView,
                        icon: Icons.person_2,
                        label: "Account Holder Name",
                        controller: bankHolderController,
                      ),
                    ),
                  ],
                ),
                verticalSpacing10,
                Row(
                  children: [
                    Expanded(
                      child: IconTextFormField(
                        validator: (val) {
                          if (ifscController.text.isEmpty) {
                            return 'Please enter IFSC Code';
                          }
                          return null;
                        },
                        isView: _isView,
                        icon: Icons.factory_outlined,
                        label: "IFSC Code",
                        controller: ifscController,
                      ),
                    ),
                    horizontalSpacing12,
                    Expanded(
                      child: IconTextFormField(
                        validator: (val) {
                          if (upiController.text.isEmpty) {
                            return 'Please enter UPI ID';
                          }
                          return null;
                        },
                        isView: _isView,
                        icon: Icons.person_2,
                        label: "UPI ID",
                        controller: upiController,
                      ),
                    ),
                  ],
                ),

                verticalSpacing20,
                if (_isView != true)
                  // SAVE BUTTON
                  Center(
                    child: CommonButton(
                      margin: leftPadding40 +
                          rightPadding40 +
                          leftPadding40 +
                          rightPadding40,
                      buttonColor: Colors.blue,
                      onTap: () {
                        if (pickedBytes == null && widget.influencer == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please select an image')),
                          );
                          return;
                        }

                        setState(() {
                          dobError = dob == null;
                          formSubmitted = true;
                        });
                        if (dobError) return;

                        // 4️⃣ Check services
                        if (selectedServices.isEmpty) return;

                        final isStateError = stateController.text.isEmpty;
                        final isCityError = cityController.text.isEmpty;
                        setState(() {
                          _isStateError = isStateError;
                          _isCityError = isCityError;
                        });
                        if (isStateError || isCityError) return;

                        if (formKey.currentState!.validate()) {
                          final Map<String, dynamic> updated = {
                            if (widget.influencer?.id != null)
                              "id": widget.influencer!.id,
                            "name": nameController.text,
                            "email": emailController.text,
                            "phone": phoneController.text,
                            "dob": dob,
                            "altPhone": altPhoneController.text,
                            "inf_id": idController.text,
                            "state": stateController.text,
                            "password": passwordController.text,
                            "service": selectedService,
                            "city": cityController.text,
                            "instagram": instagramLinkController.text,
                            "instagramFollowers":
                                instagramFollowersController.text,
                            "facebook": facebookLinkController.text,
                            "facebookFollowers":
                                facebookFollowersController.text,
                            "youtube": youtubeLinkController.text,
                            "youtubeFollowers": youtubeFollowersController.text,
                            "bankAccount": bankAccountController.text,
                            "bankHolder": bankHolderController.text,
                            "ifsc": ifscController.text,
                            "upi": upiController.text,
                            "description": descriptionController.text,
                          };

                          // ✅ IMAGE DATA (WEB)
                          if (pickedBytes != null) {
                            updated["imageBytes"] = pickedBytes;
                          } else {
                            updated["existing_image"] =
                                widget.influencer?.image;
                          }

                          // ❌ DO NOT LOG FULL MAP
                          debugPrint(
                              "Saving influencer (keys): ${updated.keys}");

                          widget.onSave(updated);
                          Navigator.pop(context);
                        }
                      },
                      text: 'Save',
                      textStyle: fontFamilySemiBold.size16.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
