import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/views/users/model/users_model.dart';
import 'common_user_dialog.dart'; // import your dialog

class UserTableSource extends DataTableSource {
  final List<UserModel> originalList;
  List<UserModel> filteredList;
  final void Function(UserModel) onEdit;
  final Function(UserModel) onDelete;

  UserTableSource({
    required List<UserModel> users,
    required this.onEdit,
    required this.onDelete,
  })  : originalList = List.from(users),
        filteredList = List.from(users);

  // ---------------------- SEARCH + FILTER ----------------------
  void applySearch(String query, String type) {
    query = query.toLowerCase();

    filteredList = originalList.where((user) {
      final matchSearch = user.name.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query) ||
          user.phone.contains(query);

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
      color: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (index.isEven) return Colors.white;
          return Colors.grey.shade100;
        },
      ),
      cells: [
        DataCell(Text("${index + 1}")),
        DataCell(Text(user.name)),
        DataCell(Text(user.email)),
        DataCell(Text(user.phone)),
        DataCell(Text(user.type)),
        DataCell(Text("${user.city}/${user.state}")),
        DataCell(Text(user.plan)),
        DataCell(Text("${user.connections}")),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => onEdit(user),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: red),
                onPressed: () => onDelete(user),
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
  int get rowCount => filteredList.isEmpty ? 1 : filteredList.length;

  @override
  int get selectedRowCount => 0;
}
