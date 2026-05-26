import 'package:flutter/material.dart';
import 'package:webapp/core/helper/date_helper.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/requests/model/request_model.dart'
    as request_model;
import 'package:webapp/services/theme_service.dart';
import 'package:webapp/widgets/common_chips.dart';
import 'package:webapp/widgets/view_link.dart';
import 'package:webapp/core/helper/permission_helper.dart';

class RequestTableSource extends DataTableSource {
  final List<request_model.Datum> data;
  final void Function(request_model.Datum) onReject;
  final void Function(request_model.Datum) onWaiting;
  final void Function(request_model.Datum) onProceed;
  final void Function(request_model.Datum) onPreparing;
  final void Function(request_model.Datum) onGoToPromoteVerified;
  final void Function(request_model.Datum) onRevoke;
  final void Function(request_model.Datum) onGotoPromotePay;
  final void Function(request_model.Datum) onPaymentDialog;
  final void Function(request_model.Datum) onGotoPromoteCommission;
  final void Function(request_model.Datum) onClientPaymentVerified;
  final void Function(request_model.Datum) onReAssign;
  final void Function(request_model.Datum) infReject;
  final void Function(request_model.Datum) onBankDetails;
  final void Function(request_model.Datum)? showNote;
  final void Function(request_model.Datum) onRefund;
  final void Function(request_model.Datum) onRefundDialog;

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
      this.onGotoPromotePay,
      this.onPaymentDialog,
      this.onGotoPromoteCommission,
      this.onClientPaymentVerified,
      this.onReAssign,
      this.onBankDetails,
      this.infReject,
      this.onRefund,
      this.onRefundDialog,
      this.showNote);

  String getFormattedId(int? categoryId, int? id) {
    if (categoryId == null || id == null) return "UNKNOWN";

    String prefix;

    switch (categoryId) {
      case 1:
        prefix = "INF";
        break;
      case 2:
        prefix = "MOV";
        break;
      case 3:
        prefix = "TV";
        break;
      case 4:
        prefix = "SP";
        break;
      default:
        prefix = "UNK";
    }

    // pad id to 4 digits → 1 => 0001, 10 => 0010
    final paddedId = id.toString().padLeft(4, '0');

    return "$prefix$paddedId";
  }

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final model = data[index];

    return DataRow.byIndex(
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
              child: Text(
                  "${m.inf!.name ?? "-"} \n ${m.inf!.infId ?? "-"} / ${m.inf!.phone ?? "-"}"))),
          DataCell(Text(DateFormatter.formatToDDMMMYYYY(
              m.dates!.requestedAt.toString()))),
          DataCell(
            SizedBox(
              width: 250, // 👈 bigger width
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (PermissionHelper.instance.has('edit_requests'))
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
                  if (PermissionHelper.instance.has('edit_requests'))
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
              if (PermissionHelper.instance.has('edit_requests'))
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
              if (PermissionHelper.instance.has('edit_requests'))
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
            ],
          )),
        ];

      case "waiting_accept":
        return [
          DataCell(Text('${index + 1}')),
          DataCell(InkWell(
              onTap: () => showNote!(m), child: Text(m.projectId ?? ""))),
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
          DataCell(
            PermissionHelper.instance.has('edit_requests')
                ? CommonStatusChip(
                    onTap: () => infReject(m),
                    imageheight: 20,
                    imagewidth: 20,
                    margin: zeroPadding,
                    text: 'Reject',
                    imagePath: 'assets/images/rejected.svg',
                    bgColor: red,
                    imageColor: white,
                    textStyle: fontFamilySemiBold.size10.white,
                  )
                : const SizedBox(),
          ),
        ];

      case "completed_pending":
        return [
          DataCell(Text('${index + 1}')),
          DataCell(InkWell(
              onTap: () => showNote!(m), child: Text(m.projectId ?? ""))),
          DataCell(Text(m.client!.name ?? "")),
          DataCell(Text(m.client!.mobileNumber ?? "")),
          DataCell(Text("${m.inf!.name ?? ""} / ${m.inf!.phone ?? ""}")),
          DataCell(Text(DateFormatter.formatToDDMMMYYYY(
                  m.dates!.requestedAt.toString()) ??
              "")),
          DataCell(Text(
              DateFormatter.formatToDDMMMYYYY(m.dates!.assignedAt.toString()) ??
                  "")),
          // DataCell(
          //   (m.promotion!.youtube != null)
          //       ? ViewLink(
          //           url: m.promotion!.youtube!.toString(),
          //           text: "ViewLink",
          //         )
          //       : m.promotion!.instagram != null
          //           ? ViewLink(
          //               url: m.promotion!.instagram!.toString(),
          //               text: "ViewLink",
          //             )
          //           : m.promotion!.facebook != null
          //               ? ViewLink(
          //                   url: m.promotion!.facebook!.toString(),
          //                   text: "ViewLink",
          //                 )
          //               : Container(
          //                   child: Text('-'),
          //                 ),
          // ),
          DataCell(
            Builder(
              builder: (_) {
                final links = <Widget>[];

                if (m.promotion?.youtube != null &&
                    m.promotion!.youtube!.isNotEmpty) {
                  links.add(
                    ViewLink(
                      url: m.promotion!.youtube!,
                      text: "YouTube",
                    ),
                  );
                }

                if (m.promotion?.instagram != null &&
                    m.promotion!.instagram!.isNotEmpty) {
                  links.add(
                    ViewLink(
                      url: m.promotion!.instagram!,
                      text: "Instagram",
                    ),
                  );
                }

                if (m.promotion?.facebook != null &&
                    m.promotion!.facebook!.isNotEmpty) {
                  links.add(
                    ViewLink(
                      url: m.promotion!.facebook!,
                      text: "Facebook",
                    ),
                  );
                }

                if (links.isEmpty) {
                  return const Text('-');
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: links,
                );
              },
            ),
          ),

          DataCell(Center(
            child: PermissionHelper.instance.has('edit_requests')
                ? CommonStatusChip(
                    onTap: () => m.status == 5
                        ? null
                        : (m.promotion?.youtube != null &&
                                    m.promotion!.youtube!.isNotEmpty) ||
                                (m.promotion?.instagram != null &&
                                    m.promotion!.instagram!.isNotEmpty) ||
                                (m.promotion?.facebook != null &&
                                    m.promotion!.facebook!.isNotEmpty)
                            ? onPreparing(m)
                            : null,
                    imageheight: 20,
                    imagewidth: 20,
                    margin: zeroPadding,
                    text: m.status == 5
                        ? "Rework"
                        : (m.promotion?.youtube != null &&
                                    m.promotion!.youtube!.isNotEmpty) ||
                                (m.promotion?.instagram != null &&
                                    m.promotion!.instagram!.isNotEmpty) ||
                                (m.promotion?.facebook != null &&
                                    m.promotion!.facebook!.isNotEmpty)
                            ? 'Inf- complete'
                            : 'Preparing',
                    imagePath: 'assets/images/pending.svg',
                    bgColor: pending,
                    imageColor: white,
                    textStyle: fontFamilySemiBold.size10.white,
                    padding: defaultPadding4 + rightPadding4,
                  )
                : const SizedBox(),
          )),
          DataCell(Center(
            child: PermissionHelper.instance.has('delete_requests')
                ? CommonStatusChip(
                    onTap: () => (m.promotion?.youtube != null &&
                                m.promotion!.youtube!.isNotEmpty) ||
                            (m.promotion?.instagram != null &&
                                m.promotion!.instagram!.isNotEmpty) ||
                            (m.promotion?.facebook != null &&
                                m.promotion!.facebook!.isNotEmpty)
                        ? null
                        : infReject(m),
                    imageheight: 20,
                    imagewidth: 20,
                    margin: zeroPadding,
                    text: 'Cancel',
                    imagePath: 'assets/images/rejected.svg',
                    bgColor: red,
                    imageColor: white,
                    textStyle: fontFamilySemiBold.size10.white,
                    padding: defaultPadding4 + rightPadding4,
                  )
                : const SizedBox(),
          )),
        ];

      case "completed":
        return [
          DataCell(Text('${index + 1}')),
          DataCell(InkWell(
              onTap: () => showNote!(m), child: Text(m.projectId ?? ""))),
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
              child: PermissionHelper.instance.has('edit_requests')
                  ? CommonStatusChip(
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
                    )
                  : const SizedBox(),
            ),
          ),
        ];

      case "influencer_cancelled":
        return [
          DataCell(Text('${index + 1}')),
          DataCell(InkWell(
              onTap: () => showNote!(m), child: Text(m.projectId ?? ""))),
          DataCell(Text(m.client!.name ?? "")),
          DataCell(Text(m.inf!.name ?? "")),
          DataCell(Text(m.client!.mobileNumber ?? "")),
          DataCell(Text(m.inf!.phone ?? "")),
          DataCell(Text(DateFormatter.formatToDDMMMYYYY(
                  m.dates!.requestedAt.toString()) ??
              "")),
          DataCell(
            Center(
              child: PermissionHelper.instance.has('edit_requests')
                  ? CommonStatusChip(
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
                    )
                  : const SizedBox(),
            ),
          ),
          DataCell(
            Center(
              child: PermissionHelper.instance.has('edit_requests')
                  ? CommonStatusChip(
                      onTap: () => onReAssign(m),
                      imageheight: 20,
                      imagewidth: 20,
                      margin: zeroPadding,
                      text: 'ReAssign',
                      imagePath: 'assets/images/assigned.svg',
                      bgColor: greenShade1,
                      imageColor: white,
                      textStyle: fontFamilySemiBold.size10.white,
                      padding: defaultPadding4 + rightPadding4,
                    )
                  : const SizedBox(),
            ),
          ),
          DataCell(
            Center(
              child: PermissionHelper.instance.has('edit_requests')
                  ? CommonStatusChip(
                      onTap: () => onRefund(m),
                      imageheight: 20,
                      imagewidth: 20,
                      margin: zeroPadding,
                      text: 'Refunded',
                      imagePath: 'assets/images/assigned.svg',
                      bgColor: onGoing,
                      imageColor: white,
                      textStyle: fontFamilySemiBold.size10.white,
                      padding: defaultPadding4 + rightPadding4,
                    )
                  : const SizedBox(),
            ),
          ),
        ];

      case "rejected":
        return [
          DataCell(Text('${index + 1}')),
          DataCell(InkWell(
              onTap: () => showNote!(m), child: Text(m.projectId ?? ""))),
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
          DataCell(
            Center(
              child: PermissionHelper.instance.has('edit_requests')
                  ? CommonStatusChip(
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
                    )
                  : const SizedBox(),
            ),
          ),
          DataCell(
            Center(
              child: PermissionHelper.instance.has('edit_requests')
                  ? CommonStatusChip(
                      onTap: () => onReAssign(m),
                      imageheight: 20,
                      imagewidth: 20,
                      margin: zeroPadding,
                      text: 'ReAssign',
                      imagePath: 'assets/images/assigned.svg',
                      bgColor: greenShade1,
                      imageColor: white,
                      textStyle: fontFamilySemiBold.size10.white,
                      padding: defaultPadding4 + rightPadding4,
                    )
                  : const SizedBox(),
            ),
          ),
          DataCell(
            Center(
              child: PermissionHelper.instance.has('edit_requests')
                  ? CommonStatusChip(
                      onTap: () => onRefund(m),
                      imageheight: 20,
                      imagewidth: 20,
                      margin: zeroPadding,
                      text: 'Refunded',
                      imagePath: 'assets/images/assigned.svg',
                      bgColor: onGoing,
                      imageColor: white,
                      textStyle: fontFamilySemiBold.size10.white,
                      padding: defaultPadding4 + rightPadding4,
                    )
                  : const SizedBox(),
            ),
          ),
        ];

      case "promote_verified":
        return [
          DataCell(Text('${index + 1}')),
          DataCell(InkWell(
              onTap: () => showNote!(m), child: Text(m.projectId ?? ""))),
          DataCell(Text(m.client!.name ?? "")),
          DataCell(Text(m.client!.mobileNumber ?? "")),
          DataCell(Text(m.inf!.name ?? "")),
          DataCell(Text("${m.inf!.infId ?? ""} / ${m.inf!.phone ?? ""}")),
          DataCell(Text(
              DateFormatter.formatToDDMMMYYYY(m.dates!.assignedAt.toString()) ??
                  "")),
          DataCell(
            Builder(
              builder: (_) {
                final links = <Widget>[];

                if (m.promotion?.youtube != null &&
                    m.promotion!.youtube!.isNotEmpty) {
                  links.add(
                    ViewLink(
                      url: m.promotion!.youtube!,
                      text: "YouTube",
                    ),
                  );
                }

                if (m.promotion?.instagram != null &&
                    m.promotion!.instagram!.isNotEmpty) {
                  links.add(
                    ViewLink(
                      url: m.promotion!.instagram!,
                      text: "Instagram",
                    ),
                  );
                }

                if (m.promotion?.facebook != null &&
                    m.promotion!.facebook!.isNotEmpty) {
                  links.add(
                    ViewLink(
                      url: m.promotion!.facebook!,
                      text: "Facebook",
                    ),
                  );
                }

                if (links.isEmpty) {
                  return const Text('-');
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: links,
                );
              },
            ),
          ),
          DataCell(Text(
              DateFormatter.formatToDDMMMYYYY(m.dates!.completed.toString()) ??
                  "")),
          DataCell(Center(
              child: m.status == 9
                  ? InkWell(
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
                    )
                  : Text("Pending client payment verification",
                      textAlign: TextAlign.center,
                      style: fontFamilySemiBold.size13.red))),
        ];

      case "promote_pay":
        return [
          DataCell(Text('${index + 1}')),
          DataCell(InkWell(
              onTap: () => showNote!(m), child: Text(m.projectId ?? ""))),
          DataCell(Text("${m.inf!.name ?? ""} / ${m.inf!.infId ?? ""}")),
          DataCell(Text(m.inf!.phone ?? "")),
          DataCell(Text(
              DateFormatter.formatToDDMMMYYYY(m.dates!.completed.toString()) ??
                  "")),
          DataCell(InkWell(
              onTap: () => onBankDetails(m), child: Text(m.inf!.upiId ?? ""))),
          DataCell(Text("${m.payment!.amount ?? 0}")),
          DataCell(Text("${m.payment!.commission ?? 0}")),
          DataCell((m.payment!.status == '1')
              ? InkWell(
                  onTap: () => onPaymentDialog(m),
                  child: Container(
                    padding: defaultPadding4 + rightPadding4 + leftPadding4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: pendingColorShade,
                    ),
                    child: Text(
                      'Payment',
                      style: fontFamilyMedium.size10.black,
                    ),
                  ),
                )
              : InkWell(
                  onTap: () =>
                      m.status == 11 ? null : onGotoPromoteCommission(m),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: (m.status == 10) ? 'Paid' : 'Success',
                          style: fontFamilySemiBold.size13.continueButton,
                        ),
                        TextSpan(
                          text:
                              " / ${DateFormatter.formatToDDMMMYYYY(m.dates!.payment.toString())}",
                          style: fontFamilyRegular
                              .size13, // adjust style if needed
                        ),
                      ],
                    ),
                  ),
                )),
        ];

      case "promote_commission":
        return [
          DataCell(Text('${index + 1}')),
          DataCell(InkWell(
              onTap: () => showNote!(m), child: Text(m.projectId ?? ""))),
          DataCell(Text("${m.inf!.name ?? ""} / ${m.inf!.infId ?? ""}")),
          DataCell(Text(m.inf!.phone ?? "")),
          DataCell(Text(
              DateFormatter.formatToDDMMMYYYY(m.dates!.payment.toString()) ??
                  "")),
          DataCell(Text("${m.payment!.commission ?? 0}")),
          DataCell(Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Success',
                style: fontFamilySemiBold.size13.continueButton,
              ),
              horizontalSpacing4,
              Text(
                  " / ${DateFormatter.formatToDDMMMYYYY(m.dates!.payment.toString()) ?? ""}"),
            ],
          )),
        ];
      case "client_payment_verified":
        return [
          DataCell(Text('${index + 1}')),
          DataCell(InkWell(
              onTap: () => showNote!(m), child: Text(m.projectId ?? ""))),
          DataCell(Text("${m.client!.name ?? ""} ")),
          DataCell(Text(m.client!.mobileNumber ?? "")),
          DataCell(Text(
              m.payment!.amount != null ? m.payment!.amount.toString() : "")),
          DataCell(Text("${m.payment!.commission ?? 0}")),
          DataCell(PermissionHelper.instance.has('edit_requests')
              ? InkWell(
                  onTap: () => onClientPaymentVerified(m),
                  child: Center(
                    child: Text(
                      'Check & Verify',
                      style: fontFamilySemiBold.size13.continueButton,
                    ),
                  ),
                )
              : const SizedBox()),
        ];

      case "refund":
        return [
          DataCell(Text('${index + 1}')),
          DataCell(InkWell(
              onTap: () => showNote!(m), child: Text(m.projectId ?? ""))),
          DataCell(Text(m.client!.name ?? "")),
          DataCell(Text(m.client!.mobileNumber ?? "")),
          DataCell(Text(
              m.payment!.amount != null ? m.payment!.amount.toString() : "")),
          DataCell(Text(
              DateFormatter.formatToDDMMMYYYY(m.dates!.refund.toString()))),
          DataCell(Text(DateFormatter.formatToDDMMMYYYY(
              m.dates!.refundUpdated.toString()))),
          DataCell(Text(m.refundStatus == 2 ? "Completed" : "Pending")),
          DataCell(InkWell(
            onTap: () => m.refundStatus == 2 ? null : onRefundDialog(m),
            child: Center(
              child: Text(
                m.refundStatus == 2 ? "Completed" : "Refund initiated",
                style: m.refundStatus == 2
                    ? fontFamilyBold.size13.appGreen400
                    : fontFamilySemiBold.size13.continueButton,
              ),
            ),
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
