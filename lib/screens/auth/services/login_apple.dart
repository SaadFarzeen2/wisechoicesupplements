import 'package:cirilla/utils/debug.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

mixin AppleLoginMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> loginApple(Function login) async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      login({
        'type': 'apple',
        'identityToken': credential.identityToken,
        'authorizationCode': credential.authorizationCode,
        'userIdentifier': credential.userIdentifier,
        'givenName': credential.givenName,
        'familyName': credential.familyName,
      });
    } catch (e) {
      avoidPrint('---- Login Apple Error---');
      avoidPrint(e);
      avoidPrint('---- End Login Apple Error---');
    }
  }
}
