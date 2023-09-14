import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/vendor/vendor.dart';
import 'package:cirilla/screens/chat/services/chat_service.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/themes/default/chat/chat_appbar.dart';
import 'package:cirilla/themes/default/chat/chat_messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as flutter_chat_types;

// Theme
import 'package:cirilla/themes/themes.dart';

class ChatDetailScreen extends StatefulWidget {
  static const routeName = '/chat';

  final SettingStore? store;

  const ChatDetailScreen({Key? key, this.store}) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> with AppBarMixin, NavigationMixin, ChatService {
  List<flutter_chat_types.Message> _messages = [];

  late String _conversationId;
  late Vendor _vendor;
  late String _name;
  late String _email;
  late String _userId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    _conversationId = args['conversationId'];
    _vendor = args['vendor'];
    _name = args['name'];
    _email = args['email'];
    _userId = args['userId'];

    subscribeChatMessages(
      conversationId: _conversationId,
      onChanged: _onChangeMessages,
    );
    subscribeEndChat(conversationId: _conversationId);
    subscribeTyping(conversationId: _conversationId, onTyping: _onTyping);
  }

  void _onChangeMessages(List<flutter_chat_types.Message> messages) {
    setState(() {
      _messages = messages;
    });
  }

  void _onTyping(String type) {
    List<flutter_chat_types.Message> messages = List<flutter_chat_types.Message>.of(_messages);

    if (type == 'added') {
      messages.insert(
          0,
          flutter_chat_types.CustomMessage(
            id: 'fbc-op-${_vendor.id}',
            author: flutter_chat_types.User(
                id: 'fbc-op-${_vendor.id}', firstName: '${_vendor.storeName}', imageUrl: '${_vendor.gravatar}'),
          ));
    }

    if (type == 'deleted' && messages.isNotEmpty && messages.first is flutter_chat_types.CustomMessage) {
      messages.removeAt(0);
    }

    setState(() {
      _messages = messages;
    });
  }

  /// Handle user submit chat content
  void _handleChat(flutter_chat_types.PartialText txt) {
    List<int> bytes = utf8.encode(_email);
    String gravatar = md5.convert(bytes).toString();

    Map<String, dynamic> message = {
      "avatar_image": "https://s.gravatar.com/avatar/$gravatar?s=80",
      "avatar_type": "image",
      "conversation_id": _conversationId,
      "gravatar": gravatar,
      "msg": txt.text,
      "msg_time": DateTime.now().millisecondsSinceEpoch,
      "read": false,
      "user_id": _userId,
      "vendor_id": _vendor.id,
      "user_name": _name,
      "type": "text",
      "user_type": "visitor",
    };

    addChat(message);
  }

  @override
  Widget build(BuildContext context) {
    return ChatDetail(
      appBar: _buildAppbar(),
      messages: _buildMessages(),
    );
  }

  Widget _buildAppbar() {
    return ChatAppBar(vendor: _vendor);
  }

  Widget _buildMessages() {
    return ChatMessages(data: _messages, userId: _userId, handleChat: _handleChat);
  }
}
