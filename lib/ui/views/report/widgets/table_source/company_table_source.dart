import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/report/model/report_model.dart';

class CompanyReportTableSource extends DataTableSource {
  final List<CompanyWiseProjectCountReport> data;
  final String status;

  CompanyReportTableSource({
    required this.data,
    required this.status,
  });

  @override
  DataRow? getRow(int index) {
    if (data.isEmpty) {
      return const DataRow(
        cells: [
          DataCell(Text("")),
          DataCell(Center(child: Text("No data found"))),
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
          item.companyName ?? '-',
          style: fontFamilySemiBold.size13.black,
        )), // Name
        DataCell(Text(
          (item.projectCount ?? 0).toString(),
          style: fontFamilySemiBold.size13.black,
        )),
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
