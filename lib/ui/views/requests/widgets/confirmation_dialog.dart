import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/widgets/search_drop_down_widget.dart';
import 'package:webapp/ui/views/influencers/model/influencers_model.dart'
    as influencer_model;
import 'package:webapp/widgets/web_image_loading.dart';

Future<void> showRejectConfirmationDialog({
  required BuildContext context,
  required String itemName,
  String? promotionProject,
  required VoidCallback onConfirm,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: "reject",
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (_, __, ___) {
      return const SizedBox.shrink();
    },
    transitionBuilder: (context, animation, _, child) {
      final scale = Tween<double>(begin: 0.9, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutBack));
      final fade = Tween<double>(begin: 0, end: 1).animate(animation);

      return FadeTransition(
        opacity: fade,
        child: ScaleTransition(
          scale: scale,
          child: Center(
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500, minWidth: 300),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🔴 Warning Icon
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 36,
                          color: Colors.red,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Title
                      const Text(
                        "Confirm to reject",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Message
                      Text(
                          "Are you sure you want to reject the $itemName from ${(promotionProject == null ? "Client request" : promotionProject)}?",
                          textAlign: TextAlign.center,
                          style: fontFamilyMedium.size14.grey),

                      const SizedBox(height: 24),

                      Row(
                        children: [
                          // Cancel
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text("Cancel"),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Delete
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                onConfirm();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                "Reject",
                                style: fontFamilyMedium.size14.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<void> showActionConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmText,
  required Color confirmColor,
  required IconData icon,
  String? image,
  required VoidCallback onConfirm,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: confirmText,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (context, animation, _, __) {
      final scale = Tween<double>(begin: 0.9, end: 1.0).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
      );
      final fade = Tween<double>(begin: 0, end: 1).animate(animation);

      return FadeTransition(
        opacity: fade,
        child: ScaleTransition(
          scale: scale,
          child: Center(
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 550, minWidth: 300),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon
                      Container(
                        // height: image!.isNotEmpty ? 35 : null,
                        // width: image.isNotEmpty ? 35 : null,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: confirmColor.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: (image != null && image!.isNotEmpty)
                            ? SvgPicture.asset(image)
                            : Icon(icon, size: 36, color: confirmColor),
                      ),

                      const SizedBox(height: 16),

                      // Title
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Message
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: fontFamilyMedium.size14.grey,
                      ),

                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text("Cancel"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                onConfirm();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: confirmColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                confirmText,
                                style: fontFamilyMedium.size14.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

void showBankDetailsDialog({
  required dynamic? bankDetails,
  required BuildContext context,
}) {
  showDialog(
    context: context,
    builder: (context) {
      dynamic details;

      if (bankDetails is List && bankDetails.isNotEmpty) {
        details = bankDetails.first;
      } else {
        details = bankDetails;
      }

      return AlertDialog(
        title: const Text("Bank Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow(
              "Account Holder Name",
              bankDetails?.accountName ?? bankDetails['holder_name'],
            ),
            _detailRow(
              "Account Number",
              bankDetails?.accountNo ?? bankDetails['account_no'],
            ),
            _detailRow(
              "IFSC Code",
              bankDetails?.ifscCode ?? bankDetails['ifsc_code'],
            ),
            _detailRow("UPI id", bankDetails?.upi ?? bankDetails['upi']),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}

Widget _detailRow(
  String label,
  String? value, {
  TextStyle? labelStyle,
  TextStyle? valueStyle,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: "$label: ",
              style: labelStyle ?? fontFamilySemiBold.size13.black),
          TextSpan(
              text: value?.isNotEmpty == true ? value! : "-",
              style: valueStyle ?? fontFamilyMedium.size13.grey),
        ],
      ),
    ),
  );
}

Future<void> showAdminPaymentConfigDialog({
  required BuildContext context,
  required Function(Map<String, dynamic>) onSave,
}) {
  final paymentCtrl = TextEditingController();
  final commissionCtrl = TextEditingController();
  final noteCtrl = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool instagram = false;
  bool facebook = false;
  bool youtube = false;

  String? checkboxError;

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420, minWidth: 320),
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔵 Title
                      const Text(
                        "Admin Payment Configuration",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Payment Amount
                      _underlineField(
                        label: "Payment Amount",
                        controller: paymentCtrl,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "Please enter payment amount";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      // Commission
                      _underlineField(
                        label: "Commission",
                        controller: commissionCtrl,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "Please enter commission";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // SM Verification
                      const Text(
                        "SM Verification",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 8),

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

                      // Checkbox error
                      if (checkboxError != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 12, top: 4),
                          child: Text(
                            checkboxError!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 11,
                            ),
                          ),
                        ),

                      const SizedBox(height: 16),

                      // Note
                      _underlineField(
                        label: "Note",
                        controller: noteCtrl,
                      ),

                      const SizedBox(height: 24),

                      // Actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue),
                            ),
                            onPressed: () {
                              final isFormValid =
                                  formKey.currentState!.validate();
                              final isCheckboxValid =
                                  instagram || facebook || youtube;

                              setState(() {
                                checkboxError = isCheckboxValid
                                    ? null
                                    : "Select at least one platform";
                              });

                              if (!isFormValid || !isCheckboxValid) return;

                              Navigator.pop(context);
                              onSave({
                                "payment": {
                                  "payment": paymentCtrl.text,
                                  "commission": commissionCtrl.text,
                                  "note": noteCtrl.text,
                                },
                                "verification": {
                                  if (instagram == true) "instagram": null,
                                  if (facebook == true) "facebook": null,
                                  if (youtube == true) "youtube": null,
                                },
                              });
                            },
                            child: Text(
                              "Save",
                              style: fontFamilySemiBold.size13.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _underlineField({
  required String label,
  required TextEditingController controller,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 13),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.blue),
      ),
    ),
  );
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

Future<dynamic> showStatusDialog(BuildContext context) {
  dynamic selectedStatus;
  bool isError = false;

  final List<Map<String, dynamic>> statusList = [
    {'id': 1, 'name': 'Rework'},
    {'id': 2, 'name': 'Completed'},
  ];

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(
              'View Link and Update Status',
              style: fontFamilyBold.size16.black,
            ),
            content: SizedBox(
              width: 420,
              child: DynamicSingleSearchDropdown(
                label: "Status",
                items: statusList,
                selectedItem: selectedStatus,
                isError: isError,
                errorText: "Please select a status",
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value;
                    isError = false;
                  });
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(continueButton),
                ),
                onPressed: () {
                  if (selectedStatus == null) {
                    setState(() => isError = true);
                    return;
                  }
                  Navigator.pop(context, selectedStatus);
                },
                child: Text(
                  'Done',
                  style: fontFamilySemiBold.size14.white,
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<influencer_model.Datum?> showReassignInfluencerDialog({
  required BuildContext context,
  required List<influencer_model.Datum> influencers,
  required int? currentInfluencerId,
  required List<int> assignedInfluencerIds, // 👈 ADD THIS
}) {
  influencer_model.Datum? selectedInfluencer;
  bool isError = false;

  // Find current influencer
  final currentInfluencer = influencers
      .where((inf) => inf.id == currentInfluencerId)
      .cast<influencer_model.Datum?>()
      .firstOrNull;

  // Already assigned influencers (excluding current one if needed)
  final alreadyAssigned = influencers
      .where((inf) =>
          assignedInfluencerIds.contains(inf.id) &&
          inf.id != currentInfluencerId)
      .toList();

  // Remove current influencer from list
  // final filteredInfluencers =
  //     influencers.where((inf) => inf.id != currentInfluencerId).toList();

  final filteredInfluencers = influencers
      .where((inf) =>
          !assignedInfluencerIds.contains(inf.id) &&
          inf.id != currentInfluencerId)
      .toList();
  return showDialog<influencer_model.Datum>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(
              "Reassign Influencer",
              style: fontFamilyBold.size16.black,
            ),
            content: SizedBox(
              width: 450,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 Current Influencer Section
                  if (currentInfluencer != null) ...[
                    Text(
                      "Currently Assigned",
                      style: fontFamilySemiBold.size14.grey,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            child: (currentInfluencer.image != null &&
                                    currentInfluencer.image!.isNotEmpty)
                                ? ClipRRect(
                                    borderRadius: BorderRadiusGeometry.all(
                                        Radius.circular(25)),
                                    child: WebImage(
                                        imageUrl: currentInfluencer.image!))
                                : (currentInfluencer.image == null ||
                                        currentInfluencer.image!.isEmpty)
                                    ? const Icon(Icons.person, size: 18)
                                    : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentInfluencer.name ?? "",
                                  style: fontFamilySemiBold.size14.black,
                                ),
                                Text(
                                  "${currentInfluencer.city ?? ""}, ${currentInfluencer.state ?? ""}",
                                  style: fontFamilyRegular.size12.grey,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  /// 🔹 Select New Influencer
                  Text(
                    "Select New Influencer",
                    style: fontFamilySemiBold.size14.black,
                  ),
                  const SizedBox(height: 8),

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isError ? Colors.red : Colors.grey.shade400,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<influencer_model.Datum>(
                        isExpanded: true,
                        value: selectedInfluencer,
                        hint: const Text("Choose Influencer"),
                        items: filteredInfluencers.map((inf) {
                          return DropdownMenuItem(
                            value: inf,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  child: (inf.image != null &&
                                          inf.image!.isNotEmpty)
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadiusGeometry.all(
                                                  Radius.circular(25)),
                                          child: WebImage(imageUrl: inf.image!))
                                      : (inf.image == null ||
                                              inf.image!.isEmpty)
                                          ? const Icon(Icons.person, size: 16)
                                          : null,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    inf.name ?? "",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedInfluencer = value;
                            isError = false;
                          });
                        },
                      ),
                    ),
                  ),

                  if (isError)
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        "Please select an influencer",
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(continueButton),
                ),
                onPressed: () {
                  if (selectedInfluencer == null) {
                    setState(() => isError = true);
                    return;
                  }

                  Navigator.pop(context, selectedInfluencer);
                },
                child: Text(
                  "Reassign",
                  style: fontFamilySemiBold.size14.white,
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> showPaymentStatusDialog({
  required BuildContext context,
  required Function(Map<String, dynamic>) onConfirm,
}) {
  dynamic selectedStatus;
  DateTime? paymentDate;
  bool isError = false;
  bool isDateError = false;

  final List<Map<String, dynamic>> statusList = [
    {'id': 1, 'name': 'Paid'},
    // {'id': 2, 'name': 'Unpaid'},
  ];

  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: "Payment",
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (context, animation, _, __) {
      final scale = Tween<double>(begin: 0.9, end: 1.0).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
      );
      final fade = Tween<double>(begin: 0, end: 1).animate(animation);

      return FadeTransition(
        opacity: fade,
        child: ScaleTransition(
          scale: scale,
          child: Center(
            child: StatefulBuilder(
              builder: (context, setState) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxWidth: 500, minWidth: 350),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// Title
                          const Text(
                            "Payment Status",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// Status Dropdown
                          SizedBox(
                            width: 420,
                            child: DynamicSingleSearchDropdown(
                              label: "Status",
                              items: statusList,
                              selectedItem: selectedStatus,
                              isError: isError,
                              errorText: "Please select a status",
                              onChanged: (value) {
                                setState(() {
                                  selectedStatus = value;
                                  isError = false;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// Payment Date (only if Paid)
                          if (selectedStatus?['name'] == 'Paid') ...[
                            InkWell(
                              onTap: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: paymentDate ?? DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime.now(),
                                );

                                if (pickedDate != null) {
                                  setState(() {
                                    paymentDate = pickedDate;
                                    isDateError = false;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        isDateError ? Colors.red : Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      paymentDate == null
                                          ? "Select payment date"
                                          : "${paymentDate!.day}-${paymentDate!.month}-${paymentDate!.year}",
                                    ),
                                    const Icon(Icons.calendar_today, size: 18),
                                  ],
                                ),
                              ),
                            ),
                            if (isDateError)
                              const Padding(
                                padding: EdgeInsets.only(top: 6),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Please select payment date",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  ),
                                ),
                              ),
                          ],

                          const SizedBox(height: 24),

                          /// Buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel"),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    backgroundColor: MaterialStateProperty.all(
                                        continueButton),
                                  ),
                                  onPressed: () {
                                    if (selectedStatus == null) {
                                      setState(() => isError = true);
                                      return;
                                    }

                                    if (selectedStatus['name'] == 'Paid' &&
                                        paymentDate == null) {
                                      setState(() => isDateError = true);
                                      return;
                                    }

                                    final data = {
                                      "status": selectedStatus,
                                      "paymentDate": paymentDate,
                                    };
                                    Navigator.pop(context, data);
                                    onConfirm(data);
                                  },
                                  child: Text(
                                    "Confirm",
                                    style: fontFamilySemiBold.size13.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    },
  );
}
