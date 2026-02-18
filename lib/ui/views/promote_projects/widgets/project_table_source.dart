import 'package:flutter/material.dart';
import 'package:webapp/core/helper/dialog_state.dart';
import 'package:webapp/ui/views/promote_projects/model/promote_project_model.dart'
    as project_model;
import 'package:webapp/ui/views/promote_projects/promote_projects_viewmodel.dart';
import 'package:webapp/widgets/over_lapping_avatar.dart';

class PromoteProjectsTableSource extends DataTableSource {
  List<project_model.Message> data;
  final Function(project_model.Message) onView;
  final PromoteProjectsViewModel vm;

  PromoteProjectsTableSource({
    required this.data,
    required this.vm,
    required this.onView,
  });

  /// 🔥 Update table data
  void updateData(List<project_model.Message> newData) {
    data = newData;
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    if (data.isEmpty) {
      return DataRow.byIndex(
        index: index,
        cells: const [
          DataCell.empty,
          DataCell.empty,
          DataCell.empty,
          DataCell.empty,
          DataCell(Text('No data available')),
          DataCell.empty,
          DataCell.empty,
          DataCell.empty,
          DataCell.empty,
          DataCell.empty,
        ],
      );
    }
    final item = data[index];

    final pay = item.payment;

    return DataRow.byIndex(
      index: index,
      color: WidgetStateProperty.resolveWith(
        (states) => index.isEven ? Colors.white : Colors.grey.shade100,
      ),
      onSelectChanged: (value) {
        vm.onRowSelected(item.id!);
      },
      cells: vm.isInprogress
          ? _inProgressCells(item, pay, index)
          : _completedCells(item, pay, index),
    );
  }

  List<DataCell> _inProgressCells(project_model.Message item,
      project_model.PaymentElement? pay, int index) {
    return [
      DataCell(Text('${index + 1}')),
      DataCell(Text(item.projectCode ?? '')),
      DataCell(Text(item.companyName ?? '')),
      DataCell(Text(item.projectName ?? '')),
      DataCell(
        vm.isDialogOpen
            ? Container(
                padding: const EdgeInsets.all(4),
              )
            : OverlappingAvatars(
                imageUrls: item.influencers!
                    .map<String>((e) => e.image ?? '')
                    .toList(),
                maxVisible: 2,
                size: 34,
              ),
      ),
      DataCell(Text('${item.influencers?.length ?? 0}')),
      DataCell(Text(item.description ?? '')),
      DataCell(Container(
          alignment: Alignment.centerRight,
          child: Text('₹${pay?.payment ?? 0}'))),
      DataCell(Container(
          alignment: Alignment.centerRight,
          child: Text('₹${pay?.commission ?? 0}'))),
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
              onPressed: () => onView(item)),
        ],
      )),
    ];
  }

  List<DataCell> _completedCells(project_model.Message item,
      project_model.PaymentElement? pay, int index) {
    return [
      DataCell(Text('${index + 1}')),
      DataCell(Text(item.projectCode ?? '')),
      DataCell(Text(item.companyName ?? '')),
      DataCell(Text(item.projectName ?? '')),
      DataCell(
        OverlappingAvatars(
          imageUrls:
              item.influencers!.map<String>((e) => e.image ?? '').toList(),
          maxVisible: 2,
          size: 34,
        ),
      ),
      DataCell(Text(item.description ?? '')),
      const DataCell(Text('10')),
      DataCell(Text('₹${pay?.payment ?? "0"}')),
      DataCell(Text('₹${pay?.commission ?? "0"}')),
      const DataCell(Text('Paid')),
    ];
  }

  @override
  int get rowCount => data.isEmpty ? 1 : data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
