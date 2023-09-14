import 'dart:io';

import 'package:cirilla/webview_flutter.dart';
import 'package:flutter/cupertino.dart';

Widget buildCirillaWebViewGateway(String url, BuildContext context, {String Function(String url)? customHandle}) {
  if (Platform.isAndroid && WebView.platform != AndroidWebView()) WebView.platform = AndroidWebView();
  if (url.contains("https://cirrilla-stripe-form.web.app")) {
    return WebView(
      initialUrl: url,
      javascriptMode: JavascriptMode.unrestricted,
      javascriptChannels: <JavascriptChannel>{
        JavascriptChannel(
          name: 'Flutter_Cirilla',
          onMessageReceived: (JavascriptMessage message) {
            Navigator.pop(context, message.message);
          },
        )
      },
    );
  }
  return WebView(
    initialUrl: url,
    javascriptMode: JavascriptMode.unrestricted,
    navigationDelegate: (NavigationRequest request) {
      if (customHandle != null) {
        String value = customHandle(request.url);
        switch (value) {
          case "prevent":
            return NavigationDecision.prevent;
          default:
            return NavigationDecision.navigate;
        }
      }
      if (request.url.contains('/order-received/')) {
        Navigator.of(context).pop({'order_received_url': request.url});
        return NavigationDecision.prevent;
      }
      return NavigationDecision.navigate;
    },
  );
}
