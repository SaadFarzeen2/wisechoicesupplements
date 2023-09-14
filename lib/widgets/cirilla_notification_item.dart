import 'package:flutter/material.dart';

import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/mixins/notification_mixin.dart';
import 'package:cirilla/models/message/message.dart';
import 'package:cirilla/screens/profile/notification_detail.dart';
import 'package:ui/ui.dart';

class CirillaNotificationItem extends StatelessWidget with NotificationMixin, NavigationMixin {
  final MessageData message;

  CirillaNotificationItem({
    Key? key,
    required this.message,
  }) : super(key: key);

  navigateDetail(BuildContext context) {
    Navigator.of(context).pushNamed(NotificationDetail.routeName, arguments: {'message': message});
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return NotificationItem(
      title: buildTitle(theme, message),
      leading: buildLeading(theme, message),
      trailing: buildTrailing(message),
      date: buildDate(theme, message),
      onTap: () => navigateDetail(context),
    );
  }
}
