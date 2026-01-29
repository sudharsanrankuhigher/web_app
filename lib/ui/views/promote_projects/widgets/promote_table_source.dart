import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/promote_projects/model/prmote_table_model.dart';
import 'package:webapp/ui/views/promote_projects/widgets/promote_status.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/view_link.dart';

class PromoteTableSource extends DataTableSource {
  final List<PromoteTableModel> data;
  final String status;
  final void Function(PromoteTableModel)? onPreparing;

  PromoteTableSource({
    required this.data,
    required this.status,
    this.onPreparing,
  });

  @override
  DataRow? getRow(int index) {
    // 🔒 HARD SAFETY CHECK
    if (index >= rowCount) return null;

    // ✅ Empty state row
    if (data.isEmpty) {
      return DataRow.byIndex(
        index: index,
        cells: List.generate(
          _columnCountByStatus(status),
          (_) => const DataCell(Text('-')),
        ),
      );
    }

    final item = data[index];

    return DataRow.byIndex(
      index: index,
      color: WidgetStateProperty.resolveWith<Color?>(
        (states) => index.isEven ? Colors.white : Colors.grey.shade100,
      ),
      cells: getCellsByStatus(item, status, index),
    );
  }

  List<DataCell> getCellsByStatus(
    PromoteTableModel item,
    String status,
    int index,
  ) {
    switch (status) {
      case PromoteStatus.assigned:
        return [
          DataCell(Text('${index + 1}')),
          DataCell(Text(item.projectCode)),
          DataCell(Text("${item.influencer} / ${item.influencerId}")),
          DataCell(Text(item.phone)),
          DataCell(Text(item.note)),
          DataCell(
            ViewLink(
              url: item.viewLink,
              text: "ViewLink",
            ),
          ),
          DataCell(Text(item.assignedDate)),
          DataCell(Center(
            child: InkWell(
              onTap: onPreparing == null ? null : () => onPreparing!(item),
              child: Container(
                  padding: defaultPadding4 + rightPadding4 + leftPadding4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: continueButton,
                  ),
                  child: Text(
                    item.status,
                    style: fontFamilyMedium.size13.white,
                  )),
            ),
          )),
          DataCell(CommonButton(
            text: 'Reject',
            onTap: () {},
            buttonColor: red,
            padding: defaultPadding4 + rightPadding4 + leftPadding4,
            margin: defaultPadding10 + leftPadding8 + rightPadding8,
            textStyle: fontFamilyMedium.size12.white,
          )),
        ];

      case PromoteStatus.completed:
        return [
          DataCell(Text('${index + 1}')),
          DataCell(Text(item.influencerId)),
          DataCell(Text(item.tCode)),
          DataCell(Text(item.assignedDate)),
          DataCell(Text(item.projectCode)),
          DataCell(Text(item.completedDate)),
          DataCell(
            ElevatedButton(
              onPressed: () {},
              child: const Text("Ready to Pay"),
            ),
          ),
        ];

      case PromoteStatus.verified:
        return [
          DataCell(Text('${index + 1}')),
          DataCell(Text(item.prSubCode)),
          DataCell(Text(item.influencer)),
          DataCell(Text(item.influencerId)),
          DataCell(Text(item.phone)),
          DataCell(Text(item.projectCode)),
          DataCell(Text(item.viewLink)),
          DataCell(Text(item.amount.toString())),
          DataCell(Text(item.assignedDate)),
          DataCell(Text(item.completedDate)),
        ];

      case PromoteStatus.pay:
        return [
          DataCell(Text('${index + 1}')),
          DataCell(Text(item.projectCode)),
          DataCell(Text(item.influencer)),
          DataCell(Text(item.influencerId)),
          DataCell(Text(item.phone)),
          DataCell(Text(item.assignedDate)),
          DataCell(Text(item.completedDate)),
          DataCell(Text(item.bankDetails)),
          DataCell(Text(item.amount.toString())),
          DataCell(
            ElevatedButton(
              onPressed: () {},
              child: const Text("Paid"),
            ),
          ),
        ];

      case PromoteStatus.commission:
        return [
          DataCell(Text('${index + 1}')),
          DataCell(Text(item.projectCode)),
          DataCell(Text(item.influencer)),
          DataCell(Text(item.influencerId)),
          DataCell(Text(item.phone)),
          DataCell(Text(item.assignedDate)),
          DataCell(Text(item.completedDate)),
          DataCell(Text(item.bankDetails)),
          DataCell(Text(item.amount.toString())),
        ];

      default:
        return const [];
    }
  }

  int _columnCountByStatus(String status) {
    switch (status) {
      case PromoteStatus.assigned:
        return 9;
      case PromoteStatus.completed:
        return 7;
      case PromoteStatus.verified:
        return 10;
      case PromoteStatus.pay:
        return 10;
      case PromoteStatus.commission:
        return 9;
      default:
        return 0;
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.isEmpty ? 1 : data.length;

  @override
  int get selectedRowCount => 0;
}
