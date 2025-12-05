
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class UniversalImagePicker {
  static Future<Map<String, dynamic>?> pickImage() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        return {
          'bytes': result.files.single.bytes,
          'path': null,
        };
      }
      return null;
    }

    // ANDROID / IOS
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      return {
        'bytes': null,
        'path': picked.path,
      };
    }
    return null;
  }
}
