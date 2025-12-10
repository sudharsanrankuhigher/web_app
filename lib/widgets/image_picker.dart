import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:html' as html;
import 'package:image_picker/image_picker.dart';

class UniversalImagePicker {
  static Future<Map<String, dynamic>?> pickImage() async {
    if (kIsWeb) {
      return _pickImageWeb();
    } else {
      return _pickImageMobile();
    }
  }

  // --- WEB PICKER ---
  static Future<Map<String, dynamic>?> _pickImageWeb() async {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    await uploadInput.onChange.first;

    final file = uploadInput.files?.first;
    if (file == null) return null;

    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);
    await reader.onLoad.first;

    return {
      'bytes': reader.result as Uint8List,
      'path': null,
    };
  }

  // --- MOBILE / DESKTOP PICKER ---
  static Future<Map<String, dynamic>?> _pickImageMobile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file == null) return null;

    return {
      'path': file.path,
      'bytes': null,
    };
  }
}
