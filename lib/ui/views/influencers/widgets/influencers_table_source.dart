import 'package:flutter/material.dart';
import 'package:webapp/ui/views/influencers/model/influencers_model.dart'
    as influencer_model;
import 'package:webapp/ui/views/services/model/service_model.dart'
    as service_model;

class InfluencerTableSource extends DataTableSource {
  final List<influencer_model.Datum> influencers;
  final List<service_model.Datum>? service;

  final Function(influencer_model.Datum, bool) onEdit;
  final Function(influencer_model.Datum, bool)? onView;
  // final Function(InfluencerModel) onDelete;
  final Function(influencer_model.Datum) onToggle;

  InfluencerTableSource({
    required this.influencers,
    required this.onEdit,
    // required this.onDelete,
    this.onView,
    this.service,
    required this.onToggle,
  });

  Map<int, String> get _serviceMap {
    return {
      for (final s in service ?? [])
        if (s.id != null) s.id!: s.name ?? ""
    };
  }

  String _getServiceNames(List<dynamic>? serviceIds) {
    if (serviceIds == null || serviceIds.isEmpty) return "-";

    return serviceIds.map((id) => _serviceMap[id] ?? "Unknown").join(", ");
  }

  @override
  DataRow? getRow(int index) {
    /// -------------------------------
    /// CASE: NO DATA FOUND
    /// -------------------------------
    ///
    ///
    if (influencers.isEmpty) {
      return DataRow(
        cells: List.generate(
          12, // total columns
          (i) {
            if (i == 6) {
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

        DataCell(Text(item.infId.toString())),
        DataCell(Text(item.name!)),
        DataCell(Text(item.phone!)),
        DataCell(Text("${item.city}/${item.state}")),
        DataCell(
          Text(_getServiceNames(item.service)),
        ),
        DataCell(
            Text(item.service != null ? item.service!.length.toString() : "0")),

        DataCell(Text(item.instagramFollowers!.toString())),
        DataCell(Text(item.youtubeFollowers.toString())),
        DataCell(Text(item.facebookFollowers.toString())),

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
              value: item.status == 1 ? true : false,
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
