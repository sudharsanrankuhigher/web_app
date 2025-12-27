import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/roles/model/roles_model.dart';
import 'package:webapp/ui/views/roles/widgets/role_add_edit_dialog.dart';
import 'package:webapp/ui/views/roles/widgets/roles_table_source.dart';
import 'package:webapp/widgets/common_button.dart';

class RolesViewModel extends BaseViewModel {
  RolesViewModel({
    String? initialName,
  }) : name = initialName ?? '' {
    loadRoles();
  }
  List<RolesModel> roles = [];
  late RolesTableSource tableSource;

  final TextEditingController nameController = TextEditingController();
  String? imagePath; // mobile
  String name = '';

  void setname(String value) {
    name = value;
    notifyListeners();
  }

  void setImagePath(String path) {
    imagePath = path;
    notifyListeners();
  }

  void loadRoles() {
    roles = [
      RolesModel(
        id: 1,
        name: "Super Admin",
      ),
      RolesModel(
        id: 2,
        name: "Admin",
      ),
      RolesModel(
        id: 2,
        name: "sub Admin",
      ),
      // Add more...
    ];

    tableSource = RolesTableSource(
      roles: roles,
      onEdit: editService,
      onDelete: confirmDelete,
    );

    notifyListeners();
  }

  void _updateTableSource() {
    tableSource = RolesTableSource(
      roles: roles,
      onEdit: editService,
      onDelete: confirmDelete,
    );
    notifyListeners();
  }

  // ------------------ ADD SERVICE ------------------
  void addService(RolesModel service) {
    roles.add(service);
    _updateTableSource();
  }

  void editService(RolesModel roles) async {
    final result = await CommonRoleDialog.show(
      StackedService.navigatorKey!.currentContext!,
      existingName: roles.name,
    );

    if (result == null) return;

    // Create updated model
    final updated = RolesModel(
      id: roles.id,
      name: result["name"],
    );

    // 🚀 Call your UPDATE API here
    // await updateServiceApi(updated);

    // After API success → reload entire table
    loadRoles();
  }

  void deleteService(RolesModel role) {
    roles.remove(role);
    tableSource = RolesTableSource(
      roles: roles,
      onEdit: editService,
      onDelete: confirmDelete,
    );
    notifyListeners();
  }

  void confirmDelete(RolesModel service) {
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
