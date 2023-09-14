import 'package:cirilla/constants/app.dart';
import 'package:cirilla/constants/languages.dart';

///
/// Remove empty string in query string and default language is not unnecessary
///
Map<String, dynamic> preQueryParameters(Map<String, dynamic> qs) {
  Map<String, dynamic> params = Map<String, dynamic>.of(qs);
  params.removeWhere((key, value) => value == null || value == "");
  if (multiLanguagePlugin != 'Polylang') {
    params.removeWhere((key, value) => key == 'lang' && value == defaultLanguage);
  }
  return params;
}
