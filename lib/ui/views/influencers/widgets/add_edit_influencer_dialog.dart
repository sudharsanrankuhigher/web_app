import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/views/influencers/model/influencers_model.dart';
import 'package:webapp/ui/views/influencers/widgets/icon_text_form_field.dart';
import 'package:webapp/widgets/common_button.dart';

class InfluencerDialog extends StatefulWidget {
  final InfluencerModel? influencer;
  final Function(InfluencerModel) onSave;
  final bool? isView;

  const InfluencerDialog(
      {Key? key, this.influencer, required this.onSave, this.isView})
      : super(key: key);

  @override
  _InfluencerDialogState createState() => _InfluencerDialogState();
}

class _InfluencerDialogState extends State<InfluencerDialog> {
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
    dobController = TextEditingController(text: inf?.dob ?? '');
    altPhoneController = TextEditingController(text: inf?.altPhone ?? '');
    idController = TextEditingController(text: inf?.idNumber ?? '');
    stateController = TextEditingController(text: inf?.state ?? '');
    passwordController = TextEditingController(text: inf?.password ?? '');
    serviceController = TextEditingController(text: inf?.service ?? '');
    cityController = TextEditingController(text: inf?.city ?? '');
    instagramLinkController = TextEditingController(text: inf?.instagram ?? '');
    instagramFollowersController =
        TextEditingController(text: inf?.instagramFollowers ?? '');
    instagramDescController =
        TextEditingController(text: inf?.instagramDesc ?? '');
    facebookLinkController = TextEditingController(text: inf?.facebook ?? '');
    facebookFollowersController =
        TextEditingController(text: inf?.facebookFollowers ?? '');
    youtubeLinkController = TextEditingController(text: inf?.youtube ?? '');
    youtubeFollowersController =
        TextEditingController(text: inf?.youtubeFollowers ?? '');
    bankAccountController = TextEditingController(text: inf?.bankAccount ?? '');
    bankHolderController = TextEditingController(text: inf?.bankHolder ?? '');
    ifscController = TextEditingController(text: inf?.ifsc ?? '');
    upiController = TextEditingController(text: inf?.upi ?? '');
    descriptionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(30),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.isView == true
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [Text('edit')],
                    )
                  : const SizedBox(height: 16),

              Center(
                child: Text(
                  widget.influencer == null
                      ? "Add New Influencer"
                      : widget.isView == true
                          ? "View Influencer"
                          : "Edit Influencer",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: CircleAvatar(
                  radius: 45,
                  backgroundImage: widget.influencer?.image != null
                      ? NetworkImage(widget.influencer!.image!)
                      : null,
                  child: widget.influencer?.image == null
                      ? const Icon(Icons.person, size: 40)
                      : null,
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
                      isView: widget.isView,
                      icon: Icons.person,
                      label: "Name",
                      controller: nameController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: IconTextFormField(
                      isView: widget.isView,
                      icon: Icons.email,
                      label: "Email",
                      controller: emailController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: IconTextFormField(
                      isView: widget.isView,
                      icon: Icons.phone,
                      label: "Phone",
                      controller: phoneController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: IconTextFormField(
                      isView: widget.isView,
                      icon: Icons.calendar_month,
                      label: "DOB",
                      controller: dobController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: IconTextFormField(
                      isView: widget.isView,
                      icon: Icons.phone,
                      label: "Alternative Phone",
                      controller: altPhoneController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: IconTextFormField(
                      isView: widget.isView,
                      icon: Icons.perm_identity,
                      label: "ID Number",
                      controller: idController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: IconTextFormField(
                      isView: widget.isView,
                      icon: Icons.map,
                      label: "State",
                      controller: stateController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: IconTextFormField(
                      isView: widget.isView,
                      icon: Icons.lock,
                      label: "Password",
                      controller: passwordController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: IconTextFormField(
                      isView: widget.isView,
                      icon: Icons.design_services,
                      label: "Service",
                      controller: serviceController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: IconTextFormField(
                      isView: widget.isView,
                      icon: Icons.location_city,
                      label: "City",
                      controller: cityController,
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
                      isView: widget.isView,
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
                      isView: widget.isView,
                      icon: Icons.camera,
                      label: "Instagram Link",
                      controller: instagramLinkController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: IconTextFormField(
                      isView: widget.isView,
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
                      isView: widget.isView,
                      icon: Icons.facebook,
                      label: "facebook Link",
                      controller: facebookLinkController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: IconTextFormField(
                      isView: widget.isView,
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
                      isView: widget.isView,
                      icon: Icons.youtube_searched_for,
                      label: "youtube Link",
                      controller: youtubeLinkController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: IconTextFormField(
                      isView: widget.isView,
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
                      isView: widget.isView,
                      icon: Icons.account_balance,
                      label: "Account Number",
                      controller: bankAccountController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: IconTextFormField(
                      isView: widget.isView,
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
                      isView: widget.isView,
                      icon: Icons.factory_outlined,
                      label: "IFSC Code",
                      controller: ifscController,
                    ),
                  ),
                  horizontalSpacing12,
                  Expanded(
                    child: IconTextFormField(
                      isView: widget.isView,
                      icon: Icons.person_2,
                      label: "UPI ID",
                      controller: upiController,
                    ),
                  ),
                ],
              ),

              verticalSpacing20,
              if (widget.isView != true)
                // SAVE BUTTON
                Center(
                  child: CommonButton(
                    margin: leftPadding40 +
                        rightPadding40 +
                        leftPadding40 +
                        rightPadding40,
                    buttonColor: Colors.blue,
                    onTap: () {
                      final updated = InfluencerModel(
                        id: widget.influencer?.id ?? 0,
                        name: nameController.text,
                        email: emailController.text,
                        phone: phoneController.text,
                        dob: dobController.text,
                        altPhone: altPhoneController.text,
                        idNumber: idController.text,
                        state: stateController.text,
                        password: passwordController.text,
                        service: serviceController.text,
                        city: cityController.text,
                        instagram: instagramLinkController.text,
                        instagramFollowers: instagramFollowersController.text,
                        instagramDesc: instagramDescController.text,
                        facebook: facebookLinkController.text,
                        facebookFollowers: facebookFollowersController.text,
                        youtube: youtubeLinkController.text,
                        youtubeFollowers: youtubeFollowersController.text,
                        bankAccount: bankAccountController.text,
                        bankHolder: bankHolderController.text,
                        ifsc: ifscController.text,
                        upi: upiController.text,
                        category: '',
                      );

                      widget.onSave(updated);
                      Navigator.pop(context);
                    },
                    text: 'Save',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
