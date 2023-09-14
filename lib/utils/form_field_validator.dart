String? emailValidator({required String value, String? errorEmail}) {
  const Pattern emailPattern =
      r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";
  if (!RegExp(emailPattern as String).hasMatch(value)) {
    return errorEmail;
  }
  return null;
}

String? phoneValidator({required String value, String? errorPhone}) {
  String pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
  if (!RegExp(pattern).hasMatch(value)) {
    return errorPhone;
  }
  return null;
}

String? changePassword({
  required String value,
  String? errorPassNew,
  String? errorCharInLength,
  String? errorUpperCase,
  String? errorLowerCase,
  String? errorDigit,
  String? errorSpecial,
  String? errorNewDiffOld,
  String? password,
}) {
  if (value.isEmpty) {
    return errorPassNew;
  }
  if (!RegExp(r'^.{8,}$').hasMatch(value)) {
    return errorCharInLength;
  }
  if (!RegExp(r'^(?=.*?[A-Z])').hasMatch(value)) {
    return errorUpperCase;
  }
  if (!RegExp(r'^(?=.*?[a-z])').hasMatch(value)) {
    return errorLowerCase;
  }
  if (!RegExp(r'^(?=.*?[0-9])').hasMatch(value)) {
    return errorDigit;
  }
  if (!RegExp(r'^(?=.*?[!@#\$&*~])').hasMatch(value)) {
    return errorSpecial;
  }
  if (value == password) {
    return errorNewDiffOld;
  }
  return null;
}

String? letterValidator({required String value, String? errorLetter}) {
  const pattern = r'^[A-Za-z]*$';
  if (!RegExp(pattern).hasMatch(value)) {
    return errorLetter;
  }
  return null;
}

String? numberValidator({required String value, String? errorNumber}) {
  const pattern = r'^[0-9]*$';
  if (!RegExp(pattern).hasMatch(value)) {
    return errorNumber;
  }
  return null;
}

String? letterNumberValidator({required String value, String? errorLetterNumber}) {
  const pattern = r'^[A-Za-z0-9]*$';
  if (!RegExp(pattern).hasMatch(value)) {
    return errorLetterNumber;
  }
  return null;
}
