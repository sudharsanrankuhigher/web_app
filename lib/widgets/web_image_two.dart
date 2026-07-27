import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

class WebImageTwo extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;

  WebImageTwo({
    super.key,
    required String imageUrl,
    this.width = double.infinity,
    this.height = double.infinity,
    this.fit = BoxFit.cover,
  }) : imageUrl = _sanitizeUrl(imageUrl) {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      this.imageUrl,
      (int viewId) {
        final img = web.HTMLImageElement()
          ..src = this.imageUrl
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.objectFit = fit.name
          // ..style.borderRadius = '50%' // 👈 circular
          ..style.border = 'none';

        return img;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: HtmlElementView(viewType: imageUrl),
    );
  }

  static String _sanitizeUrl(String url) {
    if (web.window.location.protocol == 'https:' && url.startsWith('http://')) {
      return url.replaceFirst('http://', 'https://');
    }
    return url;
  }
}
