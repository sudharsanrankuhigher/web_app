import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/common_chips.dart';
import 'package:webapp/widgets/common_data_table.dart';
import 'package:webapp/widgets/common_dialog.dart';

import 'promote_projects_viewmodel.dart';

class PromoteProjectsView extends StackedView<PromoteProjectsViewModel> {
  const PromoteProjectsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    PromoteProjectsViewModel viewModel,
    Widget? child,
  ) {
    final bool isExtended = MediaQuery.of(context).size.width > 1440;

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: viewModel.isProjectVisible == false
            ? Container(
                padding: defaultPadding20 - topPadding20,
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
                        'Promote Projects',
                        style: fontFamilyBold.size26.black,
                      ),
                    ),
                    verticalSpacing12,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 45.h,
                          width: isExtended
                              ? 450
                              : 130, // search field fixed width (responsive)
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search...",
                              hintStyle: fontFamilyRegular.size14.grey,
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onChanged: viewModel.isProjectVisible == true
                                ? null
                                : (value) => viewModel.searchPlans,
                          ),
                        ),
                        horizontalSpacing10,
                        // Filter Button

                        // Add Plan Button
                        Row(
                          children: [
                            SizedBox(
                              // width: 180,
                              child: CommonButton(
                                padding: defaultPadding12,
                                icon: Icon(Icons.donut_large,
                                    color: viewModel.isInprogress == true
                                        ? white
                                        : Colors.black,
                                    size: 16),
                                buttonColor: viewModel.isInprogress == true
                                    ? appGreen400
                                    : white,
                                textStyle: viewModel.isInprogress == true
                                    ? fontFamilyMedium.size14.white
                                    : fontFamilyMedium.size14.black,
                                margin: EdgeInsets.zero,
                                borderRadius: 10,
                                text: isExtended ? "In-Progress" : "",
                                onTap: () async {
                                  viewModel.isInprogresToggle(true);
                                },
                              ),
                            ),
                            horizontalSpacing8,
                            SizedBox(
                              // width: 180,
                              child: CommonButton(
                                padding: defaultPadding12,
                                icon: Icon(Icons.check,
                                    color: viewModel.isInprogress == false
                                        ? white
                                        : Colors.black,
                                    size: 16),
                                buttonColor: viewModel.isInprogress == false
                                    ? appGreen400
                                    : white,
                                textStyle: viewModel.isInprogress == false
                                    ? fontFamilyMedium.size14.white
                                    : fontFamilyMedium.size14.black,
                                margin: EdgeInsets.zero,
                                borderRadius: 10,
                                text: isExtended ? "Completed" : "",
                                onTap: () async {
                                  viewModel.isInprogresToggle(false);
                                },
                              ),
                            ),
                            horizontalSpacing8,
                            SizedBox(
                              // width: 180,
                              child: CommonButton(
                                padding: defaultPadding12,
                                icon: const Icon(Icons.add,
                                    color: white, size: 16),
                                buttonColor: continueButton,
                                textStyle: fontFamilyMedium.size14.white,
                                margin: EdgeInsets.zero,
                                borderRadius: 10,
                                text: isExtended ? "Add Projects" : "",
                                onTap: () async {
                                  viewModel.createProject(context);
                                },
                              ),
                            ),
                            horizontalSpacing8,
                            SizedBox(
                              // width: 180,
                              child: CommonButton(
                                buttonColor: continueButton,
                                margin: EdgeInsets.zero,
                                padding: defaultPadding4,
                                text: isExtended ? "Filter & Sort" : "",
                                borderRadius: 10,
                                textStyle: fontFamilyMedium.size14.white
                                    .copyWith(overflow: TextOverflow.ellipsis),
                                icon: SizedBox(
                                  height: 35,
                                  width: 35,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(80),
                                    child: Image.asset(
                                      height: 34,
                                      width: 34,
                                      'assets/images/filter.jpg',
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  CommonFilterDialog.show(
                                    context,
                                    initialCheckbox: false,
                                    initialSort: "A-Z",
                                    onApply: (isChecked, sortType) {
                                      viewModel.applySort(isChecked, sortType);
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    verticalSpacing10,
                    Expanded(
                      child: viewModel.isBusy == true ||
                              viewModel.isProjectTableLoading == true
                          ? const Center(child: CircularProgressIndicator())
                          : CommonPaginatedTable(
                              columns: viewModel.isInprogress
                                  ? viewModel.inProgressColumns
                                  : viewModel.completedColumns,
                              source: viewModel.tableSource,
                              rowsperPage: viewModel.tableSource.rowCount == 0
                                  ? 1
                                  : (viewModel.tableSource.rowCount < 10
                                      ? viewModel.tableSource.rowCount
                                      : 10),
                              minWidth: 1000,
                            ),
                    ),
                  ],
                ),
              )
            : Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      padding: defaultPadding12 - topPadding12,
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                        onTap: () => viewModel.backToScreen(),
                                        child:
                                            const Icon(Icons.arrow_back_ios)),
                                    horizontalSpacing10,
                                    Text(
                                      viewModel.projectCode ?? '',
                                      style: fontFamilyBold.size26.black,
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () => viewModel.splitAmount(context),
                                  child: RichText(
                                      text: TextSpan(children: [
                                    WidgetSpan(child: Icon(Icons.splitscreen)),
                                    WidgetSpan(
                                        child: Center(
                                      child: Container(
                                        child: Text(
                                          'Split Amount',
                                          style: fontFamilyMedium.size14.black,
                                        ),
                                      ),
                                    ))
                                  ])),
                                )
                              ],
                            ),
                          ),
                          verticalSpacing12,
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              if (viewModel.isInprogress == true)
                                CommonStatusChip(
                                  text: "Assigned",
                                  imagePath: "assets/images/assigned.svg",
                                  textStyle: viewModel.isChipSelected == 0
                                      ? fontFamilySemiBold.size14.white
                                      : fontFamilySemiBold.size14.black,
                                  bgColor: viewModel.isChipSelected == 0
                                      ? appGreen400
                                      : white,
                                  imageColor: viewModel.isChipSelected == 0
                                      ? white
                                      : Colors.black,
                                  onTap: () {
                                    print("Assigned");
                                    viewModel.setChipSelected(0);
                                  },
                                  margin: defaultPadding10,
                                ),
                              if (viewModel.isInprogress == true)
                                CommonStatusChip(
                                  text: "Influencer Accepted",
                                  imagePath:
                                      "assets/images/complete-pending-list.svg",
                                  textStyle: viewModel.isChipSelected == 1
                                      ? fontFamilySemiBold.size14.white
                                      : fontFamilySemiBold.size14.black,
                                  bgColor: viewModel.isChipSelected == 1
                                      ? appGreen400
                                      : white,
                                  imageColor: viewModel.isChipSelected == 1
                                      ? white
                                      : Colors.black,
                                  onTap: () {
                                    print("Influencer Accept");
                                    viewModel.setChipSelected(1);
                                  },
                                  margin: defaultPadding10,
                                ),
                              if (viewModel.isInprogress == true)
                                CommonStatusChip(
                                  text: "Completed Pending list",
                                  imagePath:
                                      "assets/images/complete-pending-list.svg",
                                  textStyle: viewModel.isChipSelected == 2
                                      ? fontFamilySemiBold.size14.white
                                      : fontFamilySemiBold.size14.black,
                                  bgColor: viewModel.isChipSelected == 2
                                      ? appGreen400
                                      : white,
                                  imageColor: viewModel.isChipSelected == 2
                                      ? white
                                      : null,
                                  onTap: () {
                                    print("Completed Pending list");
                                    viewModel.setChipSelected(2);
                                  },
                                  margin: defaultPadding10,
                                ),
                              // if (viewModel.isInprogress == false)
                              CommonStatusChip(
                                text: "Completed",
                                imagePath:
                                    "assets/images/complete-pending-list.svg",
                                textStyle: viewModel.isChipSelected == 4
                                    ? fontFamilySemiBold.size14.white
                                    : fontFamilySemiBold.size14.black,
                                bgColor: viewModel.isChipSelected == 4
                                    ? appGreen400
                                    : white,
                                imageColor: viewModel.isChipSelected == 4
                                    ? white
                                    : null,
                                onTap: () {
                                  print("Completed");
                                  viewModel.setChipSelected(4);
                                },
                                margin: defaultPadding10,
                              ),
                              CommonStatusChip(
                                text: "Company Payment Verified",
                                imagePath: "assets/images/verified.svg",
                                textStyle: viewModel.isChipSelected == 8
                                    ? fontFamilySemiBold.size14.white
                                    : fontFamilySemiBold.size14.black,
                                bgColor: viewModel.isChipSelected == 8
                                    ? appGreen400
                                    : white,
                                imageColor: viewModel.isChipSelected == 8
                                    ? white
                                    : null,
                                onTap: () {
                                  print("company payment verified");
                                  viewModel.setChipSelected(8);
                                },
                                margin: defaultPadding10,
                              ),
                              CommonStatusChip(
                                text: "Rejected",
                                imagePath: "assets/images/rejected.svg",
                                textStyle: viewModel.isChipSelected == 3
                                    ? fontFamilySemiBold.size14.white
                                    : fontFamilySemiBold.size14.black,
                                bgColor: viewModel.isChipSelected == 3
                                    ? appGreen400
                                    : white,
                                imageColor: viewModel.isChipSelected == 3
                                    ? white
                                    : null,
                                onTap: () {
                                  print("Rejected");
                                  viewModel.setChipSelected(3);
                                },
                                margin: defaultPadding10,
                              ),
                              // if (viewModel.isInprogress == false)
                              CommonStatusChip(
                                text: "Promote Verified",
                                imagePath: "assets/images/verified.svg",
                                textStyle: viewModel.isChipSelected == 5
                                    ? fontFamilySemiBold.size14.white
                                    : fontFamilySemiBold.size14.black,
                                bgColor: viewModel.isChipSelected == 5
                                    ? appGreen400
                                    : white,
                                imageColor: viewModel.isChipSelected == 5
                                    ? white
                                    : null,
                                onTap: () {
                                  print("Completed");
                                  viewModel.setChipSelected(5);
                                },
                                margin: defaultPadding10,
                              ),
                              // if (viewModel.isInprogress == false)
                              CommonStatusChip(
                                text: "Promote Pay",
                                imagePath: "assets/images/pay.svg",
                                textStyle: viewModel.isChipSelected == 6
                                    ? fontFamilySemiBold.size14.white
                                    : fontFamilySemiBold.size14.black,
                                bgColor: viewModel.isChipSelected == 6
                                    ? appGreen400
                                    : white,
                                imageColor: viewModel.isChipSelected == 6
                                    ? white
                                    : null,
                                onTap: () {
                                  print("Completed");
                                  viewModel.setChipSelected(6);
                                },
                                margin: defaultPadding10,
                              ),
                              // if (viewModel.isInprogress == false)
                              CommonStatusChip(
                                text: "Promote Commission",
                                imagePath: "assets/images/comission.svg",
                                textStyle: viewModel.isChipSelected == 7
                                    ? fontFamilySemiBold.size14.white
                                    : fontFamilySemiBold.size14.black,
                                bgColor: viewModel.isChipSelected == 7
                                    ? appGreen400
                                    : white,
                                imageColor: viewModel.isChipSelected == 7
                                    ? white
                                    : null,
                                onTap: () {
                                  print("Completed");
                                  viewModel.setChipSelected(7);
                                },
                                margin: defaultPadding10,
                              ),
                              SizedBox(
                                width: 180,
                                child: CommonButton(
                                  buttonColor: continueButton,
                                  margin: topPadding10,
                                  padding: defaultPadding4 - leftPadding4,
                                  text: isExtended ? "Filter & Sort" : "",
                                  borderRadius: 10,
                                  textStyle: fontFamilyMedium.size14.white
                                      .copyWith(
                                          overflow: TextOverflow.ellipsis),
                                  icon: SizedBox(
                                    height: 35,
                                    width: 35,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(80),
                                      child: Image.asset(
                                        height: 34,
                                        width: 34,
                                        'assets/images/filter.jpg',
                                      ),
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
                            height: MediaQuery.of(context).size.height * 0.75,
                            width: double.infinity,
                            child: (viewModel.isRequest == true ||
                                    viewModel.tableSource == null)
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : CommonPaginatedTable(
                                    columns: viewModel.getColumnsByStatus(
                                        viewModel.promoteTableSource.status),
                                    source: viewModel.promoteTableSource,
                                    minWidth: 1000,
                                    rowsperPage:
                                        viewModel.promoteTableSource.rowCount >
                                                0
                                            ? (viewModel.promoteTableSource
                                                        .rowCount <
                                                    10
                                                ? viewModel
                                                    .promoteTableSource.rowCount
                                                : 10)
                                            : 1,
                                  ),
                          )
                        ],
                      ),
                    ),
                  ),
                  if (viewModel.isRequest == true)
                    Container(
                      color: grey.withOpacity(0.1),
                    ),
                ],
              ));
  }

  @override
  PromoteProjectsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PromoteProjectsViewModel();
}
