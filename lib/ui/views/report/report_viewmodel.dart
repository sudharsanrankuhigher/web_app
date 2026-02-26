import 'dart:convert';
import 'dart:ui';

// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/core/navigation/navigation_mixin.dart';
import 'package:webapp/services/api_service.dart';
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
  List<InfBanner> infHighLigtReprot = [];
  List<CompanyProject> companyReport = [];
  List<InfProject> influencerReport = [];
  MonthlyIncome? totalMonthlyIncomeReport;
  List<Datum> clientProjectDetailedList = [];
  Total? clientProjectTotal;
  List<PromoteProject>? promoteProjectes;

  /// 🔹 Table source
  ReportTableSource? tableSource;
  InfluencerHighlightTableSource? influencerHighlightTableSource;
  CompanyReportTableSource? companyReportTableSource;
  InfluencerReportTableSource? influencerReportTableSource;
  ClientDetailedTableSource? clientDetailedTableSource;
  CompanyDetailedTableSource? companyDetailedTableSource;

  DateTime selectedMonth = DateTime.now();

  List<Map<String, dynamic>> get monthlyReport {
    if (totalMonthlyIncomeReport == null) return [];

    return [
      {
        "sno": 1,
        "particular": "Subscription Plan",
        "totalIncome": totalMonthlyIncomeReport?.subscription?.toString() ?? "0"
      },
      {
        "sno": 2,
        "particular": "Influencers Profile Highlight",
        "totalIncome": totalMonthlyIncomeReport?.bannerAmount?.toString() ?? "0"
      },
      {
        "sno": 3,
        "particular": "Client Project Commission",
        "totalIncome":
            totalMonthlyIncomeReport?.clientProjectCommission?.toString() ?? "0"
      },
      {
        "sno": 4,
        "particular": "Promote Project Commission",
        "totalIncome":
            totalMonthlyIncomeReport?.promoteProjectCommission?.toString() ??
                "0"
      }
    ];
  }

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
    // DataColumn(label: Text("inf Id/ inf name")),
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
    // DataColumn(label: Text("Package name")),
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

  ReportModel? reportModel;

  final _dialogService = locator<DialogService>();
  final _apiService = locator<ApiService>();

  Future<void> loadReport(requestDate) async {
    String formattedMonth =
        "${requestDate.month.toString().padLeft(2, '0')}-${requestDate.year}";
    final request = {"month": formattedMonth};
    // final String jsonString =
    //     await rootBundle.loadString('assets/json/data.json');

    // final reportModel = reportModelFromJson(jsonString);

    final reportModel =
        await runBusyFuture(_apiService.getReport(request).catchError((e) {
      print(e);
      return null;
    }));

    reports = reportModel.subscriptionPlan ?? [];
    infHighLigtReprot = reportModel.infBanner ?? [];
    companyReport = reportModel.companyProject ?? [];
    influencerReport = reportModel.infProject ?? [];
    totalMonthlyIncomeReport = reportModel.monthlyIncome!;
    clientProjectDetailedList = reportModel.clientProjectDetails!.data ?? [];
    clientProjectTotal = reportModel.clientProjectDetails!.total;
    promoteProjectes = reportModel.promoteProject;

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
