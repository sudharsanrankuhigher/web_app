import 'dart:typed_data';

class ProjectImage {
  final String? path; // mobile
  final Uint8List? bytes; // web

  ProjectImage({this.path, this.bytes});

  bool get isNetwork => path?.startsWith('http') ?? false;
  bool get isFile => path != null && !isNetwork;
  bool get isMemory => bytes != null;
}
