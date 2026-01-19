import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/services/api_service.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/roles/model/roles_model.dart' as role_model;
import 'package:webapp/ui/views/roles/widgets/role_add_edit_dialog.dart';
import 'package:webapp/ui/views/roles/widgets/roles_table_source.dart';
import 'package:webapp/widgets/common_button.dart';

class RolesViewModel extends BaseViewModel {
  RolesViewModel({
    String? initialName,
  }) : name = initialName ?? '' {
    loadRoles();
  }
  List<role_model.Datum> roles = [];
  late RolesTableSource tableSource;

  final _dialogService = locator<DialogService>();
  final _apiService = locator<ApiService>();

  final TextEditingController nameController = TextEditingController();
  String? imagePath; // mobile
  String name = '';

  void setname(String value) {
    name = value;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool? _isLoading = false;
  bool? get isLoading => _isLoading;

  void setImagePath(String path) {
    imagePath = path;
    notifyListeners();
  }

  Future<void> loadRoles() async {
    _setLoading(true);
    try {
      final res = await _apiService.getAllRole();
      roles = res.data ?? [];
      // allroles = List.from(roles); // 🔥 MASTER LIST
      // filteredroles = List.from(roles); // 🔥 INITIAL TABLE DATA
    } catch (e) {
      roles = [];
    } finally {
      setBusy(false);
      _updateTableSource(filtered: roles);
      _setLoading(false);
    }
  }

  void _updateTableSource({filtered}) {
    tableSource = RolesTableSource(
      roles: roles,
      onEdit: editRole,
      onDelete: confirmDelete,
    );
    notifyListeners();
  }

  // ------------------ ADD SERVICE ------------------
  void addRole(role) {
    saveOrUpdate(role);
    _updateTableSource();
  }

  void editRole(roles) async {
    final result = await CommonRoleDialog.show(
      StackedService.navigatorKey!.currentContext!,
      existingName: roles.name,
    );

    if (result == null) return;

    // Create updated model
    final updated = {
      'id': roles,
      "name": result["name"],
    };

    saveOrUpdate(updated);
  }

  Future<void> saveOrUpdate(role) async {
    _setLoading(true);

    try {
      await _apiService.addRole(role);

      final res = await _apiService.getAllRole();
      roles = res.data ?? [];
    } catch (e) {
      debugPrint('Save/Update failed: $e');
    } finally {
      _updateTableSource();
      _setLoading(false);
    }
  }

  Future<void> deleteService(role) async {
    try {
      await _apiService.deleteRole(role.id);
    } catch (e) {
      debugPrint('Delete failed: $e');
    } finally {
      loadRoles();
    }
    notifyListeners();
  }

  void confirmDelete(role_model.Datum service) {
    showDialog(
      context: StackedService.navigatorKey!.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: Text("Are you sure you want to delete ${service.name}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // cancel
              child: const Text("Cancel"),
            ),
            CommonButton(
                width: 100,
                margin: defaultPadding10,
                padding: defaultPadding8,
                buttonColor: Colors.red,
                text: "Delete",
                textStyle: fontFamilyMedium.size14.white,
                onTap: () {
                  deleteService(service);
                  Navigator.pop(context); // close dialog
                }),
          ],
        );
      },
    );
  }
}
