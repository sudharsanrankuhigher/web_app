import 'package:flutter/foundation.dart';
import 'dart:html' as html;
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class UniversalImagePicker {
  static Future<Map<String, dynamic>?> pickImage() async {
    if (kIsWeb) {
      return _pickFileWeb(accept: 'image/*');
    } else {
      return _pickImageMobile();
    }
  }

  static Future<Map<String, dynamic>?> pickImageOrPdf() async {
    if (kIsWeb) {
      return _pickFileWeb(accept: 'image/*,application/pdf');
    } else {
      // On mobile, this will only pick images. The user can add file_picker for PDF support.
      return _pickImageMobile();
    }
  }

  // --- WEB PICKER (Generic) ---
  static Future<Map<String, dynamic>?> _pickFileWeb({String? accept}) async {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement();
    if (accept != null) {
      uploadInput.accept = accept;
    }
    uploadInput.click();

    await uploadInput.onChange.first;

    final file = uploadInput.files?.first;
    if (file == null) return null;

    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);
    await reader.onLoad.first;

    return {
      'bytes': reader.result as Uint8List,
      'path': file.name,
    };
  }

  // --- MOBILE / DESKTOP PICKER ---
  static Future<Map<String, dynamic>?> _pickImageMobile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file == null) return null;

    final bytes = await file.readAsBytes();
    return {
      'path': file.path,
      'bytes': bytes,
    };
  }
}
