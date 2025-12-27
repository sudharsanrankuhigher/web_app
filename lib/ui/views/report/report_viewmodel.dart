import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/core/navigation/navigation_mixin.dart';
import 'package:webapp/ui/views/report/model/report_model.dart';
import 'package:webapp/ui/views/report/widgets/report_table_source.dart';

class ReportViewModel extends BaseViewModel with NavigationMixin {
  ReportViewModel() {
    loadReport();
  }

  List<ReportModel> reports = [];

  /// 🔹 Table source
  late ReportTableSource tableSource;

  final List<BarChartGroupData> weeklyBarGroups = [
    BarChartGroupData(
      x: 0,
      barRods: [
        BarChartRodData(
            toY: 8000,
            color: const Color(0xff33CBA9),
            width: 12,
            borderRadius: BorderRadius.circular(4)),
        BarChartRodData(
            toY: 12000,
            color: const Color(0xff34C6FA),
            width: 12,
            borderRadius: BorderRadius.circular(4)),
      ],
      barsSpace: 6,
    ),
    BarChartGroupData(
      x: 1,
      barRods: [
        BarChartRodData(
            toY: 14000,
            color: const Color(0xff33CBA9),
            width: 12,
            borderRadius: BorderRadius.circular(4)),
        BarChartRodData(
            toY: 9000,
            color: const Color(0xff34C6FA),
            width: 12,
            borderRadius: BorderRadius.circular(4)),
      ],
      barsSpace: 6,
    ),
    BarChartGroupData(
      x: 2,
      barRods: [
        BarChartRodData(
            toY: 10000,
            color: const Color(0xff33CBA9),
            width: 12,
            borderRadius: BorderRadius.circular(4)),
        BarChartRodData(
            toY: 16000,
            color: const Color(0xff34C6FA),
            width: 12,
            borderRadius: BorderRadius.circular(4)),
      ],
      barsSpace: 6,
    ),
    BarChartGroupData(
      x: 3,
      barRods: [
        BarChartRodData(
            toY: 18000,
            color: const Color(0xff33CBA9),
            width: 12,
            borderRadius: BorderRadius.circular(4)),
        BarChartRodData(
            toY: 13000,
            color: const Color(0xff34C6FA),
            width: 12,
            borderRadius: BorderRadius.circular(4)),
      ],
      barsSpace: 6,
    ),
  ];

  final reportColumn = const [
    DataColumn(label: Text("S.No")),
    DataColumn(label: Text("Influencer")),
    DataColumn(label: Text("Project")),
    DataColumn(label: Text("Client")),
    DataColumn(label: Text("Amount")),
    DataColumn(label: Text("status")),
    DataColumn(label: Text("date")),
  ];

  void loadReport() {
    reports = [
      ReportModel(
          amount: '100',
          client: 'Arul',
          date: '19/12/1996',
          influencer: "Vj siddhu",
          note: 'Good',
          project: "promote",
          status: 'in-progress'),
      ReportModel(
          amount: '1001',
          client: 'Arul mouli',
          date: '09/02/1999',
          influencer: "madhan",
          note: 'Good better',
          project: "promote app",
          status: 'completed'),
      // Add more...
    ];

    tableSource = ReportTableSource(
      data: reports,
      status: "requested",
    );

    notifyListeners();
  }
}
