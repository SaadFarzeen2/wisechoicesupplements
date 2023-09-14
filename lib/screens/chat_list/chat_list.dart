import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

import 'widgets/recent_chat.dart';

class ChatListScreen extends StatelessWidget with AppBarMixin {
  static const routeName = '/chat-list';

  final SettingStore? store;

  const ChatListScreen({
    Key? key,
    this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            leading: leading(),
            title: Text('All Chats', style: theme.appBarTheme.titleTextStyle),
            elevation: 0,
            backgroundColor: Colors.transparent,
            actions: [
              Icon(Icons.mail_outline, size: 22, color: theme.primaryColor),
              const SizedBox(width: 3),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BadgeUi(
                    text: Text(
                      '3',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.primaryColor),
                    ),
                    color: theme.primaryColorLight,
                    radius: 8,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(width: layoutPadding),
            ],
          ),
          Padding(
            padding: paddingHorizontal,
            child: Search(
              icon: const Icon(FeatherIcons.search, size: 16),
              label: Text('Enter Celebrity Name', style: theme.textTheme.bodyMedium),
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius,
                side: BorderSide(width: 1, color: theme.dividerColor),
              ),
              color: theme.canvasColor,
              onTap: () {},
            ),
          ),
          const SizedBox(height: itemPaddingLarge),
          const RecentChat(),
          const SizedBox(height: itemPaddingLarge),
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.only(top: itemPaddingSmall),
              decoration:
                  BoxDecoration(color: theme.scaffoldBackgroundColor, borderRadius: borderRadiusBottomSheetLarge),
              child: ListView(
                padding: EdgeInsets.zero,
                children: List.generate(10, (index) {
                  return CirillaChatItem(
                    padding: paddingHorizontal.add(const EdgeInsets.only(top: itemPaddingMedium)),
                  );
                }),
              ),
            ),
          )
        ],
      ),
    );
  }
}
