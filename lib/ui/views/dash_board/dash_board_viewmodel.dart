import 'dart:convert';
import 'dart:js_interop';
import 'package:web/web.dart' as web;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:stacked/stacked.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/services/api_service.dart';
import 'package:webapp/ui/views/dash_board/model/dashboard_model.dart'
    as db_model;
import 'package:webapp/core/navigation/navigation_mixin.dart';

class DashBoardViewModel extends BaseViewModel with NavigationMixin {
  final _apiService = locator<ApiService>();
  db_model.DashboardViewModel? dashboardData;

  bool isMonthly = true;
  String selectedMonth = 'January';
  String selectedYear = '2026';
  String selectedState = 'All';

  List<String> states = ['All'];

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  final List<String> years = ['2024', '2025', '2026', '2027', '2028'];

  DashBoardViewModel() {
    final now = DateTime.now();
    selectedMonth = months[now.month - 1];
    selectedYear = now.year.toString();
    loadStates();
    fetchDashboardData();
  }

  Future<void> loadStates() async {
    try {
      final String data =
          await rootBundle.loadString('assets/json/cities.json');
      final List jsonData = json.decode(data);
      final loadedStates =
          jsonData.map((e) => e['state'] as String).toSet().toList();
      loadedStates.sort();
      states = ['All', ...loadedStates];
      notifyListeners();
    } catch (e) {
      print('Error loading states: $e');
    }
  }

