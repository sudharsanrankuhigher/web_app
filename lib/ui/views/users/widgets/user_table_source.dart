import 'package:flutter/material.dart';
import 'package:webapp/ui/views/users/model/users_model.dart';

class UserTableSource extends DataTableSource {
  final List<UserModel> originalList;
  List<UserModel> filteredList;


  UserTableSource({
    required List<UserModel> users,
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

  // ------------------------- ROW UI ----------------------------
  @override
  DataRow? getRow(int index) {
    if (filteredList.isEmpty) {
      return DataRow(
        cells: List.generate(
          9, // total columns
          (i) {
            if (i == 4) {
              // column index where message should show
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
            return const DataCell(Text("")); // other cells empty
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
        // DataCell(CommonButton(
        //   icon: Icon(Icons.add, color: white, size: 16),
        //   text: 'Add',
        //   textStyle: fontFamilyMedium.size14.white,
        //   borderRadius: 12,
        //   buttonColor: continueButton,
        //   margin: defaultPadding10 - leftPadding10,
        //   padding: zeroPadding,
        // )
        // ),
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
