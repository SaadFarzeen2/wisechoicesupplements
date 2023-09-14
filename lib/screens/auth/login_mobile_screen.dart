import 'dart:async';

import 'package:cirilla/store/store.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/auth/widgets/login_mobile_digits.dart';
import 'package:cirilla/screens/auth/widgets/login_mobile_firebase.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/utils/debug.dart';

// Ensure firebase initialize
class LoginMobileScreen extends StatelessWidget with AppBarMixin, LoadingMixin {
  final String? contextType;

  static const routeName = '/login_mobile';

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  LoginMobileScreen({Key? key, this.contextType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    AuthStore authStore = Provider.of<AuthStore>(context);
    SettingStore settings = Provider.of<SettingStore>(context);

    String type = 'login';

    if (contextType != null) {
      type = contextType!;
    } else {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;

      if (args != null) {
        type = args['type']!;
      }
    }

    Map<String, dynamic>? data = settings.data?.settings!['general']!.widgets!['general']!.fields;

    String method = get(data, ['loginProvider'], 'firebase');

    return Scaffold(
      appBar: AppBar(
        leading: leading(),
        title: Text(translate('login_mobile_appbar')),
        elevation: 0,
      ),
      body: Observer(
        builder: (_) => Stack(
          children: [
            method == 'digits' ? LoginMobileDigits(type: type) : loginMobileFirebase(type: type),
            if (authStore.loginStore.loading || authStore.digitsStore.loading)
              Align(
                alignment: FractionalOffset.center,
                child: buildLoadingOverlay(context),
              ),
          ],
        ),
      ),
    );
  }

  ///
  /// Init Firebase
  FutureBuilder loginMobileFirebase({required String type}) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          avoidPrint(snapshot.error);
          return const Text('Error');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return LoginMobileFirebase(type: type);
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const CircularProgressIndicator();
      },
    );
  }
}
