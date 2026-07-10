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
import 'package:webapp/ui/views/requests/widgets/confirmation_dialog.dart';
import 'package:stacked_services/stacked_services.dart';

class RequestTableSource extends DataTableSource {
  final List<request_model.Datum> data;
  final void Function(request_model.Datum, {bool isWaiting}) onReject;
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
  final void Function(request_model.Datum)? onWaitingNotesEdit;

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
      this.showNote,
      {this.onWaitingNotesEdit});

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
          _textCell('${index + 1}'),
          _textCell(m.projectId),
          _textCell(m.client?.name),
          _textCell(m.client?.mobileNumber),
          _textCell(
              "${m.inf?.name ?? "-"} \n ${m.inf?.infId ?? "-"} / ${m.inf?.phone ?? "-"}",
              center: true),
          _textCell(DateFormatter.formatToDDMMMYYYY(m.dates?.requestedAt)),
          DataCell(
            SizedBox(
              width: 250, // 👈 bigger width
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (PermissionHelper.instance.has('edit_requests'))
                    CommonStatusChip(
                      onTap: () => onReject(m, isWaiting: true),
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
          _textCell('${index + 1}'),
          _textCell(m.projectId),
          _textCell(m.client?.name),
          _textCell(m.client?.mobileNumber),
          DataCell(
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (PermissionHelper.instance.has('edit_requests'))
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.blue,
                      size: 15,
                    ),
                    onPressed: () => onWaitingNotesEdit != null
                        ? onWaitingNotesEdit!(m)
                        : null,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                horizontalSpacing4,
                Expanded(
                  child: m.notes != null && m.notes!.isNotEmpty
                      ? Tooltip(
                          message: m.notes!,
                          child: Text(
                            m.notes!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ))
                      : const Text("-"),
                ),
              ],
            ),
          ),
          _textCell("${m.inf?.infId ?? ""} / ${(m.inf?.phone ?? "")}",
              center: true),
          _textCell(DateFormatter.formatToDDMMMYYYY(m.dates?.requestedAt)),
          DataCell(
            PermissionHelper.instance.has('edit_requests')
                ? Center(
                    child: CommonStatusChip(
                      onTap: () => onReject(m, isWaiting: true),
                      imageheight: 20,
                      imagewidth: 20,
                      margin: zeroPadding,
                      text: 'Reject',
                      imagePath: 'assets/images/rejected.svg',
                      bgColor: red,
                      imageColor: white,
                      textStyle: fontFamilySemiBold.size10.white,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          DataCell(
            PermissionHelper.instance.has('edit_requests')
                ? Center(
                    child: CommonStatusChip(
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
                  )
                : const SizedBox.shrink(),
          ),
        ];

      case "waiting_accept":
        return [
          _textCell('${index + 1}'),
          _clickableTextCell(m.projectId, () => showNote!(m)),
          _textCell(m.client?.name),
          _textCell(m.client?.mobileNumber),
          _textCell(m.inf?.name),
          _textCell(m.inf?.phone),
          _textCell(DateFormatter.formatToDDMMMYYYY(m.dates?.requestedAt)),
          _buildNotesCell(m),
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
          _textCell('${index + 1}'),
          _clickableTextCell(m.projectId, () => showNote!(m)),
          _textCell(m.client?.name),
          _textCell(m.client?.mobileNumber),
          _textCell("${m.inf?.infId ?? ""} / ${m.inf?.phone ?? ""}"),
          _textCell(DateFormatter.formatToDDMMMYYYY(m.dates?.requestedAt)),
          _textCell(DateFormatter.formatToDDMMMYYYY(m.dates?.assignedAt)),
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
          _buildNotesCell(m),
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
                    onTap: () => infReject(m),
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
          _textCell('${index + 1}'),
          _clickableTextCell(m.projectId, () => showNote!(m)),
          _textCell(m.client?.name),
          _textCell(m.client?.mobileNumber),
          _textCell("${m.inf?.name ?? ""} / ${m.inf?.phone ?? ""}"),
          _textCell(DateFormatter.formatToDDMMMYYYY(m.dates?.requestedAt)),
          _textCell(DateFormatter.formatToDDMMMYYYY(m.dates?.completed)),
          _buildNotesCell(m),
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
          _textCell('${index + 1}'),
          _clickableTextCell(m.projectId, () => showNote!(m)),
          _textCell(m.client?.name),
          _textCell(m.inf?.name),
          _textCell(m.client?.mobileNumber),
          _textCell(m.inf?.phone),
          _textCell(DateFormatter.formatToDDMMMYYYY(m.dates?.requestedAt)),
          _buildNotesCell(m),
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
          _textCell('${index + 1}'),
          _clickableTextCell(m.projectId, () => showNote!(m)),
          _textCell(m.client?.name),
          _textCell(m.client?.mobileNumber),
          _textCell(m.inf?.name),
          _textCell(m.inf?.phone),
          _textCell(DateFormatter.formatToDDMMMYYYY(m.dates?.requestedAt)),
          _textCell(DateFormatter.formatToDDMMMYYYY(m.dates?.cancelled)),
          _buildNotesCell(m),
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
          // DataCell(
          //   Center(
          //     child: PermissionHelper.instance.has('edit_requests')
          //         ? CommonStatusChip(
          //             onTap: () => onRefund(m),
          //             imageheight: 20,
          //             imagewidth: 20,
          //             margin: zeroPadding,
          //             text: 'Refunded',
          //             imagePath: 'assets/images/assigned.svg',
          //             bgColor: onGoing,
          //             imageColor: white,
          //             textStyle: fontFamilySemiBold.size10.white,
          //             padding: defaultPadding4 + rightPadding4,
          //           )
          //         : const SizedBox(),
          //   ),
          // ),
        ];

      case "promote_verified":
        return [
          _textCell('${index + 1}'),
          _clickableTextCell(m.projectId, () => showNote!(m)),
          _textCell(m.client?.name),
          _textCell(m.client?.mobileNumber),
          _textCell(m.inf?.name),
          _textCell("${m.inf?.infId ?? ""} / ${m.inf?.phone ?? ""}"),
          _textCell(DateFormatter.formatToDDMMMYYYY(m.dates?.assignedAt)),
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
          _textCell(DateFormatter.formatToDDMMMYYYY(m.dates?.completed)),
          _buildNotesCell(m),
          DataCell(
            m.status != 12 && m.image != null && m.image!.isNotEmpty
                ? InkWell(
                    onTap: () {
                      final url = _getImageUrl(m.image!);
                      showImagePreviewDialog(
                        context: StackedService.navigatorKey!.currentContext!,
                        imageUrl: url,
                      );
                    },
                    child: const Center(
                      child: Icon(
                        Icons.receipt_long,
                        color: Colors.blue,
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
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
                  : FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text("Pending client payment verification",
                          textAlign: TextAlign.center,
                          style: fontFamilySemiBold.size13.red)))),
        ];

      case "promote_pay":
        return [
          _textCell('${index + 1}'),
          _clickableTextCell(m.projectId, () => showNote!(m)),
          _textCell("${m.inf?.name ?? ""} / ${m.inf?.infId ?? ""}"),
          _textCell(m.inf?.phone),
          _textCell(DateFormatter.formatToDDMMMYYYY(m.dates?.completed)),
          _clickableTextCell(m.inf?.upiId, () => onBankDetails(m)),
          _textCell("${m.payment?.amount ?? 0}"),
          _textCell("${m.payment?.commission ?? 0}"),
          _textCell("${m.payment?.gstAmount ?? 0}"),
          _buildNotesCell(m),
          DataCell(
            m.status != 12 && m.image != null && m.image!.isNotEmpty
                ? InkWell(
                    onTap: () {
                      final url = _getImageUrl(m.image!);
                      showImagePreviewDialog(
                        context: StackedService.navigatorKey!.currentContext!,
                        imageUrl: url,
                      );
                    },
                    child: const Center(
                      child: Icon(
                        Icons.receipt_long,
                        color: Colors.blue,
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
          DataCell(Center(
            child: (m.payment!.status == '1')
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
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
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
                              style: fontFamilyRegular.size13.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          )),
        ];

      case "promote_commission":
        return [
          _textCell('${index + 1}'),
          _clickableTextCell(m.projectId, () => showNote!(m)),
          _textCell("${m.inf?.name ?? ""} / ${m.inf?.infId ?? ""}"),
          _textCell(m.inf?.phone),
          _textCell(DateFormatter.formatToDDMMMYYYY(m.dates?.payment)),
          _textCell("${m.payment?.commission ?? 0}"),
          _textCell("${m.payment?.gstAmount ?? 0}"),
          _buildNotesCell(m),
          DataCell(
            m.status != 12 && m.image != null && m.image!.isNotEmpty
                ? InkWell(
                    onTap: () {
                      final url = _getImageUrl(m.image!);
                      showImagePreviewDialog(
                        context: StackedService.navigatorKey!.currentContext!,
                        imageUrl: url,
                      );
                    },
                    child: const Center(
                      child: Icon(
                        Icons.receipt_long,
                        color: Colors.blue,
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
          DataCell(Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Success',
                      style: fontFamilySemiBold.size13.continueButton,
                    ),
                    TextSpan(
                      text:
                          " / ${DateFormatter.formatToDDMMMYYYY(m.dates!.payment.toString()) ?? ""}",
                      style: fontFamilyRegular.size13.black,
                    ),
                  ],
                ),
              ),
            ),
          )),
        ];
      case "client_payment_verified":
        return [
          _textCell('${index + 1}'),
          _clickableTextCell(m.projectId, () => showNote!(m)),
          _textCell("${m.client?.name ?? ""} "),
          _textCell(m.client?.mobileNumber),
          _textCell("${m.payment?.totalAmount ?? 0}"),
          _textCell(
              m.payment?.amount != null ? m.payment!.amount.toString() : ""),
          _textCell("${m.payment?.commission ?? 0}"),
          _textCell("${m.payment?.gstAmount ?? 0}"),
          _buildNotesCell(m),
          DataCell(
            m.status != 12 && m.image != null && m.image!.isNotEmpty
                ? InkWell(
                    onTap: () {
                      final url = _getImageUrl(m.image!);
                      showImagePreviewDialog(
                        context: StackedService.navigatorKey!.currentContext!,
                        imageUrl: url,
                      );
                    },
                    child: const Center(
                      child: Icon(
                        Icons.receipt_long,
                        color: Colors.blue,
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
          DataCell(
            m.status == 12
                ? (PermissionHelper.instance.has('edit_requests')
                    ? InkWell(
                        onTap: () => onClientPaymentVerified(m),
                        child: Center(
                          child: Text(
                            'Check & Verify',
                            style: fontFamilySemiBold.size13.continueButton,
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          'Check & Verify',
                          style: fontFamilySemiBold.size13.greyColor,
                        ),
                      ))
                : Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _getStatusString(m.status),
                        style: _getStatusStyle(m.status),
                      ),
                    ),
                  ),
          ),
        ];

      case "refund":
        return [
          _textCell('${index + 1}'),
          _clickableTextCell(m.projectId, () => showNote!(m)),
          _textCell(m.client?.name),
          _textCell(m.client?.mobileNumber),
          _textCell(m.payment?.totalAmount != null
              ? m.payment!.totalAmount.toString()
              : m.payment?.amount?.toString() ?? ""),
          _textCell(DateFormatter.formatToDDMMMYYYY(m.dates?.refund)),
          _textCell(DateFormatter.formatToDDMMMYYYY(m.dates?.refundUpdated)),
          _textCell(m.refundStatus == 2 ? "Completed" : "Pending"),
          _buildNotesCell(m),
          DataCell(InkWell(
            onTap: () => m.refundStatus == 2 ? null : onRefundDialog(m),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  m.refundStatus == 2 ? "Completed" : "Refund initiated",
                  style: m.refundStatus == 2
                      ? fontFamilyBold.size13.appGreen400
                      : fontFamilySemiBold.size13.continueButton,
                ),
              ),
            ),
          )),
        ];

      default:
        return [];
    }
  }

  String _getStatusString(int? status) {
    switch (status) {
      case 1:
        return 'Request';
      case 2:
        return 'Request Waiting';
      case 3:
        return 'Waiting Accept';
      case 4:
        return 'Completed Pending';
      case 5:
        return 'Rework';
      case 6:
        return 'Completed';
      case 7:
        return 'inf cancelled';
      case 8:
        return 'Admin Rejected';
      case 9:
        return 'Promote-Verified';
      case 10:
        return 'Promote-Pay';
      case 11:
        return 'Promote Commission';
      case 12:
        return 'client payment-verified';
      case 13:
        return 'refunded';
      default:
        return '';
    }
  }

  TextStyle _getStatusStyle(int? status) {
    switch (status) {
      case 5: // Rework
        return fontFamilySemiBold.size13.red;
      case 6: // Completed
      case 9: // Promote-Verified
      case 10: // Promote-Pay
      case 11: // Promote-Commission
        return fontFamilySemiBold.size13.completedColor;
      default:
        return fontFamilySemiBold.size13.pendingColor;
    }
  }

  String _getImageUrl(String path) {
    if (path.startsWith('http')) {
      return path;
    }
    String cleanPath = path;
    if (cleanPath.startsWith('/')) {
      cleanPath = cleanPath.substring(1);
    }
    if (cleanPath.startsWith('storage/')) {
      return "http://172.20.25.23:8001/$cleanPath";
    }
    return "http://172.20.25.23:8001/storage/$cleanPath";
  }

  DataCell _textCell(String? text, {bool center = false}) {
    final widget = SelectableText(
      text ?? "",
      textAlign: center ? TextAlign.center : TextAlign.start,
      style: fontFamilyRegular.size12.black,
    );
    return DataCell(center ? Center(child: widget) : widget);
  }

  DataCell _clickableTextCell(String? text, VoidCallback onTap) {
    return DataCell(InkWell(
      onTap: onTap,
      child: Text(
        text ?? "",
        style: fontFamilyRegular.size12.black,
      ),
    ));
  }

  DataCell _buildNotesCell(request_model.Datum m) {
    return DataCell(
      m.payment?.note != null && m.payment!.note!.isNotEmpty
          ? Tooltip(
              message: m.payment!.note!,
              child: Text(
                m.payment!.note!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )
          : const Text("-"),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.isNotEmpty ? data.length : 0;

  @override
  int get selectedRowCount => 0;
}
