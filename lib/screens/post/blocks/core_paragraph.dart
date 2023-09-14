import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

import 'html_text.dart';

Map<String, Style> styleBlog({String align = 'left', double fontSize = 15}) {
  return {
    'html': Style(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
    ),
    'body': Style(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
    ),
    'p': Style(
      lineHeight: const LineHeight(1.8),
      fontSize: FontSize(fontSize),
      padding: EdgeInsets.zero,
      textAlign: ConvertData.toTextAlign(align),
    ),
    'div': Style(
      lineHeight: const LineHeight(1.8),
      fontSize: FontSize(fontSize),
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
    ),
    'img': Style(
      padding: paddingVerticalTiny,
    )
  };
}

class Paragraph extends StatelessWidget with Utility {
  final Map<String, dynamic>? block;

  final String? alignCover;

  const Paragraph({Key? key, this.block, this.alignCover}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map attrs = get(block, ['attrs'], {}) is Map ? get(block, ['attrs'], {}) : {};

    String alignCover = attrs['align'] ?? '';

    Map? style = get(attrs, ['style'], {}) is Map ? get(attrs, ['style'], {}) : {};

    int fontSize = get(style, ['typography', 'fontSize'], 15);

    return HtmlText(
      text: '${block!['innerHTML']}',
      fontSize: fontSize.toDouble(),
      textAlign: ConvertData.toTextAlign(alignCover),
    );
  }
}
