import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'iframe_view_platform_interface.dart';

/// An implementation of [IframeViewPlatform] that uses method channels.
class MethodChannelIframeView extends IframeViewPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('iframe_view');

  @override
  Future<Widget?> show(String source) {
    final iFrame = methodChannel.invokeMethod<Widget>('show');
    return iFrame;
  }
}
