/// Register more extension for String
extension StringParse on String {
  /// Remove special symbols in String
  String get removeSymbols {
    return replaceAll(RegExp(r'[^\w\s]+'), '');
  }

  /// Remove special character
  String get normalize {
    String specialChar = 'ÀÁÂÃÄÅẤàáâãäåấÒÓÔÕÕÖØòóôõöøÈÉÊËẾèéêëðếÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    String withoutSpecialChar = 'AAAAAAAaaaaaaaOOOOOOOooooooEEEEEeeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';
    String str = this;
    for (int i = 0; i < specialChar.length; i++) {
      str = str.replaceAll(specialChar[i], withoutSpecialChar[i]);
    }
    return str;
  }

  /// Converts the HTML entities ['&quot;', '&#34;', '&apos;', '&#39;', '&amp;', '&gt;', '&gt;', '&#62;', '&lt;', '&#60;'] in string to their corresponding characters.
  String get unescape {
    String str = this;
    List<String> es = ['&quot;', '&#34;', '&apos;', '&#39;', '&amp;', '&gt;', '&gt;', '&#62;', '&lt;', '&#60;'];
    List<String> withoutEs = ['"', '"', '\'', '\'', '&', '&', '>', '>', '<', '<'];
    for (int i = 0; i < es.length; i++) {
      str = str.replaceAll(es[i], withoutEs[i]);
    }
    return str;
  }
  String get removeHtmlTag{
    String str = this;
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return str.replaceAll(exp, '');
  }
}

extension CapExtension on String {
  String get inCaps => isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';

  String get allInCaps => toUpperCase();

  String get capitalizeFirstOfEach => replaceAll(RegExp(' +'), ' ').split(" ").map((str) => str.inCaps).join(" ");
}
