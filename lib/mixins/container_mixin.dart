import 'package:flutter/material.dart';

mixin ContainerMixin {
  /// Create decoration of Blog.
  ///
  /// The width, height is required.
  ///
  /// If loading is true Shimmer will be showed
  BoxDecoration decorationColorImage({
    Color? color,
    String? image,
  }) {
    if (image?.isNotEmpty == true) {
      return BoxDecoration(color: color, image: DecorationImage(image: NetworkImage(image!), fit: BoxFit.cover));
    }

    if (color != null && color.opacity != 1) {
      return BoxDecoration(
        gradient: LinearGradient(
          tileMode: TileMode.clamp,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color, color],
        ),
      );
    }
    return BoxDecoration(
      color: color,
      border: Border.all(width: 0, color: color ?? Colors.transparent),
    );
  }
}
