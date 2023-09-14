import 'dart:convert';
import 'dart:typed_data';

import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/service/service.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

double _widthCaptcha = 150;
double _heightCaptcha = 40;

class CirillaCaptchaWrap extends StatelessWidget {
  final Widget Function(Function onPressed) buildButton;
  final void Function(String captcha, String phrase) submit;
  final bool enable;

  const CirillaCaptchaWrap({
    Key? key,
    required this.buildButton,
    required this.submit,
    this.enable = true,
  }) : super(key: key);

  Future<void> _showMyDialog(BuildContext context) async {
    if (!enable) {
      return submit('', '');
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: InkResponse(
                    onTap: () => Navigator.pop(context),
                    radius: 25,
                    child: const Icon(Icons.close),
                  ),
                ),
                const SizedBox(height: itemPaddingMedium),
                Flexible(
                  child: _CirillaCaptchaForm(
                    submit: (captcha, phrase) {
                      Navigator.pop(context);
                      submit(captcha, phrase);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildButton(
      () => _showMyDialog(context),
    );
  }
}

class _CirillaCaptchaForm extends StatefulWidget {
  final void Function(String captcha, String phrase) submit;

  const _CirillaCaptchaForm({
    Key? key,
    required this.submit,
  }) : super(key: key);

  @override
  State<_CirillaCaptchaForm> createState() => _CirillaCaptchaFormState();
}

class _CirillaCaptchaFormState extends State<_CirillaCaptchaForm> with Utility, LoadingMixin {
  late SettingStore _settingStore;

  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Map? _captcha;
  bool _loading = false;

  bool _loadingValidate = false;
  String? _error;

  @override
  void initState() {
    _settingStore = Provider.of<SettingStore>(context, listen: false);

    getCaptcha(_settingStore.requestHelper);
    super.initState();
  }

  void getCaptcha(RequestHelper requestHelper) async {
    try {
      setState(() {
        _loading = true;
      });
      Map? captcha = await requestHelper.getCaptcha(queryParameters: {'time': DateTime.now().millisecondsSinceEpoch});

      setState(() {
        _captcha = captcha;
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _captcha = null;
        _loading = false;
      });
    }
    _controller.clear();
  }

  void validateCaptcha(RequestHelper requestHelper, Map<String, dynamic> data, Function callback) async {
    try {
      setState(() {
        _loadingValidate = true;
        _error = null;
      });
      await requestHelper.validateCaptcha(data: data);

      setState(() {
        _loadingValidate = false;
      });
      callback();
    } on DioError catch (e) {
      setState(() {
        _loadingValidate = false;
        _error = e.response != null && e.response!.data != null ? e.response!.data['message'] : e.message;
      });
      getCaptcha(requestHelper);
    }
  }

  Widget buildCaptcha() {
    String value = get(_captcha, ['captcha'], '');

    Uint8List bytesImage = const Base64Decoder().convert(value.split(',').last);
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.memory(
        bytesImage,
        width: _widthCaptcha,
        height: _heightCaptcha,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildLoadingCaptcha() {
    return SizedBox(
      height: _heightCaptcha,
      width: _widthCaptcha,
      child: Center(
        child: entryLoading(context),
      ),
    );
  }

  Widget buildErrorCaptcha(TranslateType translate) {
    return SizedBox(
      height: _heightCaptcha,
      width: _widthCaptcha,
      child: Center(
        child: Text(
          translate('captcha_error'),
          style: const TextStyle(color: ColorBlock.red),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_error?.isNotEmpty == true) ...[
            Text(_error!, style: theme.textTheme.bodySmall?.copyWith(color: ColorBlock.red)),
            const SizedBox(height: itemPadding),
          ],
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 3, color: theme.dividerColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: _loading
                    ? buildLoadingCaptcha()
                    : _captcha != null
                        ? buildCaptcha()
                        : buildErrorCaptcha(translate),
              ),
              const SizedBox(width: itemPaddingSmall),
              InkResponse(
                onTap: !_loading ? () => getCaptcha(_settingStore.requestHelper) : null,
                radius: 25,
                child: Icon(Icons.sync, color: _loading ? theme.dividerColor : theme.primaryColor),
              )
            ],
          ),
          const SizedBox(height: itemPaddingSmall),
          TextFormField(
            controller: _controller,
            validator: (value) {
              if (value!.isEmpty) {
                return translate('captcha_validate_empty');
              }
              return null;
            },
            decoration: InputDecoration(labelText: translate('captcha_txt')),
          ),
          const SizedBox(height: itemPaddingLarge),
          SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _captcha != null
                  ? () {
                      if (!_loadingValidate && _formKey.currentState!.validate()) {
                        String phrase = get(_captcha, ['phrase'], '');
                        validateCaptcha(
                          _settingStore.requestHelper,
                          {
                            'captcha': _controller.text,
                            'phrase': phrase,
                          },
                          () => widget.submit(_controller.text, phrase),
                        );
                      }
                    }
                  : null,
              child: _loadingValidate
                  ? entryLoading(context, color: theme.colorScheme.onPrimary)
                  : Text(translate('captcha_submit')),
            ),
          )
        ],
      ),
    );
  }
}
