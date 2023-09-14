import 'dart:async';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyCode extends StatefulWidget {
  final Function? onReSend;
  final Function(String otp)? onVerify;
  final bool? showError;
  final bool? hidePopup;
  const VerifyCode({
    Key? key,
    this.onReSend,
    this.onVerify,
    this.showError,
    this.hidePopup,
  }) : super(key: key);

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  String _currentText = "";
  TextEditingController textEditingController = TextEditingController();
  int _start = 30;
  late Timer _timer;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _start = 30;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Padding(
      padding:
          EdgeInsets.fromLTRB(layoutPadding, layoutPadding, layoutPadding, MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            translate('login_mobile_title_verify'),
            style: textTheme.titleMedium,
          ),
          const SizedBox(
            height: 48,
          ),
          if (widget.showError == true) ...[
            Text(
              translate('login_mobile_error'),
              style: textTheme.bodyLarge?.copyWith(color: theme.colorScheme.error),
            ),
            const SizedBox(
              height: 24,
            ),
          ],
          PinCodeTextField(
            length: 6,
            obscureText: false,
            obscuringCharacter: '*',
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(8),
              fieldHeight: 48,
              fieldWidth: 48,
              activeFillColor: Colors.transparent,
              inactiveFillColor: Colors.transparent,
              inactiveColor: theme.dividerColor,
              borderWidth: 1,
            ),
            keyboardType: TextInputType.number,
            controller: textEditingController,
            // errorAnimationController: errorController,
            onCompleted: (v) {
              // Navigator.pop(context, v);
            },
            backgroundColor: Colors.transparent,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            onChanged: (value) {
              setState(() {
                _currentText = value;
              });
            },
            beforeTextPaste: (text) {
              avoidPrint("Allowing to paste $text");
              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
              //but you can show anything you want here, like your pop up saying wrong paste format or etc
              return true;
            },
            appContext: context,
            pastedTextStyle: TextStyle(
              color: Colors.green.shade300,
              fontWeight: FontWeight.bold,
            ),
            animationType: AnimationType.fade,
            validator: (v) {
              if (v!.length < 6) {
                return null;
              } else {
                return null;
              }
            },
            cursorColor: Colors.black,
            animationDuration: const Duration(milliseconds: 300),
            textStyle: const TextStyle(fontSize: 20, height: 1.6),
            enableActiveFill: false,
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            translate('login_mobile_count_down', {'_start': '$_start'}),
            style: textTheme.bodyLarge,
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                translate('login_mobile_description_code'),
                style: textTheme.bodyLarge,
              ),
              TextButton(
                onPressed: _start == 30
                    ? () {
                        startTimer();
                        widget.onReSend!();
                        if (widget.hidePopup == true) {
                          Navigator.pop(context);
                        }
                      }
                    : null,
                child: Text(
                  translate('login_mobile_btn_send').toUpperCase(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _currentText.length < 6 ? null : () => widget.onVerify!(_currentText),
              child: Text(translate('login_mobile_btn_verify')),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
