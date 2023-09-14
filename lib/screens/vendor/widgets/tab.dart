import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/types/types.dart';
import 'package:flutter/material.dart';
import 'package:ui/tab/sticky_tab_bar_delegate.dart';

class TabWidget extends StatelessWidget {
  final List<String>? tabs;
  final TranslateType? translate;
  final TabController? controller;
  final Function(String value)? onChanged;

  const TabWidget({Key? key, this.tabs, this.translate, this.controller, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: StickyTabBarDelegate(
        child: Container(
          color: theme.scaffoldBackgroundColor,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(top: itemPaddingExtraLarge, bottom: itemPaddingLarge),
          child: TabBar(
            labelPadding: paddingHorizontalMedium,
            onTap: (int index) => onChanged!(tabs!.elementAt(index)),
            isScrollable: true,
            labelColor: theme.primaryColor,
            controller: controller,
            labelStyle: theme.textTheme.titleSmall,
            unselectedLabelColor: theme.textTheme.titleSmall?.color,
            indicatorWeight: 2,
            indicatorColor: theme.primaryColor,
            indicatorPadding: paddingHorizontalMedium,
            tabs: List.generate(tabs!.length, (index) {
              String keyTab = tabs!.elementAt(index);
              return Text(translate!('vendor_detail_$keyTab').toUpperCase());
            }),
          ),
        ),
        height: 80,
      ),
    );
  }
}
