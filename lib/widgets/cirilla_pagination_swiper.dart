import 'package:cirilla/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class CirillaPaginationSwiper extends SwiperPlugin {
  /// AlignmentDirectional.bottomCenter by default when scrollDirection== Axis.horizontal
  /// AlignmentDirectional.centerRight by default when scrollDirection== Axis.vertical
  final AlignmentDirectional? alignment;

  /// Distance between pagination and the container
  final EdgeInsetsGeometry margin;

  /// Build the widet
  final SwiperPlugin builder;

  final Key? key;

  const CirillaPaginationSwiper({
    this.alignment,
    this.key,
    this.margin = secondPaddingSmall,
    this.builder = const DotSwiperPaginationBuilder(),
  });

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    AlignmentDirectional alignment = this.alignment ??
        (config.scrollDirection == Axis.horizontal
            ? AlignmentDirectional.bottomCenter
            : AlignmentDirectional.centerEnd);
    Widget child = Container(
      margin: margin,
      child: builder.build(context, config),
    );
    if (!config.outer!) {
      child = Align(
        key: key,
        alignment: alignment,
        child: child,
      );
    }
    return child;
  }
}
