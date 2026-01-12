import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/views/state/model/state_model.dart' as state_model;

class StateTableSource extends DataTableSource {
  final List<state_model.Datum> states;
  final Function(state_model.Datum) onEdit;
  final Function(state_model.Datum) onDelete;

  StateTableSource({
    required this.states,
    required this.onEdit,
    required this.onDelete,
  });

  // ---------------------- SEARCH + FILTER ----------------------
  void applySearch(String query, String type) {
    query = query.toLowerCase();

    states.where((state) {
      final matchSearch = state.name!.toLowerCase().contains(query) ||
          state.name!.toLowerCase().contains(query);

      final matchType = type == "All" || state.name == type;

      return matchSearch && matchType;
    }).toList();

    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    // if (index >= plans.length) return null;
    if (states.isEmpty) {
      return DataRow(
        cells: List.generate(
          3, // total columns
          (i) {
            if (i == 1) {
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

    final plan = states[index];
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
          DataCell(Text(plan.name ?? "")),
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
                  onPressed: () => onEdit(plan)),
              IconButton(
                  icon: const Icon(Icons.delete, size: 16, color: red),
                  onPressed: () => onDelete(plan)),
            ],
          )),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => states.isEmpty ? 1 : states.length;

  @override
  int get selectedRowCount => 0;
}
