class PermissionHelper {
  static PermissionHelper? _instance;

  final Set<String> userPermissions;

  PermissionHelper._internal(this.userPermissions);

  static void init(Set<String> userPermissions) {
    _instance = PermissionHelper._internal(userPermissions);
  }

  static PermissionHelper get instance {
    if (_instance == null) {
      return PermissionHelper._internal({});
    }
    return _instance!;
  }

  bool canView(String module) => userPermissions.contains('view_$module');
  bool canAdd(String module) => userPermissions.contains('add_$module');
  bool canEdit(String module) => userPermissions.contains('edit_$module');
  bool canDelete(String module) => userPermissions.contains('delete_$module');
  bool has(String permission) => userPermissions.contains(permission);
}
