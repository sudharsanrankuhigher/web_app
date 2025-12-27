import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';

class PieChartWidget extends StatelessWidget {
  final int completed;
  final int pending;

  const PieChartWidget({
    super.key,
    required this.completed,
    required this.pending,
  });

  @override
  Widget build(BuildContext context) {
    final total = completed + pending;

    return Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          PieChartData(
            centerSpaceRadius: 35,
            sectionsSpace: 2,
            startDegreeOffset: -90,
            sections: [
              PieChartSectionData(
                value: completed.toDouble(),
                color: const Color(0xff00BE93),
                radius: 22,
                title: '',
                // total == 0
                //     ? ''
                //     : '${((completed / total) * 100).toStringAsFixed(0)}%',
                titleStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              PieChartSectionData(
                value: pending.toDouble(),
                color: pendingColor,
                radius: 22,
                showTitle: false,
                // title: total == 0
                //     ? ''
                //     : '${((pending / total) * 100).toStringAsFixed(0)}%',
              ),
            ],
          ),
        ),

        /// 🔥 CENTER TEXT
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${((completed / total) * 100).toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Completed',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
