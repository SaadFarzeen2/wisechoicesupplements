class IdReplace {
  static String? idReplaceAllMapped(String? str) {
    RegExp regId = RegExp(r'(#[0-9]+)');
    if (str != null) {
      String replaceHtml = str.replaceAllMapped(regId, (match) {
        return '<a id=${regId.stringMatch(str)?.substring(1)}>${regId.stringMatch(str)}</a>';
      });
      return replaceHtml;
    }
    return null;
  }
}
