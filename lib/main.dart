import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'service/service.dart';

late AppService appServiceInject;

/// App starts
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializePushNotificationService();
  SharedPreferences sharedPref = await getSharedPref();

  appServiceInject = await AppServiceInject.create(
    PreferenceModule(sharedPref: sharedPref),
    NetworkModule(),
  );
  runApp(appServiceInject.getApp);
}
