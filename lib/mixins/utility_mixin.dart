import 'dart:developer';

dynamic get(dynamic data, List<dynamic> paths, [defaultValue]) {
  if (data == null || (paths.isNotEmpty && !(data is Map || data is List)))
    return defaultValue;
  if (paths.isEmpty) return data ?? defaultValue;
  List<dynamic> newPaths = List.of(paths);
  String? key = newPaths.removeAt(0);
  return get(data[key], newPaths, defaultValue);
}

class Utility {
  /// Gets the value at path of Map. If the resolved value is null, the defaultValue is returned in its place.
  dynamic get(dynamic data, List<dynamic> paths, [defaultValue]) =>
      get(data, paths);
}
