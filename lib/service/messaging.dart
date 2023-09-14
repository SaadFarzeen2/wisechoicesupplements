import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cirilla/service/service.dart';
import 'package:dio/dio.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/firebase_options.dart' as firebase_config;
import '../constants/notification.dart';

SharedPreferences? sharedPref;

Future<SharedPreferences> getSharedPref() async {
  return sharedPref ??= await SharedPreferences.getInstance();
}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

/// Init Firebase service
Future<void> initializePushNotificationService() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: firebase_config.apiKey,
        appId: firebase_config.appId,
        messagingSenderId: firebase_config.messagingSenderId,
        projectId: firebase_config.projectId,
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  /// Subscribe to default topic
  subscribeTopic(topic: kIsWeb ? 'web' : Platform.operatingSystem);

  if (!kIsWeb) {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}

/// Update token to database
Future<void> updateTokenToDatabase(
  RequestHelper requestHelper,
  String? token, {
  List<String>? topics,
}) async {
  try {
    if (topics != null) {
      await subscribeTopic(topic: topics);
    }
    await requestHelper.updateUserToken(token);
  } catch (e) {
    avoidPrint(
        '=========> Warning: Plugin Push Notifications Mobile And Web App Not Installed. Download here: https://wordpress.org/plugins/push-notification-mobile-and-web-app');
  }
}

/// Remove user token database
Future<void> removeTokenInDatabase(
  RequestHelper requestHelper,
  String? token,
  String? userId, {
  List<String>? topics,
}) async {
  try {
    if (topics != null) {
      await unSubscribeTopic(topic: topics);
    }
    await requestHelper.removeUserToken(token, userId);
  } catch (e) {
    avoidPrint(
        '=========> Warning: Plugin Push Notifications Mobile And Web App Not Installed. Download here: https://wordpress.org/plugins/push-notification-mobile-and-web-app');
  }
}

/// Get token
Future<String?> getToken() async {
  return await FirebaseMessaging.instance.getToken();
}

/// Subscribing to topics
Future<void> subscribeTopic({dynamic topic}) async {
  if (kIsWeb) return;

  if (topic is String) {
    avoidPrint("Subscribing to topics $topic");
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }
  if (topic is List<String>) {
    int i = 0;
    return Future.doWhile(() async {
      await FirebaseMessaging.instance.subscribeToTopic(topic[i]);
      avoidPrint("Subscribing to topics ${topic[i]}");
      i++;
      return i < topic.length;
    });
  }
}

/// Un subscribing to topics
Future<void> unSubscribeTopic({dynamic topic}) async {
  if (kIsWeb) return;

  if (topic is String) {
    avoidPrint("Un subscribing to topics $topic");
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }
  if (topic is List<String>) {
    int i = 0;
    return Future.doWhile(() async {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic[i]);
      avoidPrint("Un subscribing to topics ${topic[i]}");
      i++;
      return i < topic.length;
    });
  }
}

/// Listening the changes
mixin MessagingMixin<T extends StatefulWidget> on State<T> {
  Future<void> subscribe(RequestHelper requestHelper, Function navigate) async {
    if (kIsWeb || Platform.isIOS || Platform.isMacOS) {
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized &&
          settings.authorizationStatus != AuthorizationStatus.provisional) {
        return;
      }
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      await androidImplementation?.requestPermission();
    }

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen((token) => updateTokenToDatabase(requestHelper, token));

    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage, navigate);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) => _handleMessage(message, navigate));

    var initializationSettingsAndroid = const AndroidInitializationSettings('@drawable/ic_notification');

    var initializationSettingsIOS = const DarwinInitializationSettings();

    var initSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;

      void onDidReceiveNotificationResponse(NotificationResponse details) {
        navigate(jsonDecode(details.payload ?? ''));
      }

      flutterLocalNotificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      );

      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        Map<String, dynamic> data = {
          'type': message.data['type'],
          'route': message.data['route'],
          'args': jsonDecode(message.data['args'] ?? '{}')
        };
        String payloadData = jsonEncode(data);
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: notificationIcon,
              largeIcon: await getAndroidBitmapFromUrl(notification),
              color: notificationColor,
            ),
          ),
          payload: payloadData,
        );
      }
    });

    Timer(const Duration(seconds: 5), () async {
      // Get the token each time the application loads
      String? token = await getToken();
      avoidPrint("Token: $token");

      // Save the initial token to the database
      await updateTokenToDatabase(requestHelper, token);
    });
  }
}

Future<ByteArrayAndroidBitmap?> getAndroidBitmapFromUrl(RemoteNotification notification) async {
  if (notification.android?.imageUrl == null || notification.android?.imageUrl == '') {
    return null;
  }
  try {
    Response res = await dio.get(notification.android!.imageUrl!, options: Options(responseType: ResponseType.bytes));
    return ByteArrayAndroidBitmap(res.data);
  } catch (e) {
    return null;
  }
}

void _handleMessage(RemoteMessage message, Function navigate) {
  if (message.data['type'] != null && message.data['args'] != null && message.data['route'] != null) {
    try {
      Map<String, dynamic> data = {
        'type': message.data['type'],
        'route': message.data['route'],
        'args': jsonDecode(message.data['args'])
      };
      navigate(data);
    } catch (e) {
      avoidPrint(e);
    }
  }
}
