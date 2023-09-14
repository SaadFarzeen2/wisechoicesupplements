import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/setting/setting.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/extension/strings.dart';

import 'package:ui/product_category/product_category_text_center_item.dart';
import 'package:ui/product_category/product_category_text_left_item.dart';
import 'package:ui/product_category/product_category_text_right_item.dart';

class DrawerHelpInfo extends StatelessWidget with Utility, NavigationMixin {
  final Data? data;

  const DrawerHelpInfo({
    Key? key,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SettingStore settingStore = Provider.of<SettingStore>(context);
    String? languageKey = settingStore.languageKey;

    WidgetConfig sidebarData = data!.widgets!['sidebar']!;

    final itemsCustom = sidebarData.fields!['itemsCustomize'];

    String headerSideBar = get(sidebarData.fields, ['titleCustomize', languageKey], '');

    String? alignCustomize = get(sidebarData.fields, ['alignCustomize'], 'left');

    bool? enableIconCustomize = get(sidebarData.fields, ['enableIconCustomize'], true);

    return Column(
        crossAxisAlignment: alignCustomize == 'center'
            ? CrossAxisAlignment.center
            : alignCustomize == 'left'
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              bottom: itemPadding,
            ),
            child: Text(
              headerSideBar.unescape,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ...List.generate(itemsCustom.length, (index) {
            Map<String, dynamic>? itemsData = itemsCustom.elementAt(index)['data'];

            String title = get(itemsData, ['title', languageKey], '');

            Map<String, dynamic>? action = get(itemsData, ['action'], {});

            Map icons = get(itemsData, ['icon'], {});

            return Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    alignCustomize == 'left'
                        ? ProductCategoryTextLeftItem(
                            onTap: () => navigate(context, action),
                            name: Text(
                              title.unescape,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            image: enableIconCustomize == true ? buildIcon(icons: icons) : null,
                          )
                        : alignCustomize == 'right'
                            ? ProductCategoryTextRightItem(
                                onTap: () => navigate(context, action),
                                name: Text(
                                  title.unescape,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                image: enableIconCustomize == true ? buildIcon(icons: icons) : null,
                              )
                            : ProductCategoryTextCenterItem(
                                onTap: () => navigate(context, action),
                                name: Text(
                                  title.unescape,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                image: enableIconCustomize == true ? buildIcon(icons: icons) : null,
                              ),
                  ],
                ));
          })
        ]);
  }

  Widget buildIcon({Map? icons}) {
    return CirillaIconBuilder(
      data: icons,
      size: 14,
    );
  }
}
