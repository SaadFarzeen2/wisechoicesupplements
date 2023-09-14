import 'dart:async';
import 'dart:io';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/constants/currencies.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/checkout/order_received.dart';
import 'package:cirilla/service/constants/endpoints.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/store/cart/cart_store.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:cirilla/widgets/cirilla_webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:cirilla/webview_flutter.dart';

class CheckoutWebView extends StatefulWidget {
  static const routeName = '/checkout-webview';

  const CheckoutWebView({Key? key}) : super(key: key);

  @override
  State<CheckoutWebView> createState() => _CheckoutWebViewState();
}

class _CheckoutWebViewState extends State<CheckoutWebView> with TransitionMixin, AppBarMixin {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  late SettingStore _settingStore;
  late CartStore _cartStore;
  late AuthStore _authStore;

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);
    _authStore = Provider.of<AuthStore>(context);
    _cartStore = Provider.of<AuthStore>(context).cartStore;
    super.didChangeDependencies();
  }

  void navigateOrderReceived(BuildContext context, String url) {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, _, __) => OrderReceived(url: url),
      transitionsBuilder: slideTransition,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      Map<String, String?> queryParams = {
        'cart_key_restore': _cartStore.cartKey,
        'app-builder-checkout-body-class': 'app-builder-checkout'
      };

      if (_authStore.isLogin) {
        queryParams.putIfAbsent('app-builder-decode', () => 'true');
      }

      if (_settingStore.isCurrencyChanged) {
        queryParams.putIfAbsent(CURRENCY_PARAM, () => _settingStore.currency);
      }

      if (_settingStore.languageKey != "text") {
        queryParams.putIfAbsent(_authStore.isLogin ? '_lang' : 'lang', () => _settingStore.locale);
      }

      String url = _authStore.isLogin ? Endpoints.restUrl + Endpoints.loginToken : _settingStore.checkoutUrl!;

      String checkoutUrl = "$url?${Uri(queryParameters: queryParams).query}";

      TranslateType translate = AppLocalizations.of(context)!.translate;
      return Scaffold(
        appBar: baseStyleAppBar(context, title: translate('cart_checkout')),
        body: Builder(builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.only(top: layoutPadding),
            child: CirillaWebView(
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
                webViewController.clearCache();
                final cookieManager = CookieManager();
                cookieManager.clearCookies();

                if (_authStore.isLogin) {
                  Map<String, String> headers = {"Authorization": "Bearer ${_authStore.token!}"};
                  webViewController.loadUrl(checkoutUrl, headers: headers);
                } else {
                  webViewController.loadUrl(checkoutUrl);
                }
              },
              navigationDelegate: (NavigationRequest request) {
                avoidPrint(request.url);

                if (request.url.contains('/order-received/')) {
                  navigateOrderReceived(context, request.url);
                }

                if (request.url.contains('/cart/')) {
                  Navigator.of(context).pop();
                  return NavigationDecision.prevent;
                }

                if (request.url.contains('/my-account/')) {
                  return NavigationDecision.prevent;
                }

                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) {
                if (url.contains('/order-received/')) {
                  navigateOrderReceived(context, url);
                }
                avoidPrint('Page started loading: $url');
              },
            ),
          );
        }),
      );
    });
  }
}
