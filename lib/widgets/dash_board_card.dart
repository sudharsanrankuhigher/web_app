import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';

class DashBoardCard extends StatelessWidget {
  final String? title;
  final String? count;
  final IconData? icon;
  final String? asset;
  final String? subtitle;
  final Color? textColor;

  const DashBoardCard(
      {super.key,
      required this.title,
      this.count,
      this.icon,
      this.asset,
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
                  if (asset == null)
                    Icon(
                      icon,
                      color: textColor ?? Colors.black,
                    ),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: cardColor.withOpacity(0.1)),
                    padding: defaultPadding8,
                    child: Center(child: Image.asset(asset!)),
                  )
                ],
              ),
              verticalSpacing10,
              Text(subtitle!,
                  style: fontFamilyMedium.size12
                      .copyWith(color: subText.withOpacity(0.60))),
            ],
          ),
        ),
      ),
    );
  }
}
