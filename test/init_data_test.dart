// Validate init data
//

import 'package:cirilla/constants/app.dart' as acf;
import 'package:cirilla/constants/credentials.dart' as acc;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Default Configs', () {
    test('Validate app.dart', () {
      const String baseUrl = 'https://grocery2.rnlab.io/';
      const String consumerKey = 'ck_838bbf4872ceebb7b598b55823d727e783fa6f31';
      const String consumerSecret = 'cs_1cb699a1d281e30f4ac4b7aa0c01400f120e8ee8';
      const String restPrefix = 'wp-json';
      const String defaultLanguage = 'en';
      const List<String> languageSupport = ['en', 'ar', 'tr', 'id'];
      const String googleClientId = '295269595518-e7s01ueadskq7sbg2k4g4dfnefpmd7vt.apps.googleusercontent.com';
      expect(acf.baseUrl, baseUrl);
      expect(acf.consumerKey, consumerKey);
      expect(acf.consumerSecret, consumerSecret);
      expect(acf.restPrefix, restPrefix);
      expect(acf.defaultLanguage, defaultLanguage);
      expect(acf.googleClientId, googleClientId);
      expect(acf.languageSupport, languageSupport);
    });

    test('Validate credentials.dart', () {
      const String googleMapApiKey = 'AIzaSyDUhpkpgOhIqchiP-IJmvMCpG3GOalBP3M';
      expect(acc.googleMapApiKey, googleMapApiKey);
    });
  });
}
