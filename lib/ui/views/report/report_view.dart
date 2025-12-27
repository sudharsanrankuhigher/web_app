import 'package:data_table_2/data_table_2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/report/widgets/info_card.dart';
import 'package:webapp/ui/views/report/widgets/project_widget.dart';
import 'package:webapp/ui/views/report/widgets/sales_project_over_view.dart';
import 'package:webapp/widgets/common_data_table.dart';
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
    final isExtends = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: defaultPadding12 - topPadding12,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: defaultPadding16,
                decoration: const BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  'Requests',
                  style: fontFamilyBold.size26.black,
                ),
              ),
              verticalSpacing12,

              // Report Cards
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ReportCard(
                    title: "Total sales",
                    asset: "assets/images/doller.svg",
                    count: "\$ 284500",
                    graph: "assets/images/arrow-up.svg",
                    currencyColor: const Color(0xff00BE93).withOpacity(0.2),
                    subtitle: "12.5",
                    textColor: Color(0xff00BE93),
                  ),
                  ReportCard(
                    title: "Total Projects",
                    asset: "assets/images/doller.svg",
                    count: "156",
                    graph: "assets/images/arrow-up.svg",
                    currencyColor: const Color(0xff01B8F9).withOpacity(0.2),
                    subtitle: "8.2",
                    textColor: Color(0xff01B8F9),
                  ),
                  ReportCard(
                    title: "Commission Earned",
                    asset: "assets/images/doller.svg",
                    count: "\$ 42675",
                    graph: "assets/images/arrow-up.svg",
                    currencyColor: const Color(0xff008000).withOpacity(0.2),
                    subtitle: "15.3",
                    textColor: Color(0xff008000),
                  ),
                  ReportCard(
                    title: "Influencers Paid",
                    asset: "assets/images/doller.svg",
                    count: "89",
                    graph: "assets/images/arrow-down.svg",
                    currencyColor: const Color(0xffFF0000).withOpacity(0.2),
                    subtitle: "12.5",
                    textColor: Color(0xffFF0000),
                  ),
                ],
              ),
              verticalSpacing12,

              // Row with Project Status + Sales & Projects Overview
              if (isExtend)
                SizedBox(
                  height: 300, // ✅ bounded height fixes RenderFlex errors
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Project Status Widget (fixed width)
                      Flexible(
                        // width: 500,
                        child: ProjectStatusWidget(
                          completed: 156,
                          pending: 10,
                        ),
                      ),

                      horizontalSpacing16,

                      // Sales & Projects Overview (flexible width)
                      Flexible(
                        child: SalesProjectsOverviewWidget(
                          title: 'Sales & Projects Overview',
                          subtitle: 'Weekly breakdown for the current month',
                          barGroups: viewModel.weeklyBarGroups,
                          maxY: 22000,
                        ),
                      ),
                    ],
                  ),
                ),
              if (!isExtend) verticalSpacing12,
              if (!isExtend)
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 220,
                        child: ProjectStatusWidget(
                          completed: 156,
                          pending: 10,
                        ),
                      ),
                      verticalSpacing16,
                      SizedBox(
                        height: 320,
                        child: SalesProjectsOverviewWidget(
                          title: 'Sales & Projects Overview',
                          subtitle: 'Weekly breakdown for the current month',
                          barGroups: viewModel.weeklyBarGroups,
                          maxY: 22000,
                        ),
                      ),
                    ],
                  ),
                ),
              verticalSpacing20,
              Padding(
                padding: leftPadding8,
                child: Text(
                  'Monthly insights',
                  style: fontFamilySemiBold.size14.black,
                ),
              ),
              verticalSpacing12,
              if (isExtends)
                const Row(
                  children: [
                    Expanded(
                      child: InfoSalesProjectCard(
                        title: 'Partner Companies',
                        count: '27',
                        subtitle: 'Partner Companies',
                        iconPath: 'assets/images/partner_companies.svg',
                      ),
                    ),
                    horizontalSpacing20,
                    Expanded(
                      child: InfoSalesProjectCard(
                        title: 'Payment Processed',
                        count: '27',
                        subtitle: 'Partner Companies',
                        iconPath: 'assets/images/payment_processed.svg',
                      ),
                    ),
                    horizontalSpacing20,
                    Expanded(
                      child: InfoSalesProjectCard(
                        title: 'Add Platforms',
                        count: '27',
                        subtitle: 'Partner Companies',
                        iconPath: 'assets/images/add_platform.svg',
                      ),
                    ),
                  ],
                ),
              if (!isExtends)
                const Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    InfoSalesProjectCard(
                      title: 'Partner Companies',
                      count: '27',
                      subtitle: 'Partner Companies',
                      iconPath: 'assets/images/partner_companies.svg',
                    ),
                    horizontalSpacing20,
                    InfoSalesProjectCard(
                      title: 'Payment Processed',
                      count: '27',
                      subtitle: 'Partner Companies',
                      iconPath: 'assets/images/payment_processed.svg',
                    ),
                    horizontalSpacing20,
                    InfoSalesProjectCard(
                      title: 'Add Platforms',
                      count: '27',
                      subtitle: 'Partner Companies',
                      iconPath: 'assets/images/add_platform.svg',
                    ),
                  ],
                ),
              verticalSpacing20,
              Padding(
                padding: leftPadding8,
                child: Text(
                  'Recent Activity',
                  style: fontFamilySemiBold.size14.black,
                ),
              ),
              verticalSpacing12,
              Padding(
                padding: leftPadding8,
                child: Text(
                  'Track your latest project work history',
                  style: fontFamilySemiBold.size12.greyColor,
                ),
              ),
              verticalSpacing16,
              SizedBox(
                height: 400,
                child: viewModel.reports.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : CommonPaginatedTable(
                        headingTextStyle: fontFamilySemiBold.size12.greyColor,
                        heddingRowColor: white,
                        columns: viewModel.reportColumn,
                        source: viewModel.tableSource,
                        rowsperPage: viewModel.tableSource.rowCount < 10
                            ? viewModel.tableSource.rowCount
                            : 10,
                        minWidth: 1000,
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
}
