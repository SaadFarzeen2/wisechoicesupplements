import 'package:flutter/material.dart';


class StripeGateway extends StatefulWidget {
  final String publishableKey;
  final Widget Function(String url, BuildContext context, {String Function(String url)? customHandle}) webViewGateway;

  const StripeGateway({Key? key, required this.publishableKey, required this.webViewGateway}) : super(key: key);

  @override
  State<StripeGateway> createState() => _StripeGatewayState();
}

class _StripeGatewayState extends State<StripeGateway> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String url = 'https://cirrilla-stripe-form.web.app?pk=${widget.publishableKey}';
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: widget.webViewGateway(url, context),
      ),
    );
  }
}

