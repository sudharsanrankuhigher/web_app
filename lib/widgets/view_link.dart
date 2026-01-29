import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';

class ViewLink extends StatelessWidget {
  final String url;
  final String text;

  const ViewLink({
    super.key,
    required this.url,
    this.text = "View Link",
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.tryParse(url);
          if (uri != null) {
            await launchUrl(
              uri,
              mode: kIsWeb
                  ? LaunchMode.platformDefault
                  : LaunchMode.externalApplication,
            );
          }
        },
        child: Text(text,
            style: fontFamilySemiBold.size11.continueButton
                .copyWith(decoration: TextDecoration.underline)),
      ),
    );
  }
}
