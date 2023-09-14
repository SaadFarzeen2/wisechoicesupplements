//
// Copyright 2022 Appcheap.io All rights reserved
//
// App Name:          Cirilla - Multipurpose Flutter App For Wordpress & Woocommerce
// Source:            https://codecanyon.net/item/cirilla-multipurpose-flutter-wordpress-app/31940668
// Docs:              https://appcheap.io/docs/cirilla-developers-docs/
// Since:             2.5.0
// Author:            Appcheap.io
// Author URI:        https://appcheap.io

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as flutter_chat_types;

FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference chatMessagesRef = database.ref("chat_messages");
DatabaseReference chatSessionsRef = database.ref("chat_sessions");

mixin ChatService<T extends StatefulWidget> on State<T> {
  late StreamSubscription _subscribe;
  late StreamSubscription _subscribeDelete;
  late StreamSubscription _subscribeTypingAdded;
  late StreamSubscription _subscribeTypingDeleted;

  /// Subscribe chat messages
  subscribeChatMessages({
    required String conversationId,
    required Function onChanged,
  }) {
    Stream<DatabaseEvent> stream = chatMessagesRef.orderByChild('conversation_id').equalTo(conversationId).onValue;

    _subscribe = stream.listen((DatabaseEvent event) {
      List<flutter_chat_types.Message> messages = [];

      for (DataSnapshot item in event.snapshot.children) {
        Map data = item.value as Map;
        messages.add(flutter_chat_types.Message.fromJson(
          {
            "author": {
              "firstName": data['user_name'],
              "id": data['user_id'],
              "imageUrl": data['avatar_image'],
            },
            "createdAt": data['msg_time'],
            "id": item.key,
            "status": data['read'] ? 'seen' : 'sent',
            "text": data['msg'],
            "type": "text"
          },
        ));
      }
      onChanged(List<flutter_chat_types.Message>.from(messages.reversed));
    });
  }

  /// Add chat
  void addChat(Map<String, dynamic> message) {
    chatMessagesRef.push().set(message);
  }

  /// Subscribe end chat
  void subscribeEndChat({
    required String conversationId,
  }) {
    Stream<DatabaseEvent> stream = chatSessionsRef.orderByKey().equalTo(conversationId).onChildRemoved;

    _subscribeDelete = stream.listen((DatabaseEvent event) {
      if (event.type == DatabaseEventType.childRemoved) {
        Navigator.pop(context);
      }
    });
  }

  /// Subscribe typing
  void subscribeTyping({
    required String conversationId,
    required Function onTyping,
  }) {
    Stream<DatabaseEvent> stream = database.ref("chat_sessions/$conversationId/typing").onChildAdded;
    Stream<DatabaseEvent> stream2 = database.ref("chat_sessions/$conversationId/typing").onChildRemoved;

    _subscribeTypingAdded = stream.listen((DatabaseEvent event) {
      onTyping('added');
    });

    _subscribeTypingDeleted = stream2.listen((DatabaseEvent event) {
      onTyping('deleted');
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscribe.cancel();
    _subscribeDelete.cancel();
    _subscribeTypingAdded.cancel();
    _subscribeTypingDeleted.cancel();
  }
}
