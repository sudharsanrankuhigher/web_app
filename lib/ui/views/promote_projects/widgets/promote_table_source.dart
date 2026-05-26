import 'package:flutter/material.dart';
import 'package:webapp/core/helper/date_helper.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/promote_projects/model/prmote_table_model.dart'
    as promote_table_model;
import 'package:webapp/ui/views/promote_projects/widgets/promote_status.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/view_link.dart';
import 'package:webapp/core/helper/permission_helper.dart';
import 'package:webapp/services/theme_service.dart';

class PromoteTableSource extends DataTableSource {
  List<promote_table_model.Datum> data;

  void updateData(List<promote_table_model.Datum> newData) {
    data = newData;
    notifyListeners();
  }

  final String status;
  final void Function(promote_table_model.Datum)? onReject;
  final void Function(promote_table_model.Datum)? onVerify;
  final void Function(promote_table_model.Datum)? onGotoPromoteVerified;
  final void Function(promote_table_model.Datum)? onGotoPromotePay;
  final void Function(promote_table_model.Datum)? onGotoPromoteCommission;
  final void Function(promote_table_model.Datum)? showBankDetails;
  final void Function(promote_table_model.Datum)? onReAssign;
  final void Function(promote_table_model.Datum)? onRevoke;
  final void Function(promote_table_model.Datum)? onCompanyPaymentVerified;
  final void Function(promote_table_model.Datum)? onNotesEdit;
  final void Function(promote_table_model.Datum)? onRefund;
  final void Function(promote_table_model.Datum)? refunInit;

  PromoteTableSource({
    required this.data,
    required this.status,
    this.onVerify,
    this.onReject,
    this.onGotoPromoteVerified,
    this.onGotoPromotePay,
    this.onGotoPromoteCommission,
    this.showBankDetails,
    this.onReAssign,
    this.onRevoke,
    this.onCompanyPaymentVerified,
    this.onNotesEdit,
    this.onRefund,
    this.refunInit,
  });

