import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/core/enum/permission_enum.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/views/permissions/permissions_viewmodel.dart';
import 'package:webapp/widgets/permissions_cells.dart';

Widget permissionTable(PermissionsViewModel vm) {
  final bool isExtended =
      MediaQuery.of(StackedService.navigatorKey!.currentContext!).size.width >
          1440;

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: white,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          children: [
            // Checkbox(value: false, onChanged: (_) {}),
            const Text(
              'Admin Module',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            if (isExtended) Text('Select All Submenu Permissions'),
            Checkbox(
              value: vm.selectAll,
              onChanged: (v) => vm.toggleSelectAll(v ?? false),
            ),
          ],
        ),

        verticalSpacing12,

        // Table Header
        Container(
          color: Colors.grey.shade300,
          padding: const EdgeInsets.symmetric(vertical: 10) + leftPadding8,
          child: Row(
            children: const [
              HeaderCell('Submenu', TextAlign.start, flex: 3),
              HeaderCell('Add', TextAlign.center),
              HeaderCell('View', TextAlign.center),
              HeaderCell('Edit', TextAlign.center),
              HeaderCell('Delete', TextAlign.center),
            ],
          ),
        ),

        // Rows
        ...vm.permissions.map((row) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
            child: Row(
              children: [
                TextCell(row.name, flex: 3),
                CheckCell(
                  enabled: row.allowed.contains(PermissionType.add),
                  value: row.add,
                  onChanged: (v) {
                    row.add = v ?? false;
                    vm.updateRow(
                      permission: "add",
                      rowName: row.name,
                      value: v ?? false,
                    );
                  },
                ),
                CheckCell(
                  enabled: row.allowed.contains(PermissionType.view),
                  value: row.view,
                  onChanged: (v) {
                    row.view = v ?? false;
                    vm.updateRow(
                      permission: "view",
                      rowName: row.name,
                      value: v ?? false,
                    );
                  },
                ),
                CheckCell(
                  enabled: row.allowed.contains(PermissionType.edit),
                  value: row.edit,
                  onChanged: (v) {
                    row.edit = v ?? false;
                    vm.updateRow(
                      permission: "edit",
                      rowName: row.name,
                      value: v ?? false,
                    );
                  },
                ),
                CheckCell(
                  enabled: row.allowed.contains(PermissionType.delete),
                  value: row.delete,
                  onChanged: (v) {
                    row.delete = v ?? false;
                    vm.updateRow(
                      permission: "delete",
                      rowName: row.name,
                      value: v ?? false,
                    );
                  },
                ),
              ],
            ),
          );
        }).toList(),
      ],
    ),
  );
}
