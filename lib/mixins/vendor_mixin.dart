import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/widgets/cirilla_shimmer.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:awesome_icons/awesome_icons.dart';

import 'utility_mixin.dart';

mixin VendorMixin {
  Widget buildImage(
    BuildContext context, {
    Vendor? vendor,
    double? width = 60,
    double height = 60,
    double borderRadius = 30,
    BoxFit fit = BoxFit.cover,
    Border? border,
    String type = 'image',
  }) {
    if (vendor is! Vendor || vendor.id == null) {
      return CirillaShimmer(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      );
    }
    String? url = type == 'banner' ? vendor.banner : vendor.gravatar;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            border: border,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          // clipBehavior: Clip.antiAliasWithSaveLayer,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: CirillaCacheImage(
              url,
              width: width,
              height: height,
              fit: fit,
            ),
          ),
        ),
        if (type == 'image' && vendor.featured == true)
          const Positioned(
            top: 0,
            right: 0,
            child: CirillaButtonSocial(
              icon: FeatherIcons.award,
              background: ColorBlock.green,
              size: 24,
              sizeIcon: 14,
            ),
          ),
      ],
    );
  }

  Widget buildName(
    BuildContext context, {
    Vendor? vendor,
    ThemeData? theme,
    Color? color,
    TextAlign? textAlign,
    double shimmerWidth = 90,
    double shimmerHeight = 16,
  }) {
    if (vendor is! Vendor || vendor.id == null) {
      return CirillaShimmer(
        child: Container(
          height: shimmerHeight,
          width: shimmerWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      );
    }
    String name = vendor.storeName is String && vendor.storeName!.isNotEmpty ? vendor.storeName! : 'Vendor store';
    return Text(
      name,
      style: theme!.textTheme.titleMedium?.copyWith(color: color),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }

  Widget buildDistance(
    BuildContext context, {
    Vendor? vendor,
    ThemeData? theme,
    Color? color,
    bool isCenter = false,
    double shimmerWidth = 100,
    double shimmerHeight = 12,
  }) {
    if (vendor is! Vendor || vendor.id == null) {
      return CirillaShimmer(
        child: Container(
          height: shimmerHeight,
          width: shimmerWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      );
    }
    String duration = get(vendor.duration, ['text'], '_');
    String distance = get(vendor.distance, ['text'], '_');

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: isCenter ? WrapAlignment.center : WrapAlignment.start,
      spacing: 8,
      children: [
        Text(
          duration,
          style: theme!.textTheme.bodySmall?.copyWith(color: color),
        ),
        Icon(
          FontAwesomeIcons.solidCircle,
          size: 4,
          color: color ?? theme.textTheme.bodySmall?.color,
        ),
        Text(distance, style: theme.textTheme.bodySmall?.copyWith(color: color))
      ],
    );
  }

  Widget buildRating(
    BuildContext context, {
    Vendor? vendor,
    ThemeData? theme,
    Color? color,
    bool centerHorizontal = false,
    bool enableBasic = false,
    double shimmerWidth = 140,
    double shimmerHeight = 12,
  }) {
    if (vendor is! Vendor || vendor.id == null) {
      return CirillaShimmer(
        child: Container(
          height: shimmerHeight,
          width: shimmerWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      );
    }
    double pad = enableBasic ? 4 : 8;
    double avgRating = vendor.rating?.avg ?? 0;
    int count = vendor.rating?.count ?? 0;
    return Wrap(
      spacing: pad,
      runSpacing: pad,
      crossAxisAlignment: WrapCrossAlignment.center,
      // alignment: centerHorizontal ? WrapAlignment.center : null,
      children: [
        if (enableBasic)
          const Icon(FontAwesomeIcons.solidStar, size: 12, color: ColorBlock.yellow)
        else
          CirillaRating(value: avgRating),
        Text(
          avgRating.toStringAsFixed(1),
          style: theme!.textTheme.titleSmall?.copyWith(color: theme.primaryColor),
        ),
        Text('($count)', style: theme.textTheme.labelSmall?.copyWith(color: color)),
      ],
    );
  }
}
