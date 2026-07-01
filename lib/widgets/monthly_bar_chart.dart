import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';

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

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Premium, non-generic bar colors harmonized for light & dark mode
    final completedColor = isDark ? const Color(0xFF34D399) : appGreen500;
    final ongoingColor = isDark ? const Color(0xFF60A5FA) : continueButton;

    // Subtly styled axis text and line borders
    final axisTitleStyle = fontFamilyMedium.size10.copyWith(
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
    );
    final gridLineColor =
        isDark ? Colors.grey.withOpacity(0.2) : Colors.grey.withOpacity(0.4);

    return Expanded(
      child: Container(
        padding: defaultPadding12,
        color: Colors
            .transparent, // Seamlessly blend with the parent themed container
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
                    color: completedColor,
                    width: 8,
                  ),
                  BarChartRodData(
                    toY: og[index],
                    color: ongoingColor,
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
                    return Text(
                      "${value ~/ 1000}k",
                      style: axisTitleStyle,
                    );
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
                    return Text(
                      months[value.toInt()],
                      style: axisTitleStyle,
                    );
                  },
                ),
              ),
            ),

            borderData: FlBorderData(
              show: true,
              border: Border(
                left: BorderSide(color: gridLineColor),
                bottom: BorderSide(color: gridLineColor),
                top: const BorderSide(color: Colors.transparent),
                right: const BorderSide(color: Colors.transparent),
              ),
            ),

            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              drawVerticalLine: false,
              horizontalInterval: 20000,
              getDrawingHorizontalLine: (value) => FlLine(
                color: gridLineColor,
                strokeWidth: 0.3,
              ),
            ),

            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (group) {
                  return isDark ? const Color(0xFF1E293B) : Colors.white;
                },
                tooltipBorder: BorderSide(
                  color:
                      isDark ? const Color(0xFF334155) : Colors.grey.shade300,
                  width: 1,
                ),
                tooltipPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final isClient = rodIndex == 0;
                  final title = isClient ? 'Client Comm.' : 'Promote Comm.';
                  final value = rod.toY;

                  String formatCurrency(double amount) {
                    if (amount >= 1000000) {
                      return '₹${(amount / 1000000).toStringAsFixed(2)}M';
                    } else if (amount >= 1000) {
                      return '₹${(amount / 1000).toStringAsFixed(1)}K';
                    } else {
                      return '₹${amount.toStringAsFixed(0)}';
                    }
                  }

                  return BarTooltipItem(
                    '$title\n',
                    fontFamilyRegular.size10.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
                    children: [
                      TextSpan(
                        text: formatCurrency(value),
                        style: fontFamilyBold.size14.copyWith(
                          color: rod.color,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
