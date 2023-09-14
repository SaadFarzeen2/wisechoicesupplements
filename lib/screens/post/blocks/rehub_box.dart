import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:awesome_icons/awesome_icons.dart';
import 'package:gutenberg_blocks/gutenberg_blocks.dart';
import 'package:ui/badge/badge.dart';

import 'html_text.dart';

class Box extends StatelessWidget with Utility {
  final Map<String, dynamic>? block;

  const Box({Key? key, this.block}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Map? attrs = get(block, ['attrs'], {}) is Map ? get(block, ['attrs'], {}) : {};
    bool? takeDate = get(attrs, ['takeDate'], false);
    String? textalign = get(attrs, ['textalign'], 'left');
    String? type = get(attrs, ['type'], 'default');
    String? content = get(attrs, ['content'], '');
    String? date = get(attrs, ['date'], '');
    String? label = get(attrs, ['label'], 'Update');

    TextAlign textAlign = ConvertData.toTextAlign(textalign);
    InfoBoxAlign boxAlign = textalign == 'center'
        ? InfoBoxAlign.center
        : textalign == 'justify'
            ? InfoBoxAlign.justify
            : textalign == 'right'
                ? InfoBoxAlign.right
                : InfoBoxAlign.left;

    Color background = ColorBlock.greenLighter;
    Color? textColor = ColorBlock.greenLight;
    IconData? icon;
    Color? iconColor;
    // avoidPrint(theme.textTheme.titleMedium?.color);
    switch (type) {
      case 'info':
        background = ColorBlock.greenLightest;
        textColor = ColorBlock.black;
        icon = FeatherIcons.link;
        iconColor = ColorBlock.green;
        break;
      case 'download':
        background = ColorBlock.blueLightest;
        textColor = ColorBlock.black;
        icon = FeatherIcons.download;
        iconColor = ColorBlock.blueLight;
        break;
      case 'error':
        background = ColorBlock.redLighter;
        textColor = ColorBlock.redBase;
        iconColor = ColorBlock.redBase;
        icon = FeatherIcons.slash;
        break;
      case 'warning':
        background = ColorBlock.orangeLightest;
        textColor = ColorBlock.redDark;
        iconColor = ColorBlock.orange;
        icon = FontAwesomeIcons.exclamationTriangle;
        break;
      case 'yellow':
        background = ColorBlock.yellowLightest;
        textColor = ColorBlock.orangeDark;
        break;
      case 'green':
        background = ColorBlock.greenLighter;
        textColor = ColorBlock.greenLight;
        break;
      case 'gray':
        background = ColorBlock.gray1;
        textColor = ColorBlock.gray2;
        break;
      case 'red':
        background = ColorBlock.redLightest;
        textColor = ColorBlock.pink;
        break;
      case 'dashed_border':
        background = Colors.transparent;
        textColor = theme.textTheme.titleMedium?.color;
        break;
      case 'solid_border':
        background = Colors.transparent;
        textColor = theme.textTheme.titleMedium?.color;
        break;
      case 'transparent':
        background = Colors.transparent;
        textColor = theme.textTheme.titleMedium?.color;
        break;
    }
    String? textDate = label!.isNotEmpty ? '$date $label' : date;

    return buildViewBorder(
      borderType: type,
      theme: theme,
      child: InfoBox(
        icon: icon != null ? Icon(icon, color: iconColor, size: 22) : null,
        title: content!.isNotEmpty
            ? HtmlText(
                text: content,
                fontColor: textColor,
                fontSize: theme.textTheme.bodyLarge?.fontSize,
                textAlign: textAlign,
              )
            : null,
        date: takeDate!
            ? BadgeUi(
                text: Text(
                  textDate!,
                  style: theme.textTheme.titleSmall?.copyWith(color: Colors.white),
                ),
                color: ColorBlock.blueLighter,
                size: 29,
                padding: paddingHorizontalMedium,
              )
            : null,
        background: background,
        align: boxAlign,
      ),
    )!;
  }

  Widget? buildViewBorder({Widget? child, String? borderType, ThemeData? theme}) {
    switch (borderType) {
      case 'dashed_border':
        return DottedBorder(
          borderType: BorderType.RRect,
          color: theme!.dividerColor,
          dashPattern: const [4, 3],
          padding: EdgeInsets.zero,
          child: child!,
        );
      case 'solid_border':
        Border border = Border.all(color: theme!.dividerColor);
        return Container(
          decoration: BoxDecoration(border: border),
          child: child,
        );
      default:
        return child;
    }
  }
}
