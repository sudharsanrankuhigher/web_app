import 'package:flutter/material.dart';
import 'package:webapp/core/helper/date_helper.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/promote_projects/widgets/add_edit_dialog.dart';
import 'package:webapp/ui/views/report/model/report_model.dart';

class CompanyDetailedTableSource extends DataTableSource {
  final List<PromoteProjecte> data;
  final String status;

  CompanyDetailedTableSource({required this.data, required this.status});

  @override
  DataRow? getRow(int index) {
    if (data.isEmpty) {
      return const DataRow(
        cells: [
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Center(child: Text("No data found"))),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
        ],
      );
    }

    final item = data[index];

    return DataRow(
      color: WidgetStateProperty.resolveWith<Color?>(
        (states) => index.isEven ? Colors.white : Colors.grey.shade100,
      ),
      cells: [
        DataCell(Text(
          "${index + 1}",
          style: fontFamilySemiBold.size13.black,
        )), // S.No
        DataCell(Text(
          (item.ppCode ?? '-').toString(),
          style: fontFamilySemiBold.size13.black,
        )), // Name
        DataCell(Text(
          item.companyName ?? '-',
          style: fontFamilySemiBold.size13.black,
        )),
        DataCell(Text(
          "${item.companyName ?? 0}",
          style: fontFamilySemiBold.size13.black,
        )),
        DataCell(Text(
          "${item.infId ?? 0} / ${item.infName1 ?? 0}",
          style: fontFamilySemiBold.size13.black,
        )),
        DataCell(Text(
          "${item.companyPayment ?? 0}",
          style: fontFamilySemiBold.size13.black,
        )),
        DataCell(Text(
          "${item.companyCommission ?? 0}",
          style: fontFamilySemiBold.size13.black,
        )),
        DataCell(Text(
          "${item.influencerPaid ?? 0}",
          style: fontFamilySemiBold.size13.black,
        )),
        // DataCell(Text(
        //   " ${DateFormatter.formatToDDMMMYYYY(item.date) ?? 0}",
        //   style: fontFamilySemiBold.size13.black,
        // )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => data.isEmpty ? 1 : data.length;
  @override
  int get selectedRowCount => 0;
}
