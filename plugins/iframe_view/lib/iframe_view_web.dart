// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' show IFrameElement;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'iframe_view_platform_interface.dart';

/// A web implementation of the IframeViewPlatform of the IframeView plugin.
class IframeViewWeb extends IframeViewPlatform {
  /// Constructs a IframeViewWeb
  IframeViewWeb();

  static void registerWith(Registrar registrar) {
    IframeViewPlatform.instance = IframeViewWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<Widget?> show(String source) async{
    return Iframe(source: source);
  }
}

class Iframe extends StatefulWidget {
  final String source;

  const Iframe({Key? key, required this.source}) : super(key: key);

  @override
  State<Iframe> createState() => _IframeState();
}

class _IframeState extends State<Iframe> {
  // Widget _iframeWidget;
  final IFrameElement _iframeElement = IFrameElement();

  @override
  void initState() {
    super.initState();
    _iframeElement.src = widget.source;
    _iframeElement.style.border = 'none';

    //ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
          (int viewId) => _iframeElement,
    );
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(
      key: UniqueKey(),
      viewType: 'iframeElement',
    );
  }
}