class SpecialPermissionRow {
  String name; // The title of the permission/module
  bool enabled; // Whether the checkbox is checked

  SpecialPermissionRow({
    required this.name,
    this.enabled = false, // default is unchecked
  });
}
