import 'dart:async';
import 'package:cirilla/constants/assets.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class AuthLocal extends StatefulWidget {
  final Function() authLocal;
  const AuthLocal({Key? key, required this.authLocal}) : super(key: key);
  @override
  State<AuthLocal> createState() => _AuthLocalState();
}

class _AuthLocalState extends State<AuthLocal> {
  final LocalAuthentication auth = LocalAuthentication();
  List<BiometricType> _availableBiometrics = [];
  _SupportState _supportState = _SupportState.unknown;
  @override
  void initState() {
    _getAvailableBiometrics();
    auth.isDeviceSupported().then(
          (bool isSupported) =>
              setState(() => _supportState = isSupported ? _SupportState.supported : _SupportState.unsupported),
        );
    super.initState();
  }

  Future<void> _authenticate() async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    String text = translate('login_local_let_os');
    try {
      if (_availableBiometrics.contains(BiometricType.face)) {
        text = translate('login_local_scan_face');
      } else if (_availableBiometrics.contains(BiometricType.iris)) {
        text = translate('login_local_scan_iris');
      } else {
        text = translate('login_local_scan_fingerprint');
      }
      bool activity = await auth.authenticate(
        localizedReason: text,
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
      if (activity) {
        widget.authLocal();
      }
    } on PlatformException catch (e) {
      avoidPrint(e);
      return;
    }
    if (!mounted) {
      return;
    }
  }

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      avoidPrint(e);
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Container();
    double size = 40;
    if (_supportState == _SupportState.unsupported) {
      return Container();
    }
    if (_availableBiometrics.contains(BiometricType.face)) {
      child = Image.asset(Assets.faceId, width: size, height: size);
    } else if (_availableBiometrics.contains(BiometricType.iris)) {
      child = Icon(FeatherIcons.eye, size: size);
    } else {
      child = Icon(Icons.fingerprint, size: size);
    }
    return SizedBox(
      width: 48,
      height: 48,
      child: InkWell(onTap: _authenticate, child: child),
    );
  }
}

enum _SupportState { unknown, supported, unsupported }
