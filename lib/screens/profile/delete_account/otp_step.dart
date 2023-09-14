import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OtpStep extends StatefulWidget {
  final Function(String) nextStep;
  final VoidCallback backStep;
  final Function({Function? callback}) resendOtp;
  final bool loading;
  final bool loadingResendOtp;

  const OtpStep({
    Key? key,
    required this.nextStep,
    required this.backStep,
    required this.resendOtp,
    this.loading = false,
    this.loadingResendOtp = false,
  }) : super(key: key);

  @override
  State<OtpStep> createState() => _OtpStepState();
}

class _OtpStepState extends State<OtpStep> with AppBarMixin, SnackMixin, LoadingMixin {
  final TextEditingController _controller = TextEditingController();
  bool _enableNext = false;

  late AuthStore _authStore;

  @override
  void didChangeDependencies() {
    _authStore = Provider.of<AuthStore>(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {
        _enableNext = _controller.text.length == 6;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Scaffold(
      appBar: AppBar(
        leading: iconButtonLeading(onPressed: widget.backStep),
        shadowColor: Colors.transparent,
      ),
      body: CirillaFixedBottom(
        childBottom: CirillaFixedBottomContainer(
          padding: paddingVerticalMedium.add(paddingHorizontal),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: theme.textTheme.titleMedium?.color,
                      backgroundColor: theme.colorScheme.surface,
                    ),
                    child: Text(translate('delete_account_agree_cancel')),
                  ),
                ),
              ),
              const SizedBox(width: itemPaddingMedium),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _enableNext
                        ? () {
                            if (!widget.loading) {
                              widget.nextStep(_controller.text);
                            }
                          }
                        : null,
                    child: widget.loading
                        ? entryLoading(context, color: theme.colorScheme.onPrimary)
                        : Text(translate('delete_account_agree_send')),
                  ),
                ),
              ),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: paddingHorizontal.copyWith(top: itemPadding, bottom: itemPaddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate('delete_account_otp_title'),
                style: theme.textTheme.headlineSmall,
              ),
              Text.rich(
                TextSpan(
                  text: translate('delete_account_otp_subtitle'),
                  children: [
                    TextSpan(
                      text: ' ${_authStore.user?.userEmail}',
                      style: TextStyle(color: theme.textTheme.titleLarge?.color),
                    )
                  ],
                ),
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: itemPaddingExtraLarge),
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
                controller: _controller,
                backgroundColor: Colors.transparent,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                onChanged: (_) {},
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
              const SizedBox(height: itemPaddingLarge),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    translate('login_mobile_description_code'),
                    style: theme.textTheme.bodyLarge,
                  ),
                  TextButton(
                    onPressed: () {
                      if (!widget.loadingResendOtp) {
                        widget.resendOtp(callback: () {
                          showSuccess(context, translate('delete_account_otp_send_success'));
                        });
                      }
                    },
                    child: Text(translate('login_mobile_btn_send')),
                  ),
                ],
              ),
              if (widget.loadingResendOtp) entryLoading(context),
            ],
          ),
        ),
      ),
    );
  }
}
