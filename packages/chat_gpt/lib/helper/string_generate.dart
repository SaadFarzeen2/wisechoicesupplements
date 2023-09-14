import 'dart:math';

class StringGenerate {
  static String uuid([int length = 9]) {
    Random r = Random();
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(length, (index) => chars[r.nextInt(chars.length)]).join();
  }
}