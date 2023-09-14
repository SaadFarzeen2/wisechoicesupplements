import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/app_bar_mixin.dart';
import 'package:cirilla/mixins/navigation_mixin.dart';
import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/models/setting/setting.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/widgets/cirilla_tile.dart';
import 'package:cirilla/extension/strings.dart';

class HelpInfoScreen extends StatelessWidget with Utility, NavigationMixin, AppBarMixin {
  static const String routeName = '/profile/help_info';

  final SettingStore? store;

  HelpInfoScreen({
    Key? key,
    this.store,
  }) : super(key: key);

  Widget buildItem(BuildContext context, {Map? item}) {
    ThemeData theme = Theme.of(context);
    SettingStore settingStore = Provider.of<SettingStore>(context);
    String? languageKey = settingStore.languageKey;

    String title = get(item, ['data', 'title', languageKey], '');
    Map<String, dynamic>? action = get(item, ['data', 'action'], {});

    return CirillaTile(
      title: Text(title.unescape, style: theme.textTheme.titleSmall),
      onTap: () => navigate(context, action),
    );
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    WidgetConfig widgetConfig = store!.data!.screens!['profile']!.widgets!['profilePage']!;
    Map<String, dynamic>? fields = widgetConfig.fields;

    List items = get(fields, ['itemInfo'], []);

    return Scaffold(
      appBar: baseStyleAppBar(context, title: translate('help_info')),
      body: SingleChildScrollView(
        padding: paddingHorizontal,
        child: Column(
          children: List.generate(items.length, (index) => buildItem(context, item: items[index])),
        ),
      ),
    );
  }
}