  @override
  DataRow? getRow(int index) {
    // 🔒 HARD SAFETY CHECK
    if (index >= rowCount) return null;

    // ✅ Empty state row
    if (data.isEmpty) {
      return DataRow.byIndex(
        index: index,
        cells: List.generate(
          _columnCountByStatus(status),
          (_) => const DataCell(Text('-')),
        ),
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
      cells: getCellsByStatus(item, status, index),
      onSelectChanged: (value) {},
    );
  }

  List<DataCell> getCellsByStatus(
    promote_table_model.Datum item,
    String status,
    int index,
  ) {
    switch (status) {
      case PromoteStatus.assigned:
        return [
          DataCell(Text('${index + 1}')),
          DataCell(Text(item.subId ?? "")),
          DataCell(Text("${item.influencerName} / ${item.infId}")),
          DataCell(Text(item.influencerPhone.toString() ?? "")),
          DataCell(Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.blue,
                  size: 15,
                ),
                onPressed: () =>
                    onNotesEdit != null ? onNotesEdit!(item) : null,
              ),
              horizontalSpacing4,
              Expanded(
                child: Text(
                  item.note ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )),
          DataCell(Text(item.amount.toString() ?? "")),
          DataCell(Text(DateFormatter.formatToDDMMMYYYY(item.createdAt))),
          DataCell(Center(
            child: Container(
                padding: defaultPadding4 + rightPadding8 + leftPadding8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: continueButton,
                ),
                child: Text(
                  item.status == "1" ? "Assigned" : "Preparing",
                  style: fontFamilyMedium.size11.white,
                )),
          )),
          DataCell(PermissionHelper.instance.has('edit_promotion_projects')
              ? CommonButton(
                  text: 'Reject',
                  onTap: () => onReject?.call(item),
                  buttonColor: red,
                  padding: defaultPadding4 + rightPadding4 + leftPadding4,
                  margin: defaultPadding10 + leftPadding8 + rightPadding8,
                  textStyle: fontFamilyMedium.size12.white,
                )
              : const SizedBox()),
        ];
      case PromoteStatus.infAccepted:
        return [
          DataCell(Text('${index + 1}')),
          DataCell(Text(item.subId ?? "")),
          DataCell(Text("${item.influencerName} / ${item.infId}")),
          DataCell(Text(item.influencerPhone.toString() ?? "")),
          DataCell(Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.blue,
                  size: 15,
                ),
                onPressed: () =>
                    onNotesEdit != null ? onNotesEdit!(item) : null,
              ),
              horizontalSpacing4,
              Expanded(
                child: Text(
                  item.note ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )),
          DataCell(Text(item.amount.toString() ?? "")),
          DataCell(Text(DateFormatter.formatToDDMMMYYYY(item.createdAt))),
          DataCell(Center(
            child: Container(
                padding: defaultPadding4 + rightPadding8 + leftPadding8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: continueButton,
                ),
                child: Text(
                  item.status == "2" ? "Accepted" : "Waiting",
                  style: fontFamilyMedium.size11.white,
                )),
          )),
        ];
      case PromoteStatus.infCompleted:
        return [
          DataCell(Text('${index + 1}')),
          DataCell(Text(item.subId ?? "")),
          DataCell(Text("${item.influencerName} / ${item.infId}")),
          DataCell(Text(item.influencerPhone.toString() ?? "")),
          DataCell(Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.blue,
                  size: 15,
                ),
                onPressed: () =>
                    onNotesEdit != null ? onNotesEdit!(item) : null,
              ),
              horizontalSpacing4,
              Expanded(
                child: Text(
                  item.note ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )),
          DataCell(Text(item.amount.toString() ?? "")),
          DataCell(Text(DateFormatter.formatToDDMMMYYYY(item.createdAt))),
          DataCell(
            Center(
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (item.link?.instagram != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ViewLink(
                        url: item.link!.instagram.toString(),
                        text: "Instagram",
                      ),
                    ),
                  if (item.link?.youtube != null) ...{
                    verticalSpacing4,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ViewLink(
                        url: item.link!.youtube.toString(),
                        text: "YouTube",
                      ),
                    ),
                  },
                  if (item.link?.facebook != null) ...{
                    verticalSpacing4,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ViewLink(
                        url: item.link!.facebook.toString(),
                        text: "Facebook",
                      ),
                    ),
                  },
                ],
              ),
            ),
          ),
          DataCell(Center(
            child: PermissionHelper.instance.has('edit_promotion_projects')
                ? CommonButton(
                    text: item.reworkStatus == 0 ? 'Verify' : 'Rework',
                    onTap: () =>
                        item.reworkStatus == 0 ? onVerify?.call(item) : null,
                    buttonColor: greenShade1,
                    padding: defaultPadding4 + rightPadding4 + leftPadding4,
                    margin: defaultPadding10 + leftPadding8 + rightPadding8,
                    textStyle: fontFamilyMedium.size12.white,
                  )
                : const SizedBox(),
          )),
          DataCell(Center(
            child: PermissionHelper.instance.has('edit_promotion_projects')
                ? CommonButton(
                    text: 'Reject',
                    onTap: () => onReject?.call(item),
                    buttonColor: red,
                    padding: defaultPadding4 + rightPadding4 + leftPadding4,
                    margin: defaultPadding10 + leftPadding8 + rightPadding8,
                    textStyle: fontFamilyMedium.size12.white,
                  )
                : const SizedBox(),
          )),
        ];

      case PromoteStatus.adminVerified:
        return [
          DataCell(Text('${index + 1}')),
          DataCell(Text(item.infId.toString() ?? "")),
          DataCell(Text(item.influencerName ?? "")),
          DataCell(Text(
              DateFormatter.formatToDDMMMYYYY(item.createdAt.toString()) ??
                  "")),
          DataCell(Text(item.subId.toString() ?? "")),
          DataCell(Text(
              DateFormatter.formatToDDMMMYYYY(item.infCompleted.toString()) ??
                  "")),
          DataCell(
            Center(
              child: PermissionHelper.instance.has('edit_promotion_projects')
                  ? Container(
                      margin: defaultPadding4 + leftPadding8 + rightPadding8,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greenShade1,
                          padding:
                              defaultPadding4 + rightPadding4 + leftPadding4,
                        ),
                        onPressed: () => onGotoPromoteVerified?.call(item),
                        child: Text(
                          "Promote Verify",
                          style: fontFamilySemiBold.size12.white,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
          ),
        ];

      case PromoteStatus.promoteVerified:
        return [
          DataCell(Text('${index + 1}')),
          DataCell(Text(item.subId.toString() ?? "")),
          DataCell(Text(item.influencerName ?? "")),
          DataCell(Text(item.influencerId.toString() ?? "")),
          DataCell(Text(item.influencerPhone ?? "")),
          DataCell(
            Center(
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (item.link?.instagram != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ViewLink(
                        url: item.link!.instagram.toString(),
                        text: "Instagram",
                      ),
                    ),
                  if (item.link?.youtube != null) ...{
                    verticalSpacing4,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ViewLink(
                        url: item.link!.youtube.toString(),
                        text: "YouTube",
                      ),
                    ),
                  },
                  if (item.link?.facebook != null) ...{
                    verticalSpacing4,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ViewLink(
                        url: item.link!.facebook.toString(),
                        text: "Facebook",
                      ),
                    ),
                  },
                ],
              ),
            ),
          ),
          DataCell(Text(item.amount.toString())),
          DataCell(Text((item.createdAt != null)
              ? DateFormatter.formatToDDMMMYYYY(item.createdAt.toString())
              : "")),
          DataCell(Text((item.infCompleted != null)
              ? DateFormatter.formatToDDMMMYYYY(item.infCompleted.toString())
              : "")),
          DataCell(
            Center(
              child: PermissionHelper.instance.has('edit_promotion_projects')
                  ? Container(
                      margin: defaultPadding4 + leftPadding8 + rightPadding8,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greenShade1,
                          padding:
                              defaultPadding4 + rightPadding4 + leftPadding4,
                        ),
                        onPressed: () => item.status == "6"
                            ? onGotoPromotePay?.call(item)
                            : null,
                        child: Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            item.status == "6"
                                ? "Promote pay"
                                : "Waiting to payment verified",
                            style: fontFamilySemiBold.size12.white,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
          ),
        ];

      case PromoteStatus.promotePay:
        return [
          DataCell(Text('${index + 1}')),
          DataCell(Text(item.subId.toString() ?? "")),
          DataCell(Text(item.influencerName ?? "")),
          DataCell(Text(item.influencerId.toString() ?? "")),
          DataCell(Text(item.influencerPhone ?? "")),
          DataCell(Text(
              DateFormatter.formatToDDMMMYYYY(item.createdAt.toString()) ??
                  "")),
          DataCell(Text(
              DateFormatter.formatToDDMMMYYYY(item.infCompleted.toString()) ??
                  "")),
          DataCell(InkWell(
              onTap: () => showBankDetails?.call(item),
              child: Text(item.payment!.upi.toString() ?? ""))),
          DataCell(Text(item.amount.toString())),
          DataCell(
            PermissionHelper.instance.has('edit_promotion_projects')
                ? (item.status == 7)
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: pendingColor,
                          padding:
                              defaultPadding4 + rightPadding4 + leftPadding4,
                        ),
                        onPressed: () => onGotoPromoteCommission?.call(item),
                        child: Center(
                            child: Text(
                          "promote Commission",
                          style: fontFamilySemiBold.size12.white,
                          textAlign: TextAlign.center,
                        )),
                      )
                    : const Center(child: Text("Success"))
                : const SizedBox(),
          ),
        ];

      case PromoteStatus.promoteCommission:
        return [
          DataCell(Text('${index + 1}')),
          DataCell(Text(item.subId.toString() ?? "")),
          DataCell(Text(item.influencerName ?? "")),
          DataCell(Text(item.influencerId.toString() ?? "")),
          DataCell(Text(item.influencerPhone ?? "")),
          DataCell(Text(
              DateFormatter.formatToDDMMMYYYY(item.createdAt.toString()) ??
                  "")),
          DataCell(Text(
              DateFormatter.formatToDDMMMYYYY(item.infCompleted.toString()) ??
                  "")),
          DataCell(InkWell(
              onTap: () => showBankDetails?.call(item),
              child: Text(item.payment!.upi.toString() ?? ""))),
          DataCell(Text(item.commisionAmount.toString())),
        ];
      case PromoteStatus.companyPaymentVerified:
        return [
          DataCell(Text('${index + 1}')),
          DataCell(Text(item.subId.toString() ?? "")),
          DataCell(Text(item.influencerName ?? "")),
          DataCell(Text(item.influencerId.toString() ?? "")),
          DataCell(Text(item.influencerPhone ?? "")),
          DataCell(Text(item.createdAt.toString() ?? "")),
          DataCell(Text(item.completedAt.toString() ?? "")),
          DataCell(InkWell(
              onTap: () => showBankDetails?.call(item),
              child: Text(item.payment!.upi.toString() ?? ""))),
          DataCell(Text(item.amount.toString())),
          DataCell(
            PermissionHelper.instance.has('edit_promotion_projects')
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pendingColor,
                      padding: defaultPadding4 + rightPadding4 + leftPadding4,
                    ),
                    onPressed: () => onCompanyPaymentVerified?.call(item),
                    child: Center(
                        child: Text(
                      "Company Payment Verified",
                      style: fontFamilySemiBold.size12.white,
                      textAlign: TextAlign.center,
                    )),
                  )
                : const SizedBox(),
          ),
        ];
      case PromoteStatus.rejected:
        return [
          DataCell(Text('${index + 1}')),
          DataCell(Text(item.subId.toString() ?? "")),
          DataCell(Text(item.influencerName ?? "")),
          DataCell(Text(item.influencerId.toString() ?? "")),
          DataCell(Text(item.influencerPhone ?? "")),
          DataCell(Text(
              DateFormatter.formatToDDMMMYYYY(item.createdAt.toString()) ??
                  "")),
          DataCell(Text(
              DateFormatter.formatToDDMMMYYYY(item.completedAt.toString()) ??
                  "")),
          DataCell(InkWell(
              onTap: () => showBankDetails?.call(item),
              child: Text(item.payment!.upi.toString() ?? ""))),
          DataCell(Text(item.amount.toString())),
          DataCell(PermissionHelper.instance.has('edit_promotion_projects')
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => onRevoke!(item),
                      child: Text(
                        'Revoke',
                        style: fontFamilySemiBold.size11.red,
                      ),
                    ),
                    const Text('&'),
                    InkWell(
                      onTap: () => onReAssign!(item),
                      child: Text(
                        'Re-Assign',
                        style: fontFamilySemiBold.size11.continueButton,
                      ),
                    ),
                  ],
                )
              : const SizedBox()),
          DataCell(
            PermissionHelper.instance.has('edit_promotion_projects')
                ? InkWell(
                    onTap: () => refunInit!(item),
                    child: Text(
                      'Refund',
                      style: fontFamilySemiBold.size11.continueButton,
                    ),
                  )
                : const SizedBox(),
          ),
        ];

      case PromoteStatus.refund:
        return [
          DataCell(Text('${index + 1}')),
          DataCell(Text(item.subId.toString() ?? "")),
          DataCell(Text(item.influencerName ?? "")),
          DataCell(Text(item.infId.toString() ?? "")),
          DataCell(Text(item.amount.toString())),
          DataCell(
              Text(item.refundStatus == 1 ? 'Refund Initiated' : 'Completed')),
          DataCell(Text(DateFormatter.formatToDDMMMYYYY(
                  item.refundInitiatedAt.toString()) ??
              "")),
          DataCell(Text(DateFormatter.formatToDDMMMYYYY(
                  item.refundCompletedAt.toString()) ??
              "")),
          DataCell(
            Center(
              child: PermissionHelper.instance.has('edit_promotion_projects')
                  ? InkWell(
                      onTap: () =>
                          item.refundStatus == 2 ? null : onRefund!(item),
                      child: Text(
                        item.refundStatus == 1
                            ? 'Refund Initiated'
                            : 'Refund completed',
                        style: item.refundStatus == 1
                            ? fontFamilySemiBold.size11.red
                            : fontFamilySemiBold.size11.appGreen400,
                      ),
                    )
                  : const SizedBox(),
            ),
          ),
        ];

      default:
        return const [];
    }
  }

  int _columnCountByStatus(String status) {
    switch (status) {
      case PromoteStatus.assigned:
        return 9;
      case PromoteStatus.infAccepted:
        return 8;
      case PromoteStatus.adminVerified:
        return 7;
      case PromoteStatus.promoteVerified:
        return 10;
      case PromoteStatus.promotePay:
        return 10;
      case PromoteStatus.infCompleted:
        return 10;
      case PromoteStatus.rejected:
        return 11;
      case PromoteStatus.promoteCommission:
        return 9;
      case PromoteStatus.companyPaymentVerified:
        return 10;
      case PromoteStatus.refund:
        return 9;
      default:
        return 0;
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.isEmpty ? 1 : data.length;

  @override
  int get selectedRowCount => 0;
}
