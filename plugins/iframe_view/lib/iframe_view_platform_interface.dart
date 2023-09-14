import 'package:flutter/material.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'iframe_view_method_channel.dart';

abstract class IframeViewPlatform extends PlatformInterface {
  /// Constructs a IframeViewPlatform.
  IframeViewPlatform() : super(token: _token);

  static final Object _token = Object();

  static IframeViewPlatform _instance = MethodChannelIframeView();

  /// The default instance of [IframeViewPlatform] to use.
  ///
  /// Defaults to [MethodChannelIframeView].
  static IframeViewPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [IframeViewPlatform] when
  /// they register themselves.
  static set instance(IframeViewPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<Widget?> show(String source) {
    throw UnimplementedError('Iframe has not been implemented.');
  }
}
