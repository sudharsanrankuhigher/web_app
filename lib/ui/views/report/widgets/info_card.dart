import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';

class InfoSalesProjectCard extends StatelessWidget {
  final String title;
  final String count;
  final String subtitle;
  final String iconPath;
  final Color iconBgColor;
  final Color countColor;

  const InfoSalesProjectCard({
    super.key,
    required this.title,
    required this.count,
    required this.subtitle,
    required this.iconPath,
    this.iconBgColor = const Color(0xffD5FFF6),
    this.countColor = const Color(0xff13A7E4),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: SvgPicture.asset(
                iconPath,
                height: 24,
                width: 24,
                color: appGreen600,
              ),
            ),
          ),
          horizontalSpacing10,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: fontFamilySemiBold.size16.black,
              ),
              verticalSpacing16,
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: count,
                      style: fontFamilyBold.size20.copyWith(color: countColor),
                    ),
                    const WidgetSpan(child: SizedBox(width: 8)),
                    TextSpan(
                      text: subtitle,
                      style: fontFamilySemiBold.size12.greyColor,
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
