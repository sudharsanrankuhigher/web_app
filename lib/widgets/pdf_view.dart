// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';

class PdfWebView extends StatelessWidget {
  final String url;

  const PdfWebView({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final sanitizedUrl = _sanitizeUrl(url);
    final viewId = 'pdf-view-${sanitizedUrl.hashCode}';

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      viewId,
      (int viewId) {
        final iframe = html.IFrameElement()
          ..src = sanitizedUrl
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%';
        return iframe;
      },
    );

    return SizedBox(
      width: 400,
      height: 400,
      child: HtmlElementView(viewType: viewId),
    );
  }

  String _sanitizeUrl(String url) {
    if (html.window.location.protocol == 'https:' &&
        url.startsWith('http://')) {
      return url.replaceFirst('http://', 'https://');
    }
    return url;
  }
}
