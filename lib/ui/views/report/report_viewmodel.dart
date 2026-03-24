// import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/core/enum/report_enum.dart';
import 'package:webapp/core/helper/date_helper.dart';
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
import 'dart:html' as html; // 🔥 required for web download

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

  List<String> get reportsItem =>
      ReportType.values.map((e) => e.title).toList();

  ReportType? _selectedReportType = ReportType.subscription;
  ReportType? get selectedReportType => _selectedReportType;

  void selectedReport(String? value) {
    _selectedReportType = ReportType.values.firstWhere(
      (e) => e.title == value,
      orElse: () => ReportType.subscription,
    );
    print(value);
    print(_selectedReportType);

    notifyListeners();
  }

  List<String> icons = [
    'assets/images/subscription_plan.svg',
    'assets/images/influencer_banner.svg',
    'assets/images/client_project_commission.svg',
    'assets/images/promote_project_commission.svg'
  ];

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

  // pdf and xl
  List<String> getHeaders(List<DataColumn> columns) {
    return columns.map((col) {
      final textWidget = col.label as Text;
      return textWidget.data ?? "";
    }).toList();
  }

  List<DataColumn> getSelectedColumns() {
    switch (_selectedReportType) {
      case ReportType.subscription:
        return subscriptionPlans;

      case ReportType.clientDetailed:
        return clientProjectDetails;

      case ReportType.promoteDetailed:
        return promoteProjectDetails;

      case ReportType.influencerHighlight:
        return infHighlightColumn;

      case ReportType.companyReport:
        return companyProjectReport;

      case ReportType.influencerReport:
        return influencerProjectReport;

      default:
        return [];
    }
  }

  List<List<dynamic>> getSelectedRows() {
    switch (_selectedReportType) {
      case ReportType.subscription:
        return reports.asMap().entries.map((e) {
          final i = e.key;
          final item = e.value;
          return [
            i + 1,
            item.clientName ?? "-",
            item.clientMobileNumber ?? "-",
            item.packageName ?? "-",
            item.packageStatus ?? "-",
            item.amount ?? 0,
            item.paymentDate != null
                ? DateFormatter.formatToDDMMMYYYY(item.paymentDate)
                : "-"
          ];
        }).toList();

      case ReportType.clientDetailed:
        return clientProjectDetailedList.asMap().entries.map((e) {
          final i = e.key;
          final item = e.value;

          return [
            i + 1,
            item.id ?? "-",
            item.clientName ?? "-",
            item.clientPhone ?? "-",
            (_safeText("${item.infId ?? ''} / ${item.infName ?? ''}")),
            _toDouble(item.clientPayment),
            _toDouble(item.clientCommission),
            _toDouble(item.infPayment),
          ];
        }).toList();

      case ReportType.promoteDetailed:
        return promoteProjectes!.asMap().entries.map((e) {
          final i = e.key;
          final item = e.value;
          return [
            i + 1,
            item.id ?? "-",
            item.companyName ?? "-",
            item.companyMobile ?? "-",
            item.companyPayment ?? 0,
            item.companyCommission ?? 0,
            item.infPayment ?? 0,
          ];
        }).toList();

      case ReportType.influencerHighlight:
        return infHighLigtReprot.asMap().entries.map((e) {
          final i = e.key;
          final item = e.value;
          return [
            i + 1,
            item.name ?? "-",
            item.phone ?? "-",
            item.paymentStatus ?? "-",
            item.amount ?? 0,
            item.createdAt != null
                ? DateFormatter.formatToDDMMMYYYY(item.createdAt)
                : "-"
          ];
        }).toList();

      case ReportType.companyReport:
        return companyReport.asMap().entries.map((e) {
          final i = e.key;
          final item = e.value;
          return [
            i + 1,
            item.companyName ?? "-",
            item.companyCount ?? 0,
          ];
        }).toList();

      case ReportType.influencerReport:
        return influencerReport.asMap().entries.map((e) {
          final i = e.key;
          final item = e.value;
          return [
            i + 1,
            item.infName ?? "-",
            item.promoteProjectCount ?? 0,
            item.clientProjectCount ?? 0,
            item.totalProjectCount ?? 0,
          ];
        }).toList();

      default:
        return [];
    }
  }

  String _safeText(String value, {int max = 20}) {
    if (value.length <= max) return value;
    return value.substring(0, max);
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  List<CellValue?> toCellValues(List<dynamic> row) {
    return row.map((e) {
      if (e == null) return TextCellValue("");

      if (e is int) return IntCellValue(e);
      if (e is double) return DoubleCellValue(e);

      return TextCellValue(e.toString());
    }).toList();
  }

  void exportCsv() {
    final headers = getHeaders(getSelectedColumns());
    final rows = getSelectedRows();

    if (rows.isEmpty) {
      Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          textColor: white,
          msg: "export Data Empty ❌");
      print("No data to export");
      return;
    }

    /// 🔥 Convert to CSV string
    String csv = '';

    // Header
    csv += headers.join(",") + "\n";

    // Rows
    for (var row in rows) {
      csv += row.map((e) => '"${e ?? ""}"').join(",") + "\n";
    }

    final bytes = utf8.encode(csv);

    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: url)
      ..setAttribute("download", "${_selectedReportType?.title}.csv")
      ..click();

    html.Url.revokeObjectUrl(url);
  }

  Future<void> exportPdfWeb() async {
    final pdf = pw.Document();

    final font = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final ttf = pw.Font.ttf(font);

    final headers = getHeaders(getSelectedColumns());
    final data = getSelectedRows();

    if (data.isEmpty) {
      // Fluttertoast.showToast(msg: "PDF Data Empty ❌");
      Fluttertoast.showToast(
          timeInSecForIosWeb: 2,
          gravity: ToastGravity.TOP,
          webBgColor: "linear-gradient(to right, #000000, #000000)",
          webPosition: "center",
          webShowClose: true,
          textColor: white,
          msg: "PDF Data Empty ❌");
      print("PDF Data Empty ❌");
      return;
    }

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              _selectedReportType?.title ?? "",
              style: pw.TextStyle(font: ttf, fontSize: 18),
            ),
            pw.SizedBox(height: 10),
            pw.Expanded(
              child: pw.Table.fromTextArray(
                headers: headers,
                data: data.map((row) {
                  return row.map((e) => e?.toString() ?? "").toList();
                }).toList(),
                headerStyle: pw.TextStyle(font: ttf),
                cellStyle: pw.TextStyle(font: ttf),
              ),
            ),
          ],
        ),
      ),
    );

    final bytes = await pdf.save();

    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.window.open(url, "_blank");

    html.AnchorElement(href: url)
      ..setAttribute("download", "${_selectedReportType?.title}.pdf")
      ..click();

    html.Url.revokeObjectUrl(url);
  }
}
