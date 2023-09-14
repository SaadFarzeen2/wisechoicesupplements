import 'package:cirilla/constants/assets.dart';
// import 'package:cirilla/constants/color_block.dart';
// import 'package:cirilla/models/models.dart';
// import 'package:cirilla/widgets/cirilla_shimmer.dart';
// import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/widgets/widgets.dart';
// import 'package:awesome_icons/awesome_icons.dart';

mixin ChatMixin {
  Widget buildImage(
    BuildContext context, {
    double size = 60,
    BoxBorder? border,
  }) {
    // if (vendor is! Vendor || vendor.id == null) {
    //   return CirillaShimmer(
    //     child: Container(
    //       height: height,
    //       width: width,
    //       decoration: BoxDecoration(
    //         color: Colors.white,
    //         borderRadius: BorderRadius.circular(borderRadius),
    //       ),
    //     ),
    //   );
    // }
    return Container(
      decoration: BoxDecoration(
        border: border,
        borderRadius: BorderRadius.circular(size / 2),
      ),
      // clipBehavior: Clip.antiAliasWithSaveLayer,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: CirillaCacheImage(
          Assets.noImageUrl,
          width: size,
          height: size,
        ),
      ),
    );
  }

  Widget buildName(
    BuildContext context, {
    ThemeData? theme,
    TextAlign? textAlign,
    double shimmerWidth = 100,
    double shimmerHeight = 16,
  }) {
    // if (vendor is! Vendor || vendor.id == null) {
    //   return CirillaShimmer(
    //     child: Container(
    //       height: shimmerHeight,
    //       width: shimmerWidth,
    //       decoration: BoxDecoration(
    //         color: Colors.white,
    //         borderRadius: BorderRadius.circular(1),
    //       ),
    //     ),
    //   );
    // }
    // String name = vendor.storeName is String && vendor.storeName!.isNotEmpty ? vendor.storeName! : 'Vendor store';
    return Text(
      'Jollibee',
      style: theme!.textTheme.titleMedium,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }

  Widget buildMessage(
    BuildContext context, {
    ThemeData? theme,
    double shimmerWidth = 150,
    double shimmerHeight = 12,
  }) {
    // if (vendor is! Vendor || vendor.id == null) {
    //   return CirillaShimmer(
    //     child: Container(
    //       height: shimmerHeight,
    //       width: shimmerWidth,
    //       decoration: BoxDecoration(
    //         color: Colors.white,
    //         borderRadius: BorderRadius.circular(1),
    //       ),
    //     ),
    //   );
    // }
    // String name = vendor.storeName is String && vendor.storeName!.isNotEmpty ? vendor.storeName! : 'Vendor store';
    return Text(
      'It is a long established fact ',
      style: theme!.textTheme.bodyMedium?.copyWith(color: theme.textTheme.labelSmall?.color),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget buildTime(
    BuildContext context, {
    ThemeData? theme,
    double shimmerWidth = 75,
    double shimmerHeight = 12,
  }) {
    // if (vendor is! Vendor || vendor.id == null) {
    //   return CirillaShimmer(
    //     child: Container(
    //       height: shimmerHeight,
    //       width: shimmerWidth,
    //       decoration: BoxDecoration(
    //         color: Colors.white,
    //         borderRadius: BorderRadius.circular(1),
    //       ),
    //     ),
    //   );
    // }
    // String name = vendor.storeName is String && vendor.storeName!.isNotEmpty ? vendor.storeName! : 'Vendor store';
    return Text(
      '9:05 AM',
      style: theme!.textTheme.bodySmall,
    );
  }
}
