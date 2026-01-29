import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/widgets/search_drop_down_widget.dart';

Future<void> showRejectConfirmationDialog({
  required BuildContext context,
  required String itemName,
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
                          "Are you sure you want to reject the $itemName from Client request?",
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
                constraints: const BoxConstraints(maxWidth: 500, minWidth: 300),
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
                                "payment": paymentCtrl.text,
                                "commission": commissionCtrl.text,
                                "note": noteCtrl.text,
                                "verification": {
                                  "instagram": instagram,
                                  "facebook": facebook,
                                  "youtube": youtube,
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
