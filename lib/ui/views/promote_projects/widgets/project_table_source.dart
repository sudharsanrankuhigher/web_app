import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/promote_projects/model/promote_project_model.dart';
import 'package:webapp/ui/views/promote_projects/promote_projects_viewmodel.dart';
import 'package:webapp/widgets/over_lapping_avatar.dart';

class PromoteProjectsTableSource extends DataTableSource {
  final List<ProjectModel> data;
  final PromoteProjectsViewModel vm;

  PromoteProjectsTableSource({
    required this.data,
    required this.vm,
  });

  @override
  DataRow? getRow(int index) {
    // if (index >= data.length) return null;
    if (data.isEmpty) {
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

    final item = data[index];

    return DataRow.byIndex(
      index: index,
      selected: item.isSelected,
      onSelectChanged: (val) {
        item.isSelected = val ?? false;
        notifyListeners();
        vm.notifySelectionChanged();
      },
      color: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (index.isEven) return Colors.white;
          return Colors.grey.shade100;
        },
      ),
      cells: [
        DataCell(Text('${index + 1}')),
        DataCell(Text(item.projectCode)),
        DataCell(Text(item.clientName)),
        DataCell(Text(item.projectTitle)),
        DataCell(Text(item.note)),

        DataCell(
          OverlappingAvatars(
            imageUrls: item.influencerImages,
            maxVisible: 2,
            size: 34,
          ),
        ),

        DataCell(Text(
          '7/10',
          style: fontFamilySemiBold.size12.black,
        )),

        /// 🔥 Payment (example static)
        const DataCell(Text('Pending')),

        /// 🔥 Commission
        const DataCell(Text('₹1,200')),

        /// 🔥 Assigned Date
        DataCell(
          Text(
            '${item.assignedDate.day}/${item.assignedDate.month}/${item.assignedDate.year}',
          ),
        ),

        /// 🔥 Actions
        DataCell(
          GestureDetector(
            onTap: () {},
            child: const Icon(Icons.visibility, size: 20, color: Colors.blue),
          ),
        ),
        DataCell(
          Text(
            item.isCompleted ? 'Completed' : 'Pending',
            style: item.isCompleted
                ? fontFamilyBold.size12.appGreen400
                : fontFamilyRegular.size12.red,
          ),
        ),
      ],
    );
  }

  @override
  int get rowCount => data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => data.where((e) => e.isSelected).length;
}
