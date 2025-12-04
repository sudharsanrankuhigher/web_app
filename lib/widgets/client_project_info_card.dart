import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';

class ClientProjectInfoCard extends StatelessWidget {
  final Color boxColor;
  final Color dotColor;
  final String text;
  final Color textColor;
  final String count;
  final Color countColor;
  final double? height;

  const ClientProjectInfoCard({
    super.key,
    required this.boxColor,
    required this.dotColor,
    required this.text,
    required this.textColor,
    required this.count,
    required this.countColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 60,
      margin: bottomPadding10,
      padding: defaultPadding16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: boxColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            // <-- Add this
            child: Row(
              children: [
                Container(
                  height: 10,
                  width: 10,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotColor,
                  ),
                ),
                Expanded(
                  // <-- Add this
                  child: Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            count,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: countColor,
            ),
          ),
        ],
      ),
    );
  }
}
