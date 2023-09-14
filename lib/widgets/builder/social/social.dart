import 'package:awesome_icons/awesome_icons.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cirilla/utils/url_launcher.dart';

class SocialWidget extends StatelessWidget with Utility, ContainerMixin {
  final WidgetConfig? widgetConfig;

  SocialWidget({
    Key? key,
    required this.widgetConfig,
  }) : super(key: key);

  void share(String? url) {
    if (url is String && url != '') {
      launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    SettingStore settingStore = Provider.of<SettingStore>(context);
    String themeModeKey = settingStore.themeModeKey;
    String languageKey = settingStore.languageKey;

    // Styles
    Map<String, dynamic> styles = widgetConfig?.styles ?? {};
    Map<String, dynamic>? margin = get(styles, ['margin'], {});
    Map<String, dynamic>? padding = get(styles, ['padding'], {});
    Color background = ConvertData.fromRGBA(get(styles, ['background', themeModeKey], {}), Colors.transparent);

    // General config
    Map<String, dynamic> fields = widgetConfig?.fields ?? {};
    String? alignment = get(fields, ['alignment'], 'center');
    double pad = ConvertData.stringToDouble(get(fields, ['pad'], 0));
    List items = get(fields, ['socials'], []);

    return Container(
      margin: ConvertData.space(margin, 'margin'),
      padding: ConvertData.space(padding, 'padding'),
      decoration: decorationColorImage(color: background),
      child: Wrap(
        spacing: pad,
        runSpacing: pad,
        alignment: wrapAlignment(alignment),
        children: List.generate(items.length, (index) {
          Map item = items[index];
          Map icon = get(item, [
            'data',
            'icon'
          ], {
            'name': "fab-facebook",
            'type': "awesome",
          });
          Color backgroundIcon =
              ConvertData.fromRGBA(get(item, ['data', 'backgroundColor', themeModeKey], {}), Colors.transparent);
          Color colorIcon =
              ConvertData.fromRGBA(get(item, ['data', 'iconColor', themeModeKey], {}), theme.primaryColor);
          String? url = ConvertData.stringFromConfigs(get(item, ['data', 'linkSocial', languageKey], ''));
          bool enableRound = get(item, ['data', 'enableRound'], false);
          bool enableOutLine = get(item, ['data', 'enableOutLine'], true);

          SocialType typeButton = enableRound ? SocialType.circle : SocialType.square;
          return CirillaButtonSocial(
            icon: getIconData(data: icon) ?? fontAwesomeIcons['fab-facebook']!,
            background: backgroundIcon,
            color: colorIcon,
            size: 34,
            sizeIcon: 14,
            isBorder: enableOutLine,
            type: typeButton,
            onPressed: () => share(url),
          );
        }),
      ),
    );
  }

  WrapAlignment wrapAlignment(String? type) {
    switch (type) {
      case 'left':
        return WrapAlignment.start;
      case 'right':
        return WrapAlignment.end;
      default:
        return WrapAlignment.center;
    }
  }
}
