// This test utility Pre Query Parameters
//

import 'package:cirilla/utils/query.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Pre Query Parameters', () {
    test('should be return without null value', () {
      final qs = {
        'a': null,
        'b': 1,
      };

      final qs2 = {
        'a': null,
        'b': 1,
        'c': 'c',
      };

      final result = {
        'b': 1,
      };

      final result2 = {
        'b': 1,
        'c': 'c',
      };

      expect(preQueryParameters(qs), result);
      expect(preQueryParameters(qs2), result2);
    });

    test('should be return without empty value', () {
      final qs = {
        'a': '',
        'b': 1,
      };

      final qs2 = {
        'a': '',
        'b': 1,
        'c': 'c',
      };

      final result = {
        'b': 1,
      };

      final result2 = {
        'b': 1,
        'c': 'c',
      };

      expect(preQueryParameters(qs), result);
      expect(preQueryParameters(qs2), result2);
    });

    test('should remove default language param', () {
      final qs = {
        'a': '',
        'b': 1,
        'lang': 'en',
      };

      final qs2 = {
        'a': '',
        'b': 1,
        'c': 'c',
        'lang': 'ar',
      };

      final result = {
        'b': 1,
      };

      final result2 = {
        'b': 1,
        'c': 'c',
        'lang': 'ar',
      };

      expect(preQueryParameters(qs), result);
      expect(preQueryParameters(qs2), result2);
    });
  });
}
