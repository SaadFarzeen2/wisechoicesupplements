library payment_base;

import 'package:flutter/cupertino.dart';

abstract class PaymentBase {
  /// The logo path in folder assets
  ///
  final String logoPath = "";

  /// The library name
  /// This used in Widget Image when call the assets from library folder
  ///
  final String libraryName = "";

  /// **context**: BuildContext
  ///
  /// **processCheckout**: Process after payment success with payment
  /// response data
  ///
  /// **callback**: Callback after checkout success
  ///
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
    required Widget Function(String url, BuildContext context, {String Function(String url)? customHandle}) webViewGateway,
  });

  /// Get error message
  ///
  String getErrorMessage(Map<String, dynamic>? error);
}

class PaymentException implements Exception {
  String error;
  PaymentException({required this.error});

  @override
  String toString() {
    return "Payment Error: $error";
  }
}
