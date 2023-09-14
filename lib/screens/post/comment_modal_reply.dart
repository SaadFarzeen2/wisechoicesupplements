import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/widgets/cirilla_captcha.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModalReply extends StatefulWidget {
  final PostCommentStore? commentStore;
  final int? parent;

  const ModalReply({Key? key, this.commentStore, this.parent}) : super(key: key);

  @override
  State<ModalReply> createState() => _ModalReplyState();
}

class _ModalReplyState extends State<ModalReply> with SnackMixin, LoadingMixin {
  String? _error;
  bool _loading = false;

  final _formKey = GlobalKey<FormState>();
  final commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Future<void> handleSubmit(String captcha, String phrase) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // Write comment
      await widget.commentStore!.writeComment(
        content: commentController.text,
        parent: widget.parent,
        captcha: captcha,
        phrase: phrase,
      );
      setState(() {
        _loading = false;
      });
      if (mounted) Navigator.pop(context, true);
    } on DioError catch (e) {
      _error = e.response != null && e.response!.data != null ? e.response!.data['message'] : e.message;
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    SettingStore settingStore = Provider.of<SettingStore>(context, listen: false);
    Map<String, dynamic>? data = settingStore.data?.settings!['general']!.widgets!['general']!.fields;

    bool enableCaptchaCommentPost = get(data, ['enableCaptchaCommentPost'], true);

    return SingleChildScrollView(
      padding: EdgeInsets.only(
          top: itemPaddingExtraLarge,
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: layoutPadding,
          right: layoutPadding),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Text(
              translate('comment_leave_a_reply'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: itemPadding,
            ),
            Text(
              translate('comment_your_email_address_will'),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: itemPadding,
            ),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            const Padding(padding: EdgeInsets.only(top: itemPaddingLarge)),
            TextFormField(
              controller: commentController,
              minLines: 5,
              maxLines: 10,
              decoration: InputDecoration(
                labelText: translate('comment_your_comments'),
                alignLabelWithHint: true,
                contentPadding: const EdgeInsetsDirectional.only(start: itemPaddingMedium, top: itemPaddingMedium),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return translate('comment_invalid_comment_content');
                }
                return null;
              },
            ),
            Padding(
              padding: paddingVerticalExtraLarge,
              child: CirillaCaptchaWrap(
                enable: enableCaptchaCommentPost,
                submit: handleSubmit,
                buildButton: (onPressed) {
                  return SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_loading && _formKey.currentState!.validate()) {
                          onPressed();
                        }
                      },
                      child: _loading
                          ? entryLoading(
                              context,
                              color: Theme.of(context).colorScheme.onPrimary,
                            )
                          : Text(translate('comment_post')),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
