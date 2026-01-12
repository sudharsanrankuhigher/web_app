import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/core/model/get_user_model.dart' as user_model;

class UserTableSource extends DataTableSource {
  final List<user_model.Datum> originalList;
  List<user_model.Datum> filteredList;
  // final void Function(UserModel) onEdit;
  // final Function(UserModel) onDelete;
  final Function() onAdd;

  UserTableSource({
    required List<user_model.Datum> users,
    // required this.onEdit,
    // required this.onDelete,
    required this.onAdd,
  })  : originalList = List.from(users),
        filteredList = List.from(users);

  // ---------------------- SEARCH + FILTER ----------------------
  void applySearch(String query, String type) {
    query = query.toLowerCase();

    filteredList = originalList.where((user) {
      final matchSearch = user.name!.toLowerCase().contains(query) ||
          user.email!.toLowerCase().contains(query) ||
          user.mobileNumber!.contains(query);

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
          if (index.isEven) return Colors.white;
          return Colors.grey.shade100;
        },
      ),
      cells: [
        DataCell(Text("${index + 1}")),
        DataCell(Text(user.name ?? "")),
        DataCell(Text(user.email ?? "")),
        DataCell(Text(user.mobileNumber ?? "")),
        DataCell(Text(user.type ?? "")),
        DataCell(Text("${user.city}/${user.state}")),
        DataCell(Text(user.plan ?? "")),
        DataCell(Text("${user.connections}")),
        DataCell(CommonButton(
          text: 'ADD',
          textStyle: fontFamilyBold.size12.white,
          buttonColor: continueButton,
          width: 85,
          padding: zeroPadding,
          margin: zeroPadding,
          icon: Icon(
            Icons.add,
            color: white,
          ),
          onTap: () => onAdd(),
          height: 30,
        )
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
