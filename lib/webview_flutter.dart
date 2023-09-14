///
/// This file use switch webview_flutter to flutter_webview_pro
///
/// The default Flutter Webview from Flutter team not support photo upload/take camera and Geolocation that why we change
/// to fork plugin base on Webview flutter: https://pub.dev/packages/flutter_webview_pro
///
/// Step1: Change to flutter_webview_pro in file pubspec.yaml
///
/// ```dart
///   flutter_webview_pro: ^3.0.1+2
/// ```
///
/// Step 2: flutter_webview_pro in this file
///
/// ```dart
///   export 'package:flutter_webview_pro/webview_flutter.dart';
/// ```
///
/// Step3: Install dependencies and run the app again
///
/// Support Geolocation: If you want support geolocation you need find the WebView and and set geolocationEnabled = true
///
/// Example:
///
/// ```dart
///    body: Builder(builder: (BuildContext context) {
///       return WebView(
///         initialUrl: 'https://www.domain.com',
///         javascriptMode: JavascriptMode.unrestricted,
///         geolocationEnabled: false, // Support geolocation or not
///       );
///    }),
/// ```
///

export 'package:webview_flutter/webview_flutter.dart';