import 'package:awesome_icons/awesome_icons.dart';
import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cirilla/utils/url_launcher.dart';

class ProfileFooter extends StatelessWidget with Utility {
  final String? copyright;
  final List? socials;

  const ProfileFooter({Key? key, this.copyright, this.socials}) : super(key: key);

  void share(String? url) {
    if (url is String && url != '') {
      launch(url);
    }
  }

  Widget buildItem({
    Map? item,
    int? index,
    int? length,
    required ThemeData theme,
    required String themeModeKey,
    required String languageKey,
  }) {
    String? url = get(item, ['data', 'linkSocial', languageKey], '');
    Map icon = get(item, [
      'data',
      'icon'
    ], {
      'name': "fab-facebook",
      'type': "awesome",
    });
    Color backgroundIcon = ConvertData.fromRGBA(
      get(item, ['data', 'backgroundColor', themeModeKey], {}),
      Colors.transparent,
    );
    Color colorIcon = ConvertData.fromRGBA(
      get(item, ['data', 'iconColor', themeModeKey], {}),
      theme.primaryColor,
    );

    bool enableRound = get(item, ['data', 'enableRound'], false);
    bool enableOutLine = get(item, ['data', 'enableOutLine'], true);

    SocialType typeButton = enableRound ? SocialType.circle : SocialType.square;

    return Padding(
      padding: EdgeInsetsDirectional.only(start: index != 0 ? 16 : 0),
      child: CirillaButtonSocial(
        icon: getIconData(data: icon) ?? fontAwesomeIcons['fab-facebook']!,
        background: backgroundIcon,
        color: colorIcon,
        size: 34,
        sizeIcon: 14,
        isBorder: enableOutLine,
        type: typeButton,
        onPressed: () => share(url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    SettingStore settingStore = Provider.of<SettingStore>(context);
    String themeModeKey = settingStore.themeModeKey;
    String languageKey = settingStore.languageKey;

    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(child: Text(copyright!, style: theme.textTheme.bodySmall)),
          if (socials!.isNotEmpty) ...[
            const SizedBox(width: 16),
            Wrap(
              children: List.generate(
                socials!.length,
                (index) => buildItem(
                  item: socials![index],
                  index: index,
                  length: socials!.length,
                  theme: theme,
                  themeModeKey: themeModeKey,
                  languageKey: languageKey,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
