import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';

class MonthlyBarChart extends StatelessWidget {
  final List<double> ongoing;
  final List<double> completed;

  const MonthlyBarChart({
    super.key,
    required this.ongoing,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    // Convert int → double (safe on web)
    final og = ongoing.map((e) => e.toDouble()).toList();
    final cm = completed.map((e) => e.toDouble()).toList();

    // Get max value
    final maxValue = [...og, ...cm].reduce((a, b) => a > b ? a : b);

    return Expanded(
      child: Container(
        padding: defaultPadding12,
        color: white,
        child: BarChart(
          BarChartData(
            maxY: maxValue == 0 ? 10000 : maxValue + 10000,
            barGroups: List.generate(12, (index) {
              return BarChartGroupData(
                x: index,
                barsSpace: 4,
                barRods: [
                  BarChartRodData(
                    toY: cm[index],
                    color: Colors.green,
                    width: 8,
                  ),
                  BarChartRodData(
                    toY: og[index],
                    color: Colors.blue,
                    width: 8,
                  ),
                ],
              );
            }),

            // Only left and bottom titles
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 20000,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    if (value % 20000 != 0) return const SizedBox.shrink();
                    return Text("${value ~/ 1000}k");
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const months = [
                      "Jan",
                      "Feb",
                      "Mar",
                      "Apr",
                      "May",
                      "Jun",
                      "Jul",
                      "Aug",
                      "Sep",
                      "Oct",
                      "Nov",
                      "Dec"
                    ];
                    if (value < 0 || value > 11) return const SizedBox.shrink();
                    return Text(months[value.toInt()]);
                  },
                ),
              ),
            ),

            borderData: FlBorderData(
              show: true,
              border: const Border(
                left: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey),
                top: BorderSide(color: Colors.transparent),
                right: BorderSide(color: Colors.transparent),
              ),
            ),

            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              drawVerticalLine: false,
              horizontalInterval: 20000,
              getDrawingHorizontalLine: (value) => const FlLine(
                color: Colors.grey,
                strokeWidth: 0.3,
              ),
            ),

            barTouchData: const BarTouchData(enabled: false),
          ),
        ),
      ),
    );
  }
}
