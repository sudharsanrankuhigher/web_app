import 'package:flutter/material.dart';
import 'package:webapp/core/helper/date_helper.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/report/model/report_model.dart';
import 'package:webapp/services/theme_service.dart';

class ReportTableSource extends DataTableSource {
  final List<SubscriptionPlan> data;
  final String status;
  final String? total;

  ReportTableSource({
    required this.data,
    required this.status,
    required this.total,
  });

  @override
  DataRow? getRow(int index) {
    if (index == data.length && data.isNotEmpty) {
      return DataRow(
          color: WidgetStateProperty.all(
            ThemeService.instance.isDarkMode
                ? const Color(0xFF334155) // slate-700
                : Colors.grey.shade300,
          ),
          cells: [
            const DataCell(Text("")),
            const DataCell(Text("")),
            DataCell(
              Text(
                "TOTAL",
                style: fontFamilySemiBold.size13.black,
              ),
            ),
            const DataCell(Center(child: Text(""))),
            const DataCell(Text("")),
            DataCell(
              Text(
                total!,
                style: fontFamilySemiBold.size13.black,
              ),
            ),
            const DataCell(Text("")),
          ]);
    }

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

    final item = data[index];

    return DataRow(
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
      cells: [
        DataCell(Text(
          "${index + 1}",
          style: fontFamilySemiBold.size13.black,
        )), // S.No
        DataCell(Text(
          item.clientName ?? '-',
          style: fontFamilySemiBold.size13.black,
        )), // Name
        DataCell(Text(
          item.clientMobileNumber ?? '-',
          style: fontFamilySemiBold.size13.black,
        )),
        DataCell(Text(
          "${item.packageName ?? 0}",
          style: fontFamilySemiBold.size13.black,
        )),
        DataCell(Text(
          "${item.packageStatus ?? 0}",
          style: fontFamilySemiBold.size13.black,
        )),
        DataCell(Text(
          "${item.amount ?? 0}",
          style: fontFamilySemiBold.size13.black,
        )),
        DataCell(Text(
          "${DateFormatter.formatToDDMMMYYYY(item.paymentDate) ?? 0}",
          style: fontFamilySemiBold.size13.black,
        )),
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
