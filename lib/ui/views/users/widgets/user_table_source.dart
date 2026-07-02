import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/core/helper/date_helper.dart';
import 'package:webapp/core/model/get_user_model.dart' as user_model;
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/services/theme_service.dart';

class UserTableSource extends DataTableSource {
  final List<user_model.Datum> originalList;
  List<user_model.Datum> filteredList;
  final navigatorKey = StackedService.navigatorKey!;
  final void Function(user_model.Datum)? onNotesEdit;

  // final void Function(UserModel) onEdit;
  // final Function(UserModel) onDelete;
  final Function() onAdd;

  UserTableSource({
    required List<user_model.Datum> users,
    // required this.onEdit,
    // required this.onDelete,
    required this.onNotesEdit,
    required this.onAdd,
  })  : originalList = List.from(users),
        filteredList = List.from(users);

  // ---------------------- SEARCH + FILTER ----------------------
  void applySearch(String query, String type) {
    query = query.toLowerCase().trim();

    filteredList = originalList.where((user) {
      final name = user.name?.toLowerCase() ?? '';
      final email = user.email?.toLowerCase() ?? '';
      final mobile = user.mobileNumber?.toLowerCase() ?? '';

      final matchSearch = name.contains(query) ||
          email.contains(query) ||
          mobile.contains(query);

      final matchType = type == "All" || user.type == type;

      return matchSearch && matchType;
    }).toList();

    notifyListeners();
  }

  // ---------------------- ROW UI ----------------------
  @override
  DataRow? getRow(int index) {
    if (filteredList.isEmpty) {
      return DataRow(
        cells: List.generate(
          9,
          (i) {
            if (i == 4) {
              return const DataCell(
                Center(
                  child: Text(
                    "No data found",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            }
            return const DataCell(Text(""));
          },
        ),
      );
    }

    final user = filteredList[index];

    return DataRow(
      color: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          final isDark = ThemeService.instance.isDarkMode;
          if (isDark) {
            return index.isEven
                ? const Color(0xFF1E293B)
                : const Color(0xFF0F172A);
          }
          return index.isEven ? Colors.white : Colors.grey.shade100;
        },
      ),
      cells: [
        DataCell(SelectableText(
          "${index + 1}",
          style: fontFamilyRegular.size12.black,
        )),
        DataCell(SelectableText(
          user.name ?? "",
          style: fontFamilyRegular.size12.black,
        )),
        DataCell(SelectableText(
          user.email ?? "",
          style: fontFamilyRegular.size12.black,
        )),
        DataCell(SelectableText(
          user.mobileNumber ?? "",
          style: fontFamilyRegular.size12.black,
        )),
        DataCell(SelectableText(
          user.type ?? "",
          style: fontFamilyRegular.size12.black,
        )),
        DataCell(SelectableText(
          DateFormatter.formatToDDMMMYYYY(user.createdAt),
          style: fontFamilyRegular.size12.black,
        )),
        DataCell(Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.blue,
                size: 15,
              ),
              onPressed: () => onNotesEdit != null ? onNotesEdit!(user) : null,
            ),
            horizontalSpacing4,
            Expanded(
              child: Text(
                user.notes ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        )),
        DataCell(SelectableText(
          "${user.city}/${user.state}",
          style: fontFamilyRegular.size12.black,
        )),
        DataCell(
          IconButton(
            icon: const Icon(
              Icons.remove_red_eye,
              color: Colors.blue,
              size: 20,
            ),
            onPressed: () {
              _showPlansDialog(user);
            },
          ),
        ),
      ],
      // DataCell(CommonButton(
      //   text: 'ADD',
      //   textStyle: fontFamilyBold.size12.white,
      //   buttonColor: continueButton,
      //   width: 85,
      //   padding: zeroPadding,
      //   margin: zeroPadding,
      //   icon: const Icon(
      //     Icons.add,
      //     color: white,
      //   ),
      //   onTap: () => onAdd(),
      //   height: 30,
      // )
      // Row(
      //   children: [
      //     IconButton(
      //       icon: const Icon(Icons.edit, color: Colors.blue),
      //       onPressed: () => onEdit(user),
      //     ),
      //     IconButton(
      //       icon: const Icon(Icons.delete, color: red),
      //       onPressed: () => onDelete(user),
      //     ),
      //   ],
      // ),
      // ),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => filteredList.isEmpty ? 1 : filteredList.length;

  @override
  int get selectedRowCount => 0;
  void _showPlansDialog(user_model.Datum user) {
    final ScrollController verticalController = ScrollController();
    final ScrollController horizontalController = ScrollController();

    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: Text("${user.name} Plans"),
          content: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 100,
              maxHeight: 400,
              minWidth: 400,
              maxWidth: 600,
            ),
            child: user.plans == null || user.plans!.isEmpty
                ? const Center(child: Text("No Plans Available"))
                : Scrollbar(
                    controller: verticalController, // ✅ attach controller
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: verticalController, // ✅ same controller
                      child: Scrollbar(
                        controller: horizontalController, // ✅ horizontal
                        thumbVisibility: true,
                        notificationPredicate: (notif) =>
                            notif.metrics.axis == Axis.horizontal,
                        child: SingleChildScrollView(
                          controller: horizontalController,
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 40,
                            headingRowColor: WidgetStateProperty.all(
                              Colors.grey.shade200,
                            ),
                            columns: const [
                              DataColumn(label: Text("S.No")),
                              DataColumn(label: Text("Category")),
                              DataColumn(label: Text("Sub Plan")),
                              DataColumn(label: Text("Total")),
                              DataColumn(label: Text("Used")),
                              DataColumn(label: Text("Plan Created")),
                            ],
                            rows: user.plans!.asMap().entries.map((entry) {
                              final index = entry.key + 1;
                              final plan = entry.value;
                              return DataRow(
                                cells: [
                                  DataCell(Text("$index")),
                                  DataCell(Text(plan.categoryName ?? "")),
                                  DataCell(Text(plan.subName ?? "")),
                                  DataCell(Text(plan.totalConnection ?? "")),
                                  DataCell(Text("${plan.connection ?? 0}")),
                                  DataCell(
                                    Text(
                                      DateFormatter.formatToDDMMMYYYY(plan.createdAt!),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
