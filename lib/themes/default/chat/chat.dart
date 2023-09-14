import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:flutter/material.dart';

///
/// Layout chat detail
class ChatDetail extends StatelessWidget with AppBarMixin {
  final Widget appBar;
  final Widget messages;

  ChatDetail({
    Key? key,
    required this.appBar,
    required this.messages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        leading: leading(),
        title: appBar,
        toolbarHeight: 90,
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleSpacing: 0,
      ),
      body: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: const BoxDecoration(borderRadius: borderRadiusBottomSheetLarge),
        child: messages,
      ),
    );
  }
}
