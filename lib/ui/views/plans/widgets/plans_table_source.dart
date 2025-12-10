import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/views/plans/model/plans_model.dart';

class PlanTableSource extends DataTableSource {
  final List<PlanModel> plans;
  final Function(PlanModel) onEdit;
  final Function(PlanModel) onView;
  final Function(PlanModel) onDelete;

  PlanTableSource({
    required this.plans,
    required this.onEdit,
    required this.onView,
    required this.onDelete,
  });

  @override
  DataRow? getRow(int index) {
    // if (index >= plans.length) return null;
    if (plans.isEmpty) {
      return DataRow(
        cells: List.generate(
          6, // total columns
          (i) {
            if (i == 3) {
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

    final plan = plans[index];
    final sNo = index + 1;

    return DataRow(
        color: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (index.isEven) return Colors.white;
            return Colors.grey.shade100;
          },
        ),
        cells: [
          DataCell(Text("$sNo")),
          DataCell(Text(plan.planName)),
          DataCell(Text("${plan.connections}")),
          DataCell(Text("₹${plan.amount}")),
          DataCell(Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: Colors.blue),
            child: Text(
              plan.badge,
              style: const TextStyle(color: Colors.white),
            ),
          )),
          DataCell(Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: const Icon(
                    Icons.visibility,
                    size: 16,
                    color: Colors.blue,
                  ),
                  onPressed: () => onView(plan)),
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
  int get rowCount => plans.isEmpty ? 1 : plans.length;

  @override
  int get selectedRowCount => 0;
}
