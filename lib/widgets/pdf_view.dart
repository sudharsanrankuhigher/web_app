import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

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
        final iframe = web.HTMLIFrameElement()
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
    if (web.window.location.protocol == 'https:' && url.startsWith('http://')) {
      return url.replaceFirst('http://', 'https://');
    }
    return url;
  }
}
