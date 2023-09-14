import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

abstract class SnackMixin {
  void showError(BuildContext context, dynamic e, {OnTap? onLinkTap, SnackBarAction? action}) {
    String? message = '';

    if (e.runtimeType == String) {
      message = e;
    } else if (e is DioError) {
      message = e.response != null && e.response?.data != null ? e.response?.data['message'] : e.message;
    }

    final snackBar = SnackBar(
      content: Builder(
        builder: (BuildContext context) => Html(
          data: "<div>$message</div>",
          style: {
            "div": Style(color: Colors.white),
            "a": Style(color: Colors.white, fontWeight: FontWeight.bold),
          },
          onLinkTap: onLinkTap,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.error,
      action: action,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSuccess(BuildContext context, String? e, {OnTap? onLinkTap, SnackBarAction? action}) {
    final snackBar = SnackBar(
      duration: const Duration(milliseconds: 700),
      content: Builder(
        builder: (BuildContext context) => Html(
          data: "<div>$e</div>",
          style: {
            "div": Style(color: Colors.white),
            "a": Style(color: Colors.white, fontWeight: FontWeight.bold),
          },
          onLinkTap: onLinkTap,
        ),
      ),
      action: action,
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
