import 'dart:typed_data';

class ImageItem {
  final String? path; // mobile local file
  final Uint8List? bytes; // web picked image
  final String? url; // server image (edit mode)

  ImageItem({
    this.path,
    this.bytes,
    this.url,
  });

  bool get isNetwork => url != null;
  bool get isFile => path != null;
  bool get isWeb => bytes != null;
}
