import 'dart:convert';
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/core/navigation/navigation_mixin.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/views/report/model/report_model.dart';
import 'package:webapp/ui/views/report/widgets/table_source/client_detailed_table_source.dart';
import 'package:webapp/ui/views/report/widgets/table_source/company_detailed_table_source.dart';
import 'package:webapp/ui/views/report/widgets/table_source/company_table_source.dart';
import 'package:webapp/ui/views/report/widgets/table_source/inf_highlight_table_source.dart';
import 'package:webapp/ui/views/report/widgets/table_source/inf_report_table_source.dart';
import 'package:webapp/ui/views/report/widgets/table_source/subscription_report_table_source.dart';

class ReportViewModel extends BaseViewModel with NavigationMixin {
  // ReportViewModel() {
  //   loadReport();
  // }

  List<SubscriptionPlan> reports = [];
  List<InfluencerProfileHighlight> infHighLigtReprot = [];
  List<CompanyWiseProjectCountReport> companyReport = [];
  List<InfluencersProjectCount> influencerReport = [];
  List<TotalMonthlyIncomeReport> totalMonthlyIncomeReport = [];
  List<Datum> clientProjectDetailedList = [];
  Total? clientProjectTotal;
  List<PromoteProjecte>? promoteProjectes;

  /// 🔹 Table source
  ReportTableSource? tableSource;
  InfluencerHighlightTableSource? influencerHighlightTableSource;
  CompanyReportTableSource? companyReportTableSource;
  InfluencerReportTableSource? influencerReportTableSource;
  ClientDetailedTableSource? clientDetailedTableSource;
  CompanyDetailedTableSource? companyDetailedTableSource;

  DateTime selectedMonth = DateTime.now();

  @override
  Future<void> initialise() async {
    await loadReport();
  }

  final List<BarChartGroupData> weeklyBarGroups = [
    BarChartGroupData(
      x: 0,
      barRods: [
        BarChartRodData(
            toY: 80,
            color: const Color(0xff33CBA9),
            width: 12,
            borderRadius: BorderRadius.circular(4)),
        BarChartRodData(
            toY: 12,
            color: pendingColor,
            width: 12,
            borderRadius: BorderRadius.circular(4)),
      ],
      barsSpace: 6,
    ),
    BarChartGroupData(
      x: 1,
      barRods: [
        BarChartRodData(
            toY: 14,
            color: const Color(0xff33CBA9),
            width: 12,
            borderRadius: BorderRadius.circular(4)),
        BarChartRodData(
            toY: 9,
            color: pendingColor,
            width: 12,
            borderRadius: BorderRadius.circular(4)),
      ],
      barsSpace: 6,
    ),
    BarChartGroupData(
      x: 2,
      barRods: [
        BarChartRodData(
            toY: 10,
            color: const Color(0xff33CBA9),
            width: 12,
            borderRadius: BorderRadius.circular(4)),
        BarChartRodData(
            toY: 16,
            color: pendingColor,
            width: 12,
            borderRadius: BorderRadius.circular(4)),
      ],
      barsSpace: 6,
    ),
    BarChartGroupData(
      showingTooltipIndicators: [18, 13],
      x: 3,
      barRods: [
        BarChartRodData(
            toY: 18,
            color: const Color(0xff33CBA9),
            width: 12,
            borderRadius: BorderRadius.circular(4)),
        BarChartRodData(
            toY: 13,
            color: pendingColor,
            width: 12,
            borderRadius: BorderRadius.circular(4)),
      ],
      barsSpace: 6,
    ),
  ];

  final clientProjectDetails = const [
    DataColumn(label: Text("S.No")),
    DataColumn(label: Text("CP id")),
    DataColumn(label: Text("client name")),
    DataColumn(label: Text("client mobile no")),
    DataColumn(label: Text("inf Id/ inf name")),
    DataColumn(label: Text("client payment")),
    DataColumn(label: Text("client commission")),
    DataColumn(label: Text("influencer paid")),
  ];
  final promoteProjectDetails = const [
    DataColumn(label: Text("S.No")),
    DataColumn(label: Text("PP id")),
    DataColumn(label: Text("Company name")),
    DataColumn(label: Text("Company mobile no")),
    DataColumn(label: Text("inf Id/ inf name")),
    DataColumn(label: Text("Company payment")),
    DataColumn(label: Text("Company commission")),
    DataColumn(label: Text("influencer paid")),
  ];

  final subscriptionPlans = const [
    DataColumn(label: Text("S.No")),
    DataColumn(label: Text("Client Name")),
    DataColumn(label: Text("Client mobile no")),
    DataColumn(label: Text("Package name")),
    DataColumn(label: Text("payment status")),
    DataColumn(label: Text("Amount")),
    DataColumn(label: Text("Date")),
  ];
  final infHighlightColumn = const [
    DataColumn(label: Text("S.No")),
    DataColumn(label: Text("Influencer Name")),
    DataColumn(label: Text("Inf mobile no")),
    DataColumn(label: Text("Package name")),
    DataColumn(label: Text("payment status")),
    DataColumn(label: Text("Amount")),
    DataColumn(label: Text("Date")),
  ];
  final companyProjectReport = const [
    DataColumn(label: Text("S.No")),
    DataColumn(label: Text("Company Name")),
    DataColumn(label: Text("Project Count")),
  ];
  final influencerProjectReport = const [
    DataColumn(label: Text("S.No")),
    DataColumn(label: Text("Influencer Name")),
    DataColumn(label: Text("Promote projects")),
    DataColumn(label: Text("Client projects")),
    DataColumn(label: Text("total projects")),
  ];

  Future<void> loadReport() async {
    final String jsonString =
        await rootBundle.loadString('assets/json/data.json');

    final reportModel = reportModelFromJson(jsonString);

    reports = reportModel.subscriptionPlan ?? [];
    infHighLigtReprot = reportModel.influencersProfileHighlight ?? [];
    companyReport = reportModel.companyWiseProjectCountReport ?? [];
    influencerReport = reportModel.influencersProjectCount ?? [];
    totalMonthlyIncomeReport = reportModel.totalMonthlyIncomeReport ?? [];
    clientProjectDetailedList =
        reportModel.clientProjectDetailedReport?.data ?? [];
    clientProjectTotal = reportModel.clientProjectDetailedReport?.total;
    promoteProjectes = reportModel.promoteProjectes;

    tableSource = ReportTableSource(
      data: reports,
      status: "requested",
    );

    influencerHighlightTableSource = InfluencerHighlightTableSource(
      data: infHighLigtReprot,
      status: "requested",
    );

    companyReportTableSource = CompanyReportTableSource(
      data: companyReport,
      status: "requested",
    );

    influencerReportTableSource = InfluencerReportTableSource(
      data: influencerReport,
      status: "requested",
    );

    clientDetailedTableSource = ClientDetailedTableSource(
      data: clientProjectDetailedList,
      total: clientProjectTotal,
      status: "requested",
    );

    companyDetailedTableSource = CompanyDetailedTableSource(
      data: promoteProjectes ?? [],
      status: "requested",
    );

    notifyListeners();
  }
}
