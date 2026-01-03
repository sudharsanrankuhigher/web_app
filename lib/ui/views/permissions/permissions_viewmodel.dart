import 'package:stacked/stacked.dart';
import 'package:webapp/core/enum/permission_enum.dart';
import 'package:webapp/ui/views/permissions/model/permmission_check_model.dart';

class PermissionsViewModel extends BaseViewModel {
  bool isCheck = false;
  bool selectAll = false;

  final List<PermissionRow> permissions = [
    PermissionRow(
      name: 'dashboard',
      allowed: {PermissionType.view},
    ),
    PermissionRow(
      name: 'users',
      allowed: {PermissionType.view},
    ),
    PermissionRow(
      name: 'influencers',
      allowed: {
        PermissionType.view,
        PermissionType.add,
        PermissionType.edit,
        PermissionType.delete
      },
    ),
    PermissionRow(name: 'services', allowed: {
      PermissionType.add,
      PermissionType.view,
      PermissionType.edit,
      PermissionType.delete
    }),
    PermissionRow(name: 'city', allowed: {
      PermissionType.add,
      PermissionType.view,
      PermissionType.edit,
      PermissionType.delete
    }),
    PermissionRow(name: 'state', allowed: {
      PermissionType.add,
      PermissionType.view,
      PermissionType.edit,
      PermissionType.delete
    }),
    PermissionRow(name: 'plans', allowed: {
      PermissionType.add,
      PermissionType.view,
      PermissionType.edit,
      PermissionType.delete
    }),
    PermissionRow(
        name: 'requests', allowed: {PermissionType.view, PermissionType.edit}),
    PermissionRow(name: 'promote_projects', allowed: {
      PermissionType.add,
      PermissionType.view,
      PermissionType.edit
    }),
    PermissionRow(name: 'contact_supports', allowed: {PermissionType.delete}),
    PermissionRow(name: 'company', allowed: {
      PermissionType.view,
      PermissionType.edit,
      PermissionType.delete,
      PermissionType.add
    }),
    PermissionRow(name: 'sub_admin', allowed: {
      PermissionType.add,
      PermissionType.view,
      PermissionType.edit,
      PermissionType.delete
    }),
    PermissionRow(name: 'reports', allowed: {PermissionType.view}),
  ];

  void toggleSelectAll(bool value) {
    selectAll = value;
    for (final p in permissions) {
      if (p.add != value) {
        p.add = value;
        // print('Row: ${p.name} | Permission: add | Value: $value');
        print('Row: ${p.name}_add | Value: $value');
      }

      if (p.view != value) {
        p.view = value;
        // print('Row: ${p.name} | Permission: view | Value: $value');
        print('Row: ${p.name}_view | Value: $value');
      }

      if (p.edit != value) {
        p.edit = value;
        // print('Row: ${p.name} | Permission: edit | Value: $value');
        print('Row: ${p.name}_edit | Value: $value');
      }

      if (p.delete != value) {
        p.delete = value;
        // print('Row: ${p.name} | Permission: delete | Value: $value');
        print('Row: ${p.name}_delete | Value: $value');
      }
    }

    print("SelectAll = $selectAll");
    notifyListeners();
  }

  void updateRow({
    required String rowName,
    required String permission,
    required bool value,
  }) {
    selectAll = permissions.every((e) => e.isAllSelected);
    notifyListeners();
    print(
      'Row: $rowName | Permission: $permission | Value: $value',
    );
    print('Row: ${rowName}_$permission | Value: $value');
  }
}
