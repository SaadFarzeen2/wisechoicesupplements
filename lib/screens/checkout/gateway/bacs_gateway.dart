import 'package:flutter/widgets.dart';
import 'package:payment_base/payment_base.dart';

class BacsGateway implements PaymentBase {
  /// Payment method key
  ///
  static const key = "bacs";

  @override
  String get libraryName => "";

  @override
  String get logoPath => "assets/images/payment/bacs.png";

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
    required Widget Function(String url, BuildContext context) webViewGateway,

  }) async {
    try {
      await checkout([]);
      callback("");
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

    return 'Error!';
  }
}
