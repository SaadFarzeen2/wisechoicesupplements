import 'dart:async';
import 'dart:io';

import 'package:cirilla/mixins/loading_mixin.dart';
import 'package:cirilla/models/post/post.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:flutter/material.dart';

import 'package:cirilla/webview_flutter.dart';

class PostEvent extends StatefulWidget {
  final Post? post;

  const PostEvent({Key? key, this.post}) : super(key: key);

  @override
  State<PostEvent> createState() => _PostEventState();
}

class _PostEventState extends State<PostEvent> with LoadingMixin {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> qs = {'app-builder-checkout-body-class': 'app-builder-event-screens'};

    String checkoutUrl = "${widget.post!.link!}?${Uri(queryParameters: qs).query}";

    avoidPrint(checkoutUrl);

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(widget.post!.postTitle!),
        ),
        body: Stack(
          children: [
            WebView(
              initialUrl: checkoutUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onProgress: (int progress) {
                avoidPrint("WebView is loading (progress : $progress%)");
              },
              navigationDelegate: (NavigationRequest request) {
                avoidPrint('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) {
                avoidPrint('Page started loading: $url');
              },
              onPageFinished: (String url) {
                setState(() {
                  _loading = false;
                });
              },
              gestureNavigationEnabled: true,
            ),
            if (_loading) buildLoading(context, isLoading: _loading),
          ],
        ));
  }
}
