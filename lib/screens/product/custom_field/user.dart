import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';

class FieldUser extends StatelessWidget with Utility {
  final dynamic value;
  final String? align;
  final String format;
  final Color? color;

  const FieldUser({
    Key? key,
    this.value,
    this.align,
    this.format = 'object',
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (format == 'id' && (value is int || (value is String && !value.isEmpty))) {
      TextAlign textAlign = ConvertData.toTextAlignDirection(align);
      return Text(
        '$value',
        textAlign: textAlign,
        style: TextStyle(color: color),
      );
    }
    if (value is Map) {
      late String text;
      switch (format) {
        case 'array':
          text = get(value, ['display_name'], '');
          break;
        case 'object':
          text = get(value, ['data', 'display_name'], '');
          break;
        default:
          text = '';
      }
      TextAlign textAlign = ConvertData.toTextAlignDirection(align);
      return Text(
        text,
        textAlign: textAlign,
        style: TextStyle(color: color),
      );
    }

    return Container();
  }

  String getObject(List data) {
    List<String> arrLabel = [];
    for (var item in data) {
      if (item is Map) {
        String label = get(item, ['name'], '');
        arrLabel.add(label);
      }
    }
    return arrLabel.join(', ');
  }

  String getStringId(List data) {
    List<String> arrLabel = [];
    for (var item in data) {
      arrLabel.add('$item');
    }
    return arrLabel.join(', ');
  }
}
