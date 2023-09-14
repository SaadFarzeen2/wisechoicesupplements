import 'package:cirilla/utils/debug.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/webview_flutter.dart';

class CirillaWebView extends StatefulWidget {
  final WebViewCreatedCallback? onWebViewCreated;
  final NavigationDelegate? navigationDelegate;
  final PageStartedCallback? onPageStarted;
  final Widget? loading;

  const CirillaWebView({
    Key? key,
    this.onWebViewCreated,
    this.navigationDelegate,
    this.onPageStarted,
    this.loading,
  }) : super(key: key);

  @override
  State<CirillaWebView> createState() => _CirillaWebViewState();
}

class _CirillaWebViewState extends State<CirillaWebView> with LoadingMixin {
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebView(
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: widget.onWebViewCreated,
          onProgress: (int progress) {
            avoidPrint("WebView is loading (progress : $progress%)");
            if (progress == 100 && _loading) {
              setState(() {
                _loading = false;
              });
            }
          },
          navigationDelegate: widget.navigationDelegate,
          onPageStarted: widget.onPageStarted,
          gestureNavigationEnabled: true,
        ),
        if (_loading) Center(child: widget.loading ?? buildLoadingOverlay(context)),
      ],
    );
  }
}
