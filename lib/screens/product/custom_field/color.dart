import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:flutter/material.dart';

class FieldColor extends StatelessWidget with Utility {
  final dynamic value;
  final String? align;
  final String format;
  final Color? color;

  const FieldColor({
    Key? key,
    this.value,
    this.align,
    this.format = 'string',
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextAlign textAlign = ConvertData.toTextAlignDirection(align);
    String text = '';

    switch (format) {
      case 'string':
        if (value is String && value.isNotEmpty == true) {
          text = value;
        }
        break;
      case 'array':
        if (value is Map) {
          int r = ConvertData.stringToInt(get(value, ['red'], 0));
          int g = ConvertData.stringToInt(get(value, ['green'], 0));
          int b = ConvertData.stringToInt(get(value, ['blue'], 0));
          double a = ConvertData.stringToDouble(get(value, ['alpha'], 1), 1);
          text = 'rgba($r, $g, $b, $a)';
        }
        break;
    }
    return Text(text, textAlign: textAlign, style: TextStyle(color: color));
  }
}
