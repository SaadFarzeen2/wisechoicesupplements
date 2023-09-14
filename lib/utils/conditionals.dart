/// Check conditional settings
///
bool conditionalCheck(
  String conditional,
  dynamic data,
  List<String> variableKeys,
  dynamic Function(String variable) getVariable,
) {
  if (conditional == 'always' || data is! List || data.isEmpty) {
    return true;
  }

  bool result = data.any((element) {
    if (element is List && element.isNotEmpty) {
      return element.every((els) {
        dynamic value1 = mergeTags(els['value1'], variableKeys, getVariable);
        dynamic value2 = mergeTags(els['value2'], variableKeys, getVariable);
        String operator = els['operator'];
        return operators(operator, value1, value2);
      });
    }
    return true;
  });

  return conditional == 'show_if' ? result : !result;
}

dynamic mergeTags(
  String? value,
  List<String> variableKeys,
  dynamic Function(String variable) getVariable,
) {
  String newValue = value ?? '';
  for (String tag in variableKeys) {
    dynamic replace = getVariable(tag);

    if (replace is List && '{$tag}' == value) {
      return replace;
    }

    newValue = newValue.replaceAll('{$tag}', '$replace');
  }
  // In some case the variable keys not exist we return empty value
  return newValue.startsWith('{') && newValue.endsWith('}') && newValue == value ? '' : newValue;
}

bool operators(String operator, dynamic value1, dynamic value2) {
  switch (operator) {
    case 'is_equal_to':
      return value1 == value2;
    case 'is_not_equal_to':
      return value1 != value2;
    case 'is_empty':
      return value1 == null || value1 == '' || '${value1.isEmpty}' == 'true';
    case 'is_not_empty':
      return value1 != null && value1 != '' && '${value1.isNotEmpty}' == 'true';
    case 'contains':
      return (value1 is String || value1 is List) && value2 is String && value1.contains(value2);
    case 'does_not_contain':
      return (value1 is String || value1 is List) && value2 is String && !value1.contains(value2);
    case 'match_regular_expressions':
      return RegExp(value2).hasMatch(value1);
    case 'is_less_than':
      return value1 < value2;
    case 'is_less_or_equal_to':
      return value1 <= value2;
    case 'is_greater_than':
      return value1 > value2;
    case 'is_greater_or_equal_to':
      return value1 >= value2;
    default:
      return false;
  }
}
