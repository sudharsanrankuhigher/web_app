import 'package:flutter/material.dart';
import 'package:webapp/core/helper/date_helper.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/requests/model/request_model.dart'
    as request_model;
import 'package:webapp/widgets/common_chips.dart';
import 'package:webapp/widgets/view_link.dart';

class RequestTableSource extends DataTableSource {
  final List<request_model.Datum> data;
  final void Function(request_model.Datum) onReject;
  final void Function(request_model.Datum) onWaiting;
  final void Function(request_model.Datum) onProceed;
  final void Function(request_model.Datum) onPreparing;
  final void Function(request_model.Datum) onGoToPromoteVerified;
  final void Function(request_model.Datum) onRevoke;
  final void Function(request_model.Datum) onGotoPromotePay;

  final String status;

  RequestTableSource(
      this.data,
      this.status,
      this.onReject,
      this.onWaiting,
      this.onProceed,
      this.onPreparing,
      this.onGoToPromoteVerified,
      this.onRevoke,
      this.onGotoPromotePay);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final model = data[index];

    return DataRow.byIndex(
      color: WidgetStateProperty.resolveWith<Color?>(
        (states) => index.isEven ? Colors.white : Colors.grey.shade100,
      ),
      index: index,
      cells: getCellsByStatus(model, status, index),
    );
  }

  List<DataCell> getCellsByStatus(
      request_model.Datum m, String status, int index) {
    switch (status) {
      case "requested":
        return [
          DataCell(Text('${index + 1}')),
          DataCell(Text(m.projectId ?? "")),
          DataCell(Text(m.client!.name ?? "")),
          DataCell(Text(m.client!.mobileNumber ?? "")),
          DataCell(Center(
              child: Text("${m.inf!.infId ?? "-"} / ${m.inf!.phone ?? "-"}"))),
          DataCell(Text(DateFormatter.formatToDDMMMYYYY(
              m.dates!.requestedAt.toString()))),
          DataCell(
            SizedBox(
              width: 250, // 👈 bigger width
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonStatusChip(
                    onTap: () => onReject(m),
                    imageheight: 22,
                    imagewidth: 22,
                    margin: zeroPadding,
                    text: 'Reject',
                    imagePath: 'assets/images/rejected.svg',
                    bgColor: red,
                    imageColor: white,
                    textStyle: fontFamilySemiBold.size10.white,
                  ),
                  CommonStatusChip(
                    onTap: () => onWaiting(m),
                    imageheight: 22,
                    imagewidth: 22,
                    margin: zeroPadding,
                    text: 'Waiting',
                    imagePath: 'assets/images/complete-pending-list.svg',
                    bgColor: greenShade1,
                    imageColor: white,
                    textStyle: fontFamilySemiBold.size10.white,
                  ),
                  // Text("Reject", style: TextStyle(color: Colors.red)),
                  // Text("Move to Waiting",
                  //     style: TextStyle(color: Colors.green)),
                ],
              ),
            ),
          ),
        ];

      case "waiting":
        return [
          DataCell(Text('${index + 1}')),
          DataCell(Text(m.projectId ?? "")),
          DataCell(Text(m.client!.name ?? "")),
          DataCell(Text(m.client!.mobileNumber ?? "")),
          DataCell(Center(
              child: Center(
                  child: Text(
                      "${m.inf!.infId ?? ""} / ${(m.inf!.phone ?? "")}")))),
          DataCell(Text(DateFormatter.formatToDDMMMYYYY(
                  m.dates!.requestedAt.toString()) ??
              "")),
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
                onTap: () => onProceed(m),
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
          DataCell(Text('${index + 1}')),
          DataCell(Text(m.projectId ?? "")),
          DataCell(Text(m.client!.name ?? "")),
          DataCell(Text(m.client!.mobileNumber ?? "")),
          DataCell(Text(m.inf!.name ?? "")),
          DataCell(Text(m.inf!.phone ?? "")),
          DataCell(Text(DateFormatter.formatToDDMMMYYYY(
                  m.dates!.requestedAt.toString()) ??
              "")),
          DataCell(
            Center(
              child: CommonStatusChip(
                imageheight: 20,
                imagewidth: 20,
                margin: zeroPadding,
                text: 'Processing',
                imagePath: 'assets/images/pending.svg',
                bgColor: pending,
                imageColor: white,
                textStyle: fontFamilySemiBold.size10.white,
              ),
            ),
          ),
        ];

      case "completed_pending":
        return [
          DataCell(Text('${index + 1}')),
          DataCell(Text(m.projectId ?? "")),
          DataCell(Text(m.client!.name ?? "")),
          DataCell(Text(m.client!.mobileNumber ?? "")),
          DataCell(Text("${m.inf!.name ?? ""} / ${m.inf!.phone ?? ""}")),
          DataCell(Text(DateFormatter.formatToDDMMMYYYY(
                  m.dates!.requestedAt.toString()) ??
              "")),
          DataCell(Text(
              DateFormatter.formatToDDMMMYYYY(m.dates!.assignedAt.toString()) ??
                  "")),
          DataCell(
            (m.promotion!.youtube != null)
                ? ViewLink(
                    url: m.promotion!.youtube!,
                    text: "ViewLink",
                  )
                : m.promotion!.instagram != null
                    ? ViewLink(
                        url: m.promotion!.instagram!,
                        text: "ViewLink",
                      )
                    : m.promotion!.facebook != null
                        ? ViewLink(
                            url: m.promotion!.facebook!,
                            text: "ViewLink",
                          )
                        : Container(
                            child: Text('-'),
                          ),
          ),
          DataCell(Center(
            child: CommonStatusChip(
              onTap: () => onPreparing(m),
              imageheight: 20,
              imagewidth: 20,
              margin: zeroPadding,
              text: 'Preparing',
              imagePath: 'assets/images/pending.svg',
              bgColor: pending,
              imageColor: white,
              textStyle: fontFamilySemiBold.size10.white,
              padding: defaultPadding4 + rightPadding4,
            ),
          )),
        ];

      case "completed":
        return [
          DataCell(Text('${index + 1}')),
          DataCell(Text(m.projectId ?? "")),
          DataCell(Text(m.client!.name ?? "")),
          DataCell(Text(m.client!.mobileNumber ?? "")),
          DataCell(Text("${m.inf!.name ?? ""} / ${m.inf!.phone ?? ""}")),
          DataCell(Text(DateFormatter.formatToDDMMMYYYY(
                  m.dates!.requestedAt.toString()) ??
              "")),
          DataCell(Text(
              DateFormatter.formatToDDMMMYYYY(m.dates!.completed.toString()) ??
                  "")),
          DataCell(
            Center(
              child: CommonStatusChip(
                onTap: () => onGoToPromoteVerified(m),
                imageheight: 20,
                imagewidth: 20,
                margin: zeroPadding,
                text: 'go to verified',
                imagePath: 'assets/images/verified.svg',
                bgColor: greenShade1,
                imageColor: white,
                textStyle: fontFamilySemiBold.size10.white,
                padding: defaultPadding4 + rightPadding4,
              ),
            ),
          ),
        ];

      case "influencer_cancelled":
        return [
          DataCell(Text('${index + 1}')),
          DataCell(Text(m.projectId ?? "")),
          DataCell(Text(m.client!.name ?? "")),
          DataCell(Text(m.inf!.name ?? "")),
          DataCell(Text(m.client!.mobileNumber ?? "")),
          DataCell(Text(m.inf!.phone ?? "")),
          DataCell(Text(DateFormatter.formatToDDMMMYYYY(
                  m.dates!.requestedAt.toString()) ??
              "")),
          DataCell(
            Center(
              child: CommonStatusChip(
                onTap: () => onRevoke(m),
                imageheight: 20,
                imagewidth: 20,
                margin: zeroPadding,
                text: 'Revoke',
                imagePath: 'assets/images/assigned.svg',
                bgColor: redShade,
                imageColor: Colors.black,
                textStyle: fontFamilySemiBold.size10.black,
                padding: defaultPadding4 + rightPadding4,
              ),
            ),
          ),
        ];

      case "rejected":
        return [
          DataCell(Text('${index + 1}')),
          DataCell(Text(m.projectId ?? "")),
          DataCell(Text(m.client!.name ?? "")),
          DataCell(Text(m.inf!.name ?? "")),
          DataCell(Text(m.client!.mobileNumber ?? "")),
          DataCell(Text(m.inf!.phone ?? "")),
          DataCell(Text(DateFormatter.formatToDDMMMYYYY(
                  m.dates!.requestedAt.toString()) ??
              "")),
          DataCell(Text(
              DateFormatter.formatToDDMMMYYYY(m.dates!.cancelled.toString()) ??
                  "")),
        ];

      case "promote_verified":
        return [
          DataCell(Text('${index + 1}')),
          DataCell(Text(m.projectId ?? "")),
          DataCell(Text(m.client!.name ?? "")),
          DataCell(Text(m.client!.mobileNumber ?? "")),
          DataCell(Text(m.inf!.name ?? "")),
          DataCell(Text("${m.inf!.infId ?? ""} / ${m.inf!.phone ?? ""}")),
          DataCell(Text(
              DateFormatter.formatToDDMMMYYYY(m.dates!.assignedAt.toString()) ??
                  "")),
          DataCell(Text(
              DateFormatter.formatToDDMMMYYYY(m.dates!.completed.toString()) ??
                  "")),
          DataCell(SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (m.promotion != null)
                  (m.promotion!.youtube != null)
                      ? ViewLink(
                          url: m.promotion!.youtube!,
                          text: "ViewLink",
                        )
                      : m.promotion!.instagram != null
                          ? ViewLink(
                              url: m.promotion!.instagram!,
                              text: "ViewLink",
                            )
                          : m.promotion!.facebook != null
                              ? ViewLink(
                                  url: m.promotion!.facebook!,
                                  text: "ViewLink",
                                )
                              : Container(),
                horizontalSpacing4,
                InkWell(
                  onTap: () => onGotoPromotePay(m),
                  child: Container(
                    padding: defaultPadding4 + rightPadding4 + leftPadding4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: greenShade1,
                    ),
                    child: Text(
                      'Promote pay',
                      style: fontFamilyMedium.size10.white,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ];

      case "promote_pay":
        return [
          DataCell(Text('${index + 1}')),
          DataCell(Text(m.projectId ?? "")),
          DataCell(Text("${m.inf!.name ?? ""} / ${m.inf!.infId ?? ""}")),
          DataCell(Text(m.inf!.phone ?? "")),
          DataCell(Text(
              DateFormatter.formatToDDMMMYYYY(m.dates!.completed.toString()) ??
                  "")),
          DataCell(Text(m.payment!.bankDetails ?? "")),
          DataCell(Text("${m.payment!.amount ?? 0}")),
          DataCell(Text("${m.payment!.commission ?? 0}")),
          DataCell(Row(
            children: [
              Text(
                'Paid',
                style: fontFamilySemiBold.size13.continueButton,
              ),
              horizontalSpacing4,
              Text(" / ${m.dates!.completed.toString() ?? ""}"),
            ],
          )),
        ];

      case "promote_commission":
        return [
          DataCell(Text('${index + 1}')),
          DataCell(Text(m.projectId ?? "")),
          DataCell(Text("${m.inf!.name ?? ""} / ${m.inf!.infId ?? ""}")),
          DataCell(Text(m.inf!.phone ?? "")),
          DataCell(Text(
              DateFormatter.formatToDDMMMYYYY(m.dates!.completed.toString()) ??
                  "")),
          DataCell(Text("${m.payment!.commission ?? 0}")),
          DataCell(Row(
            children: [
              Text(
                'Success',
                style: fontFamilySemiBold.size13.continueButton,
              ),
              horizontalSpacing4,
              Text(
                  " / ${DateFormatter.formatToDDMMMYYYY(m.dates!.completed.toString()) ?? ""}"),
            ],
          )),
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
