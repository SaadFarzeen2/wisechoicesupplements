import 'package:cirilla/webview_flutter.dart';
import 'package:cirilla/widgets/cirilla_html.dart';
import 'package:flutter/material.dart';

class FieldHtml extends StatelessWidget {
  final dynamic value;
  final double height;

  const FieldHtml({
    Key? key,
    this.value,
    this.height = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text = value is String ? value : '';

    if (text.startsWith('<!DOCTYPE html>')) {
      return SizedBox(
        height: height,
        child: WebView(
          initialUrl: Uri.dataFromString(text, mimeType: 'text/html').toString(),
          javascriptMode: JavascriptMode.unrestricted,
          allowsInlineMediaPlayback: true,
        ),
      );
    }
    return CirillaHtml(html: '<div>$text</div>');
  }
}
