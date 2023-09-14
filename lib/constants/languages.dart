import 'package:flutter/material.dart';

// Manual config locale
// ignore: constant_identifier_names
const LANGUAGES = {
  'zh-hant': Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW'),
  'pt-br': Locale.fromSubtags(languageCode: 'pt', countryCode: 'BR'),
};

// with plugin is [WPML, Polylang]
const multiLanguagePlugin = 'WPML';
