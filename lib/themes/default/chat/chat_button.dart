//
// Copyright 2022 Appcheap.io All rights reserved
//
// App Name:          Cirilla - Multipurpose Flutter App For Wordpress & Woocommerce
// Source:            https://codecanyon.net/item/cirilla-multipurpose-flutter-wordpress-app/31940668
// Docs:              https://appcheap.io/docs/cirilla-developers-docs/
// Since:             2.5.0
// Author:            Appcheap.io
// Author URI:        https://appcheap.io

import 'dart:convert';

import 'package:cirilla/mixins/loading_mixin.dart';
import 'package:flutter/material.dart';

import 'package:cirilla/models/vendor/vendor.dart';
import 'package:feather_icons/feather_icons.dart';

import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/screens/chat/chat.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/utils/form_field_validator.dart';

String? _email;
String? _name;

///
/// Button chat
class ChatButton extends StatefulWidget {
  /// Vendor object
  final Vendor vendor;

  /// Status vendor available for chat
  final bool chatStatus;

  /// Init chat data
  final Future<String> Function({
    required Vendor vendor,
    required String name,
    required String email,
  }) initChat;

  const ChatButton({
    Key? key,
    required this.vendor,
    required this.chatStatus,
    required this.initChat,
  }) : super(key: key);

  @override
  State<ChatButton> createState() => _ChatButtonState();
}

class _ChatButtonState extends State<ChatButton> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_email != null) {
      _emailController = TextEditingController(text: _email);
    }
    if (_name != null) {
      _nameController = TextEditingController(text: _name);
    }
  }

  /// Show form get user chat info
  Future<void> _showForm(BuildContext context) async {
    String? userChat = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: borderRadiusBottomSheet,
      ),
      builder: (_) => _Form(
        emailController: _emailController,
        nameController: _nameController,
        vendor: widget.vendor,
        initChat: widget.initChat,
      ),
    );

    if (userChat != null && mounted) {
      Map<String, dynamic> info = jsonDecode(userChat);
      Navigator.pushNamed(context, ChatDetailScreen.routeName, arguments: {
        'vendor': widget.vendor,
        'email': _emailController.text,
        'name': _nameController.text,
        'conversationId': info['conversation_id'],
        'userId': info['user_id'],
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return SizedBox(
      height: 34,
      child: ElevatedButton(
        onPressed: widget.chatStatus ? () => _showForm(context) : null,
        style: ElevatedButton.styleFrom(
          foregroundColor: theme.primaryColor,
          backgroundColor: theme.cardColor,
          textStyle: theme.textTheme.bodySmall,
        ),
        child: Row(
          children: [
            const Icon(FeatherIcons.messageSquare, size: 14),
            const SizedBox(width: 8),
            Text(translate('vendor_detail_chat')),
          ],
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController nameController;

  /// Vendor object
  final Vendor vendor;

  /// Init chat data
  final Future<String> Function({
    required Vendor vendor,
    required String name,
    required String email,
  }) initChat;

  const _Form({
    Key? key,
    required this.emailController,
    required this.nameController,
    required this.vendor,
    required this.initChat,
  }) : super(key: key);

  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<_Form> with LoadingMixin {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return SizedBox(
      height: MediaQuery.of(context).size.height - 440,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: paddingHorizontal.add(paddingVerticalExtraLarge),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: itemPadding),
                child: Text(
                  'Chat now',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              TextFormField(
                controller: widget.nameController,
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
                controller: widget.emailController,
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

                      String userChat = await widget.initChat(
                        vendor: widget.vendor,
                        email: widget.emailController.text,
                        name: widget.nameController.text,
                      );

                      /// Store global
                      _email = widget.emailController.text;
                      _name = widget.nameController.text;

                      setState(() {
                        _loading = false;
                      });

                      if (mounted) Navigator.pop(context, userChat);
                    }
                  },
                  child: _loading
                      ? entryLoading(context, color: Theme.of(context).colorScheme.onPrimary)
                      : const Text('Start chat'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
