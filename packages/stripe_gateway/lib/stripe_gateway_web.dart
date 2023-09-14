library stripe_gateway;

import 'package:flutter/widgets.dart';
import 'package:payment_base/payment_base.dart';
import 'widgets/stripe.dart';

class StripeGatewayWeb implements PaymentBase {
  /// Payment method key
  ///
  static const key = "stripe";

  @override
  String get libraryName => "stripe_gateway";

  @override
  String get logoPath => "assets/images/stripe.png";

  @override
  Future<void> initialized({
    required BuildContext context,
    required RouteTransitionsBuilder slideTransition,
    required Future<dynamic> Function(List<dynamic>) checkout,
    required Function(dynamic data) callback,
    required String amount,
    required String currency,
    required Map<String, dynamic> billing,
    required Map<String, dynamic> settings,
    required Future<dynamic> Function({String? cartKey, required Map<String, dynamic> data}) progressServer,
    required String cartId,
    required Widget Function(String url, BuildContext context, {String Function(String url)? customHandle})
        webViewGateway,
  }) async {
    try {
      String pk = settings['testmode']['value'] == "yes"
          ? settings['test_publishable_key']['value']
          : settings['publishable_key']['value'];
      String? source = await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, _, __) => StripeGateway(
            publishableKey: pk,
            webViewGateway: webViewGateway,
          ),
          transitionsBuilder: slideTransition,
        ),
      );
      if(source == null){
        callback(PaymentException(error: "Cancel payment"));
        return;
      }
      List<dynamic> paymentData = [
        {"key": "stripe_source", "value": source},
        {"key": "billing_email", "value": billing['email']},
        {"key": "billing_first_name", "value": billing['first_name']},
        {"key": "billing_last_name", "value": billing['last_name']},
        {"key": "paymentMethod", "value": "stripe"},
        {"key": "paymentRequestType", "value": "cc"},
        {"key": "wc-stripe-new-payment-method", "value": true}
      ];
      dynamic res = await checkout(paymentData);
      if(res['message'] != null){
        callback(PaymentException(error: res['message']));
      }else{
        callback('success');
      }
    } catch (e) {
      callback(e);
    }
  }

  @override
  String getErrorMessage(Map<String, dynamic>? error) {
    if (error == null) {
      return 'Something wrong in checkout!';
    }

    if (error['message'] != null) {
      return error['message'];
    }

    if (error['payment_result'] != null && error['payment_result']['payment_status'] == 'failure') {
      return error['payment_result']['payment_details'][0]['value'];
    }

    return 'Error!';
  }
}
