///
/// Test Conditionals

import 'package:flutter_test/flutter_test.dart';

import 'package:cirilla/utils/conditionals.dart';

void main() {
  /// Operators
  group('Conditionals - operators', () {
    test('is_equal_to', () {
      expect(operators('is_equal_to', '1', '1'), true);
      expect(operators('is_equal_to', true, true), true);
      expect(operators('is_equal_to', false, false), true);
      expect(operators('is_equal_to', null, null), true);
      expect(operators('is_equal_to', "aaa", "aaa"), true);
      expect(operators('is_equal_to', "aaa", "aaa2"), false);
      expect(operators('is_equal_to', 1, 2), false);
      expect(operators('is_equal_to', true, false), false);
      expect(operators('is_equal_to', 'true', false), false);
    });

    test('is_not_equal_to', () {
      expect(operators('is_not_equal_to', '1', '1'), false);
      expect(operators('is_not_equal_to', true, true), false);
      expect(operators('is_not_equal_to', false, false), false);
      expect(operators('is_not_equal_to', null, null), false);
      expect(operators('is_not_equal_to', "aaa", "aaa"), false);
      expect(operators('is_not_equal_to', "aaa", "aaa2"), true);
      expect(operators('is_not_equal_to', 1, 2), true);
      expect(operators('is_not_equal_to', true, false), true);
      expect(operators('is_not_equal_to', 'true', false), true);
    });
  });

  group('conditionalCheck', () {
    test('Test conditionals should return truly', () {
      String conditional = 'show_if';
      List<dynamic> conditionals = [
        [
          {'value1': '{id}', 'operator': 'is_equal_to', 'value2': '1'},
        ],
      ];
      List<String> variableKeys = ['id', 'name', 'slug', 'type', 'status', 'sku', 'stock_status'];

      dynamic getVariable(String operator) {
        switch (operator) {
          case 'id':
            return 1;
          case 'name':
            return 'Iphone';
          default:
            return '';
        }
      }

      expect(conditionalCheck(conditional, conditionals, variableKeys, getVariable), true);

      List<dynamic> conditionals2 = [
        [
          {'value1': '{name}', 'operator': 'is_equal_to', 'value2': 'Iphone'},
        ],
      ];

      expect(conditionalCheck(conditional, conditionals2, variableKeys, getVariable), true);


      List<dynamic> conditionals3 = [
        [
          {'value1': '{id}', 'operator': 'is_equal_to', 'value2': '1'},
          {'value1': '{name}', 'operator': 'is_equal_to', 'value2': 'Iphone'},
        ],
      ];

      expect(conditionalCheck(conditional, conditionals3, variableKeys, getVariable), true);

      List<dynamic> conditionals4 = [
        [
          {'value1': '{id}', 'operator': 'is_equal_to', 'value2': '1'},
        ],
        [
          {'value1': '{name}', 'operator': 'is_equal_to', 'value2': 'Iphone'},
        ]
      ];

      expect(conditionalCheck(conditional, conditionals4, variableKeys, getVariable), true);

      List<dynamic> conditionals5 = [
        [
          {'value1': '{id}', 'operator': 'is_equal_to', 'value2': '1'},
        ],
        [
          {'value1': '{name}', 'operator': 'is_equal_to', 'value2': 'Iphone 222'},
        ]
      ];

      expect(conditionalCheck(conditional, conditionals5, variableKeys, getVariable), true);

    });
    test('Test conditionals should return falsely', () {
      String conditional = 'show_if';
      List<dynamic> conditionals = [
        [
          {'value1': '{id}', 'operator': 'is_equal_to', 'value2': '2'},
        ],
      ];
      List<String> variableKeys = ['id', 'name', 'slug', 'type', 'status', 'sku', 'stock_status'];

      dynamic getVariable(String operator) {
        switch (operator) {
          case 'id':
            return 1;
          case 'name':
            return 'Iphone';
          default:
            return '';
        }
      }

      expect(conditionalCheck(conditional, conditionals, variableKeys, getVariable), false);

      List<dynamic> conditionals2 = [
        [
          {'value1': '{name}', 'operator': 'is_equal_to', 'value2': 'Iphone1'},
        ],
      ];

      expect(conditionalCheck(conditional, conditionals2, variableKeys, getVariable), false);


      List<dynamic> conditionals3 = [
        [
          {'value1': '{id}', 'operator': 'is_equal_to', 'value2': '2'},
          {'value1': '{name}', 'operator': 'is_equal_to', 'value2': 'Iphone'},
        ],
      ];

      expect(conditionalCheck(conditional, conditionals3, variableKeys, getVariable), false);

      List<dynamic> conditionals4 = [
        [
          {'value1': '{id}', 'operator': 'is_equal_to', 'value2': '2'},
        ],
        [
          {'value1': '{name}', 'operator': 'is_equal_to', 'value2': 'Iphone2'},
        ]
      ];

      expect(conditionalCheck(conditional, conditionals4, variableKeys, getVariable), false);

    });
  });
}
