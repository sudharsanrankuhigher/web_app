import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/report/model/report_model.dart';

class CompanyDetailedTableSource extends DataTableSource {
  final List<PromoteProject> data;
  final String status;
  final String? totalPayments;
  final String? totalCommissions;
  final String? totalInfPayments;

  CompanyDetailedTableSource(
      {required this.data,
      required this.status,
      required this.totalCommissions,
      required this.totalInfPayments,
      required this.totalPayments});

  @override
  DataRow? getRow(int index) {
    if (index == data.length && data.isNotEmpty) {
      return DataRow(
          color: WidgetStateProperty.all(Colors.grey.shade300),
          cells: [
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(
              Text(
                "TOTAL",
                style: fontFamilySemiBold.size13.black,
              ),
            ),
            DataCell(Center(child: Text(""))),
            DataCell(
              Text(
                totalPayments!,
                style: fontFamilySemiBold.size13.black,
              ),
            ),
            DataCell(
              Text(
                totalCommissions!,
                style: fontFamilySemiBold.size13.black,
              ),
            ),
            DataCell(
              Text(
                totalInfPayments!,
                style: fontFamilySemiBold.size13.black,
              ),
            ),
          ]);
    }
    if (data.isEmpty) {
      return const DataRow(
        cells: [
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Text("")),
          DataCell(Center(child: Text("No data found"))),
          // DataCell(Text("")),
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
          (item.projectCode ?? '-').toString(),
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
        // DataCell(Text(
        //   "${item.in ?? 0} / ${item.infName1 ?? 0}",
        //   style: fontFamilySemiBold.size13.black,
        // )),
        DataCell(Text(
          "${item.companyPayment ?? 0}",
          style: fontFamilySemiBold.size13.black,
        )),
        DataCell(Text(
          "${item.companyCommission ?? 0}",
          style: fontFamilySemiBold.size13.black,
        )),
        DataCell(Text(
          "${item.infPayment ?? 0}",
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
  int get rowCount => data.isEmpty ? 1 : data.length + 1;
  @override
  int get selectedRowCount => 0;
}
