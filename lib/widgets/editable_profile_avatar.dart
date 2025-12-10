import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:webapp/widgets/image_picker.dart'; // your picker

class EditableServiceImagePicker extends StatelessWidget {
  final String? imageUrl; // from API
  final Uint8List? imageBytes; // web picked image
  final String? imagePath; // mobile picked image
  final Function(Uint8List? bytes, String? path) onImageSelected;

  const EditableServiceImagePicker({
    Key? key,
    this.imageUrl,
    this.imageBytes,
    this.imagePath,
    required this.onImageSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await UniversalImagePicker.pickImage();

        if (result != null) {
          if (kIsWeb && result['bytes'] != null) {
            onImageSelected(result['bytes'], null); // return bytes
          } else {
            onImageSelected(null, result['path']); // return file path
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
        clipBehavior: Clip.hardEdge,
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    // 1. Web picked image
    if (imageBytes != null) {
      return Image.memory(
        imageBytes!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 50),
      );
    }

    // 2. Local file path (mobile)
    if (imagePath != null &&
        imagePath!.isNotEmpty &&
        !kIsWeb &&
        File(imagePath!).existsSync()) {
      return Image.file(
        File(imagePath!),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 50),
      );
    }

    // 3. Network image
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        placeholder: (_, __) => const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        errorWidget: (_, __, ___) => const Icon(Icons.broken_image, size: 50),
      );
    }

    // 4. Default icon
    return const Icon(Icons.upload_file, size: 50);
  }
}
