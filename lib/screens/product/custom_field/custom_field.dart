import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:flutter/material.dart';

import 'progress_indicator.dart';
import 'text.dart';
import 'text_area.dart';
import 'image.dart';
import 'select.dart';
import 'checkbox.dart';
import 'switch.dart';
import 'link.dart';
import 'taxonomy.dart';
import 'user.dart';
import 'date.dart';
import 'color.dart';
import 'file.dart';
import 'google_map.dart';
import 'embed.dart';
import 'base64.dart';
import 'html.dart';

class AdvancedFieldsCustomView extends StatelessWidget with Utility {
  final Map? fields;
  final String? align;
  final String? fieldName;
  final Color? color;

  const AdvancedFieldsCustomView({
    Key? key,
    this.fields,
    this.align,
    this.fieldName,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (fieldName?.isNotEmpty == true && fields != null && fields![fieldName] is Map) {
      Map data = fields![fieldName];
      String type = get(data, ['type'], '');
      dynamic value = get(data, ['value'], null);
      dynamic height = get(data, ['height'], 200);

      switch (type) {
        case 'text':
        case 'number':
        case 'range':
        case 'email':
        case 'url':
        case 'password':
          return FieldText(
            value: value,
            align: align,
            type: type,
            color: color,
          );
        case 'progress-indicator':
          return ProgressIndicatorField(value: value);
        case 'textarea':
          String line = get(data, ['new_lines'], '');
          return FieldTextArea(
            value: value,
            align: align,
            line: line,
            color: color,
          );
        case 'wysiwyg':
          return FieldTextArea(
            value: value,
            align: align,
            line: 'wpautop',
            color: color,
          );
        case 'oembed':
          return FieldEmbed(
            value: value,
          );
        case 'image':
          String format = get(data, ['return_format'], 'array');
          return FieldImage(
            value: value,
            format: format,
          );
        case 'select':
        case 'radio':
        case 'button_group':
          Map choices = get(data, ['choices'], {});
          String format = get(data, ['return_format'], 'value');
          return FieldSelect(
            value: value,
            align: align,
            choices: choices,
            format: format,
            color: color,
          );
        case 'checkbox':
          Map choices = get(data, ['choices'], {});
          String format = get(data, ['return_format'], 'value');
          return FieldCheckbox(
            value: value,
            align: align,
            choices: choices,
            format: format,
            color: color,
          );
        case 'true_false':
          return FieldSwitch(
            value: value,
            align: align,
            color: color,
          );
        case 'link':
          String format = get(data, ['return_format'], 'array');
          return FieldLink(
            value: value,
            align: align,
            format: format,
          );
        case 'taxonomy':
          String format = get(data, ['return_format'], 'array');
          return FieldTaxonomy(
            value: value,
            align: align,
            format: format,
            color: color,
          );
        case 'user':
          String format = get(data, ['return_format'], 'array');
          return FieldUser(
            value: value,
            align: align,
            format: format,
            color: color,
          );
        case 'date_picker':
        case 'date_time_picker':
        case 'time_picker':
          return FieldDate(
            value: value,
            align: align,
            color: color,
          );
        case 'color_picker':
          String format = get(data, ['return_format'], 'string');
          return FieldColor(
            value: value,
            align: align,
            format: format,
            color: color,
          );
        case 'file':
          String format = get(data, ['return_format'], 'array');
          return FieldFile(
            value: value,
            format: format,
          );
        case 'page_link':
          return FieldText(
            value: value,
            align: align,
            type: 'url',
            color: color,
          );
        case 'google_map':
          return FieldGoogleMap(value: value);
        case 'base64':
          String label = get(data, ['label'], '');
          return Base64Image(
            value: value,
            label: label,
          );
        case 'html':
          return FieldHtml(value: value, height: ConvertData.stringToDouble(height));
        default:
          return FieldText(
            value: value,
            align: align,
            color: color,
          );
      }
    }
    return Container();
  }
}
