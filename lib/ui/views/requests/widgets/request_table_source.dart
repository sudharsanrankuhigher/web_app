import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/requests/model/request_model.dart';

class RequestTableSource extends DataTableSource {
  final List<ProjectRequestModel> data;
  final String status;

  RequestTableSource(this.data, this.status);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final model = data[index];

    return DataRow.byIndex(
      color: WidgetStateProperty.resolveWith<Color?>(
        (states) => index.isEven ? Colors.white : Colors.grey.shade100,
      ),
      index: index,
      cells: getCellsByStatus(model, status),
    );
  }

  List<DataCell> getCellsByStatus(ProjectRequestModel m, String status) {
    switch (status) {
      case "requested":
      case "pending":
        return [
          DataCell(Text("${m.sNo}")),
          DataCell(Text("${m.projectCode}")),
          DataCell(Text("${m.clientName}")),
          DataCell(Text("${m.clientPhone}")),
          DataCell(Text("${m.influencerId}")),
          DataCell(Text("${m.requestedDate}")),
          DataCell(Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Rejected',
                style: fontFamilySemiBold.size12.red,
              ),
              Text(
                'Pending',
                style: fontFamilySemiBold.size12.appGreen700,
              )
            ],
          )),
        ];

      case "accepted":
        return [
          DataCell(Text("${m.sNo}")),
          DataCell(Text("${m.projectCode}")),
          DataCell(Text("${m.clientName}")),
          DataCell(Text("${m.influencerName}")),
          DataCell(Text("${m.clientPhone}")),
          DataCell(Text("${m.influencerPhone}")),
          DataCell(Text("${m.requestedDate}")),
          const DataCell(Icon(Icons.more_vert)),
        ];

      case "complete_pending_list":
      case "completed":
        return [
          DataCell(Text("${m.sNo}")),
          DataCell(Text("${m.projectCode}")),
          DataCell(Text("${m.clientName}")),
          DataCell(Text("${m.influencerName}")),
          DataCell(Text("${m.requestedDate}")),
          DataCell(Text("${m.completedDate}")),
          const DataCell(Icon(Icons.more_vert)),
        ];

      case "cancelled":
      case "rejected":
        return [
          DataCell(Text("${m.sNo}")),
          DataCell(Text("${m.projectCode}")),
          DataCell(Text("${m.clientName}")),
          DataCell(Text("${m.influencerName}")),
          DataCell(Text("${m.clientPhone}")),
          DataCell(Text("${m.influencerPhone}")),
          DataCell(Text("${m.requestedDate}")),
          DataCell(Text("${m.cancelledDate}")),
        ];

      case "promote_verified":
        return [
          DataCell(Text("${m.sNo}")),
          DataCell(Text("${m.projectCode}")),
          DataCell(Text("${m.clientName}")),
          DataCell(Text("${m.influencerName}")),
          DataCell(Text("${m.clientPhone}")),
          DataCell(Text("${m.influencerPhone}")),
          DataCell(Text("${m.assignedDate}")),
        ];

      case "promote_pay":
        return [
          DataCell(Text("${m.sNo}")),
          DataCell(Text("${m.projectCode}")),
          DataCell(Text("${m.clientName}")),
          DataCell(Text("${m.influencerName}")),
          DataCell(Text("${m.completedDate}")),
          DataCell(Text("${m.influencerBankDetails}")),
          DataCell(Text("${m.paymentAmount}")),
          const DataCell(Icon(Icons.more_vert)),
        ];

      case "promote_commission":
        return [
          DataCell(Text("${m.sNo}")),
          DataCell(Text("${m.projectCode}")),
          DataCell(Text("${m.clientName}")),
          DataCell(Text("${m.influencerName}")),
          DataCell(Text("${m.completedDate}")),
          DataCell(Text("${m.influencerBankDetails}")),
          DataCell(Text("${m.commissionAmount}")),
        ];

      default:
        return [];
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.isNotEmpty ? data.length : 0;

  @override
  int get selectedRowCount => 0;
}
