import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/ui/views/services/services_viewmodel.dart';
import 'package:webapp/widgets/buil_safe_image.dart';
import 'package:webapp/widgets/image_picker.dart';
import 'package:webapp/widgets/initial_textform.dart';
import 'package:file_picker/file_picker.dart';

class CommonServiceDialog {
  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    String? existingName,
    Uint8List? existingBytes,
    String? existingImagePath,
  }) async {
    return showDialog<Map<String, dynamic>>(
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
                child: Column(
                  children: [
                    InitialTextForm(
                      hintText: "Service Name",
                      radius: 12,
                      initialValue: model.serviceName,
                      onChanged: (value) => model.setServiceName(value ?? ''),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () async {
                        final result = await UniversalImagePicker.pickImage();
                        if (result != null) {
                          if (kIsWeb && result['bytes'] != null) {
                            model.setImageBytes(result['bytes']);
                          } else {
                            model.setImagePath(result['path']);
                          }
                        }
                      },
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: model.imagePath != null &&
                                model.imagePath!.isNotEmpty
                            ? buildSafeImage(model)
                            : const Icon(Icons.upload_file, size: 50),
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
                  onPressed: () {
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
