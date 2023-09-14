import 'package:cirilla/widgets/cirilla_phone_input/phone_number.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/auth/widgets/verify_code.dart';
import 'package:cirilla/screens/home/home.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/utils/debug.dart';

// Theme
import 'package:cirilla/themes/themes.dart';

///
/// Login SMS Firebase
class LoginMobileFirebase extends StatefulWidget {
  final String type;

  const LoginMobileFirebase({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  State<LoginMobileFirebase> createState() => _LoginMobileFirebaseState();
}

class _LoginMobileFirebaseState extends State<LoginMobileFirebase> with SnackMixin, LoadingMixin, AppBarMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late AuthStore _authStore;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        avoidPrint('User is currently signed out!');
      } else {
        avoidPrint('User logged!');
        handleLoginAndRegister(user);
      }
    });
  }

  @override
  void didChangeDependencies() {
    _authStore = Provider.of<AuthStore>(context);
    super.didChangeDependencies();
  }

  handleLoginAndRegister(User user) async {
    try {
      if (widget.type == "register") {
        await _authStore.registerStore.register({
          'phone': user.phoneNumber,
          'enable_phone_number': true,
          'callback': _callback,
        });
      } else {
        IdTokenResult idTokenResult = await user.getIdTokenResult();
        await _authStore.loginStore.login({'type': 'phone', 'token': idTokenResult.token, 'callback': _callback});
      }
      if (mounted) Navigator.popUntil(context, ModalRoute.withName(HomeScreen.routeName));
    } catch (e) {
      showError(context, e);
      await _authStore.logout();
    }
  }

  Future<void> _callback() async {
    await _auth.signOut();
  }

  setLoading(bool value) {
    setState(() {
      _loading = value;
    });
  }

  onSubmit({required PhoneNumber phoneNumber}) async {
    // Exist if phone not validate
    if (phoneNumber.number == null || phoneNumber.number!.length < 8 || phoneNumber.number!.length > 13) {
      return;
    }

    String? phone = phoneNumber.number!.startsWith('+') ? phoneNumber.number : phoneNumber.completeNumber;
    int? resendToken;
    setLoading(true);

    try {
      // For web
      if (isWeb) {
        ConfirmationResult confirmationResult = await _auth.signInWithPhoneNumber(phone!);
        if (mounted) {}
        await showModalBottomSheet<String>(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          builder: (context) => VerifyCode(
            onReSend: () async {
              await _auth.verifyPhoneNumber(
                phoneNumber: phone,
                verificationFailed: (FirebaseAuthException error) {},
                codeSent: (String verificationId, int? forceResendingToken) {},
                codeAutoRetrievalTimeout: (String verificationId) {},
                verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
              );
            },
            onVerify: (smsCode) async {
              try {
                await confirmationResult.confirm(smsCode);
                if (mounted) Navigator.pop(context);
                setLoading(false);
              } on UnimplementedError catch (e) {
                setLoading(false);
                showError(context, e.message);
              }
            },
          ),
        );
      } else {
        await _auth.verifyPhoneNumber(
          phoneNumber: phone!,
          verificationCompleted: (PhoneAuthCredential credential) async {
            // Automatic handling of the SMS code on Android devices.
            await _auth.signInWithCredential(credential);
            setLoading(false);
          },
          verificationFailed: (FirebaseAuthException e) {
            setLoading(false);
            showError(context, e.message);
          },
          codeSent: (String verificationId, int? resendToken) async {
            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              builder: (BuildContext context) {
                String checkOTP = '';
                return StatefulBuilder(
                  builder: (BuildContext context, setState) {
                    return VerifyCode(
                      showError: checkOTP.length == 6,
                      hidePopup: true,
                      onReSend: () async {
                        try {
                          await _auth.verifyPhoneNumber(
                            phoneNumber: phone,
                            forceResendingToken: resendToken,
                            verificationFailed: (FirebaseAuthException error) {},
                            codeSent: (String verificationId, int? forceResendingToken) {},
                            codeAutoRetrievalTimeout: (String verificationId) {},
                            verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
                          );
                        } catch (e) {
                          rethrow;
                        }
                      },
                      onVerify: (smsCode) async {
                        PhoneAuthCredential phoneAuthCredential =
                            PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
                        try {
                          await _auth.signInWithCredential(phoneAuthCredential);
                          if (mounted) Navigator.pop(context);
                          setLoading(false);
                        } catch (e) {
                          setState(() => checkOTP = smsCode);
                          setLoading(false);
                        }
                      },
                    );
                  },
                );
              },
            );
          },
          forceResendingToken: resendToken,
          timeout: const Duration(seconds: 30),
          codeAutoRetrievalTimeout: (String verificationId) {
            setLoading(false);
          },
        );
      }
    } on UnimplementedError catch (e) {
      setLoading(false);
      showError(context, e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoginMobileForm(loading: _loading, onSubmit: onSubmit);
  }
}
