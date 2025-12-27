import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SalesProjectsOverviewWidget extends StatelessWidget {
  /// Title & Subtitle
  final String title;
  final String subtitle;

  /// Bar chart data
  final List<BarChartGroupData> barGroups;

  /// Maximum Y value for the chart
  final double maxY;

  const SalesProjectsOverviewWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.barGroups,
    this.maxY = 22000, // default max Y
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 4),

          /// Subtitle
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 16),

          /// Bar Chart
          Expanded(
            child: BarChart(
              BarChartData(
                maxY: maxY,
                barTouchData: BarTouchData(enabled: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 4,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.shade300,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: maxY / 4,
                      getTitlesWidget: (value, meta) => Text(
                        value == 0 ? '0' : '${(value / 1000).toInt()}k',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final weeks = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            weeks[value.toInt()],
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: barGroups,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
