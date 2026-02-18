import 'package:flutter/material.dart';
import 'package:webapp/core/helper/date_helper.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/promote_projects/model/prmote_table_model.dart'
    as promote_table_model;
import 'package:webapp/ui/views/promote_projects/widgets/promote_status.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/view_link.dart';

class PromoteTableSource extends DataTableSource {
  final List<promote_table_model.Datum> data;
  final String status;
  final void Function(promote_table_model.Datum)? onReject;
  final void Function(promote_table_model.Datum)? onVerify;
  final void Function(promote_table_model.Datum)? onGotoPromoteVerified;
  final void Function(promote_table_model.Datum)? onGotoPromotePay;
  final void Function(promote_table_model.Datum)? onGotoPromoteCommission;
  final void Function(promote_table_model.Datum)? showBankDetails;
  final void Function(promote_table_model.Datum)? onReAssign;
  final void Function(promote_table_model.Datum)? onRevoke;

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

    return DataRow.byIndex(
      index: index,
      color: WidgetStateProperty.resolveWith<Color?>(
        (states) => index.isEven ? Colors.white : Colors.grey.shade100,
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
          DataCell(Text("${item.influencerName} / ${item.influencerId}")),
          DataCell(Text(item.influencerPhone.toString() ?? "")),
          DataCell(Text(item.note)),
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
          DataCell(CommonButton(
            text: 'Reject',
            onTap: () => onReject?.call(item),
            buttonColor: red,
            padding: defaultPadding4 + rightPadding4 + leftPadding4,
            margin: defaultPadding10 + leftPadding8 + rightPadding8,
            textStyle: fontFamilyMedium.size12.white,
          )),
        ];
      case PromoteStatus.infAccepted:
        return [
          DataCell(Text('${index + 1}')),
          DataCell(Text(item.subId ?? "")),
          DataCell(Text("${item.influencerName} / ${item.influencerId}")),
          DataCell(Text(item.influencerPhone.toString() ?? "")),
          DataCell(Text(item.note)),
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
          DataCell(Text("${item.influencerName} / ${item.influencerId}")),
          DataCell(Text(item.influencerPhone.toString() ?? "")),
          DataCell(Text(item.note)),
          DataCell(Text(item.amount.toString() ?? "")),
          DataCell(Text(DateFormatter.formatToDDMMMYYYY(item.createdAt))),
          DataCell(
            (item.link != null && item.link?.instagram != null)
                ? Center(
                    child: ViewLink(
                      url: item.link!.instagram.toString(),
                      text: "ViewLink",
                    ),
                  )
                : (item.link != null && item.link?.facebook != null)
                    ? Center(
                        child: ViewLink(
                          url: item.link!.facebook.toString(),
                          text: "ViewLink",
                        ),
                      )
                    : (item.link != null && item.link?.youtube != null)
                        ? Center(
                            child: ViewLink(
                              url: item.link!.youtube.toString(),
                              text: "ViewLink",
                            ),
                          )
                        : Center(child: const SizedBox.shrink()),
          ),
          DataCell(CommonButton(
            text: 'Verify',
            onTap: () => onVerify?.call(item),
            buttonColor: greenShade1,
            padding: defaultPadding4 + rightPadding4 + leftPadding4,
            margin: defaultPadding10 + leftPadding8 + rightPadding8,
            textStyle: fontFamilyMedium.size12.white,
          )),
        ];

      case PromoteStatus.adminVerified:
        return [
          DataCell(Text('${index + 1}')),
          DataCell(Text(item.influencerId.toString() ?? "")),
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
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: greenShade1,
                  padding: defaultPadding4 + rightPadding4 + leftPadding4,
                ),
                onPressed: () => onGotoPromoteVerified?.call(item),
                child: Text(
                  "Promote Verify",
                  style: fontFamilySemiBold.size12.white,
                ),
              ),
            ),
          ),
        ];

      case PromoteStatus.promoteVerified:
        return [
          DataCell(Text('${index + 1}')),
          DataCell(Text(item.subId.toString() ?? "")),
          DataCell(Text("${item.influencerName ?? ""}")),
          DataCell(Text(item.influencerId.toString() ?? "")),
          DataCell(Text(item.influencerPhone ?? "")),
          DataCell(
            (item.link != null && item.link?.instagram != null)
                ? ViewLink(
                    url: item.link!.instagram.toString(),
                    text: "ViewLink",
                  )
                : (item.link != null && item.link?.facebook != null)
                    ? ViewLink(
                        url: item.link!.facebook.toString(),
                        text: "ViewLink",
                      )
                    : (item.link != null && item.link?.youtube != null)
                        ? ViewLink(
                            url: item.link!.youtube.toString(),
                            text: "ViewLink",
                          )
                        : const SizedBox.shrink(),
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
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: greenShade1,
                  padding: defaultPadding4 + rightPadding4 + leftPadding4,
                ),
                onPressed: () => onGotoPromotePay?.call(item),
                child: Text(
                  "Promote pay",
                  style: fontFamilySemiBold.size12.white,
                ),
              ),
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
          DataCell(Text(item.createdAt.toString() ?? "")),
          DataCell(Text(item.completedAt.toString() ?? "")),
          DataCell(InkWell(
              onTap: () => showBankDetails?.call(item),
              child: Text(item.payment!.upi.toString() ?? ""))),
          DataCell(Text(item.amount.toString())),
          DataCell(
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: pendingColor,
                padding: defaultPadding4 + rightPadding4 + leftPadding4,
              ),
              onPressed: () => onGotoPromoteCommission?.call(item),
              child: Center(
                  child: Text(
                "promote Commission",
                style: fontFamilySemiBold.size12.white,
                textAlign: TextAlign.center,
              )),
            ),
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
          DataCell(Row(
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
              Text('&'),
              InkWell(
                onTap: () => onReAssign!(item),
                child: Text(
                  'Re-Assign',
                  style: fontFamilySemiBold.size11.continueButton,
                ),
              ),
            ],
          )),
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
        return 9;
      case PromoteStatus.rejected:
        return 10;
      case PromoteStatus.promoteCommission:
        return 9;
      case PromoteStatus.companyPaymentVerified:
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
