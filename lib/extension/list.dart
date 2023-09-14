extension ListEquals on List {
  /// equals two list
  bool equals(List list) {
    if (length != list.length) return false;
    return every((item) => list.contains(item));
  }
}
