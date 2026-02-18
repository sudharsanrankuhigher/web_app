import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/widgets/pie_chart_widget.dart';

class ProjectStatusWidget extends StatelessWidget {
  final int completed;
  final int pending;
  final String? title;

  const ProjectStatusWidget({
    super.key,
    required this.completed,
    required this.pending,
    this.title,
  });

  int get total => completed + pending;

  @override
  Widget build(BuildContext context) {
    final bool isExtended = MediaQuery.of(context).size.width > 900;

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
          /// 🔹 Title
          Text(
            title!,
            style: fontFamilySemiBold.size14.black,
          ),

          verticalSpacing40,

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// 🔹 Pie Chart
              ///
              SizedBox(
                height: 120,
                width: 120,
                child: PieChartWidget(
                  completed: completed,
                  pending: pending,
                ),
              ),

              const SizedBox(width: 24),

              /// 🔹 Legend & Counts
              Expanded(
                child: Column(
                  children: [
                    _statusRow(
                      color: const Color(0xff00BE93),
                      label: 'Completed',
                      value: completed,
                    ),
                    const SizedBox(height: 12),
                    _statusRow(
                      color: pendingColor,
                      label: 'Pending',
                      value: pending,
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // const Text(
                        //   'Total Projects',
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        // ),
                        Text(
                          '$total',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusRow({
    required Color color,
    required String label,
    required int value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
            ),
            // const SizedBox(width: 8),
            // Text(label),
          ],
        ),
        Text(
          '$value',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
