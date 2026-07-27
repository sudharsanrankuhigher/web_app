import 'package:flutter/material.dart';
import 'package:webapp/core/helper/date_helper.dart';
import 'package:webapp/ui/views/promote_projects/model/promote_project_model.dart'
    as project_model;
import 'package:webapp/ui/views/promote_projects/promote_projects_viewmodel.dart';
import 'package:webapp/widgets/over_lapping_avatar.dart';
import 'package:webapp/services/theme_service.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';

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
      final columnsCount = vm.isInprogress ? 12 : 11;
      return DataRow.byIndex(
        index: index,
        cells: List<DataCell>.generate(
          columnsCount,
          (i) => i == (columnsCount ~/ 2)
              ? const DataCell(Text('No data available'))
              : DataCell.empty,
        ),
      );
    }
    final item = data[index];

    final pay = item.payment;

    return DataRow.byIndex(
      index: index,
      color: WidgetStateProperty.resolveWith<Color?>(
        (states) {
          final isDark = ThemeService.instance.isDarkMode;
          if (isDark) {
            return index.isEven
                ? const Color(0xFF1E293B)
                : const Color(0xFF0F172A);
          }
          return index.isEven ? Colors.white : Colors.grey.shade100;
        },
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
      _textCell('${index + 1}'),
      DataCell(
        // vm.isDialogOpen
        //     ? Container(
        //         padding: const EdgeInsets.all(4),
        //       )
        //     :
        OverlappingAvatars(
          imageUrls:
              item.influencers!.map<String>((e) => e.image ?? '').toList(),
          maxVisible: 2,
          size: 34,
        ),
      ),
      _textCell(item.projectCode),
      _textCell(item.companyName),
      _textCell(item.projectName),
      _textCell('${item.influencers?.length ?? 0}'),
      DataCell(
        Tooltip(
            message: item.description ?? '',
            child: Text(item.description ?? '')),
      ),
      _textCell(
          DateFormatter.formatToDDMMMYYYY(item.payment?.validDate ?? '-')),
      _textCell('₹${pay?.totalAmount ?? 0}', alignment: Alignment.centerRight),
      _textCell('₹${pay?.payment ?? 0}', alignment: Alignment.centerRight),
      _textCell('₹${pay?.commission ?? 0}', alignment: Alignment.centerRight),
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
      _textCell('${index + 1}'),
      DataCell(
        OverlappingAvatars(
          imageUrls:
              item.influencers!.map<String>((e) => e.image ?? '').toList(),
          maxVisible: 2,
          size: 34,
        ),
      ),
      _textCell(item.projectCode),
      _textCell(item.companyName),
      _textCell(item.projectName),
      _textCell(item.description),
      _textCell(
          DateFormatter.formatToDDMMMYYYY(item.payment?.validDate ?? '-')),
      _textCell('₹${pay?.totalAmount ?? 0}', alignment: Alignment.centerRight),
      _textCell('₹${pay?.payment ?? "0"}'),
      _textCell('₹${pay?.commission ?? "0"}'),
      _textCell('Paid'),
    ];
  }

  DataCell _textCell(String? text,
      {bool center = false, AlignmentGeometry? alignment}) {
    final widget = SelectableText(
      text ?? "",
      textAlign: center ? TextAlign.center : TextAlign.start,
      style: fontFamilyRegular.size12.black,
    );
    final child = center ? Center(child: widget) : widget;
    return DataCell(
      alignment != null ? Align(alignment: alignment, child: child) : child,
    );
  }

  @override
  int get rowCount => data.isEmpty ? 1 : data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
