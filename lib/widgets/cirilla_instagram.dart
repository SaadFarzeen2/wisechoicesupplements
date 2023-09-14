import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:cirilla/webview_flutter.dart';

class CirillaInstagram extends StatefulWidget {
  final String id;

  const CirillaInstagram({Key? key, required this.id}) : super(key: key);

  @override
  State<CirillaInstagram> createState() => _CirillaInstagramState();
}

class _CirillaInstagramState extends State<CirillaInstagram> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 625,
      child: WebView(
        initialUrl: Uri.dataFromString(
          '<iframe frameBorder="0" height="100%" width="100%" src="https://www.instagram.com/p/${widget.id}/embed/"></iframe>',
          mimeType: 'text/html',
        ).toString(),
        javascriptMode: JavascriptMode.unrestricted,
        allowsInlineMediaPlayback: true,
      ),
    );
  }
}
