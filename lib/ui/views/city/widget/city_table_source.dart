import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/views/city/model/city_model.dart' as city_model;

class CityTableSource extends DataTableSource {
  final List<city_model.Datum> cities;
  final Function(city_model.Datum) onEdit;
  final Function(city_model.Datum) onDelete;

  CityTableSource({
    required this.cities,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  DataRow? getRow(int index) {
    // if (index >= plans.length) return null;
    if (cities.isEmpty) {
      return DataRow(
        cells: List.generate(
          3, // total columns
          (i) {
            if (i == 2) {
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

    final city = cities[index];
    final sNo = index + 1;

    return DataRow(
        color: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (index.isEven) return Colors.white;
            return Colors.grey.shade100;
          },
        ),
        cells: [
          DataCell(Text("$sNo")),
          DataCell(Text(city.name!)),
          DataCell(Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: const Icon(
                    Icons.edit,
                    size: 16,
                    color: grey,
                  ),
                  onPressed: () => onEdit(city)),
              IconButton(
                  icon: const Icon(Icons.delete, size: 16, color: red),
                  onPressed: () => onDelete(city)),
            ],
          )),
          // DataCell(Text(city.status)),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => cities.isEmpty ? 1 : cities.length;

  @override
  int get selectedRowCount => 0;
}
