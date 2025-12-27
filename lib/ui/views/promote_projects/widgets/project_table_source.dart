import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/ui/views/promote_projects/model/promote_project_model.dart';
import 'package:webapp/ui/views/promote_projects/promote_projects_viewmodel.dart';
import 'package:webapp/widgets/over_lapping_avatar.dart';

class PromoteProjectsTableSource extends DataTableSource {
  List<ProjectModel> data;
  final PromoteProjectsViewModel vm;

  PromoteProjectsTableSource({
    required this.data,
    required this.vm,
  });

  /// 🔥 Update table data
  void updateData(List<ProjectModel> newData) {
    data = newData;
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;

    final item = data[index];

    return DataRow.byIndex(
      index: index,
      color: WidgetStateProperty.resolveWith(
        (states) => index.isEven ? Colors.white : Colors.grey.shade100,
      ),
      onSelectChanged: (value) {
        item.isSelected = value ?? false;
        vm.notifySelectionChanged();
      },
      cells: vm.isInprogress
          ? _inProgressCells(item, index)
          : _completedCells(item, index),
    );
  }

  List<DataCell> _inProgressCells(ProjectModel item, int index) {
    return [
      DataCell(Text('${index + 1}')),
      DataCell(Text(item.projectCode)),
      DataCell(Text(item.clientName ?? '')),
      DataCell(Text(item.projectTitle)),
      DataCell(Text(item.note)),
      const DataCell(Text('5')),
      DataCell(
        OverlappingAvatars(
          imageUrls: item.influencerImages,
          maxVisible: 2,
          size: 34,
        ),
      ),
      const DataCell(Text('7/10')),
      const DataCell(Text('Pending')),
      DataCell(Text('₹${item.commission}')),
      DataCell(Text(
        '${item.assignedDate!.day}/${item.assignedDate!.month}/${item.assignedDate!.year}',
      )),
      DataCell(
        IconButton(
          icon: const Icon(Icons.check_circle, color: Colors.green),
          onPressed: () => vm.toggleProjectStatus(item),
        ),
      ),
    ];
  }

  List<DataCell> _completedCells(ProjectModel item, int index) {
    return [
      DataCell(Text('${index + 1}')),
      DataCell(Text(item.projectCode)),
      DataCell(Text(item.clientName ?? '')),
      DataCell(Text(item.projectTitle)),
      DataCell(
        OverlappingAvatars(
          imageUrls: item.influencerImages,
          maxVisible: 2,
          size: 34,
        ),
      ),
      DataCell(Text(item.note)),
      const DataCell(Text('10')),
      DataCell(Text('₹${item.payment}')),
      DataCell(Text('₹${item.commission}')),
      DataCell(Text(
        '${item.assignedDate!.day}/${item.assignedDate!.month}/${item.assignedDate!.year}',
      )),
      const DataCell(Text('Paid')),
    ];
  }

  @override
  int get rowCount => data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
