import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/requests/model/request_model.dart';
import 'package:webapp/widgets/common_chips.dart';

class RequestTableSource extends DataTableSource {
  final List<ProjectRequestModel> data;
  Function(ProjectRequestModel) onReject;
  final String status;

  RequestTableSource(this.data, this.status, this.onReject);

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
        return [
          DataCell(Text("${m.sNo}")),
          DataCell(Text(m.projectCode ?? "")),
          DataCell(Text(m.clientName ?? "")),
          DataCell(Text(m.clientPhone ?? "")),
          DataCell(Text(m.influencerId ?? "")),
          DataCell(Text(m.requestedDate ?? "")),
          DataCell(Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Text("Reject", style: TextStyle(color: Colors.red)),
              Text("Move to Waiting", style: TextStyle(color: Colors.green)),
            ],
          )),
        ];

      case "waiting":
        return [
          DataCell(Text("${m.sNo}")),
          DataCell(Text(m.projectCode ?? "")),
          DataCell(Text(m.clientName ?? "")),
          DataCell(Text(m.clientPhone ?? "")),
          DataCell(Text(m.influencerId ?? "")),
          DataCell(Text(m.requestedDate ?? "")),
          DataCell(Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CommonStatusChip(
                onTap: () => onReject(m),
                imageheight: 20,
                imagewidth: 20,
                margin: zeroPadding,
                text: 'Reject',
                imagePath: 'assets/images/rejected.svg',
                bgColor: red,
                imageColor: white,
                textStyle: fontFamilySemiBold.size10.white,
              ),
              horizontalSpacing10,
              CommonStatusChip(
                imageheight: 20,
                imagewidth: 20,
                margin: zeroPadding,
                text: 'Proceed',
                imagePath: 'assets/images/complete-pending-list.svg',
                bgColor: greenShade1,
                imageColor: white,
                textStyle: fontFamilySemiBold.size10.white,
              ),
              //   Text("Reject", style: TextStyle(color: Colors.red)),
              //   Text("Proceed", style: TextStyle(color: Colors.green)),
            ],
          )),
        ];

      case "waiting_accept":
        return [
          DataCell(Text("${m.sNo}")),
          DataCell(Text(m.projectCode ?? "")),
          DataCell(Text(m.clientName ?? "")),
          DataCell(Text(m.influencerName ?? "")),
          DataCell(Text(m.clientPhone ?? "")),
          DataCell(Text(m.influencerPhone ?? "")),
          DataCell(Text(m.requestedDate ?? "")),
          const DataCell(Icon(Icons.more_vert)),
        ];

      case "completed_pending":
        return [
          DataCell(Text("${m.sNo}")),
          DataCell(Text(m.projectCode ?? "")),
          DataCell(Text(m.clientName ?? "")),
          DataCell(Text(m.influencerName ?? "")),
          DataCell(Text(m.requestedDate ?? "")),
          DataCell(Text(m.viewLink ?? "View")),
          const DataCell(Icon(Icons.verified)),
        ];

      case "completed":
        return [
          DataCell(Text("${m.sNo}")),
          DataCell(Text(m.projectCode ?? "")),
          DataCell(Text(m.clientName ?? "")),
          DataCell(Text(m.influencerName ?? "")),
          DataCell(Text(m.requestedDate ?? "")),
          DataCell(Text(m.completedDate ?? "")),
          const DataCell(Icon(Icons.arrow_forward)),
        ];

      case "influencer_cancelled":
        return [
          DataCell(Text("${m.sNo}")),
          DataCell(Text(m.projectCode ?? "")),
          DataCell(Text(m.clientName ?? "")),
          DataCell(Text(m.influencerName ?? "")),
          DataCell(Text(m.clientPhone ?? "")),
          DataCell(Text(m.influencerPhone ?? "")),
          DataCell(Text(m.requestedDate ?? "")),
          const DataCell(Text("Revoke")),
        ];

      case "rejected":
        return [
          DataCell(Text("${m.sNo}")),
          DataCell(Text(m.projectCode ?? "")),
          DataCell(Text(m.clientName ?? "")),
          DataCell(Text(m.influencerName ?? "")),
          DataCell(Text(m.clientPhone ?? "")),
          DataCell(Text(m.influencerPhone ?? "")),
          DataCell(Text(m.requestedDate ?? "")),
          DataCell(Text(m.rejectedDate ?? "")),
        ];

      case "promote_verified":
        return [
          DataCell(Text("${m.sNo}")),
          DataCell(Text(m.projectCode ?? "")),
          DataCell(Text(m.clientName ?? "")),
          DataCell(Text(m.influencerName ?? "")),
          DataCell(Text(m.clientPhone ?? "")),
          DataCell(Text(m.influencerPhone ?? "")),
          DataCell(Text(m.assignedDate ?? "")),
          const DataCell(Icon(Icons.payment)),
        ];

      case "promote_pay":
        return [
          DataCell(Text("${m.sNo}")),
          DataCell(Text(m.projectCode ?? "")),
          DataCell(Text(m.clientName ?? "")),
          DataCell(Text(m.influencerName ?? "")),
          DataCell(Text(m.completedDate ?? "")),
          DataCell(Text(m.influencerBankDetails ?? "")),
          DataCell(Text("${m.paymentAmount ?? 0}")),
          const DataCell(Icon(Icons.check_circle)),
        ];

      case "promote_commission":
        return [
          DataCell(Text("${m.sNo}")),
          DataCell(Text(m.projectCode ?? "")),
          DataCell(Text(m.clientName ?? "")),
          DataCell(Text(m.influencerName ?? "")),
          DataCell(Text(m.completedDate ?? "")),
          DataCell(Text(m.influencerBankDetails ?? "")),
          DataCell(Text("${m.commissionAmount ?? 0}")),
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
