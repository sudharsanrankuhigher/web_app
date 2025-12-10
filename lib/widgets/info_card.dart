import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';

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
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
            padding: defaultPadding10,
            child: SizedBox(
              height: 26.h,
              width: 26.w,
              child: Image.asset('assets/images/promote_vector.png'),
            ),
          ),
          verticalSpacing10,
          Text(text,
              style: isExtended!
                  ? fontFamilySemiBold.size14.white
                  : fontFamilySemiBold.size12.white),
          verticalSpacing10,
          Text(
            count,
            style: fontFamilyBold.size16.white,
          ),
        ],
      ),
    );
  }
}
