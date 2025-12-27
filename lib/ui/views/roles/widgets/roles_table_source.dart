import 'package:flutter/material.dart';
import 'package:webapp/ui/views/roles/model/roles_model.dart';

class RolesTableSource extends DataTableSource {
  final List<RolesModel> roles;
  final Function(RolesModel) onEdit;
  final Function(RolesModel) onDelete;

  RolesTableSource({
    required this.roles,
    required this.onEdit,
    required this.onDelete,
  });

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
        DataCell(Text(role.name)), // Name
        DataCell(
          Row(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => onEdit(role),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete(role),
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
