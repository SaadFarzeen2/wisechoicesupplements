import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/product/add_on/model.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/utils/utils.dart';

import 'helper.dart';

Map<String, String> validateAddOn({
  Product? product,
  required Map<String, AddOnData> data,
  required TranslateType translate,
}) {
  Map<String, String> result = {};

  Map<String, dynamic> metaData = product?.metaData!.firstWhere(
        (e) => e['key'] == 'product_addons',
        orElse: () => {'value': []},
      ) ??
      {'value': []};

  if (metaData['value'].isNotEmpty) {
    for (Map<String, dynamic> item in metaData['value']) {
      String keyValue = getFieldAddOn(item);
      bool required = get(item, ['required'], 0) == 1;
      String type = item['type'];

      if (required && !checkExistValue(data[keyValue])) {
        result[keyValue] = getErrorRequired(type, translate);
      } else {
        if (type == 'custom_text') {
          String restrictionsType = get(item, ['restrictions_type'], 'any_text');
          String? errorText = getErrorText(
            data[keyValue]?.string?.value ?? '',
            restrictionsType,
            translate,
          );
          if (errorText != null) {
            result[keyValue] = errorText;
          }
        } else if (type == 'custom_price' || type == 'input_multiplier') {
          int min = ConvertData.stringToInt(item['min']);
          int max = ConvertData.stringToInt(item['max']);
          String? errorText = getErrorNumber(
            data[keyValue]?.string?.value ?? '',
            min,
            max,
            translate,
          );
          if (errorText != null) {
            result[keyValue] = errorText;
          }
        }
      }
    }
  }

  return result;
}

bool checkExistValue(dynamic value) {
  if (value is AddOnData) {
    return (value.type == AddOnDataType.string && value.string?.value != null) ||
        (value.type == AddOnDataType.option && value.option?.value != null) ||
        (value.type == AddOnDataType.listOption && value.listOption?.isNotEmpty == true);
  }
  return false;
}

String getErrorRequired(String type, TranslateType translate) {
  if (type == 'multiple_choice') {
    return translate('product_addon_single_choice');
  }
  if (type == 'checkbox') {
    return translate('product_addon_checkbox');
  }
  return translate('product_addon_text');
}

String? getErrorText(String value, String restrictionsType, TranslateType translate) {
  if (value.isEmpty) return null;
  if (restrictionsType == 'only_letters') {
    return letterValidator(value: value, errorLetter: translate('product_addon_letter'));
  }
  if (restrictionsType == 'only_numbers') {
    return numberValidator(value: value, errorNumber: translate('product_addon_number'));
  }
  if (restrictionsType == 'only_letters_numbers') {
    return letterNumberValidator(value: value, errorLetterNumber: translate('product_addon_letter_number'));
  }
  if (restrictionsType == 'email') {
    return emailValidator(value: value, errorEmail: translate('product_addon_email'));
  }
  return null;
}

String? getErrorNumber(String value, int min, int max, TranslateType translate) {
  if (value.isEmpty) return null;

  int? valueInt = int.tryParse(value);

  if (valueInt == null) return translate('product_addon_number');

  if (min == max && max == 0) return null;

  if (min == max && max != 0 && valueInt != max) {
    return translate('product_addon_compare_number', {
      'compare': '=',
      'value': max.toString(),
    });
  }

  if (valueInt < min) {
    return translate('product_addon_compare_number', {
      'compare': '>=',
      'value': min.toString(),
    });
  }

  if (max > 0 && valueInt > max) {
    return translate('product_addon_compare_number', {
      'compare': '<=',
      'value': max.toString(),
    });
  }

  return null;
}
