import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  bool? _hasPermissions = false;
  bool? get hasPermissions => _hasPermissions;

  int? _selectedRoleId;
  int? get selectedRoleId => _selectedRoleId;
  Set<String> selectedPermissions = {};
  Set<String> originalPermissions = {};

  void setSelectedRoleId(int? value) {
    // if (value == null) return;
    _selectedRoleId = value;
    getAllPermissions(_selectedRoleId);

    notifyListeners();
  }

  void _addPermission(String value) {
    selectedPermissions.add(value);
    print(selectedPermissions);
  }

  void _removePermission(String value) {
    selectedPermissions.remove(value);
  }

  List<String> get permissionsForApi => selectedPermissions.toList();

  Future<void> savePermissions() async {
    if (_selectedRoleId == null) return;

    final confirmed = await showSaveConfirmationDialog();
    if (!confirmed) return; // ❌ User cancelled

    setBusy(true);

    try {
      print(permissionsForApi);
      await runBusyFuture(
          _apiService.addPermissions(_selectedRoleId, permissionsForApi));
      originalPermissions = selectedPermissions.toSet();
      await getAllPermissions(_selectedRoleId);

      notifyListeners();
    } catch (e) {
      print(e);
      setBusy(false);
    }
    setBusy(false);
  }

  final _dialogService = locator<DialogService>();
  final _apiService = locator<ApiService>();

  List<role_model.Datum> roles = [];

  Future<void> getRoles() async {
    final res = await runBusyFuture(_apiService.getAllRole());
    roles = res.data ?? [];
    print(_selectedRoleId);
  }

  bool? _isPermissionsLoading = false;
  bool? get isPermissionsLoading => _isPermissionsLoading;
  void permmissionsLoading(bool? value) {
    _isPermissionsLoading = value;
    notifyListeners();
  }

  Future<void> getAllPermissions(int? id) async {
    if (id == null) return;

    setBusy(true);
    permmissionsLoading(true);

    selectedPermissions.clear();
    originalPermissions.clear();

    try {
      final res = await runBusyFuture(_apiService.getPermissions(id));

      for (final e in res.data ?? []) {
        _addPermission(e.abilityName!);
        originalPermissions.add(e.abilityName!);
      }

      syncUiWithPermissions(); // ✅ IMPORTANT
    } catch (e) {
      print(e);
    }

    permmissionsLoading(false);
    setBusy(false);
  }

  hasPermissionChanges() {
    _hasPermissions = !setEquals(selectedPermissions, originalPermissions);
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
    PermissionRow(name: 'promotion_projects', allowed: {
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
    PermissionRow(name: 'report', allowed: {PermissionType.view}),
    PermissionRow(name: 'banner', allowed: {
      PermissionType.view,
      PermissionType.edit,
      PermissionType.delete,
      PermissionType.add
    }),
    PermissionRow(name: 'location_contact', allowed: {
      PermissionType.view,
      PermissionType.edit,
      PermissionType.delete,
      PermissionType.add
    }),
  ];

  void toggleSelectAll(bool value) {
    selectAll = value;

    for (final p in permissions) {
      if (p.allowed.contains(PermissionType.add)) {
        p.add = value;
        value
            ? _addPermission('add_${p.name}')
            : _removePermission('add_${p.name}');
      }

      if (p.allowed.contains(PermissionType.view)) {
        p.view = value;
        value
            ? _addPermission('view_${p.name}')
            : _removePermission('view_${p.name}');
      }

      if (p.allowed.contains(PermissionType.edit)) {
        p.edit = value;
        value
            ? _addPermission('edit_${p.name}')
            : _removePermission('edit_${p.name}');
      }

      if (p.allowed.contains(PermissionType.delete)) {
        p.delete = value;
        value
            ? _addPermission('delete_${p.name}')
            : _removePermission('delete_${p.name}');
      }
      hasPermissionChanges();
    }

    print('SelectAll → $value');
    print('Current list → $selectedPermissions');

    notifyListeners();
  }

  void updateRow({
    required String rowName,
    required String permission,
    required bool value,
  }) {
    final key = '${permission}_$rowName';

    if (value) {
      _addPermission(key);
    } else {
      _removePermission(key);
    }

    selectAll = permissions.every((e) => e.isAllSelected);
    notifyListeners();
    print(
      'Row: $rowName | Permission: $permission | Value: $value',
    );
    print('Row: ${permission}_${rowName} | Value: $value');
    hasPermissionChanges();
  }

  List<SpecialPermissionRow> specialPermissons = [
    SpecialPermissionRow(name: 'payment'),
    SpecialPermissionRow(name: 'add_call'),
    SpecialPermissionRow(name: 'add_project'),
    SpecialPermissionRow(name: 'client_payment_approval'),
    SpecialPermissionRow(name: 'company_payment_approval'),
  ];

  bool selectAllSpecial = false;

  /// Toggle single row
  void updateSpecialRow({
    required String rowName,
    required bool value,
  }) {
    final row = specialPermissons.firstWhere((r) => r.name == rowName);
    row.enabled = value;

    if (value) {
      _addPermission(row.name);
    } else {
      _removePermission(row.name);
    }

    selectAllSpecial = specialPermissons.every((r) => r.enabled);

    print('Special → ${row.name} : $value');
    print('Current list → $selectedPermissions');
    hasPermissionChanges();

    notifyListeners();
  }

  /// Toggle all rows from "Select All" checkbox
  void toggleSelectAllSpecial(bool value) {
    selectAllSpecial = value;

    for (final r in specialPermissons) {
      r.enabled = value;

      value ? _addPermission(r.name) : _removePermission(r.name);
    }

    print('Special SelectAll → $value');
    print('Current list → $selectedPermissions');
    hasPermissionChanges();

    notifyListeners();
  }

  void syncUiWithPermissions() {
    // NORMAL PERMISSIONS
    for (final p in permissions) {
      p.add = selectedPermissions.contains('add_${p.name}');
      p.view = selectedPermissions.contains('view_${p.name}');
      p.edit = selectedPermissions.contains('edit_${p.name}');
      p.delete = selectedPermissions.contains('delete_${p.name}');
    }

    // SPECIAL PERMISSIONS
    for (final r in specialPermissons) {
      r.enabled = selectedPermissions.contains(r.name);
    }

    selectAll = permissions.every((e) => e.isAllSelected);
    selectAllSpecial = specialPermissons.every((e) => e.enabled);
    hasPermissionChanges();

    notifyListeners();
  }

  Future<bool> showSaveConfirmationDialog() async {
    final result = await showDialog<bool>(
      context: StackedService.navigatorKey!.currentContext!,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Save'),
          content: const Text(
            'Are you sure you want to save permission changes?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}
