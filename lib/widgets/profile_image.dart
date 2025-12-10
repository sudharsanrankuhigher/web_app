import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webapp/widgets/image_picker.dart';

class ProfileImageEdit extends StatelessWidget {
  final String? imageUrl; // from API
  final Uint8List? imageBytes; // web picked image
  final String? imagePath; // mobile picked image
  final double radius;
  final Function(Uint8List? bytes, String? path) onImageSelected;

  const ProfileImageEdit({
    Key? key,
    this.imageUrl,
    this.imageBytes,
    this.imagePath,
    this.radius = 60, // default radius
    required this.onImageSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await UniversalImagePicker.pickImage();

        if (result != null) {
          if (kIsWeb && result['bytes'] != null) {
            onImageSelected(result['bytes'], null); // web
          } else {
            onImageSelected(null, result['path']); // mobile
          }
        }
      },
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey[200],
        backgroundImage: _getImageProvider(),
        child: _showIconIfNoImage(),
      ),
    );
  }

  ImageProvider? _getImageProvider() {
    // 1. Web picked image
    if (imageBytes != null) {
      return MemoryImage(imageBytes!);
    }

    // 2. Mobile picked file
    if (imagePath != null &&
        imagePath!.isNotEmpty &&
        !kIsWeb &&
        File(imagePath!).existsSync()) {
      return FileImage(File(imagePath!));
    }

    // 3. Network image
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImageProvider(imageUrl!);
    }

    // 4. No image
    return null;
  }

  Widget? _showIconIfNoImage() {
    if (imageBytes == null &&
        imagePath == null &&
        (imageUrl == null || imageUrl!.isEmpty)) {
      return const Icon(Icons.upload_file, size: 40, color: Colors.grey);
    }
    return null;
  }
}
