import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/widgets/image_picker.dart';
import 'package:webapp/widgets/web_image_loading.dart';

class ProfileImageEdit extends StatelessWidget {
  final String? imageUrl; // from API
  final Uint8List? imageBytes; // web picked image
  final String? imagePath; // mobile picked image
  final double radius;
  final Function(Uint8List? bytes, String? path) onImageSelected;
  final bool? isView;

  const ProfileImageEdit({
    Key? key,
    this.imageUrl,
    this.imageBytes,
    this.imagePath,
    this.isView = false,
    this.radius = 60, // default radius
    required this.onImageSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        // _buildCircleAvatar();
        GestureDetector(
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
      child: _buildCircleAvatar(),
    );
  }

  Widget _buildCircleAvatar() {
    final imageProvider = _getImageProvider();

    if (imageUrl != null && imageUrl!.isNotEmpty && imageProvider == null) {
      return Stack(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: Colors.grey[200],
            child: kIsWeb
                ? ClipRRect(
                    borderRadius: radius != null
                        ? BorderRadius.circular(radius)
                        : BorderRadius.circular(60),
                    child: WebImage(
                      imageUrl: imageUrl!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.fill,
                    ),
                  )
                : CachedNetworkImage(
                    imageUrl: Uri.encodeFull(imageUrl!),
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const Center(
                        child: CircularProgressIndicator(strokeWidth: 2)),
                    errorWidget: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 50),
                  ),
          ),
          if (isView == true)
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
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
                child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: grey,
                    ),
                    child: Icon(
                      Icons.add,
                      color: white,
                    )),
              ),
            ),
        ],
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[200],
      backgroundImage: imageProvider,
      child: (imageProvider == null)
          ? const Icon(Icons.upload_file, size: 40, color: Colors.grey)
          : null,
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

    // 3. No image
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
