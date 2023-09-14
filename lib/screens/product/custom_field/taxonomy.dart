import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';

class FieldTaxonomy extends StatelessWidget with Utility {
  final dynamic value;
  final String? align;
  final String format;
  final Color? color;

  const FieldTaxonomy({
    Key? key,
    this.value,
    this.align,
    this.format = 'object',
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (value is! List || (value is List && value.isEmpty == true)) {
      return Container();
    }
    late String text;
    switch (format) {
      case 'object':
        text = getObject(value);
        break;
      case 'id':
        text = getStringId(value);
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
