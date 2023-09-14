
import 'package:flutter/widgets.dart';

import 'iframe_view_platform_interface.dart';

class IframeView {
  Future<Widget?> show(String source) {
    return IframeViewPlatform.instance.show(source);
  }
}
