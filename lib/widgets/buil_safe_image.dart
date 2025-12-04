import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webapp/ui/views/services/services_viewmodel.dart';

Widget buildSafeImage(ServicesViewModel vm) {
  final path = vm.imagePath!;

  // If API sends URL
  if (path.startsWith("http")) {
    return Image.network(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 50),
    );
  }

  // If local file path
  if (!kIsWeb && File(path).existsSync()) {
    return Image.file(
      File(path),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 50),
    );
  }

  // If invalid data
  return const Icon(Icons.broken_image, size: 50);
}
