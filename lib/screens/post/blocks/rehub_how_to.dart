import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:gutenberg_blocks/gutenberg_blocks.dart';

class RehubHowTo extends StatelessWidget with Utility {
  final Map<String, dynamic>? block;

  const RehubHowTo({Key? key, this.block}) : super(key: key);

  Widget buildStep({int? visit, dynamic item, Color? numberColor, Color? numberBgColor, required ThemeData theme}) {
    String title = get(item, ['title'], '');
    String content = get(item, ['content'], '');

    Color? colorBorder = numberBgColor ?? theme.textTheme.titleSmall?.color;

    return StepItem(
      visit: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: colorBorder ?? theme.dividerColor),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          '$visit',
          style: theme.textTheme.titleSmall?.copyWith(color: numberColor),
        ),
      ),
      title: Text(title, style: theme.textTheme.titleMedium),
      content: content.isNotEmpty ? Text(content, style: theme.textTheme.bodyMedium) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    Map? attrs = get(block, ['attrs'], {}) is Map ? get(block, ['attrs'], {}) : {};
    String title = get(attrs, ['title'], translate('post_detail_edit_title'));
    String description = get(attrs, ['description'], '');
    List tabs = get(attrs, ['tabs'], []);
    Color? titleColor =
        get(attrs, ['titleColor'], '') != '' ? ConvertData.fromHex(get(attrs, ['titleColor'], '')) : null;
    Color? borderColor =
        get(attrs, ['borderColor'], '') != '' ? ConvertData.fromHex(get(attrs, ['borderColor'], '')) : null;
    Color? numberColor =
        get(attrs, ['numberColor'], '') != '' ? ConvertData.fromHex(get(attrs, ['numberColor'], '')) : null;
    Color? numberBgColor =
        get(attrs, ['numberBgColor'], '') != '' ? ConvertData.fromHex(get(attrs, ['numberBgColor'], '')) : null;

    return HowTo(
      title: title.isNotEmpty
          ? Text(
              title.toUpperCase(),
              style: theme.textTheme.titleLarge?.copyWith(color: titleColor),
            )
          : null,
      description: description.isNotEmpty ? Text(description, style: theme.textTheme.bodyMedium) : null,
      borderColor: borderColor ?? theme.dividerColor,
      countStep: tabs.length,
      buildItemStep: (int index) {
        return buildStep(
          visit: index + 1,
          item: tabs[index],
          numberColor: numberColor,
          numberBgColor: numberBgColor,
          theme: theme,
        );
      },
    );
  }
}
