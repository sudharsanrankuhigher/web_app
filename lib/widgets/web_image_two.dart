import 'dart:html' as html;
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webapp/core/helper/dialog_state.dart';

class WebImageTwo extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;

  WebImageTwo({
    super.key,
    required this.imageUrl,
    this.width = double.infinity,
    this.height = double.infinity,
    this.fit = BoxFit.cover,
  }) {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      imageUrl,
      (int viewId) {
        final img = html.ImageElement()
          ..src = imageUrl
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
}
