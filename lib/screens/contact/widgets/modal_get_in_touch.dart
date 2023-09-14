import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:provider/provider.dart';

class ModalGetInTouch extends StatefulWidget {
  final String? formId;
  const ModalGetInTouch({
    Key? key,
    this.formId,
  }) : super(key: key);
  @override
  State<ModalGetInTouch> createState() => _ModalGetInTouchState();
}

class _ModalGetInTouchState extends State<ModalGetInTouch> with SnackMixin, LoadingMixin {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _messController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    RequestHelper requestHelper = Provider.of<RequestHelper>(context);
    return SizedBox(
      height: MediaQuery.of(context).size.height - 140,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: paddingHorizontal.add(paddingVerticalExtraLarge),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: itemPadding),
                  child: Text(
                    translate('contact_touch'),
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  translate('contact_questions'),
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: itemPaddingLarge,
                ),
                TextFormField(
                  minLines: 10,
                  maxLines: 20,
                  controller: _messController,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsetsDirectional.only(start: itemPaddingMedium, top: itemPaddingMedium),
                      labelText: translate('contact_mess'),
                      labelStyle: Theme.of(context).textTheme.bodyLarge,
                      border: const OutlineInputBorder(
                        borderRadius: borderRadius,
                      ),
                      alignLabelWithHint: true),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return translate('contact_mess_is_required');
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: itemPaddingMedium,
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: translate('contact_name'),
                    labelStyle: Theme.of(context).textTheme.bodyLarge,
                    border: const OutlineInputBorder(borderRadius: borderRadius),
                    contentPadding: const EdgeInsetsDirectional.only(start: itemPaddingMedium),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return translate('contact_name_is_required');
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: itemPaddingMedium,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: translate('contact_email'),
                    labelStyle: Theme.of(context).textTheme.bodyLarge,
                    border: const OutlineInputBorder(
                      borderRadius: borderRadius,
                    ),
                    contentPadding: const EdgeInsetsDirectional.only(start: itemPaddingMedium),
                  ),
                  validator: (value) => emailValidator(value: value!, errorEmail: translate('validate_email_value')),
                ),
                const SizedBox(
                  height: itemPaddingLarge,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _loading = true;
                          });
                          try {
                            Map<String, dynamic> res = await requestHelper.sendContact(queryParameters: {
                              'your-email': _emailController.text,
                              'your-name': _nameController.text,
                              'your-subject': 'yourSub',
                              'your-message': _messController.text,
                            }, formId: widget.formId);
                            if (res['status'] != 'mail_sent') {
                              if (mounted) showError(context, res['message']);
                            } else {
                              if (mounted) showSuccess(context, res['message']);
                            }
                            setState(() {
                              _loading = false;
                            });
                          } on DioError catch (e) {
                            showError(context, e);
                            setState(() {
                              _loading = false;
                            });
                          }
                        }
                      },
                      child: _loading
                          ? entryLoading(context, color: Theme.of(context).colorScheme.onPrimary)
                          : Text(translate('contact_submit'))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
