import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_html.dart';
import 'package:flutter/material.dart';

class FieldTextArea extends StatelessWidget {
  final dynamic value;
  final String? align;
  final String line;
  final Color? color;

  const FieldTextArea({
    Key? key,
    this.value,
    this.align,
    this.line = '',
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextAlign textAlign = ConvertData.toTextAlignDirection(align);

    String text = value is String ? value : '';
    if (line == 'br' || line == 'wpautop') {
      return CirillaHtml(html: '<div>$text</div>');
    }
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(color: color),
    );
  }
}
