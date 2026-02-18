import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/report/widgets/widget/info_card.dart';
import 'package:webapp/ui/views/report/widgets/widget/project_widget.dart';
import 'package:webapp/ui/views/report/widgets/widget/sales_project_over_view.dart';
import 'package:webapp/widgets/common_count_box.dart';
import 'package:webapp/widgets/common_data_table.dart';
import 'package:webapp/widgets/month_year_picker.dart';
import 'package:webapp/widgets/report_card.dart';

import 'report_viewmodel.dart';

class ReportView extends StackedView<ReportViewModel> {
  const ReportView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ReportViewModel viewModel,
    Widget? child,
  ) {
    final isExtend = MediaQuery.of(context).size.width > 700;
    final isExtends = MediaQuery.of(context).size.width > 1200;

    final rowCount = viewModel.tableSource?.rowCount ?? 0;

    if (rowCount == 0)
      return const Scaffold(
          body: Center(
              child: CircularProgressIndicator())); // loading / empty state

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        title: Text(
          'Reports',
          style: fontFamilyBold.size20.black,
        ),
        actions: [
          Padding(
            padding: defaultPadding12,
            child: MonthYearPickerField(
              selectedDate: viewModel.selectedMonth,
              onChanged: (viewDate) {
                viewModel.selectedMonth = viewDate;
                viewModel.notifyListeners();
                print(viewDate);
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: defaultPadding12 - topPadding12,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpacing12,
              Text(
                'Subscription Plans Report',
                style: fontFamilySemiBold.size16.black,
              ),
              verticalSpacing12,
              SizedBox(
                height: rowCount < 10 ? (rowCount * 50) + 50 : 100,
                child: viewModel.reports.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : CommonPaginatedTable(
                        headingTextStyle: fontFamilySemiBold.size12.greyColor,
                        heddingRowColor: greenShade,
                        columns: viewModel.subscriptionPlans,
                        source: viewModel.tableSource!,
                        rowsperPage: viewModel.tableSource!.rowCount < 10
                            ? viewModel.tableSource!.rowCount
                            : 10,
                        minWidth: 1000,
                        hidePaginator: true,
                      ),
              ),
              verticalSpacing20,
              Text(
                'Influencer HighLight Report',
                style: fontFamilySemiBold.size16.black,
              ),
              verticalSpacing12,
              SizedBox(
                height: rowCount < 10 ? (rowCount * 50) + 50 : 100,
                child: viewModel.reports.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : CommonPaginatedTable(
                        headingTextStyle: fontFamilySemiBold.size12.greyColor,
                        heddingRowColor: pendingColorShade,
                        columns: viewModel.infHighlightColumn,
                        source: viewModel.influencerHighlightTableSource!,
                        rowsperPage: viewModel
                                    .influencerHighlightTableSource!.rowCount <
                                10
                            ? viewModel.influencerHighlightTableSource!.rowCount
                            : 10,
                        minWidth: 1000,
                        hidePaginator: true,
                      ),
              ),
              verticalSpacing20,
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Influencer Project Report",
                        style: fontFamilySemiBold.size16.black,
                      ),
                      verticalSpacing10,
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.48,
                        height: rowCount < 10 ? (rowCount * 50) + 50 : 100,
                        child: viewModel.reports.isEmpty
                            ? const Center(child: CircularProgressIndicator())
                            : CommonPaginatedTable(
                                headingTextStyle:
                                    fontFamilySemiBold.size12.greyColor,
                                heddingRowColor: activeColorShade,
                                columns: viewModel.influencerProjectReport,
                                source: viewModel.influencerReportTableSource!,
                                rowsperPage: viewModel
                                            .influencerReportTableSource!
                                            .rowCount <
                                        10
                                    ? viewModel
                                        .influencerReportTableSource!.rowCount
                                    : 10,
                                minWidth: 500,
                                hidePaginator: true,
                              ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Company Wise Project Report",
                        style: fontFamilySemiBold.size16.black,
                      ),
                      verticalSpacing10,
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.33,
                        height: rowCount < 10 ? (rowCount * 50) + 50 : 100,
                        child: viewModel.reports.isEmpty
                            ? const Center(child: CircularProgressIndicator())
                            : CommonPaginatedTable(
                                headingTextStyle:
                                    fontFamilySemiBold.size12.greyColor,
                                heddingRowColor: completedColorShade,
                                columns: viewModel.companyProjectReport,
                                source: viewModel.companyReportTableSource!,
                                rowsperPage: viewModel.companyReportTableSource!
                                            .rowCount <
                                        10
                                    ? viewModel
                                        .companyReportTableSource!.rowCount
                                    : 10,
                                minWidth: 500,
                                hidePaginator: true,
                              ),
                      ),
                    ],
                  ),
                ],
              ),
              verticalSpacing20,
              Text('Total Monthly Income Report',
                  style: fontFamilySemiBold.size16.black),
              verticalSpacing12,
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isExtends ? 4 : 2,
                  childAspectRatio: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                shrinkWrap: true,
                // physics: const NeverScrollableScrollPhysics(),
                itemCount: viewModel.totalMonthlyIncomeReport.length,
                itemBuilder: (context, index) => InfoSalesProjectCard(
                  title: viewModel.totalMonthlyIncomeReport[index].particular ??
                      '',
                  count: viewModel.totalMonthlyIncomeReport[index].totalIncome
                          .toString() ??
                      '',
                  iconPath: 'assets/images/arrow-down.svg',
                ),
              ),
              verticalSpacing20,
              Text('Client Project Detailed Report',
                  style: fontFamilySemiBold.size16.black),
              verticalSpacing12,
              SizedBox(
                height: rowCount < 10 ? (rowCount * 50) + 100 : 100,
                child: viewModel.reports.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : CommonPaginatedTable(
                        headingTextStyle: fontFamilySemiBold.size12.greyColor,
                        heddingRowColor: availableCampaignColor,
                        columns: viewModel.clientProjectDetails,
                        source: viewModel.clientDetailedTableSource!,
                        rowsperPage:
                            viewModel.clientDetailedTableSource!.rowCount < 10
                                ? viewModel.clientDetailedTableSource!.rowCount
                                : 10,
                        minWidth: 1100,
                        hidePaginator: true,
                      ),
              ),
              verticalSpacing20,
              Text('Promote Projectes Detailed Report',
                  style: fontFamilySemiBold.size16.black),
              verticalSpacing12,
              SizedBox(
                height: rowCount < 10 ? (rowCount * 50) + 50 : 100,
                child: viewModel.reports.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : CommonPaginatedTable(
                        headingTextStyle: fontFamilySemiBold.size12.greyColor,
                        heddingRowColor: publisButtonColor.withOpacity(0.5),
                        columns: viewModel.promoteProjectDetails,
                        source: viewModel.companyDetailedTableSource!,
                        rowsperPage:
                            viewModel.companyDetailedTableSource!.rowCount < 10
                                ? viewModel.companyDetailedTableSource!.rowCount
                                : 10,
                        minWidth: 1100,
                        hidePaginator: true,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  ReportViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ReportViewModel();

  @override
  void onViewModelReady(ReportViewModel viewModel) async {
    await viewModel.loadReport();
  }
}
