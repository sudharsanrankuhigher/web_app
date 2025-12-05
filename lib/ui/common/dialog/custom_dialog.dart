import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';

class CustomDialog extends StatelessWidget {
  final String? title;
  final String? description;
  final String? mainButtonTitle;
  final Function() onMainButtonClick;
  const CustomDialog({
    Key? key,
    this.title,
    this.description,
    required this.onMainButtonClick,
    this.mainButtonTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: backgroundColor.withOpacity(0.7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: leftPadding20 + rightPadding20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  verticalSpacing20,
                  Text(
                    title ?? 'Error',
                    style: fontFamilyBold.size16.copyWith(
                      color: Colors.black87,
                    ),
                  ),
                  verticalSpacing8,
                  Text(
                    description ?? 'Description not available.',
                    textAlign: TextAlign.center,
                    style: fontFamilyRegular.size14.black,
                  ),
                  verticalSpacing20,
                ],
              ),
            ),

            // horizontalDivider,
            horizontalDivider,
            IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(15),
                      ),
                      onTap: onMainButtonClick,
                      child: Center(
                        child: Padding(
                          padding: defaultPadding8,
                          child: Text(
                            mainButtonTitle ?? 'Dismiss',
                            style: fontFamilyBold.size16.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
