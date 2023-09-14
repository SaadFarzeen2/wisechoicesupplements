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
import 'dart:convert';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import 'package:cirilla/models/vendor/vendor.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';

FirebaseDatabase database = FirebaseDatabase.instance;

DatabaseReference refChatUser = database.ref("chat_users");
DatabaseReference refChatSessions = database.ref("chat_sessions");

/// Store userId, conversationId temporary for guest
String? _userId;
String? _conversationId;

mixin ChatStatusService<T extends StatefulWidget> on State<T> {
  late StreamSubscription _subscribe;

  @override
  void initState() {
    super.initState();
    _userId ??= refChatUser.push().key;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AuthStore authStore = Provider.of<AuthStore>(context);
    if (authStore.isLogin) {
      _userId = 'usr-${authStore.user?.id}';
    } else if (_userId != null && _userId!.startsWith('usr-')) {
      _userId = refChatUser.push().key;
    } else {
      _userId ??= refChatUser.push().key;
    }
    _conversationId ??= refChatSessions.push().key;
  }

  /// Subscribe vendor online/offline
  void subscribeVendorStatus(int vendorId, Function onChanged) {
    DatabaseReference ref = database.ref("chat_users/fbc-op-$vendorId/status");

    Stream<DatabaseEvent> stream = ref.onValue;

    _subscribe = stream.listen((DatabaseEvent event) {
      onChanged(event.snapshot.value == 'online');
    });
  }

  /// init user chat
  /// @return String Json with user_id and conversation_id
  Future<String> initUserChat({
    required Vendor vendor,
    required String name,
    required String email,
  }) async {
    List<int> bytes = utf8.encode(email);
    String gravatar = md5.convert(bytes).toString();

    await refChatSessions.child(_conversationId!).set({
      'user_id': _userId,
      'user_type': 'visitor',
    });

    final response = await http.get(Uri.parse('https://api.myip.com'));
    Map<String, dynamic> myIp = jsonDecode(response.body);

    await refChatUser.child(_userId!).set({
      'user_name': name,
      'user_email': email,
      'vendor_id': vendor.id,
      'user_type': 'visitor',
      'status': 'online',
      'is_mobile': true,
      'current_page': vendor.storeName,
      'conversation_id': _conversationId,
      'last_online': DateTime.now().millisecondsSinceEpoch,
      'chat_with': 'free',
      'avatar_type': 'image',
      "avatar_image": "https://s.gravatar.com/avatar/$gravatar?s=80",
      'gravatar': gravatar,
      'vendor_name': vendor.storeName,
      'user_ip': myIp['ip'],
      "user_id": _userId,
    });

    return jsonEncode({'user_id': _userId, 'conversation_id': _conversationId});
  }

  @override
  void dispose() {
    super.dispose();
    _subscribe.cancel();
  }
}
