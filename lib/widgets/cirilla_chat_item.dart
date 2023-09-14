import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class CirillaChatItem extends StatelessWidget with ChatMixin {
  final double? width;
  final EdgeInsetsGeometry? padding;
  final double padBorder;

  const CirillaChatItem({
    Key? key,
    this.width,
    this.padding,
    this.padBorder = 16,
  }) : super(key: key);

  void navigate(BuildContext context) {
    Navigator.pushNamed(context, ChatDetailScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        double defaultWidth = constraints.maxWidth != double.infinity ? constraints.maxWidth : 300;
        double widthData = width ?? defaultWidth;
        return ChatItemContainer(
          image: buildImage(context, border: Border.all(color: theme.dividerColor)),
          name: buildName(context, theme: theme),
          message: buildMessage(context, theme: theme),
          time: buildTime(context, theme: theme),
          width: widthData,
          padding: padding,
          padBorder: padBorder,
          borderColor: theme.dividerColor,
          onTap: () => navigate(context),
        );
      },
    );
  }
}
