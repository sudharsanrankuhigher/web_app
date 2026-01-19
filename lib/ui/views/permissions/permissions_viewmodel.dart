import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/core/enum/permission_enum.dart';
import 'package:webapp/services/api_service.dart';
import 'package:webapp/ui/views/permissions/model/permission_row.dart';
import 'package:webapp/ui/views/permissions/model/permmission_check_model.dart';
import 'package:webapp/ui/views/roles/model/roles_model.dart' as role_model;

class PermissionsViewModel extends BaseViewModel {
  PermissionsViewModel() {
    getRoles();
  }
  bool isCheck = false;
  bool selectAll = false;

  int? _selectedRoleId;
  int? get selectedRoleId => _selectedRoleId;

  void setSelectedRoleId(int? value) {
    _selectedRoleId = value;
    notifyListeners();
  }

  final _dialogService = locator<DialogService>();
  final _apiService = locator<ApiService>();

  List<role_model.Datum> roles = [];

  Future<void> getRoles() async {
    final res = await runBusyFuture(_apiService.getAllRole());
    roles = res.data ?? [];
    print(selectedRoleId);
  }

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
    // PermissionRow(name: 'city', allowed: {
    //   PermissionType.add,
    //   PermissionType.view,
    //   PermissionType.edit,
    //   PermissionType.delete
    // }),
    // PermissionRow(name: 'state', allowed: {
    //   PermissionType.add,
    //   PermissionType.view,
    //   PermissionType.edit,
    //   PermissionType.delete
    // }),
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
      // ADD
      if (p.allowed.contains(PermissionType.add)) {
        p.add = value;
        print('Row: add_${p.name} | Value: $value');
      }

      // VIEW
      if (p.allowed.contains(PermissionType.view)) {
        p.view = value;
        print('Row: view_${p.name} | Value: $value');
      }

      // EDIT
      if (p.allowed.contains(PermissionType.edit)) {
        p.edit = value;
        print('Row: edit_${p.name} | Value: $value');
      }

      // DELETE
      if (p.allowed.contains(PermissionType.delete)) {
        p.delete = value;
        print('Row: delete_${p.name} | Value: $value');
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
    print('Row: ${permission}_${rowName} | Value: $value');
  }

  List<SpecialPermissionRow> specialPermissons = [
    SpecialPermissionRow(name: 'payment'),
    SpecialPermissionRow(name: 'add_call'),
    SpecialPermissionRow(name: 'add _project'),
  ];

  bool selectAllSpecial = false;

  /// Toggle single row
  void updateSpecialRow({required String rowName, required bool value}) {
    final row = specialPermissons.firstWhere((r) => r.name == rowName);
    row.enabled = value;

    print('Special Permission Changed → ${row.name} : $value');

    // Update header checkbox
    selectAllSpecial = specialPermissons.every((r) => r.enabled);
    notifyListeners();
  }

  /// Toggle all rows from "Select All" checkbox
  void toggleSelectAllSpecial(bool value) {
    selectAllSpecial = value;
    for (var r in specialPermissons) {
      r.enabled = value;
      print('Special Permission SelectAll → ${r.name} : $value');
    }
    notifyListeners();
  }
}
