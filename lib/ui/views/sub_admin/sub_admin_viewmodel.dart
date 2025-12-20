import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/core/navigation/navigation_mixin.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/sub_admin/model/sub_admin_model.dart';
import 'package:webapp/ui/views/sub_admin/widgets/sub_admin_add_edit_dialog.dart';
import 'package:webapp/ui/views/sub_admin/widgets/sub_admin_table_source.dart';
import 'package:webapp/widgets/common_button.dart';

class SubAdminViewModel extends BaseViewModel with NavigationMixin {
  SubAdminViewModel() {
    loadData();
  }

  List<SubAdminModel> subAdmins = [];
  late SubAdminTableSource tableSource;

  void loadData() {
    subAdmins = [
      SubAdminModel(
        sNo: 1,
        name: "John",
        phone: "9876543210",
        email: "john@mail.com",
        gender: "Male",
        dob: DateTime(1995, 5, 12),
        state: "Tamil Nadu",
        city: "Chennai",
        access: ["Payment", "Add Project"],
        imageUrl: "",
        idImageUrl: "",
        loginTime: DateTime.now().subtract(const Duration(hours: 2)),
        onlineAt: DateTime.now().subtract(const Duration(minutes: 5)),
        logoutTime: null,
        isActive: true,
      ),
    ];

    _refreshTable();
  }

  // ---------- ADD ----------
  Future<void> onAdd(BuildContext context) async {
    final result = await CommonSubAdminDialog.show(context);
    if (result == null) return;

    subAdmins.add(
      SubAdminModel(
        sNo: subAdmins.length + 1,
        name: result["name"],
        phone: result["phone"],
        email: result["email"],
        gender: result["gender"],
        dob: result["dob"],
        state: result["state"],
        city: result["city"],
        access: result["access"],
        imageUrl: result["image"],
        idImageUrl: result["idImage"],
        isActive: result["status"],
        loginTime: null,
        logoutTime: null,
        onlineAt: null,
      ),
    );

    _refreshTable();
  }

  // ---------- EDIT ----------
  Future<void> onEdit(SubAdminModel model) async {
    final result = await CommonSubAdminDialog.show(
      StackedService.navigatorKey!.currentContext!,
      model: model,
    );
    if (result == null) return;

    final index = subAdmins.indexOf(model);
    if (index == -1) return;

    subAdmins[index] = SubAdminModel(
      sNo: model.sNo,
      name: result["name"],
      phone: result["phone"],
      email: result["email"],
      gender: result["gender"],
      dob: result["dob"],
      state: result["state"],
      city: result["city"],
      access: result["access"],
      imageUrl: result["image"],
      idImageUrl: result["idImage"],
      isActive: result["status"],
      loginTime: model.loginTime,
      logoutTime: model.logoutTime,
      onlineAt: model.onlineAt,
    );

    _refreshTable();
  }

  void onDelete(SubAdminModel model) {
    subAdmins.remove(model);
    _refreshTable();
  }

  void _refreshTable() {
    tableSource = SubAdminTableSource(
      subAdmins,
      onEdit,
      confirmDelete,
    );
    notifyListeners();
  }

  void confirmDelete(SubAdminModel service) {
    showDialog(
      context: StackedService.navigatorKey!.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: Text(
              "Are you sure you want to delete ${service.name} Sub-Admin?"),
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
                  onDelete(service);
                  Navigator.pop(StackedService
                      .navigatorKey!.currentContext!); // close dialog
                }),
          ],
        );
      },
    );
  }
}
