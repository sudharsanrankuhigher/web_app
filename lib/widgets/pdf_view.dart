// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';

class PdfWebView extends StatelessWidget {
  final String url;

  const PdfWebView({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final viewId = 'pdf-view-${url.hashCode}';

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      viewId,
      (int viewId) {
        final iframe = html.IFrameElement()
          ..src = url
          ..style.border = 'none';
        return iframe;
      },
    );

    return SizedBox(
      width: 400,
      height: 400,
      child: HtmlElementView(viewType: viewId),
    );
  }
}
