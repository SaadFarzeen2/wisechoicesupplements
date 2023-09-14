import 'package:chat_gpt/chat_gpt.dart';
import 'package:cirilla/constants/chat_gpt.dart';
import 'package:cirilla/models/models.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

class ChatGPTWidgetBuilder extends StatelessWidget {
  const ChatGPTWidgetBuilder({Key? key, required this.widgetConfig}) : super(key: key);
  final WidgetConfig? widgetConfig;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ChatGPTWidget(
        apiKey: chatGPTAPIKey,
        chatGPTConfig: ChatGPTConfig.fromJson(widgetConfig?.fields ?? {}),
        retryWidgetBuilder: (handleRetry) {
          return InkWell(
            splashColor: Colors.red,
            onTap: () {
              handleRetry();
            },
            child:  Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                Icons.refresh,
                size: 18,
                color: theme.colorScheme.error,
              ),
            ),
          );
        },
        customMessageBuilder: (mess, {required messageWidth}) {
          return SizedBox(
            width: 100,
            height: 50,
            child: SpinKitThreeBounce(
              color: theme.primaryColor,
              size: 16,
            ),
          );
        },
        chatTheme: DefaultChatTheme(
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
          receivedMessageBodyTextStyle:
              theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.titleMedium?.color) ??
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
      ),
    );
  }
}
