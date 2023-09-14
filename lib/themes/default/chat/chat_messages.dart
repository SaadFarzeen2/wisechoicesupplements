import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as flutter_chat_types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

DatabaseReference refChatUser = FirebaseDatabase.instance.ref("chat_users");
DatabaseReference refChatSessions = FirebaseDatabase.instance.ref("chat_sessions");

class ChatMessages extends StatefulWidget {
  final List<flutter_chat_types.Message> data;
  final void Function(flutter_chat_types.PartialText) handleChat;
  final String userId;

  const ChatMessages({
    Key? key,
    required this.data,
    required this.handleChat,
    required this.userId,
  }) : super(key: key);

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> with LoadingMixin {
  List<flutter_chat_types.Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  late FocusNode _focus;
  bool _showButtonSend = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _focus = FocusNode();
    _controller.addListener(() {
      if (_controller.text.isNotEmpty && !_showButtonSend) {
        setState(() {
          _showButtonSend = true;
        });
      }
      if (_controller.text.isEmpty && _showButtonSend) {
        setState(() {
          _showButtonSend = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _focus.dispose();
  }

  void _handleMessageTap(BuildContext context, flutter_chat_types.Message message) async {
    if (message is flutter_chat_types.FileMessage) {
      // await OpenFile.open(message.uri);
    }
  }

  void _handlePreviewDataFetched(
    flutter_chat_types.TextMessage message,
    flutter_chat_types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as flutter_chat_types.TextMessage).copyWith(
      previewData: previewData,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _messages[index] = updatedMessage;
      });
    });
  }

  void _loadMessages() async {
    setState(() {
      _messages = widget.data;
    });
  }

  InputBorder getBorderInput({double width = 1, required Color color}) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        width: width,
        color: color,
      ),
      borderRadius: BorderRadius.circular(24),
    );
  }

  Widget customMessageBuilder(flutter_chat_types.CustomMessage mess, {required int messageWidth}) {
    return SizedBox(
      width: 100,
      height: 50,
      child: entryLoading(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Chat(
      customMessageBuilder: customMessageBuilder,
      messages: widget.data,
      // onAttachmentPressed: _handleAtachmentPressed,
      onMessageTap: _handleMessageTap,
      onPreviewDataFetched: _handlePreviewDataFetched,
      onSendPressed: widget.handleChat,
      user: flutter_chat_types.User(id: widget.userId),
      showUserAvatars: true,
      l10n: const ChatL10nEn(emptyChatPlaceholder: '...'),
      theme: DefaultChatTheme(
        backgroundColor: theme.scaffoldBackgroundColor,
        primaryColor: theme.primaryColor,
        secondaryColor: theme.colorScheme.surface,
        inputBackgroundColor: Colors.transparent,
        sentMessageCaptionTextStyle:
            theme.textTheme.titleSmall?.copyWith(color: Colors.white) ?? const TextStyle(color: Colors.white),
        sentMessageBodyTextStyle:
            theme.textTheme.bodyMedium?.copyWith(color: Colors.white) ?? const TextStyle(color: Colors.white),
        sentMessageLinkTitleTextStyle:
            theme.textTheme.titleMedium?.copyWith(color: Colors.white) ?? const TextStyle(color: Colors.white),
        sentMessageLinkDescriptionTextStyle:
            theme.textTheme.bodyMedium?.copyWith(color: Colors.white) ?? const TextStyle(color: Colors.white),
        receivedMessageBodyTextStyle: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.titleMedium?.color) ??
            TextStyle(color: theme.textTheme.titleMedium?.color),
        receivedMessageCaptionTextStyle: theme.textTheme.titleSmall ?? const TextStyle(),
        receivedMessageLinkDescriptionTextStyle:
            theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.titleMedium?.color) ??
                TextStyle(color: theme.textTheme.titleMedium?.color),
        receivedMessageLinkTitleTextStyle: theme.textTheme.titleMedium ?? const TextStyle(),
        dateDividerTextStyle: theme.textTheme.bodySmall ?? const TextStyle(),
        emptyChatPlaceholderTextStyle: theme.textTheme.bodySmall ?? const TextStyle(),
        inputContainerDecoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: borderRadiusBottomSheetLarge,
        ),
        inputTextColor: theme.textTheme.titleMedium?.color ?? Colors.black,
        inputTextStyle: theme.textTheme.bodyMedium ?? const TextStyle(),
        inputTextDecoration: const InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
