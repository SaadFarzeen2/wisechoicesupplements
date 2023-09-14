import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/extension/strings.dart';
import 'package:cirilla/widgets/cirilla_shimmer.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class ItemLocation extends StatelessWidget with Utility {
  final bool primaryIcon;
  final String title;
  final String subTitle;
  final String search;
  final EdgeInsetsGeometry padding;
  final bool loading;
  final bool isDivider;
  final GestureTapCallback? onTap;

  ItemLocation({
    Key? key,
    this.primaryIcon = false,
    this.title = '',
    this.subTitle = '',
    this.search = '',
    this.padding = paddingVerticalMedium,
    this.loading = false,
    this.isDivider = true,
    this.onTap,
  }) : super(key: key);

  List getCutSearchString() {
    List data = [];
    String value = title.toLowerCase().normalize;

    String searchTrim =
        search.trim().split(' ').where((String str) => str.isNotEmpty).toList().join(' ').toLowerCase().normalize;

    int visitContains = value.indexOf(searchTrim);
    if (visitContains < 0) {
      data.add({
        'title': title,
        'isSearch': false,
      });
    } else {
      if (visitContains > 0) {
        data.add({
          'title': title.substring(0, visitContains),
          'isSearch': false,
        });
      }
      int endVisitContains = visitContains + searchTrim.length;
      data.add({
        'title': title.substring(visitContains, endVisitContains),
        'isSearch': true,
      });
      if (endVisitContains < value.length) {
        data.add({
          'title': title.substring(endVisitContains),
          'isSearch': false,
        });
      }
    }
    return data;
  }

  Widget buildTitle(ThemeData theme) {
    if (loading) {
      return CirillaShimmer(
        child: Container(
          height: 16,
          width: 120,
          color: Colors.white,
        ),
      );
    }

    List dataTitle = getCutSearchString();

    return RichText(
      text: TextSpan(
        style: theme.textTheme.titleSmall,
        children: List.generate(
          dataTitle.length,
          (index) {
            dynamic item = dataTitle[index];
            String title = get(item, ['title'], '');
            bool isSearch = get(item, ['isSearch'], false);
            return TextSpan(
              text: title,
              style: isSearch ? const TextStyle(color: ColorBlock.redBase) : null,
            );
          },
        ),
      ),
    );
  }

  Widget buildSubtitle(ThemeData theme) {
    if (loading) {
      return CirillaShimmer(
        child: Container(
          height: 16,
          width: 200,
          color: Colors.white,
        ),
      );
    }

    return Text(subTitle, style: theme.textTheme.bodySmall);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return InkWell(
      onTap: !loading ? onTap : null,
      child: Column(
        children: [
          Padding(
            padding: padding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Icon(
                    FeatherIcons.mapPin,
                    size: 16,
                    color: primaryIcon ? theme.primaryColor : theme.textTheme.bodySmall?.color,
                  ),
                ),
                const SizedBox(width: itemPaddingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTitle(theme),
                      const SizedBox(height: 5),
                      buildSubtitle(theme),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isDivider) const Divider(height: 1, thickness: 1),
        ],
      ),
    );
  }
}
