import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webapp/ui/views/services/services_viewmodel.dart';

Widget buildSafeImage(ServicesViewModel vm) {
  // 1) If Web bytes are set
  if (vm.imageBytes != null) {
    return Image.memory(
      vm.imageBytes!,
      fit: BoxFit.fill,
      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 50),
    );
  }

  // 2) If API sends URL
  if (vm.imagePath != null && vm.imagePath!.startsWith("http")) {
    return Image.network(
      vm.imagePath!,
      fit: BoxFit.fill,
      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 50),
    );
  }

  // 3) If local file path (mobile/desktop)
  if (vm.imagePath != null &&
      vm.imagePath!.isNotEmpty &&
      !kIsWeb &&
      File(vm.imagePath!).existsSync()) {
    return Image.file(
      File(vm.imagePath!),
      fit: BoxFit.fill,
      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 50),
    );
  }

  // 4) Fallback
  return const Icon(Icons.broken_image, size: 50);
}
