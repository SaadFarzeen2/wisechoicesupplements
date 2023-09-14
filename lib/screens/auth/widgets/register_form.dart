import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_captcha.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  final HandleLoginType? handleRegister;
  final bool? enableRegisterPhoneNumber;
  final String? term;
  final String? initCountryCode;
  final bool enableEmail;

  const RegisterForm({
    Key? key,
    this.handleRegister,
    this.enableRegisterPhoneNumber = true,
    this.term,
    this.initCountryCode,
    this.enableEmail = true,
  }) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> with SnackMixin {
  final _formKey = GlobalKey<FormState>();
  final _txtFirstName = TextEditingController();
  final _txtLastName = TextEditingController();
  final _txtUsername = TextEditingController();
  final _txtEmail = TextEditingController();
  final _txtPassword = TextEditingController();
  bool _obscureText = true;
  FocusNode? _lastNameFocusNode;
  FocusNode? _usernameFocusNode;
  FocusNode? _emailFocusNode;
  FocusNode? _passwordFocusNode;

  bool _agree = true;

  @override
  void initState() {
    super.initState();
    _lastNameFocusNode = FocusNode();
    _usernameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // dispose controller input
    _txtFirstName.dispose();
    _txtLastName.dispose();
    _txtUsername.dispose();
    _txtEmail.dispose();
    _txtPassword.dispose();

    // dispose focus input
    _lastNameFocusNode!.dispose();
    _usernameFocusNode!.dispose();
    _emailFocusNode!.dispose();
    _passwordFocusNode!.dispose();
    super.dispose();
  }

  void _updateObscure() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    SettingStore settingStore = Provider.of<SettingStore>(context, listen: false);
    Map<String, dynamic>? data = settingStore.data?.settings!['general']!.widgets!['general']!.fields;

    bool enableCaptchaRegister = get(data, ['enableCaptchaRegister'], true);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildFirstName(translate),
          const SizedBox(height: 16),
          buildLastName(translate),
          const SizedBox(height: 16),
          buildUsername(translate),
          if (widget.enableEmail) ...[
            const SizedBox(height: 16),
            buildEmail(translate),
          ],
          const SizedBox(height: 16),
          buildPasswordField(translate),
          const SizedBox(height: 8),
          CirillaHtml(
            html: widget.term ?? '',
          ),
          const SizedBox(height: 24),
          CirillaCaptchaWrap(
            enable: enableCaptchaRegister,
            submit: (captcha, phrase) => widget.handleRegister!({
              'first_name': _txtFirstName.text,
              'last_name': _txtLastName.text,
              'user_login': _txtUsername.text,
              'email': _txtEmail.text,
              'password': _txtPassword.text,
              'agree_privacy_term': _agree,
              'captcha': captcha,
              'phrase': phrase,
            }),
            buildButton: (onPressed) {
              return SizedBox(
                height: 48,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (!_agree) {
                      showError(context, translate('agree_term'));
                      return;
                    }
                    if (_formKey.currentState!.validate()) {
                      onPressed();
                    }
                  },
                  child: Text(translate('register_btn_submit')),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildFirstName(TranslateType translate) {
    return TextFormField(
      controller: _txtFirstName,
      validator: (value) {
        if (value!.isEmpty) {
          return translate('validate_first_name_required');
        }
        if (RegExp(r'^(?=.*?[!@#\$&*~])').hasMatch(value)) {
          return translate('validate_without_special_characters');
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: translate('input_first_name_required'),
      ),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_lastNameFocusNode);
      },
    );
  }

  Widget buildLastName(TranslateType translate) {
    return TextFormField(
      controller: _txtLastName,
      focusNode: _lastNameFocusNode,
      validator: (value) {
        if (value!.isEmpty) {
          return translate('validate_last_name_required');
        }
        if (RegExp(r'^(?=.*?[!@#\$&*~])').hasMatch(value)) {
          return translate('validate_without_special_characters');
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: translate('input_last_name_required'),
      ),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_usernameFocusNode);
      },
    );
  }

  Widget buildUsername(TranslateType translate) {
    return TextFormField(
      controller: _txtUsername,
      focusNode: _usernameFocusNode,
      validator: (value) {
        if (!RegExp(r'^.{1,}$').hasMatch(value!)) {
          return translate('validate_characters_in_length', {'length': '1'});
        }
        if (value.contains(' ')) {
          return translate('validate_space');
        }
        if (RegExp(r'^(?=.*?[!@#\$&*~])').hasMatch(value)) {
          return translate('validate_without_special_characters');
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: translate('input_username_required'),
      ),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_emailFocusNode);
      },
    );
  }

  Widget buildEmail(TranslateType translate) {
    return TextFormField(
      controller: _txtEmail,
      focusNode: _emailFocusNode,
      validator: (value) {
        if (value!.isEmpty) {
          return translate('validate_email_required');
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: translate('input_email_required'),
      ),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      },
    );
  }

  Widget buildPasswordField(TranslateType translate) {
    SettingStore settingStore = Provider.of<SettingStore>(context);
    WidgetConfig widgetConfig = settingStore.data!.screens!['register']!.widgets!['register']!;
    Map<String, dynamic>? fields = widgetConfig.fields ?? {};

    int minLength = ConvertData.stringToInt(get(fields, ['minLengthPassword'], 6), 6);
    bool enableSymbol = get(fields, ['enableSymbolPassword'], true);
    bool enableNumber = get(fields, ['enableNumberPassword'], true);
    bool enableLower = get(fields, ['enableLowerCharacterPassword'], true);
    bool enableUpper = get(fields, ['enableUpperCharacterPassword'], true);

    return TextFormField(
      controller: _txtPassword,
      validator: (String? value) {
        if (minLength > value!.length) {
          return translate('validate_characters_in_length', {'length': minLength.toString()});
        }
        if (value.contains(' ')) {
          return translate('validate_space');
        }
        if (enableUpper && !RegExp(r'^(?=.*?[A-Z])').hasMatch(value)) {
          return translate('validate_one_upper_case');
        }
        if (enableLower && !RegExp(r'^(?=.*?[a-z])').hasMatch(value)) {
          return translate('validate_one_lower_case');
        }
        if (enableNumber && !RegExp(r'^(?=.*?[0-9])').hasMatch(value)) {
          return translate('validate_one_digit');
        }
        if (enableSymbol && !RegExp(r'^(?=.*?[!@#\$&*~])').hasMatch(value)) {
          return translate('validate_one_special_character');
        }
        return null;
      },
      focusNode: _passwordFocusNode,
      obscureText: _obscureText, // Error when login then login again if enable
      decoration: InputDecoration(
        labelText: translate('input_password_required'),
        suffixIcon: IconButton(
          iconSize: 16,
          icon: Icon(_obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined),
          onPressed: _updateObscure,
        ),
      ),
    );
  }

  Widget buildAgreeTerm(TranslateType translate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Accept the [Terms and Conditions]'),
        Switch(
          value: _agree,
          onChanged: (value) {
            setState(() {
              _agree = value;
            });
          },
        )
      ],
    );
  }
}
