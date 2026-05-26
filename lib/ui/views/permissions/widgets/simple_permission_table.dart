import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/permissions/permissions_viewmodel.dart';

Widget simplePermissionTable(PermissionsViewModel vm) {
  final context = StackedService.navigatorKey!.currentContext!;
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final bool isWide = MediaQuery.of(context).size.width > 1440;

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row with "Select All"
        Row(
          children: [
            Text(
              'Special Permission',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            Checkbox(
              value: vm.selectAllSpecial,
              onChanged: (v) => vm.toggleSelectAllSpecial(v ?? false),
            ),
          ],
        ),

        verticalSpacing12,

        // Table Header (optional, could just be a line)
        Container(
          color: isDark ? const Color(0xFF334155) : Colors.grey.shade300,
          padding: const EdgeInsets.symmetric(vertical: 10) + leftPadding8,
          child: Row(
            children: [
              Expanded(
                child: Text('Permission',
                    style: fontFamilySemiBold.size14.black,
                    textAlign: TextAlign.start),
              ),
              SizedBox(
                  width: 70,
                  child: Text(
                    'Enabled',
                    textAlign: TextAlign.center,
                    style: fontFamilySemiBold.size14.black,
                  )),
            ],
          ),
        ),

        // Rows
        ...vm.specialPermissons.map((row) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? const Color(0xFF334155) : Colors.grey,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    row.name,
                    style: fontFamilyBold.size13.black,
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Checkbox(
                    value: row.enabled,
                    onChanged: (v) {
                      row.enabled = v ?? false;
                      vm.updateSpecialRow(rowName: row.name, value: v ?? false);
                    },
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    ),
  );
}
