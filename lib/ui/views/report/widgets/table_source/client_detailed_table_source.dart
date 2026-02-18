import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/report/model/report_model.dart';

class ClientDetailedTableSource extends DataTableSource {
  final List<Datum> data;
  final Total? total;
  final String status;

  ClientDetailedTableSource(
      {required this.data, required this.status, this.total});

  @override
  DataRow? getRow(int index) {
    if (index == data.length && data.isNotEmpty) {
      return DataRow(
        color: WidgetStateProperty.all(Colors.grey.shade300),
        cells: [
          const DataCell(Text("")), // S.No
          const DataCell(Text("")), // Code
          DataCell(
            Text(
              "TOTAL",
              style: fontFamilySemiBold.size13.black,
            ),
          ),
          const DataCell(Text("")), // Empty
          const DataCell(Text("")), // Empty
          DataCell(
            Text(
              total!.clientPayment!.toStringAsFixed(0),
              style: fontFamilySemiBold.size13.black,
            ),
          ),
          DataCell(
            Text(
              total!.clientCommission!.toStringAsFixed(0),
              style: fontFamilySemiBold.size13.black,
            ),
          ),
          DataCell(
            Text(
              total!.influencerPaid!.toStringAsFixed(0),
              style: fontFamilySemiBold.size13.black,
            ),
          ),
        ],
      );
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
          item.cpCode ?? '-',
          style: fontFamilySemiBold.size13.black,
        )), // Name
        DataCell(Text(
          item.clientName ?? '-',
          style: fontFamilySemiBold.size13.black,
        )),
        DataCell(Text(
          "${item.clientMobile ?? 0}",
          style: fontFamilySemiBold.size13.black,
        )),
        DataCell(Text(
          "${item.influencerId ?? 0} / ${item.influencerName ?? 0}",
          style: fontFamilySemiBold.size13.black,
        )),
        DataCell(Text(
          "${item.clientPayment ?? 0}",
          style: fontFamilySemiBold.size13.black,
        )),
        DataCell(Text(
          "${item.clientCommission ?? 0}",
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
  int get rowCount => data.isEmpty ? 1 : data.length + 1;
  @override
  int get selectedRowCount => 0;
}
