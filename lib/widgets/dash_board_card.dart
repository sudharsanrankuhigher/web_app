import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Resolve custom text/icon colors to be accessible and vibrant in dark mode
    Color? resolvedTextColor = textColor;
    if (isDark && textColor != null) {
      if (textColor == appGreen800) {
        resolvedTextColor = appGreen300;
      } else if (textColor == continueButton) {
        resolvedTextColor = const Color(0xFF60A5FA);
      }
    }

    return SizedBox(
      width: 308, // MediaQuery.of(context).size.width * .20
      child: Card(
        color: Theme.of(context).colorScheme.surface,
        elevation: Theme.of(context).cardTheme.elevation ?? 2,
        shape: Theme.of(context).cardTheme.shape,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title!,
                style: resolvedTextColor != null
                    ? fontFamilyBold.size18.copyWith(color: resolvedTextColor)
                    : fontFamilyBold.size18.appGreen400,
              ),
              verticalSpacing10,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    count ?? '00',
                    style: fontFamilySemiBold.size20.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  if (asset == null)
                    Icon(
                      icon,
                      color: resolvedTextColor ?? (isDark ? Colors.white70 : Colors.black87),
                    )
                  else
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: (resolvedTextColor ?? cardColor).withOpacity(isDark ? 0.15 : 0.08),
                      ),
                      padding: defaultPadding8,
                      child: Center(
                        child: SvgPicture.asset(
                          asset!,
                          colorFilter: ColorFilter.mode(
                            resolvedTextColor ?? (isDark ? Colors.white : cardColor),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              verticalSpacing10,
              Text(
                subtitle!,
                style: fontFamilyMedium.size12.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
