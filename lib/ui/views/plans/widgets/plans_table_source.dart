import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/views/plans/model/plans_model.dart' as plan_model;
import 'package:webapp/services/theme_service.dart';

class PlanTableSource extends DataTableSource {
  final List<plan_model.Datum> plans;
  final Function(plan_model.Datum) onEdit;
  final Function(plan_model.Datum) onView;
  final Function(plan_model.Datum) onDelete;

  PlanTableSource({
    required this.plans,
    required this.onEdit,
    required this.onView,
    required this.onDelete,
  });
  String getCategoryName(int? categoryId) {
    switch (categoryId) {
      case 1:
        return "Influencers";
      case 2:
        return "Movie Stars";
      case 3:
        return "TV Stars";
      case 4:
        return "Sports Stars";
      default:
        return "Unknown";
    }
  }

  @override
  DataRow? getRow(int index) {
    // if (index >= plans.length) return null;
    if (plans.isEmpty) {
      return DataRow(
        cells: List.generate(
          9, // total columns
          (i) {
            if (i == 5) {
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
          DataCell(Text("$sNo")),
          DataCell(Text(plan.name!)),
          DataCell(Text("${plan.connections}")),
          DataCell(Text("₹${plan.amount}")),
          DataCell(Text("₹${plan.saleAmount}")),
          DataCell(Text("${plan.gst}")),
          DataCell(
              Text(getCategoryName(int.tryParse(plan.category.toString())))),
          plan.badge != null
              ? DataCell(
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue,
                    ),
                    child: Text(
                      plan.badge!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : const DataCell(SizedBox()),
          DataCell(Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => onView(plan),
                borderRadius: BorderRadius.circular(12),
                child: const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Icon(
                    Icons.visibility,
                    size: 16,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              InkWell(
                onTap: () => onEdit(plan),
                borderRadius: BorderRadius.circular(12),
                child: const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Icon(
                    Icons.edit,
                    size: 16,
                    color: grey,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              InkWell(
                onTap: () => onDelete(plan),
                borderRadius: BorderRadius.circular(12),
                child: const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Icon(
                    Icons.delete,
                    size: 16,
                    color: red,
                  ),
                ),
              ),
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
