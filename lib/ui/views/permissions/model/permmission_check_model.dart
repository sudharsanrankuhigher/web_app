import 'package:webapp/core/enum/permission_enum.dart';

class PermissionRow {
  final String name;
  final Set<PermissionType> allowed; // 👈 NEW

  bool add;
  bool view;
  bool edit;
  bool delete;

  PermissionRow({
    required this.name,
    required this.allowed,
    this.add = false,
    this.view = false,
    this.edit = false,
    this.delete = false,
  });

  bool get isAllSelected =>
      (!allowed.contains(PermissionType.add) || add) &&
      (!allowed.contains(PermissionType.view) || view) &&
      (!allowed.contains(PermissionType.edit) || edit) &&
      (!allowed.contains(PermissionType.delete) || delete);
}
