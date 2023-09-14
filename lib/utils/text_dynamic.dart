import 'package:cirilla/store/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class TextDynamic {
  static RegExp exp = RegExp(r"\{(.*?)\}");

  static String replace(txt, Map<String, String?> options) => txt.replaceAllMapped(exp, (Match m) {
        if (options.isEmpty) return m.group(0) ?? '';
        if (m.group(0) == null || m.group(1) == null) return '';
        return options[m.group(1)] ?? m.group(0) ?? '';
      });

  static String getTextDynamic(BuildContext context, {required String text}) {
    AuthStore authStore = Provider.of<AuthStore>(context);
    return replace(text, {
      'first_name': authStore.user?.firstName ?? '_',
      'last_name': authStore.user?.lastName ?? '_',
      'email': authStore.user?.userEmail ?? '_',
    });
  }
}
