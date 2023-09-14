import 'package:cirilla/utils/debug.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:cirilla/screens/auth/widgets/verify_code.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/auth/digits_store.dart';
import 'package:cirilla/widgets/cirilla_phone_input/phone_number.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/home/home.dart';
import 'package:cirilla/store/auth/auth_store.dart';

// Theme
import 'package:cirilla/themes/themes.dart';

///
/// Login Digits plugin
class LoginMobileDigits extends StatefulWidget {
  final String type;

  const LoginMobileDigits({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  State<LoginMobileDigits> createState() => _LoginMobileDigitsState();
}

class _LoginMobileDigitsState extends State<LoginMobileDigits> with SnackMixin, LoadingMixin, AppBarMixin {
  late RequestHelper _requestHelper;
  late AuthStore _authStore;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _authStore = Provider.of<AuthStore>(context);
    _requestHelper = Provider.of<RequestHelper>(context);
    super.didChangeDependencies();
  }

  handleLoginAndRegister({required String countryCode, required String mobileNo, required String otp}) async {
    try {
      if (widget.type == "register") {
        await _authStore.digitsStore.register({
          'digits_reg_mobile': mobileNo,
          'digits_reg_countrycode': countryCode,
          'otp': otp,
        });
      } else {
        await _authStore.digitsStore.login({
          'type': widget.type,
          'user': mobileNo,
          'countrycode': countryCode,
          'otp': otp,
        });
      }
      if (mounted) Navigator.popUntil(context, ModalRoute.withName(HomeScreen.routeName));
    } on DigitsException catch (e) {
      showError(context, e.cause);
    }
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

    setLoading(true);
    String countryCode = phoneNumber.countryCode ?? '+';
    String? mobileNo =
        phoneNumber.number!.startsWith('+') ? phoneNumber.number!.replaceAll(countryCode, '') : phoneNumber.number;

    try {
      Map<String, dynamic> data = await _requestHelper.digitsSendOtp({
        'type': widget.type,
        'mobileNo': mobileNo,
        'countrycode': countryCode,
        'whatsapp': 0,
      });

      setLoading(false);

      if (data['code']?.toString() == '1') {
        if (mounted) {}
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
            return StatefulBuilder(builder: (BuildContext context, setState) {
              return VerifyCode(
                onReSend: () async {
                  try {
                    await _requestHelper.digitsReSendOtp({
                      'type': widget.type,
                      'mobileNo': mobileNo,
                      'countrycode': countryCode,
                      'whatsapp': 0,
                    });
                  } catch (e) {
                    avoidPrint(e);
                  }
                },
                showError: checkOTP == '0',
                onVerify: (smsCode) async {
                  try {
                    final dataVerifyOtp = await _requestHelper.digitsVerifyOtp({
                      'type': widget.type,
                      'mobileNo': mobileNo,
                      'countrycode': countryCode,
                      'whatsapp': 0,
                      'otp': smsCode,
                    });
                    setState(() => checkOTP = dataVerifyOtp['code'].toString());
                    if (dataVerifyOtp['code'] == 1) {
                      await handleLoginAndRegister(mobileNo: mobileNo!, countryCode: countryCode, otp: smsCode);
                    }
                  } catch (e) {
                    showError(context, e);
                  }
                },
              );
            });
          },
        );
      } else {
        if (mounted) showError(context, data['message']);
      }
    } catch (e) {
      showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoginMobileForm(loading: _loading, onSubmit: onSubmit);
  }
}
