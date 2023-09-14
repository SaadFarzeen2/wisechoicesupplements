import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:gutenberg_blocks/gutenberg_blocks.dart';

import 'html_text.dart';

class PrettyList extends StatelessWidget with Utility {
  final Map<String, dynamic>? block;

  const PrettyList({Key? key, this.block}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Map? attrs = get(block, ['attrs'], {}) is Map ? get(block, ['attrs'], {}) : {};
    String? type = get(attrs, ['type'], 'arrow');
    List items = get(attrs, ['items'], []);

    List<String?> data = [];
    if (items.isNotEmpty) {
      for (int i = 0; i < items.length; i++) {
        data.add(get(items[i], ['text'], ''));
      }
    }

    IconData icon = type == 'check'
        ? FeatherIcons.checkCircle
        : type == 'star'
            ? FeatherIcons.star
            : type == 'bullet'
                ? FeatherIcons.circle
                : FeatherIcons.chevronRight;
    Color? colorIcon = type == 'check'
        ? ColorBlock.green
        : type == 'star' || type == 'arrow'
            ? ColorBlock.yellow
            : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(data.length, (index) {
        double pad = index < data.length - 1 ? 16 : 0;
        return Padding(
          padding: EdgeInsets.only(bottom: pad),
          child: PrettyListItem(
            icon: Icon(
              icon,
              size: 20,
              color: colorIcon,
            ),
            title: HtmlText(
              text: data[index],
              fontColor: theme.textTheme.titleMedium?.color,
              fontSize: theme.textTheme.bodyMedium?.fontSize,
            ),
          ),
        );
      }),
    );
  }
}
