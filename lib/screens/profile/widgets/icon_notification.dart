import 'package:flutter/material.dart';

import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:feather_icons/feather_icons.dart';

import 'package:cirilla/screens/profile/notification_list.dart';
import 'package:cirilla/service/service.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/widgets/cirilla_badge.dart';

class IconNotification extends StatefulWidget {
  const IconNotification({super.key});

  @override
  State<IconNotification> createState() => _IconNotificationState();
}

class _IconNotificationState extends State<IconNotification> {
  late AppStore _appStore;
  late MessageStore _messageStore;
  late AuthStore _authStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _authStore = Provider.of<AuthStore>(context);
    _appStore = Provider.of<AppStore>(context);

    String key = "notification_store";

    if (_appStore.getStoreByKey(key) == null) {
      MessageStore store = MessageStore(Provider.of<RequestHelper>(context), _authStore, key: key);

      _appStore.addStore(store);
      _messageStore = store;
    } else {
      _messageStore = _appStore.getStoreByKey(key);
    }
  }

  Future<void> _navigate() async {
    Navigator.of(context).pushNamed(NotificationList.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Observer(
        builder: (_) => _authStore.isLogin
            ? Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      FeatherIcons.bell,
                      size: 20,
                    ),
                    splashRadius: 28,
                    onPressed: _navigate,
                  ),
                  Container(
                    margin: const EdgeInsetsDirectional.only(top: 7, start: 24),
                    padding: const EdgeInsetsDirectional.only(end: 20),
                    child: InkWell(
                      onTap: _navigate,
                      child: CirillaBadge(
                        size: 18,
                        label: "${_messageStore.countUnRead}",
                        type: CirillaBadgeType.error,
                      ),
                    ),
                  ),
                ],
              )
            : Container(),
      ),
    );
  }
}
