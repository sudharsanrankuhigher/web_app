import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/common_chips.dart';
import 'package:webapp/widgets/common_data_table.dart';
import 'package:webapp/widgets/common_dialog.dart';

import 'requests_viewmodel.dart';

class RequestsView extends StackedView<RequestsViewModel> {
  const RequestsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    RequestsViewModel viewModel,
    Widget? child,
  ) {
    final bool isExtended = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: defaultPadding16,
                      decoration: const BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12)),
                      ),
                      child: Text(
                        'Connection Requests',
                        style: fontFamilyBold.size26.black,
                      ),
                    ),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        /// 0 - Requested
                        CommonStatusChip(
                          text: "Requested",
                          imagePath: "assets/images/requested.svg",
                          textStyle: viewModel.isSelected == 0
                              ? fontFamilySemiBold.size14.white
                              : fontFamilySemiBold.size14.black,
                          bgColor:
                              viewModel.isSelected == 0 ? appGreen400 : white,
                          imageColor:
                              viewModel.isSelected == 0 ? white : appSecond950,
                          onTap: () => viewModel.setSelected(0),
                          margin: defaultPadding10,
                        ),

                        /// 1 - Waiting
                        CommonStatusChip(
                          text: "Waiting",
                          imagePath: "assets/images/pending.svg",
                          textStyle: viewModel.isSelected == 1
                              ? fontFamilySemiBold.size14.white
                              : fontFamilySemiBold.size14.black,
                          bgColor:
                              viewModel.isSelected == 1 ? appGreen400 : white,
                          imageColor:
                              viewModel.isSelected == 1 ? white : appSecond950,
                          onTap: () => viewModel.setSelected(1),
                          margin: defaultPadding10,
                        ),

                        /// 2 - Waiting Accept
                        CommonStatusChip(
                          text: "Waiting Accept",
                          imagePath: "assets/images/accepted.svg",
                          textStyle: viewModel.isSelected == 2
                              ? fontFamilySemiBold.size14.white
                              : fontFamilySemiBold.size14.black,
                          bgColor:
                              viewModel.isSelected == 2 ? appGreen400 : white,
                          imageColor:
                              viewModel.isSelected == 2 ? white : appSecond950,
                          onTap: () => viewModel.setSelected(2),
                          margin: defaultPadding10,
                        ),

                        /// 3 - Completed Pending
                        CommonStatusChip(
                          text: "Completed Pending",
                          imagePath: "assets/images/complete-pending-list.svg",
                          textStyle: viewModel.isSelected == 3
                              ? fontFamilySemiBold.size14.white
                              : fontFamilySemiBold.size14.black,
                          bgColor:
                              viewModel.isSelected == 3 ? appGreen400 : white,
                          imageColor:
                              viewModel.isSelected == 3 ? white : appSecond950,
                          onTap: () => viewModel.setSelected(3),
                          margin: defaultPadding10,
                        ),

                        /// 4 - Completed
                        CommonStatusChip(
                          text: "Completed",
                          imagePath: "assets/images/complete-pending-list.svg",
                          textStyle: viewModel.isSelected == 4
                              ? fontFamilySemiBold.size14.white
                              : fontFamilySemiBold.size14.black,
                          bgColor:
                              viewModel.isSelected == 4 ? appGreen400 : white,
                          imageColor:
                              viewModel.isSelected == 4 ? white : appSecond950,
                          onTap: () => viewModel.setSelected(4),
                          margin: defaultPadding10,
                        ),

                        /// 5 - Influencer Cancelled
                        CommonStatusChip(
                          text: "Influencer Cancelled",
                          imagePath: "assets/images/cancelled.svg",
                          textStyle: viewModel.isSelected == 5
                              ? fontFamilySemiBold.size14.white
                              : fontFamilySemiBold.size14.black,
                          bgColor:
                              viewModel.isSelected == 5 ? appGreen400 : white,
                          imageColor:
                              viewModel.isSelected == 5 ? white : appSecond950,
                          onTap: () => viewModel.setSelected(5),
                          margin: defaultPadding10,
                        ),

                        /// 6 - Rejected
                        CommonStatusChip(
                          text: "Rejected",
                          imagePath: "assets/images/rejected.svg",
                          textStyle: viewModel.isSelected == 6
                              ? fontFamilySemiBold.size14.white
                              : fontFamilySemiBold.size14.black,
                          bgColor:
                              viewModel.isSelected == 6 ? appGreen400 : white,
                          imageColor:
                              viewModel.isSelected == 6 ? white : appSecond950,
                          onTap: () => viewModel.setSelected(6),
                          margin: defaultPadding10,
                        ),

                        /// 7 - Promote Verified
                        CommonStatusChip(
                          text: "Promote Verified",
                          imagePath: "assets/images/verified.svg",
                          textStyle: viewModel.isSelected == 7
                              ? fontFamilySemiBold.size14.white
                              : fontFamilySemiBold.size14.black,
                          bgColor:
                              viewModel.isSelected == 7 ? appGreen400 : white,
                          imageColor:
                              viewModel.isSelected == 7 ? white : appSecond950,
                          onTap: () => viewModel.setSelected(7),
                          margin: defaultPadding10,
                        ),

                        /// 8 - Promote Pay
                        CommonStatusChip(
                          text: "Promote Pay",
                          imagePath: "assets/images/pay.svg",
                          textStyle: viewModel.isSelected == 8
                              ? fontFamilySemiBold.size14.white
                              : fontFamilySemiBold.size14.black,
                          bgColor:
                              viewModel.isSelected == 8 ? appGreen400 : white,
                          imageColor:
                              viewModel.isSelected == 8 ? white : appSecond950,
                          onTap: () => viewModel.setSelected(8),
                          margin: defaultPadding10,
                        ),

                        /// 9 - Promote Commission
                        CommonStatusChip(
                          text: "Promote Commission",
                          imagePath: "assets/images/comission.svg",
                          textStyle: viewModel.isSelected == 9
                              ? fontFamilySemiBold.size14.white
                              : fontFamilySemiBold.size14.black,
                          bgColor:
                              viewModel.isSelected == 9 ? appGreen400 : white,
                          imageColor:
                              viewModel.isSelected == 9 ? white : appSecond950,
                          onTap: () => viewModel.setSelected(9),
                          margin: defaultPadding10,
                        ),
                      ],
                    ),
                    verticalSpacing20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 45.h,
                          width: 500.w,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search service name...",
                              hintStyle: fontFamilyRegular.size12.grey,
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            // onChanged: viewModel.searchServices,
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          child: CommonButton(
                            buttonColor: continueButton,
                            margin: EdgeInsets.zero,
                            padding: defaultPadding4 - leftPadding4,
                            text: isExtended ? "Filter & Sort" : "",
                            borderRadius: 10,
                            textStyle: fontFamilyMedium.size14.white
                                .copyWith(overflow: TextOverflow.ellipsis),
                            icon: ClipRRect(
                              borderRadius: BorderRadius.circular(80),
                              child: Image.asset(
                                height: 34,
                                width: 34,
                                'assets/images/filter.jpg',
                              ),
                            ),
                            onTap: () {
                              CommonFilterDialog.show(
                                context,
                                initialCheckbox: false,
                                initialSort: "A-Z",
                                onApply: (isChecked, sortType) {
                                  // viewModel.applySort(isChecked, sortType);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    verticalSpacing12,
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: double.infinity,
                      child: viewModel.isRequest == true
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: appGreen400,
                              ),
                            )
                          : viewModel.requests.isEmpty
                              ? const Center(child: Text('No data found'))
                              : CommonPaginatedTable(
                                  columns: viewModel.getColumnsByStatus(
                                    viewModel.selectedString.toString(),
                                  ),
                                  source: viewModel.tableSource,
                                  minWidth: 1000,
                                  rowsperPage:
                                      viewModel.tableSource.rowCount > 0
                                          ? (viewModel.tableSource.rowCount < 10
                                              ? viewModel.tableSource.rowCount
                                              : 10)
                                          : 1, // default 1
                                ),
                    ),
                  ]),
            ),
          ),
          if (viewModel.isRequest == true)
            Container(
              color: grey.withOpacity(0.1),
            ),
        ],
      ),
    );
  }

  @override
  RequestsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      RequestsViewModel();
}
