import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/report/model/report_model.dart';

class ReportTableSource extends DataTableSource {
  final List<ReportModel> data;
  final String status;

  ReportTableSource({
    required this.data,
    required this.status,
  });

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
        ],
      );
    }

    final service = data[index];

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
          service.project,
          style: fontFamilySemiBold.size13.black,
        )), // Name
        DataCell(Text(
          service.influencer,
          style: fontFamilySemiBold.size13.black,
        )),
        DataCell(Text(
          service.client,
          style: fontFamilySemiBold.size13.black,
        )),
        DataCell(Text(
          "\$ ${service.amount}",
          style: fontFamilySemiBold.size13.black,
        )),
        DataCell(Container(
          padding: defaultPadding4 + rightPadding4 + leftPadding4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: service.status == 'in-progress'
                  ? pendingColorShade
                  : greenShade),
          child: Text(
            service.status,
            style: service.status == 'in-progress'
                ? fontFamilySemiBold.size13.pendingColor
                : fontFamilySemiBold.size13.completedColor,
          ),
        )),
        DataCell(Text(
          service.date,
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
