import 'package:awesome_drawer_bar/awesome_drawer_bar.dart';
import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/screens/home/home.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import 'package:cirilla/utils/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import 'utility_mixin.dart' show get;

class NavigationMixin {
  static const typeTab = 'tab';
  static const typeLauncher = 'launcher';
  static const typeShare = 'share';
  static const typeRate = 'rate';

  /// Handle navigate in app
  void navigate(BuildContext context, Map<String, dynamic>? data) async {
    SettingStore settingStore = Provider.of<SettingStore>(context, listen: false);
    Map<String, dynamic>? action = data;

    // User changed language
    if (settingStore.languageKey != 'text') {
      action = get(data, [settingStore.locale], data);
    }

    String? type = get(action, ['type'], 'tab');
    if (action == null || type == 'none') return;

    String? route = get(action, ['route'], '/');
    if (route == 'none') return;

    switch (type) {
      case typeTab:
        _openTab(context, action);
        break;
      case typeLauncher:
        _openLauncher(context, action);
        break;
      case typeRate:
        _openRate(context, action);
        break;
      case typeShare:
        _openShare(context, action);
        break;
      default:
        _openOther(context, action);
    }
  }

  /// Handle open tab
  ///
  void _openTab(BuildContext context, Map<String, dynamic>? action) async {
    String? tab = get(action, ['args', 'key'], Strings.tabActive);
    SettingStore store = Provider.of<SettingStore>(context, listen: false);
    store.setTab(tab);
    Navigator.popUntil(context, ModalRoute.withName(HomeScreen.routeName));
    if (AwesomeDrawerBar.of(context) != null && AwesomeDrawerBar.of(context)!.isOpen()) {
      AwesomeDrawerBar.of(context)!.toggle();
    }
  }

  /// Handle open link
  ///
  void _openLauncher(BuildContext context, Map<String, dynamic>? action) async {
    Map<String, dynamic> args = get(action, ['args'], {});
    String url = get(args, ['url'], '/');
    launch(url);
  }

  /// Handle open share
  ///
  void _openShare(BuildContext context, Map<String, dynamic>? action) async {
    Map<String, dynamic> args = get(action, ['args'], {});
    String content = get(args, ['content'], '');
    String? subject = get(args, ['subject'], null);
    Share.share(content, subject: subject);
  }

  /// Handle rate app
  ///
  void _openRate(BuildContext context, Map<String, dynamic>? action) async {
    Map<String, dynamic> args = get(action, ['args'], {});
    final InAppReview inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      String appStoreId = get(args, ['appStoreId'], '');
      String microsoftStoreId = get(args, ['microsoftStoreId'], '');
      inAppReview.openStoreListing(
        appStoreId: appStoreId,
        microsoftStoreId: microsoftStoreId,
      );
    }
  }

  /// Handle open other link
  ///
  void _openOther(BuildContext context, Map<String, dynamic>? action) async {
    String route = get(action, ['route'], '/');
    if (route == 'none') return;

    Map<String, dynamic> args = get(action, ['args'], {});

    if ((route == '/product' || route == '/post' || route == '/order_detail') && args['id'] != null) {
      route = '$route/${args['id']}';
    }

    Navigator.of(context).pushNamed(route, arguments: args);
  }
}
