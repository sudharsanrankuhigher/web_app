import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/core/helper/permission_helper.dart';
import 'package:webapp/ui/views/roles/model/roles_model.dart' as role_model;

class RolesTableSource extends DataTableSource {
  final List<role_model.Datum> roles;
  final Function(role_model.Datum) onEdit;
  final Function(role_model.Datum) onDelete;

  RolesTableSource({
    required this.roles,
    required this.onEdit,
    required this.onDelete,
  });

  final _dialogService = locator<DialogService>();

  @override
  DataRow? getRow(int index) {
    if (roles.isEmpty) {
      return const DataRow(
        cells: [
          DataCell(Text("")),
          DataCell(Center(child: Text("No data found"))),
          DataCell(Text("")),
          DataCell(Text("")),
        ],
      );
    }

    final role = roles[index];

    return DataRow(
      color: WidgetStateProperty.resolveWith<Color?>(
        (states) => index.isEven ? Colors.white : Colors.grey.shade100,
      ),
      cells: [
        DataCell(Text("${index + 1}")), // S.No
        DataCell(Text(role.id.toString())), // Name
        DataCell(Text(role.name!)), // Name
        DataCell(
          Row(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => (PermissionHelper.instance.canEdit('role'))
                    ? onEdit(role)
                    : _dialogService.showDialog(
                        title: "Warning",
                        description:
                            "Locked 🔒 – You need special permission to access this.",
                        buttonTitle: 'ok'),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => PermissionHelper.instance.canDelete('role')
                    ? onDelete(role)
                    : _dialogService.showDialog(
                        title: "Warning",
                        description:
                            "Locked 🔒 – You need special permission to access this.",
                        buttonTitle: 'ok'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => roles.isEmpty ? 1 : roles.length;
  @override
  int get selectedRowCount => 0;
}
