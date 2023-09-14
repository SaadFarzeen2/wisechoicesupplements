import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';

class FieldCheckbox extends StatelessWidget with Utility {
  final dynamic value;
  final String? align;
  final Map choices;
  final String format;
  final Color? color;

  const FieldCheckbox({Key? key, this.value, this.align, this.choices = const {}, this.format = 'value', this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (value is! List || (value is List && value.isEmpty == true)) {
      return Container();
    }
    late String text;
    switch (format) {
      case 'value':
        text = getStringValue(value, choices);
        break;
      case 'label':
        text = getStringLabel(value);
        break;
      case 'array':
        text = getStringArray(value);
        break;
      default:
        text = '';
    }
    TextAlign textAlign = ConvertData.toTextAlignDirection(align);
    return Text(text, textAlign: textAlign, style: TextStyle(color: color));
  }

  String getStringValue(List data, Map optionChoices) {
    List<String> arrLabel = [];
    for (var item in data) {
      if (item is String) {
        String label = get(choices, [item], item);
        arrLabel.add(label);
      }
    }
    return arrLabel.join(', ');
  }

  String getStringLabel(List data) {
    List<String> arrLabel = [];
    for (var item in data) {
      if (item is String) {
        arrLabel.add(item);
      }
    }
    return arrLabel.join(', ');
  }

  String getStringArray(List data) {
    List<String> arrLabel = [];
    for (var item in data) {
      if (item is Map) {
        String label = get(item, ['label'], '');
        arrLabel.add(label);
      }
    }
    return arrLabel.join(', ');
  }
}