  Future<void> fetchDashboardData() async {
    setBusy(true);
    try {
      int? monthParam;
      if (isMonthly) {
        monthParam = getMonthNumber(selectedMonth);
      }

      final yearParam = int.tryParse(selectedYear);
      final stateParam = selectedState == 'All' ? null : selectedState;

      print("month $monthParam , year $yearParam , state $stateParam");

      dashboardData = await _apiService.getDashboard(
        month: monthParam,
        year: yearParam,
        state: stateParam,
      );
    } catch (e) {
      print('Error fetching dashboard data: $e');
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  int getMonthNumber(String monthName) {
    final map = {
      'January': 1,
      'February': 2,
      'March': 3,
      'April': 4,
      'May': 5,
      'June': 6,
      'July': 7,
      'August': 8,
      'September': 9,
      'October': 10,
      'November': 11,
      'December': 12,
    };
    return map[monthName] ?? DateTime.now().month;
  }

  void setMonthly(bool value) {
    if (isMonthly != value) {
      isMonthly = value;
      notifyListeners();
      fetchDashboardData();
    }
  }

  void setSelectedMonth(String value) {
    if (selectedMonth != value) {
      selectedMonth = value;
      notifyListeners();
      fetchDashboardData();
    }
  }

  void setSelectedYear(String value) {
    if (selectedYear != value) {
      selectedYear = value;
      notifyListeners();
      fetchDashboardData();
    }
  }

  void setSelectedState(String value) {
    if (selectedState != value) {
      selectedState = value;
      notifyListeners();
      fetchDashboardData();
    }
  }

  // --- Scaling Logic for Dynamic Mock Data ---
  double _getScaleFactor() {
    final stateStr = selectedState;
    final periodStr = isMonthly ? '$selectedMonth-$selectedYear' : selectedYear;
    final key = '$stateStr|$periodStr';

    // Simple deterministic hash function
    int hash = 0;
    for (int i = 0; i < key.length; i++) {
      hash = (hash * 31 + key.codeUnitAt(i)) & 0xFFFFFFFF;
    }

    // Scale factor: All Area gets 1.0 base, other states vary between 0.35 and 1.05
    double baseFactor =
        (selectedState == 'All') ? 1.0 : 0.35 + (hash % 70) / 100.0;

    // Monthly values are roughly a fraction of yearly values
    if (isMonthly) {
      baseFactor = baseFactor * 0.12;
    }

    return baseFactor;
  }

  // 1. Client Side
  int get clientCount =>
      dashboardData?.clientSide?.clientCount ??
      (150 * _getScaleFactor() * (isMonthly ? 8 : 1)).round().clamp(5, 5000);
  int get clientProjects =>
      dashboardData?.clientSide?.clientProjects ??
      (350 * _getScaleFactor()).round().clamp(10, 10000);
  double get clientRevenue =>
      dashboardData?.clientSide?.clientRevenue?.toDouble() ??
      450000.0 * _getScaleFactor();

  // 2. Promote Side
  int get companyCount =>
      dashboardData?.promoteSide?.companyCount ??
      (85 * _getScaleFactor() * (isMonthly ? 8 : 1)).round().clamp(3, 3000);
  int get companyProjects =>
      dashboardData?.promoteSide?.companyProjects ??
      (240 * _getScaleFactor()).round().clamp(8, 8000);
  double get companyRevenue =>
      dashboardData?.promoteSide?.companyRevenue?.toDouble() ??
      380000.0 * _getScaleFactor();

  // 3. Influencers Count
  int get tvStarsCount =>
      dashboardData?.influencersCount?.tvStarsCount ??
      (80 * _getScaleFactor() * (isMonthly ? 8 : 1)).round().clamp(2, 2000);
  int get sportStarsCount =>
      dashboardData?.influencersCount?.sportStarsCount ??
      (90 * _getScaleFactor() * (isMonthly ? 8 : 1)).round().clamp(2, 2000);
  int get movieStarsCount =>
      dashboardData?.influencersCount?.movieStarsCount ??
      (150 * _getScaleFactor() * (isMonthly ? 8 : 1)).round().clamp(5, 4000);
  int get regularInfluencersCount =>
      dashboardData?.influencersCount?.regularInfluencersCount ??
      (200 * _getScaleFactor() * (isMonthly ? 8 : 1)).round().clamp(5, 5000);
  int get totalInfluencersCount =>
      dashboardData?.influencersCount?.totalInfluencersCount ??
      (tvStarsCount +
          sportStarsCount +
          movieStarsCount +
          regularInfluencersCount);

  // 4. Projects Count
  int get tvStarsProjects =>
      dashboardData?.projectsCount?.tvStarsProjects ??
      (100 * _getScaleFactor()).round().clamp(2, 3000);
  int get sportStarsProjects =>
      dashboardData?.projectsCount?.sportStarsProjects ??
      (80 * _getScaleFactor()).round().clamp(2, 2000);
  int get movieStarsProjects =>
      dashboardData?.projectsCount?.movieStarsProjects ??
      (120 * _getScaleFactor()).round().clamp(3, 4000);
  int get regularInfluencerProjects =>
      dashboardData?.projectsCount?.regularInfluencerProjects ??
      (290 * _getScaleFactor()).round().clamp(5, 8000);
  int get totalProjectsCount =>
      dashboardData?.projectsCount?.totalProjectsCount ??
      (tvStarsProjects +
          sportStarsProjects +
          movieStarsProjects +
          regularInfluencerProjects);

  // 5. Commissions
  double get clientProjectCommission =>
      dashboardData?.commissions?.clientProjectCommission?.toDouble() ??
      45000.0 * _getScaleFactor();
  double get promoteProjectCommission =>
      dashboardData?.commissions?.promoteProjectCommission?.toDouble() ??
      38000.0 * _getScaleFactor();

  // 6. Package and Banner Revenue
  double get packageRevenue =>
      dashboardData?.packageAndBannerRevenue?.packageRevenue ??
      25000.0 * _getScaleFactor();
  double get bannerRevenue =>
      dashboardData?.packageAndBannerRevenue?.bannerRevenue?.toDouble() ??
      18000.0 * _getScaleFactor();
  int get packageClientCount =>
      dashboardData?.packageAndBannerRevenue?.clientCount ?? 0;
  int get packageInfluencerCount =>
      dashboardData?.packageAndBannerRevenue?.influencerCount ?? 0;
  int get packagePaidCount =>
      (98 * _getScaleFactor() * (isMonthly ? 8 : 1)).round().clamp(2, 3000);

  // 7. Client Projects Status
  int get clientPendingCount =>
      dashboardData?.clientProjectsStatus?.clientPendingCount ??
      (35 * _getScaleFactor()).round().clamp(1, 1000);
  int get clientOngoingCount =>
      dashboardData?.clientProjectsStatus?.clientOngoingCount ??
      (95 * _getScaleFactor()).round().clamp(2, 3000);
  int get clientCompletedCount =>
      dashboardData?.clientProjectsStatus?.clientCompletedCount ??
      (220 * _getScaleFactor()).round().clamp(5, 7000);
  int get clientMonthlyCount =>
      dashboardData?.clientProjectsStatus?.clientMonthlyCount ??
      (25 * _getScaleFactor() * (isMonthly ? 1 : 0.15)).round().clamp(1, 500);

  // 8. Promote Projects Status
  int get promoteInProgressCount =>
      dashboardData?.promoteProjectsStatus?.promoteInProgressCount ??
      (40 * _getScaleFactor()).round().clamp(1, 1500);
  int get promoteCompletedCount =>
      dashboardData?.promoteProjectsStatus?.promoteCompletedCount ??
      (200 * _getScaleFactor()).round().clamp(5, 6000);
  int get promoteMonthlyCount =>
      dashboardData?.promoteProjectsStatus?.promoteMonthlyCount ??
      (18 * _getScaleFactor() * (isMonthly ? 1 : 0.15)).round().clamp(1, 400);

  // --- Monthly Bar Chart Data (Client vs Promote Commissions) ---
  List<double> getMonthlyClientCommissions() {
    if (dashboardData?.chartData?.monthlyClientCommissions != null &&
        dashboardData!.chartData!.monthlyClientCommissions!.isNotEmpty) {
      return dashboardData!.chartData!.monthlyClientCommissions!;
    }
    List<double> list = [];
    for (int m = 1; m <= 12; m++) {
      final stateStr = selectedState;
      final key = '$stateStr|$m-$selectedYear';
      int hash = 0;
      for (int i = 0; i < key.length; i++) {
        hash = (hash * 31 + key.codeUnitAt(i)) & 0xFFFFFFFF;
      }
      double stateFactor =
          (selectedState == 'All') ? 1.0 : 0.35 + (hash % 70) / 100.0;
      double monthFactor = 0.5 + (m % 5) * 0.2;
      list.add(45000.0 * stateFactor * monthFactor * 0.12);
    }
    return list;
  }

  List<double> getMonthlyPromoteCommissions() {
    if (dashboardData?.chartData?.monthlyPromoteCommissions != null &&
        dashboardData!.chartData!.monthlyPromoteCommissions!.isNotEmpty) {
      return dashboardData!.chartData!.monthlyPromoteCommissions!;
    }
    List<double> list = [];
    for (int m = 1; m <= 12; m++) {
      final stateStr = selectedState;
      final key = '$stateStr|$m-$selectedYear-promote';
      int hash = 0;
      for (int i = 0; i < key.length; i++) {
        hash = (hash * 31 + key.codeUnitAt(i)) & 0xFFFFFFFF;
      }
      double stateFactor =
          (selectedState == 'All') ? 1.0 : 0.35 + (hash % 70) / 100.0;
      double monthFactor = 0.4 + (m % 6) * 0.18;
      list.add(38000.0 * stateFactor * monthFactor * 0.12);
    }
    return list;
  }

  Future<void> exportPdfWeb(BuildContext context) async {
    try {
      final pdf = pw.Document();

      final font = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
      final ttf = pw.Font.ttf(font);

      // Format helpers
      String formatCurrency(double amount) {
        if (amount >= 1000000) {
          return 'Rs. ${(amount / 1000000).toStringAsFixed(2)}M';
        } else if (amount >= 1000) {
          return 'Rs. ${(amount / 1000).toStringAsFixed(1)}K';
        } else {
          return 'Rs. ${amount.toStringAsFixed(0)}';
        }
      }

      String formatNumber(int number) {
        if (number >= 1000000) {
          return '${(number / 1000000).toStringAsFixed(2)}M';
        } else if (number >= 1000) {
          return '${(number / 1000).toStringAsFixed(1)}K';
        } else {
          return number.toString();
        }
      }

      final periodStr =
          isMonthly ? '$selectedMonth $selectedYear' : selectedYear;

      pdf.addPage(
        pw.MultiPage(
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "Promote Dashboard Metrics Report",
                    style: pw.TextStyle(
                        font: ttf,
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    DateTime.now().toString().substring(0, 10),
                    style: pw.TextStyle(font: ttf, fontSize: 10),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              "Location: $selectedState",
              style: pw.TextStyle(
                  font: ttf, fontSize: 11, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              "Period: $periodStr",
              style: pw.TextStyle(
                  font: ttf, fontSize: 11, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 15),
            pw.Table.fromTextArray(
              headers: ["Metric Category", "Metric Name", "Value"],
              data: [
                ["Client Side", "No. of Clients", formatNumber(clientCount)],
                [
                  "Client Side",
                  "Client Projects",
                  formatNumber(clientProjects)
                ],
                [
                  "Client Side",
                  "Client Revenue",
                  formatCurrency(clientRevenue)
                ],
                [
                  "Promote Side",
                  "No. of Companies",
                  formatNumber(companyCount)
                ],
                [
                  "Promote Side",
                  "Companies Projects",
                  formatNumber(companyProjects)
                ],
                [
                  "Promote Side",
                  "Company Revenue",
                  formatCurrency(companyRevenue)
                ],
                [
                  "Influencers",
                  "Total Influencers",
                  formatNumber(totalInfluencersCount)
                ],
                ["Influencers", "TV Stars", formatNumber(tvStarsCount)],
                ["Influencers", "Sport Stars", formatNumber(sportStarsCount)],
                ["Influencers", "Movie Stars", formatNumber(movieStarsCount)],
                [
                  "Influencers",
                  "Regular Influencers",
                  formatNumber(regularInfluencersCount)
                ],
                [
                  "Projects",
                  "Total Projects",
                  formatNumber(totalProjectsCount)
                ],
                [
                  "Projects",
                  "Influencer Projects",
                  formatNumber(regularInfluencerProjects)
                ],
                [
                  "Projects",
                  "TV Stars Projects",
                  formatNumber(tvStarsProjects)
                ],
                [
                  "Projects",
                  "Sport Stars Projects",
                  formatNumber(sportStarsProjects)
                ],
                [
                  "Projects",
                  "Movie Stars Projects",
                  formatNumber(movieStarsProjects)
                ],
                [
                  "Commissions",
                  "Client Project Commission",
                  formatCurrency(clientProjectCommission)
                ],
                [
                  "Commissions",
                  "Promote Project Commission",
                  formatCurrency(promoteProjectCommission)
                ],
                [
                  "Advertising",
                  "Package Revenue",
                  formatCurrency(packageRevenue)
                ],
                [
                  "Advertising",
                  "Total Client Count (Package)",
                  formatNumber(packageClientCount)
                ],
                [
                  "Advertising",
                  "Banner Revenue",
                  formatCurrency(bannerRevenue)
                ],
                [
                  "Advertising",
                  "Total Influencer Count (Package)",
                  formatNumber(packageInfluencerCount)
                ],
                [
                  "Client Projects Status",
                  "Pending",
                  formatNumber(clientPendingCount)
                ],
                [
                  "Client Projects Status",
                  "Ongoing",
                  formatNumber(clientOngoingCount)
                ],
                [
                  "Client Projects Status",
                  "Completed",
                  formatNumber(clientCompletedCount)
                ],
                [
                  "Client Projects Status",
                  "Monthly Projects",
                  formatNumber(clientMonthlyCount)
                ],
                [
                  "Promote Projects Status",
                  "In Progress",
                  formatNumber(promoteInProgressCount)
                ],
                [
                  "Promote Projects Status",
                  "Completed",
                  formatNumber(promoteCompletedCount)
                ],
                [
                  "Promote Projects Status",
                  "Monthly Projects",
                  formatNumber(promoteMonthlyCount)
                ],
              ],
              headerStyle: pw.TextStyle(
                  font: ttf, fontWeight: pw.FontWeight.bold, fontSize: 10),
              cellStyle: pw.TextStyle(font: ttf, fontSize: 9),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey300),
              rowDecoration: const pw.BoxDecoration(
                border: pw.Border(
                    bottom:
                        pw.BorderSide(color: PdfColors.grey200, width: 0.5)),
              ),
            ),
            pw.SizedBox(height: 15),
            pw.Align(
              alignment: pw.Alignment.center,
              child: pw.Text(
                "Generated via Web Application - $periodStr Data Report",
                style: pw.TextStyle(
                    font: ttf, fontSize: 8, color: PdfColors.grey600),
              ),
            ),
          ],
        ),
      );

      final bytes = await pdf.save();

      final blob = web.Blob(
          [bytes.toJS].toJS, web.BlobPropertyBag(type: 'application/pdf'));
      final url = web.URL.createObjectURL(blob);

      try {
        web.window.open(url, "_blank");
      } catch (e) {
        print("Popup blocked or window.open failed: $e");
      }

      web.HTMLAnchorElement()
        ..href = url
        ..setAttribute("download",
            "Dashboard_Report_${selectedState}_${periodStr.replaceAll(' ', '_')}.pdf")
        ..click();

      web.URL.revokeObjectURL(url);

      Fluttertoast.showToast(
        msg: "PDF downloaded successfully! 📄",
        timeInSecForIosWeb: 2,
        gravity: ToastGravity.TOP,
        webBgColor: "linear-gradient(to right, #10B981, #10B981)",
        webPosition: "center",
        textColor: Colors.white,
      );
    } catch (e, stack) {
      print("Error exporting PDF: $e");
      print(stack);
      Fluttertoast.showToast(
        msg: "PDF export failed: $e ❌",
        timeInSecForIosWeb: 4,
        gravity: ToastGravity.TOP,
        webBgColor: "linear-gradient(to right, #EF4444, #EF4444)",
        webPosition: "center",
        textColor: Colors.white,
      );
    }
  }
}
