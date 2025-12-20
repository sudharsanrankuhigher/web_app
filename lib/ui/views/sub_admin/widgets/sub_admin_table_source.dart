import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/views/sub_admin/model/sub_admin_model.dart';
import 'package:webapp/widgets/profile_image.dart';

class SubAdminTableSource extends DataTableSource {
  final List<SubAdminModel> data;
  late List<SubAdminModel> filteredList;

  final void Function(SubAdminModel) onEdit;
  final void Function(SubAdminModel) onDelete;

  SubAdminTableSource(
    this.data,
    this.onEdit,
    this.onDelete,
  ) {
    filteredList = List.from(data);
  }

  // ---------------------- SEARCH ----------------------
  void applySearch(String query) {
    query = query.toLowerCase().trim();

    filteredList = data.where((user) {
      return user.name.toLowerCase().contains(query) ||
          user.city.toLowerCase().contains(query) ||
          user.state.toLowerCase().contains(query);
    }).toList();

    notifyListeners();
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
      color: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (index.isEven) return Colors.white;
          return Colors.grey.shade100;
        },
      ),
      cells: [
        DataCell(Text("${index + 1}")),
        DataCell(

            // Text(row.imageUrl)
            Padding(
          padding: defaultPadding4,
          child: ProfileImageEdit(
            imageUrl: row.idImageUrl,
            radius: 30,
            onImageSelected: (_, a) {},
          ),
        )),
        DataCell(Text(row.name)),
        DataCell(Text("${row.city}/${row.state}")),
        DataCell(Text(row.loginTime.toString())),
        DataCell(Text(row.logoutTime.toString())),
        DataCell(Text(row.onlineAt.toString())),
        DataCell(Text("${row.access}".toString().split(",").join(", "))),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => onEdit(row),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: red),
                onPressed: () => onDelete(row),
              ),
            ],
          ),
        ),
        DataCell(Text(row.isActive.toString())),
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
