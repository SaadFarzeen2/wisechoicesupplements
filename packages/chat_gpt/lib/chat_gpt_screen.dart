import 'package:chat_gpt/chat_gpt.dart';
import 'package:chat_gpt/helper/string_generate.dart';
import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

const String gptId = 'gpt_id';
const String userId = 'user_id';
const Radius radiusMessage = Radius.circular(15);

class ChatGPTWidget extends StatelessWidget {
  const ChatGPTWidget({
    Key? key,
    required this.apiKey,
    this.messageData,
    this.customMessageBuilder,
    this.chatGPTConfig,
    this.chatTheme,
    this.retryWidgetBuilder,
  }) : super(key: key);

  final String apiKey;
  final List<types.Message>? messageData;
  final Widget Function(types.CustomMessage mess, {required int messageWidth})? customMessageBuilder;
  final ChatGPTConfig? chatGPTConfig;
  final ChatTheme? chatTheme;
  final Widget Function(Function handleRetry)? retryWidgetBuilder;

  @override
  Widget build(BuildContext context) {
    return ChatGPTDetail(
      apiKey: apiKey,
      messageData: messageData,
      customMessageBuilder: customMessageBuilder,
      chatGPTConfig: chatGPTConfig,
      chatTheme: chatTheme,
      retryWidgetBuilder: retryWidgetBuilder,
    );
  }
}

class ChatGPTDetail extends StatefulWidget {
  const ChatGPTDetail({
    Key? key,
    required this.apiKey,
    required this.messageData,
    required this.customMessageBuilder,
    required this.chatGPTConfig,
    required this.chatTheme,
    required this.retryWidgetBuilder,
  }) : super(key: key);
  final String apiKey;
  final List<types.Message>? messageData;
  final Widget Function(types.CustomMessage mess, {required int messageWidth})? customMessageBuilder;
  final ChatGPTConfig? chatGPTConfig;
  final ChatTheme? chatTheme;
  final Widget Function(Function handleRetry)? retryWidgetBuilder;

  @override
  State<ChatGPTDetail> createState() => _ChatGPTDetailState();
}

class _ChatGPTDetailState extends State<ChatGPTDetail> {
  late types.User _gpt;
  late types.User _user;
  late OpenAIServices _openAIServices;
  List<types.Message> _messages = [];
  bool _loadingAnswer = false;
  bool _retry = false;
  double _maxWidthMessage = 0;

  @override
  void initState() {
    /// Init user of room chat.
    _initChatUser();

    /// Create OpenAI service instant.
    _openAIServices = OpenAIServices(
      openAIKey: widget.apiKey,
      chatGPTConfig: widget.chatGPTConfig,
    );

    /// Init first message
    _messages.add(
      types.TextMessage(
        author: types.User(
          id: gptId,
          firstName: widget.chatGPTConfig?.botName ?? 'BOT',
          imageUrl: widget.chatGPTConfig?.botAvatar?['src'],
        ),
        id: StringGenerate.uuid(4),
        text: "Welcome back, what do you want to know?",
      ),
    );

    /// Load old messages
    _loadMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _maxWidthMessage = MediaQuery.of(context).size.width * 0.7;

    return Chat(
      customMessageBuilder: widget.customMessageBuilder ?? _customMessageBuilderDefault,
      messages: _messages,
      onPreviewDataFetched: _handlePreviewDataFetched,
      onSendPressed: _handleSendPressed,
      showUserAvatars: true,
      showUserNames: true,
      user: _user,
      theme: widget.chatTheme ?? const DefaultChatTheme(),
      bubbleBuilder: _customBubbleBuilder,
    );
  }

  /// Create user for chat room.
  void _initChatUser() {
    _gpt = types.User(
      id: gptId,
      firstName: widget.chatGPTConfig?.botName ?? 'BOT',
      imageUrl: widget.chatGPTConfig?.botAvatar?['src'],
    );
    _user = const types.User(
      id: userId,
    );
  }

  /// Load all messages.
  void _loadMessages() async {
    if (widget.messageData != null) {
      setState(() {
        _messages = [...widget.messageData!];
      });
    }
  }

