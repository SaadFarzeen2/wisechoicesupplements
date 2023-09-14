import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/mixins/loading_mixin.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/widgets/cirilla_phone_input/cirilla_phone_input.dart';
import 'package:cirilla/widgets/cirilla_phone_input/phone_number.dart';
import 'package:flutter/material.dart';

class LoginMobileForm extends StatefulWidget {
  final bool loading;
  final Function onSubmit;

  const LoginMobileForm({Key? key, required this.loading, required this.onSubmit}) : super(key: key);

  @override
  State<LoginMobileForm> createState() => _LoginMobileFormState();
}

class _LoginMobileFormState extends State<LoginMobileForm> with LoadingMixin {
  final _formKey = GlobalKey<FormState>();
  final _txtPhoneNumber = TextEditingController();
  PhoneNumber? _phoneNumber;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;

    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: paddingHorizontal.add(paddingVerticalMedium),
              child: Column(
                children: [
                  Text(
                    translate('login_mobile_description'),
                    style: textTheme.bodyLarge,
                  ),
                  sizeBoxLarge,
                  CirillaPhoneInput(
                    controller: _txtPhoneNumber,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return translate('validate_phone_number_required');
                      }
                      return null;
                    },
                    autoValidate: false,
                    onChanged: (phone) {
                      setState(() {
                        _phoneNumber = phone;
                      });
                    },
                  ),
                  sizeBoxLarge,
                  widget.loading
                      ? buildLoading(context, isLoading: widget.loading)
                      : SizedBox(
                          height: 48,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate() && _phoneNumber != null) {
                                widget.onSubmit(
                                  phoneNumber: _phoneNumber,
                                );
                              }
                            },
                            child: Text(translate('login_mobile_btn_code')),
                          ),
                        ),
                  sizeBoxLarge,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
