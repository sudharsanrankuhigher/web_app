import 'package:flutter/material.dart';
import 'package:webapp/ui/views/influencers/model/influencers_model.dart';

class InfluencerTableSource extends DataTableSource {
  final List<InfluencerModel> influencers;
  final Function(InfluencerModel, bool) onEdit;
  final Function(InfluencerModel, bool)? onView;
  // final Function(InfluencerModel) onDelete;
  final Function(InfluencerModel) onToggle;

  InfluencerTableSource({
    required this.influencers,
    required this.onEdit,
    // required this.onDelete,
    this.onView,
    required this.onToggle,
  });

  @override
  DataRow? getRow(int index) {
    /// -------------------------------
    /// CASE: NO DATA FOUND
    /// -------------------------------
    if (influencers.isEmpty) {
      return DataRow(
        cells: List.generate(
          10, // total columns
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

    /// -------------------------------
    /// CASE: NORMAL ROW
    /// -------------------------------
    final item = influencers[index];

    return DataRow(
      color: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (index.isEven) return Colors.white;
          return Colors.grey.shade100;
        },
      ),
      cells: [
        DataCell(Text("${index + 1}")),

        DataCell(Text(item.id.toString())),
        DataCell(Text(item.name)),
        DataCell(Text(item.phone)),
        DataCell(Text("${item.city}/${item.state}")),
        DataCell(Text(item.category)),
        DataCell(Text(item.category)),

        DataCell(Text(item.instagramFollowers ?? "")),
        DataCell(Text(item.youtubeFollowers ?? "")),
        DataCell(Text(item.facebookFollowers ?? "")),

        /// ACTION BUTTONS
        DataCell(
          GestureDetector(
            onTap: () => onView?.call(item, true),
            child: const Icon(Icons.visibility, size: 20, color: Colors.blue),
          ),
          // Row(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [

          //     const SizedBox(width: 8),
          //     GestureDetector(
          //       onTap: () => onEdit(item, false),
          //       child: const Icon(Icons.edit, size: 16, color: Colors.blue),
          //     ),
          //     const SizedBox(width: 8),
          //     GestureDetector(
          //       // onTap: () => onDelete(item),
          //       child: const Icon(Icons.delete, size: 16, color: Colors.red),
          //     ),
          //   ],
          // ),
        ),

        /// TOGGLE SWITCH
        DataCell(
          Transform.scale(
            scale: 0.7,
            child: Switch(
              value: item.isActive,
              onChanged: (_) => onToggle(item),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  /// Return at least 1 row so table does not crash
  @override
  int get rowCount => influencers.isEmpty ? 1 : influencers.length;

  @override
  int get selectedRowCount => 0;
}
