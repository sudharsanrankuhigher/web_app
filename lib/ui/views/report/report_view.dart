import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/core/enum/report_enum.dart';
import 'package:webapp/core/helper/permission_helper.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/home/home_view.dart';
import 'package:webapp/ui/views/report/widgets/widget/info_card.dart';

import 'package:webapp/widgets/common_data_table.dart';
import 'package:webapp/widgets/month_year_picker.dart';
import 'package:webapp/widgets/no_access_widget.dart';
import 'package:webapp/widgets/search_drop_down_widget.dart';

import 'report_viewmodel.dart';

class ReportView extends StackedView<ReportViewModel> {
  const ReportView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ReportViewModel viewModel,
    Widget? child,
  ) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 768;
    final isExtends = MediaQuery.of(context).size.width > 1200;

    final rowCount = viewModel.tableSource?.rowCount ?? 0;

    if (!PermissionHelper.instance.canView('report')) {
      return const Scaffold(body: NoAccessWidget());
    }

    if (viewModel.isBusy || rowCount == 0) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: isMobile
            ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () =>
                    HomeView.scaffoldKey.currentState?.openDrawer(),
              )
            : null,
        title: Text(
          'Reports',
          style: fontFamilyBold.size20
              .copyWith(color: Theme.of(context).colorScheme.onSurface),
        ),
        actions: isMobile
            ? null
            : [
                Padding(
                  padding: defaultPadding12,
                  child: MonthYearPickerField(
                    selectedDate: viewModel.selectedMonth,
                    onChanged: (viewDate) {
                      viewModel.selectedMonth = viewDate;
                      print(viewModel.selectedMonth.toString());
                      viewModel.loadReport(viewModel.selectedMonth);
                      viewModel.notifyListeners();
                      print(viewDate);
                    },
                  ),
                ),
              ],
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: defaultPadding12 - topPadding12,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isMobile) ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: MonthYearPickerField(
                          selectedDate: viewModel.selectedMonth,
                          onChanged: (viewDate) {
                            viewModel.selectedMonth = viewDate;
                            viewModel.loadReport(viewModel.selectedMonth);
                            viewModel.notifyListeners();
                          },
                        ),
                      ),
                    ],
                    verticalSpacing12,
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        /// 🔹 LEFT → Dropdown
                        SizedBox(
                          width: isMobile
                              ? screenWidth * 0.9
                              : MediaQuery.of(context).size.width * 0.4,
                          child: DynamicSingleSearchDropdown(
                            label: 'Select Reports',
                            onChanged: (val) {
                              viewModel.selectedReport(val);
                            },
                            items: viewModel.reportsItem,
                            selectedItem: viewModel.selectedReportType?.title,
                          ),
                        ),

                        /// 🔹 RIGHT → Buttons (only if selected)
                        if (viewModel.selectedReportType != null) ...[
                          Builder(
                            builder: (context) {
                              final isDark = Theme.of(context).brightness ==
                                  Brightness.dark;

                              // Dynamic colors for Preview PDF button
                              final pdfBg = isDark
                                  ? const Color(0x29EF4444)
                                  : redShade; // 16% opacity red in dark mode
                              final pdfFg = isDark
                                  ? const Color(0xFFFCA5A5)
                                  : Colors
                                      .black87; // sleek light red vs dark red/black

                              // Dynamic colors for Excel button
                              final excelBg = isDark
                                  ? const Color(0x2910B981)
                                  : appGreen400; // 16% opacity green in dark mode
                              final excelFg = isDark
                                  ? const Color(0xFFA7F3D0)
                                  : white; // sleek light green vs white

                              return Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  ElevatedButton.icon(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStateProperty.all<Color>(pdfBg),
                                      elevation:
                                          WidgetStateProperty.all<double>(0),
                                      shape: WidgetStateProperty.all<
                                          OutlinedBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                      ),
                                    ),
                                    onPressed: () {
                                      viewModel.exportPdfWeb();
                                    },
                                    icon: Icon(
                                      Icons.picture_as_pdf,
                                      color: pdfFg,
                                    ),
                                    label: Text(
                                      "Preview PDF",
                                      style: fontFamilySemiBold.size13
                                          .copyWith(color: pdfFg),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStateProperty.all<Color>(
                                              excelBg),
                                      elevation:
                                          WidgetStateProperty.all<double>(0),
                                      shape: WidgetStateProperty.all<
                                          OutlinedBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                      ),
                                    ),
                                    onPressed: () {
                                      viewModel.exportCsv();
                                    },
                                    icon: Icon(
                                      Icons.download,
                                      color: excelFg,
                                    ),
                                    label: Text(
                                      "Excel",
                                      style: fontFamilySemiBold.size13
                                          .copyWith(color: excelFg),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                    verticalSpacing12,
                    if (viewModel.selectedReportType?.title ==
                        "Subscription Plans Report") ...{
                      Text(
                        'Subscription Plans Report',
                        style: fontFamilySemiBold.size16.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      verticalSpacing12,
                      SizedBox(
                        height: (viewModel.tableSource!.rowCount * 47) + 50,
                        //  viewModel.tableSource!.rowCount < 10
                        //     ? (viewModel.tableSource!.rowCount * 50) + 50
                        //     : 100,
                        child: CommonPaginatedTable(
                          key: const ValueKey("subscription"), // 🔥 important
                          headingTextStyle: fontFamilySemiBold.size12.greyColor,
                          heddingRowColor: greenShade,
                          columns: viewModel.subscriptionPlans,
                          source: viewModel.tableSource!,
                          rowsperPage: viewModel.tableSource!.rowCount,
                          // viewModel.tableSource!.rowCount < 10
                          //     ? viewModel.tableSource!.rowCount
                          //     : 10,
                          minWidth: 1000,
                          hidePaginator: true,
                        ),
                      ),
                      verticalSpacing20,
                    },
                    if (viewModel.selectedReportType?.title ==
                        "Influencer HighLight Report") ...{
                      Text(
                        'Influencer HighLight Report',
                        style: fontFamilySemiBold.size16.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      verticalSpacing12,
                      SizedBox(
                        height: (viewModel
                                    .influencerHighlightTableSource!.rowCount *
                                47) +
                            50,
                        // viewModel.influencerHighlightTableSource!.rowCount <
                        //         10
                        //     ? (viewModel.influencerHighlightTableSource!
                        //                 .rowCount *
                        //             50) +
                        //         50
                        //     : 100,
                        child: CommonPaginatedTable(
                          key: const ValueKey("highlight"), // 🔥 important

                          headingTextStyle: fontFamilySemiBold.size12.greyColor,
                          heddingRowColor: pendingColorShade,
                          columns: viewModel.infHighlightColumn,
                          source: viewModel.influencerHighlightTableSource!,
                          rowsperPage: viewModel
                              .influencerHighlightTableSource!.rowCount,
                          // viewModel.influencerHighlightTableSource!
                          //             .rowCount <
                          //         10
                          //     ? viewModel
                          //         .influencerHighlightTableSource!.rowCount
                          //     : 10,
                          minWidth: 1000,
                          hidePaginator: true,
                        ),
                      ),
                      verticalSpacing20,
                    },
                    if (viewModel.selectedReportType?.title ==
                        "Influencer Project Report") ...{
                      Text(
                        "Influencer Project Report",
                        style: fontFamilySemiBold.size16.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      verticalSpacing10,
                      SizedBox(
                        height:
                            (viewModel.influencerReportTableSource!.rowCount *
                                    47) +
                                50,
                        // viewModel.influencerReportTableSource!.rowCount < 10
                        //     ? (viewModel.influencerReportTableSource!
                        //                 .rowCount *
                        //             50) +
                        //         50
                        //     : 100,
                        child: CommonPaginatedTable(
                          key: const ValueKey("influencer"),

                          headingTextStyle: fontFamilySemiBold.size12.greyColor,
                          heddingRowColor: activeColorShade,
                          columns: viewModel.influencerProjectReport,
                          source: viewModel.influencerReportTableSource!,
                          rowsperPage:
                              viewModel.influencerReportTableSource!.rowCount,
                          // viewModel
                          //             .influencerReportTableSource!.rowCount <
                          //         10
                          //     ? viewModel.influencerReportTableSource!.rowCount
                          //     : 10,
                          minWidth: 1100,
                          hidePaginator: true,
                        ),
                      ),
                    },
                    if (viewModel.selectedReportType?.title ==
                        "Company Wise Project Report") ...{
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Company Wise Project Report",
                            style: fontFamilySemiBold.size16.copyWith(
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                          verticalSpacing10,
                          SizedBox(
                            height:
                                (viewModel.companyReportTableSource!.rowCount *
                                        47) +
                                    50,
                            // viewModel.companyReportTableSource!.rowCount <
                            //         10
                            //     ? (viewModel.companyReportTableSource!
                            //                 .rowCount *
                            //             50) +
                            //         50
                            //     : 100,
                            child: CommonPaginatedTable(
                              key: const ValueKey("company"),

                              headingTextStyle:
                                  fontFamilySemiBold.size12.greyColor,
                              heddingRowColor: completedColorShade,
                              columns: viewModel.companyProjectReport,
                              source: viewModel.companyReportTableSource!,
                              rowsperPage:
                                  viewModel.companyReportTableSource!.rowCount,
                              //  viewModel
                              //             .companyReportTableSource!.rowCount <
                              //         10
                              //     ? viewModel.companyReportTableSource!.rowCount
                              //     : 10,
                              minWidth: 1100,
                              hidePaginator: true,
                            ),
                          ),
                        ],
                      ),
                      verticalSpacing20,
                    },
                    if (viewModel.selectedReportType?.title ==
                        "Client Project Detailed Report") ...{
                      Text('Client Project Detailed Report',
                          style: fontFamilySemiBold.size16.copyWith(
                              color: Theme.of(context).colorScheme.onSurface)),
                      verticalSpacing12,
                      SizedBox(
                        // height:
                        //  viewModel.clientDetailedTableSource!.rowCount <
                        //         10
                        //     ?
                        height: (viewModel.clientDetailedTableSource!.rowCount *
                                47) +
                            100,
                        // : 600,
                        child: CommonPaginatedTable(
                          key: const ValueKey("client"),

                          headingTextStyle: fontFamilySemiBold.size12.greyColor,
                          heddingRowColor: availableCampaignColor,
                          columns: viewModel.clientProjectDetails,
                          source: viewModel.clientDetailedTableSource!,
                          rowsperPage:
                              // viewModel.clientDetailedTableSource!.rowCount < 10
                              //     ?
                              viewModel.clientDetailedTableSource!.rowCount,
                          // : 10,
                          minWidth: 1100,
                          hidePaginator: true,
                        ),
                      ),
                      verticalSpacing20,
                    },
                    if (viewModel.selectedReportType?.title ==
                        "Promote Projectes Detailed Report") ...{
                      Text('Promote Projectes Detailed Report',
                          style: fontFamilySemiBold.size16.copyWith(
                              color: Theme.of(context).colorScheme.onSurface)),
                      verticalSpacing12,
                      SizedBox(
                        height:
                            (viewModel.companyDetailedTableSource!.rowCount *
                                    47) +
                                50,
                        // viewModel.companyDetailedTableSource!.rowCount <
                        //         10
                        //     ? (viewModel.companyDetailedTableSource!.rowCount *
                        //             50) +
                        //         50
                        //     : 100,
                        child: CommonPaginatedTable(
                          key: const ValueKey("promote"),

                          headingTextStyle: fontFamilySemiBold.size12.greyColor,
                          heddingRowColor:
                              publisButtonColor.withValues(alpha: 0.5),
                          columns: viewModel.promoteProjectDetails,
                          source: viewModel.companyDetailedTableSource!,
                          rowsperPage:
                              viewModel.companyDetailedTableSource!.rowCount,
                          //  viewModel
                          //         .companyDetailedTableSource!.rowCount <
                          //     10
                          // ? viewModel.companyDetailedTableSource!.rowCount
                          // : 10,
                          minWidth: 1100,
                          hidePaginator: true,
                        ),
                      ),
                    },
                    Text('Total Monthly Income Report',
                        style: fontFamilySemiBold.size16.copyWith(
                            color: Theme.of(context).colorScheme.onSurface)),
                    verticalSpacing12,
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isMobile ? 1 : (isExtends ? 4 : 2),
                        childAspectRatio: isMobile ? 3.5 : 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: viewModel.monthlyReport.length,
                      itemBuilder: (context, index) => InfoSalesProjectCard(
                        title:
                            viewModel.monthlyReport[index]['particular'] ?? '',
                        count: viewModel.monthlyReport[index]['totalIncome']
                                .toString() ??
                            '',
                        iconPath: viewModel.icons[index],
                      ),
                    ),
                    verticalSpacing20,
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
    if (PermissionHelper.instance.canView('report')) {
      await viewModel.loadReport(viewModel.selectedMonth);
    }
  }
}
