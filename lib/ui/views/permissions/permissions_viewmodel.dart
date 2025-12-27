import 'package:stacked/stacked.dart';
import 'package:webapp/core/enum/permission_enum.dart';
import 'package:webapp/ui/views/permissions/model/permmission_check_model.dart';

class PermissionsViewModel extends BaseViewModel {
  bool isCheck = false;
  bool selectAll = false;

  final List<PermissionRow> permissions = [
    PermissionRow(
      name: 'Dashboard',
      allowed: {PermissionType.view},
    ),
    PermissionRow(
      name: 'Users',
      allowed: {PermissionType.view},
    ),
    PermissionRow(
      name: 'Influencers',
      allowed: {
        PermissionType.view,
        PermissionType.add,
        PermissionType.edit,
        PermissionType.delete
      },
    ),
    PermissionRow(name: 'Services', allowed: {
      PermissionType.add,
      PermissionType.view,
      PermissionType.edit,
      PermissionType.delete
    }),
    PermissionRow(name: 'City', allowed: {
      PermissionType.add,
      PermissionType.view,
      PermissionType.edit,
      PermissionType.delete
    }),
    PermissionRow(name: 'State', allowed: {
      PermissionType.add,
      PermissionType.view,
      PermissionType.edit,
      PermissionType.delete
    }),
    PermissionRow(name: 'Plans', allowed: {
      PermissionType.add,
      PermissionType.view,
      PermissionType.edit,
      PermissionType.delete
    }),
    PermissionRow(
        name: 'Requests', allowed: {PermissionType.view, PermissionType.edit}),
    PermissionRow(name: 'Promote Projects', allowed: {
      PermissionType.add,
      PermissionType.view,
      PermissionType.edit
    }),
    PermissionRow(name: 'Contact Supports', allowed: {PermissionType.delete}),
    PermissionRow(name: 'Sub Admin', allowed: {
      PermissionType.add,
      PermissionType.view,
      PermissionType.edit,
      PermissionType.delete
    }),
    PermissionRow(name: 'Reports', allowed: {PermissionType.view}),
  ];

  void toggleSelectAll(bool value) {
    selectAll = value;
    for (final p in permissions) {
      if (p.add != value) {
        p.add = value;
        print('Row: ${p.name} | Permission: add | Value: $value');
      }

      if (p.view != value) {
        p.view = value;
        print('Row: ${p.name} | Permission: view | Value: $value');
      }

      if (p.edit != value) {
        p.edit = value;
        print('Row: ${p.name} | Permission: edit | Value: $value');
      }

      if (p.delete != value) {
        p.delete = value;
        print('Row: ${p.name} | Permission: delete | Value: $value');
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
  }
}
