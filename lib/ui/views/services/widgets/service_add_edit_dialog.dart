import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/ui/views/services/services_viewmodel.dart';
import 'package:webapp/widgets/editable_profile_avatar.dart';
import 'package:webapp/widgets/initial_textform.dart';

class CommonServiceDialog {
  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    String? existingName,
    Uint8List? existingBytes,
    String? existingImagePath,
  }) async {
    final formKey = GlobalKey<FormState>(); // ✅ Added formKey

    return showDialog<Map<String, dynamic>>(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return ViewModelBuilder<ServicesViewModel>.reactive(
          viewModelBuilder: () => ServicesViewModel(
            initialName: existingName,
            initialBytes: existingBytes,
            initialPath: existingImagePath,
          ),
          builder: (context, model, _) {
            return AlertDialog(
              title:
                  Text(existingName == null ? "Add Service" : "Edit Service"),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey, // ✅ Attach key
                  child: Column(
                    children: [
                      // ----- Service Name -----
                      InitialTextForm(
                        hintText: "Service Name",
                        radius: 12,
                        initialValue: model.serviceName,
                        onChanged: (value) => model.setServiceName(value ?? ''),
                        validator: (value) {
                          // ✅ Add validation
                          if (value == null || value.trim().isEmpty) {
                            return "Service name is required";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      // ----- Image Picker -----
                      EditableServiceImagePicker(
                        imageUrl: existingImagePath, // network
                        imageBytes: model.imageBytes, // web
                        imagePath: model.imagePath, // mobile
                        onImageSelected: (bytes, path) {
                          if (bytes != null) {
                            model.setImageBytes(bytes);
                          } else {
                            model.setImagePath(path!);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // -------- Buttons --------
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // VALIDATE BEFORE SAVE
                    if (!formKey.currentState!.validate()) return;

                    Navigator.pop(context, {
                      "serviceName": model.serviceName,
                      "imageBytes": model.imageBytes,
                      "imagePath": model.imagePath,
                    });
                  },
                  child: Text(existingName == null ? "Save" : "Update"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
