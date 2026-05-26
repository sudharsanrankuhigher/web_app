import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/core/enum/permission_enum.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/views/permissions/permissions_viewmodel.dart';
import 'package:webapp/widgets/permissions_cells.dart';

Widget permissionTable(PermissionsViewModel vm) {
  final context = StackedService.navigatorKey!.currentContext!;
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final bool isExtended = MediaQuery.of(context).size.width > 1440;

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          children: [
            Text(
              'Admin Module',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            if (isExtended)
              Text(
                'Select All Submenu Permissions',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            Checkbox(
              value: vm.selectAll,
              onChanged: (v) => vm.toggleSelectAll(v ?? false),
            ),
          ],
        ),

        verticalSpacing12,

        // Table Header
        Container(
          color: isDark ? const Color(0xFF334155) : Colors.grey.shade300,
          padding: const EdgeInsets.symmetric(vertical: 10) + leftPadding8,
          child: const Row(
            children: [
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
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? const Color(0xFF334155) : Colors.grey,
                ),
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
