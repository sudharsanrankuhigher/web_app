import 'dart:async';
import 'dart:js_interop';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web/web.dart' as web;

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
    final web.HTMLInputElement uploadInput =
        web.document.createElement('input') as web.HTMLInputElement;
    uploadInput.type = 'file';
    if (accept != null) {
      uploadInput.accept = accept;
    }

    final changeCompleter = Completer<void>();
    final changeListener = (web.Event event) {
      changeCompleter.complete();
    }.toJS;

    uploadInput.addEventListener('change', changeListener);
    uploadInput.click();

    await changeCompleter.future;
    uploadInput.removeEventListener('change', changeListener);

    final file = uploadInput.files?.item(0);
    if (file == null) return null;

    final reader = web.FileReader();
    reader.readAsArrayBuffer(file);

    final loadCompleter = Completer<void>();
    final loadListener = (web.Event event) {
      loadCompleter.complete();
    }.toJS;

    reader.addEventListener('load', loadListener);
    await loadCompleter.future;
    reader.removeEventListener('load', loadListener);

    final result = reader.result;
    if (result == null) return null;

    return {
      'bytes': (result as JSArrayBuffer).toDart.asUint8List(),
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
