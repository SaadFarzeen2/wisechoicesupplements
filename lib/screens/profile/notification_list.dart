import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/widgets/cirilla_notification_item.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/message/message.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:ui/notification/notification_screen.dart';

class NotificationList extends StatefulWidget {
  static const routeName = '/notification_list';

  const NotificationList({Key? key}) : super(key: key);

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> with AppBarMixin, LoadingMixin, NavigationMixin, Utility {
  final ScrollController _controller = ScrollController();

  late AppStore _appStore;
  late MessageStore _messageStore;
  late AuthStore _authStore;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() async {
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

    if (!_messageStore.loading) {
      _messageStore.getListNotify();
    }
  }

  void _onScroll() {
    if (!_controller.hasClients || _messageStore.loading || !_messageStore.canLoadMore) return;

    final thresholdReached = _controller.position.extentAfter < endReachedThreshold;

    if (thresholdReached) {
      _messageStore.getListNotify();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: baseStyleAppBar(
        context,
        title: AppLocalizations.of(context)!.translate('notifications_list_title'),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 10),
            child: IconButton(
              icon: const Icon(FeatherIcons.trash2),
              onPressed: () => buildDialog(context),
              iconSize: 20,
            ),
          )
        ],
      ),
      body: Observer(
        builder: (_) {
          List<MessageData> messages = _messageStore.messages;
          bool loading = _messageStore.loading;

          bool isShimmer = messages.isEmpty && loading;
          List<MessageData> loadingNotification =
              List.generate(10, (index) => MessageData(id: '', createdAt: '', seen: 0)).toList();

          List<MessageData> messData = isShimmer ? loadingNotification : messages;
          return Stack(
            children: [
              if (_authStore.isLogin) ...[
                CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  controller: _controller,
                  slivers: <Widget>[
                    CupertinoSliverRefreshControl(
                      onRefresh: () => _messageStore.refresh(),
                      builder: buildAppRefreshIndicator,
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          List<MessageData> data = messData;
                          return messData.isEmpty
                              ? _buildNotificationEmpty()
                              : buildItem(index, data[index], isShimmer);
                        },
                        childCount: messData.length,
                      ),
                    ),
                    if (_messageStore.loading && _messageStore.canLoadMore)
                      SliverToBoxAdapter(
                        child: buildLoading(context, isLoading: _messageStore.canLoadMore),
                      ),
                  ],
                ),
                if (_messageStore.messages.isEmpty && !_messageStore.loading) _buildNotificationEmpty(),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget buildItem(int index, MessageData message, bool isShimmer) {
    return Dismissible(
      // Each Dismissible must contain a Key. Keys allow Flutter to
      // uniquely identify widgets.
      key: UniqueKey(),
      direction: isShimmer ? DismissDirection.none : DismissDirection.horizontal,
      // Provide a function that tells the app
      // what to do after an item has been swiped away.
      onDismissed: (direction) {
        _messageStore.removeMessageById(id: message.id);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.translate('notifications_list_delete')),
          action: SnackBarAction(
            label: AppLocalizations.of(context)!.translate('undo'),
            onPressed: () {},
          ),
        ));
      },
      // Show a red background as the item is swiped away.
      background: Container(color: Colors.red),
      child: Column(
        children: [
          CirillaNotificationItem(message: message),
          const Padding(
            padding: paddingHorizontalLarge,
            child: Divider(height: 0),
          )
        ],
      ),
    );
  }

  Future<void> buildDialog(BuildContext context) async {
    String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate('notifications_list_dialog_title')),
        content: Text(AppLocalizations.of(context)!.translate('notifications_list_dialog_description')),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text(AppLocalizations.of(context)!.translate('notifications_list_dialog_cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: Text(AppLocalizations.of(context)!.translate('notifications_list_dialog_ok')),
          ),
        ],
      ),
    );
    if (result == "OK") {
      if (_authStore.isLogin && _messageStore.messages.isNotEmpty) {
        _messageStore.removeAllNotify();
      }
    }
  }

  Widget _buildNotificationEmpty() {
    return NotificationScreen(
      title: Text(AppLocalizations.of(context)!.translate('notifications_no'),
          style: Theme.of(context).textTheme.titleLarge),
      content: Text(AppLocalizations.of(context)!.translate('notifications_you_currently'),
          style: Theme.of(context).textTheme.bodyMedium),
      iconData: FeatherIcons.bell,
      textButton: Text(AppLocalizations.of(context)!.translate('notifications_back')),
      styleBtn: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 61)),
      onPressed: () => Navigator.pop(context),
    );
  }
}