  /// Add message to first of list.
  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  /// Replace message at the first of list.
  void _replaceLastMessage(types.Message message) {
    if (_messages.isNotEmpty) {
      setState(() {
        _messages.removeAt(0);
        _messages.insert(0, message);
      });
    }
  }

  /// Handle Preview Data Fetched.
  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  /// Handle event on tap send message.
  void _handleSendPressed(types.PartialText message) {
    // hide retry icon if it being showed.
    if (_retry) {
      _retry = false;
    }
    // If loadingAnswer is true, can't send new message.
    if (_loadingAnswer) {
      return;
    }
    // Send new question.
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: StringGenerate.uuid(4),
      text: message.text,
    );
    _addMessage(textMessage);

    // Add message for show loading message animation.
    _addMessage(types.CustomMessage(
      author: _gpt,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: StringGenerate.uuid(4),
    ));
    _loadingAnswer = true;

    // Get answer
    _openAIServices.generateResponse(message.text).then((value) {
      // Replace loading message with answer.
      _replaceLastMessage(types.TextMessage(
        author: _gpt,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: StringGenerate.uuid(4),
        text: value,
      ));
      _loadingAnswer = false;
    }).catchError((error, stackTrace) {
      // Replace loading message with answer.
      _loadingAnswer = false;
      _retry = true;
      _replaceLastMessage(types.TextMessage(
          author: _gpt,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: StringGenerate.uuid(4),
          text: error.toString(),
          metadata: const {'exception': true}));
    });
  }

  /// Handle on tap retry button.
  _handleRetry() {
    if (_messages.length > 1) {
      try {
        _handleSendPressed(types.PartialText(text: (_messages[1] as types.TextMessage).text));
      } catch (_) {}
    }
  }


  /// Build loading message default.
  Widget _customMessageBuilderDefault(
    types.CustomMessage mess, {
    required int messageWidth,
  }) {
    return const SizedBox(
      width: 100,
      height: 50,
      child: CupertinoActivityIndicator(),
    );
  }

  /// Build retry widget.
  Widget _customRetryBuilder() {
    if (widget.retryWidgetBuilder != null) {
      return widget.retryWidgetBuilder!(_handleRetry);
    }
    return IconButton(
      onPressed: () {
        _handleRetry();
      },
      icon: const Icon(
        Icons.refresh,
      ),
      iconSize: 25,
    );
  }

  /// Define error message of user which not be processed yet.
  bool _defineErrorMessage(types.Message message) {
    if (_messages.length > 1) {
      if (message.createdAt != null && _messages[1].createdAt != null) {
        return (_retry && message.createdAt!.compareTo(_messages[1].createdAt!) == 0);
      }
    }
    return false;
  }

  /// Define error message of bot which not be processed yet.
  bool _defineErrorRequest(types.Message message) {
    if (message.metadata != null) {
      if (message.metadata!['exception'] == true) {
        return true;
      }
    }
    return false;
  }

  /// Build bubble message widget
  Widget _customBubbleBuilder(
    Widget child, {
    required types.Message message,
    required bool nextMessageInGroup,
  }) {
    bool isUser = message.author.id == _user.id;
    bool isErrorQuestion = _defineErrorMessage(message) && isUser;
    bool isErrorRequest = _defineErrorRequest(message);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isErrorQuestion) _customRetryBuilder(),
        Container(
          decoration: BoxDecoration(
            borderRadius: (isUser)
                ? const BorderRadius.only(
                    topLeft: radiusMessage,
                    topRight: radiusMessage,
                    bottomLeft: radiusMessage,
                  )
                : const BorderRadius.only(
                    topLeft: radiusMessage,
                    topRight: radiusMessage,
                    bottomRight: radiusMessage,
                  ),
            color: isErrorRequest
                ? Theme.of(context).colorScheme.error.withOpacity(0.1)
                : (isUser)
                    ? Theme.of(context).primaryColor
                    : Colors.grey.withOpacity(0.1),
          ),
          constraints: BoxConstraints(maxWidth: _maxWidthMessage),
          child: child,
        ),
      ],
    );
  }
}
