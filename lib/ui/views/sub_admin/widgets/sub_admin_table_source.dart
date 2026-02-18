import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/core/helper/permission_helper.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/views/sub_admin/model/sub_admin_model.dart'
    as sub_admin_model;
import 'package:webapp/widgets/profile_image.dart';
import 'package:webapp/ui/views/roles/model/roles_model.dart' as roles_model;

class SubAdminTableSource extends DataTableSource {
  final List<sub_admin_model.Datum> data;
  final List<roles_model.Datum> roles;
  late List<sub_admin_model.Datum> filteredList;
  final Function(sub_admin_model.Datum) onToggle;

  final void Function(sub_admin_model.Datum) onEdit;
  final void Function(sub_admin_model.Datum) onDelete;

  SubAdminTableSource(
      this.data, this.onEdit, this.onDelete, this.roles, this.onToggle) {
    filteredList = List.from(data);
    print('object$onToggle');
  }

  final _dialogService = locator<DialogService>();

  // ---------------------- SEARCH ----------------------
  void applySearch(String query) {
    query = query.toLowerCase().trim();

    filteredList = data.where((user) {
      return user.name!.toLowerCase().contains(query) ||
          user.city!.toLowerCase().contains(query) ||
          user.state!.toLowerCase().contains(query);
    }).toList();

    notifyListeners();
  }

  String formatDate(String value) {
    try {
      final dateTime = DateTime.parse(value).toLocal();
      return DateFormat('dd MMM yyyy').format(dateTime);
    } catch (e) {
      return '-';
    }
  }

  String formatTimeToDotAMPM(String? time) {
    if (time == null || time.trim().isEmpty) return '-';

    try {
      DateTime dateTime;

      // Case 1: Full datetime
      if (time.contains(' ')) {
        dateTime = DateTime.parse(time);
      }
      // Case 2: HH:mm or HH:mm:ss
      else if (time.contains(':')) {
        final parts = time.split(':');
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);

        if (hour == null || minute == null) return '-';

        dateTime = DateTime(0, 1, 1, hour, minute);
      } else {
        return '-';
      }

      int hour = dateTime.hour;
      final minute = dateTime.minute.toString().padLeft(2, '0');

      final isAM = hour < 12;
      hour = hour % 12;
      if (hour == 0) hour = 12;

      return '$hour.$minute${isAM ? 'am' : 'pm'}';
    } catch (_) {
      return '-';
    }
  }

  String getRoleName(int? roleId) {
    if (roleId == null) return '-';

    try {
      final role = roles.firstWhere(
        (r) => r.id == roleId,
        orElse: () => roles_model.Datum(),
      );

      return role.name ?? '-';
    } catch (e) {
      return '-';
    }
  }

  @override
  DataRow? getRow(int index) {
    // if (index >= filteredList.length) return null;

    // ---------------------- NO DATA ----------------------
    if (filteredList.isEmpty) {
      return const DataRow(
        cells: [
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("No data found")),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
        ],
      );
    }

    final row = filteredList[index];

    return DataRow(
      color: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          return index.isEven ? Colors.white : Colors.grey.shade100;
        },
      ),
      cells: [
        // Index
        DataCell(Text("${index + 1}")),

        // Profile Image
        DataCell(
          IgnorePointer(
            ignoring: true,
            child: Padding(
              padding: defaultPadding4,
              child: ProfileImageEdit(
                imageUrl: row.profileImage ?? '', // handle null
                radius: 30,
                onImageSelected: (_, __) {},
              ),
            ),
          ),
        ),

        // Name
        DataCell(Text(row.name ?? 'N/A')),

        // City/State
        DataCell(Text("${row.city ?? '-'} / ${row.state ?? '-'}")),

        // Login Time
        DataCell(
          Text(row.loginTime != null
              ? formatTimeToDotAMPM(row.loginTime.toString())
              : '-'),
        ),

        // Logout Time
        DataCell(
          Text(row.logoutTime != null
              ? formatTimeToDotAMPM(row.logoutTime.toString())
              : '-'),
        ),

        // Online Status
        DataCell(
          Text(row.isOnline?.toString() == "1" ? "Online" : "Offline"),
        ),

        // Role Name
        DataCell(Text(getRoleName(row.roleId ?? 0))), // default 0 if null

        // Action Buttons
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => (PermissionHelper.instance
                        .canEdit('sub_admin'))
                    ? onEdit(row)
                    : _dialogService.showDialog(
                        title: "Warning",
                        description:
                            "Locked 🔒 – You need special permission to access this.",
                        buttonTitle: 'ok'),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: red),
                onPressed: () => (PermissionHelper.instance
                        .canDelete('sub_admin'))
                    ? onDelete(row)
                    : _dialogService.showDialog(
                        title: "Warning",
                        description:
                            "Locked 🔒 – You need special permission to access this.",
                        buttonTitle: 'ok'),
              ),
            ],
          ),
        ),

        // Status Switch
        DataCell(
          Transform.scale(
            scale: 0.7,
            child: Switch(
              value: row.status == 1,
              onChanged: (_) => (PermissionHelper.instance.canEdit('sub_admin'))
                  ? onToggle(row)
                  : _dialogService.showDialog(
                      title: "Warning",
                      description:
                          "Locked 🔒 – You need special permission to access this.",
                      buttonTitle: 'ok'),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => filteredList.isEmpty ? 1 : filteredList.length;

  @override
  int get selectedRowCount => 0;
}
