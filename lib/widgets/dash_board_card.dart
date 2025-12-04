import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';

class DashBoardCard extends StatelessWidget {
  final String? title;
  final String? count;
  final IconData? icon;
  final String? subtitle;
  final Color? textColor;

  const DashBoardCard(
      {super.key,
      required this.title,
      this.count,
      this.icon,
      this.subtitle,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 308, //MediaQuery.of(context).size.width *
      // .20, //305, // Adaptive width for Wrap
      child: Card(
        color: white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title!,
                  style: textColor != null
                      ? fontFamilyBold.size18.copyWith(color: textColor)
                      : fontFamilyBold.size18.appGreen400),
              verticalSpacing10,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(count ?? '00', style: fontFamilySemiBold.size20.black),
                  Icon(
                    icon,
                    color: textColor ?? Colors.black,
                  ),
                ],
              ),
              verticalSpacing10,
              Text(subtitle!),
            ],
          ),
        ),
      ),
    );
  }
}
