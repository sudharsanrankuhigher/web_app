import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final Color boxColor;
  final IconData icon;
  final String text;
  final String count;
  final bool? isExtended;

  const InfoCard({
    super.key,
    required this.boxColor,
    required this.icon,
    required this.text,
    required this.count,
    this.isExtended = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: boxColor,
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 30),
          const SizedBox(height: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: isExtended! ? 14 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            count,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
