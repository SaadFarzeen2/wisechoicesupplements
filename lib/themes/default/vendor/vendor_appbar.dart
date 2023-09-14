//
// Copyright 2022 Appcheap.io All rights reserved
//
// App Name:          Cirilla - Multipurpose Flutter App For Wordpress & Woocommerce
// Source:            https://codecanyon.net/item/cirilla-multipurpose-flutter-wordpress-app/31940668
// Docs:              https://appcheap.io/docs/cirilla-developers-docs/
// Since:             2.5.0
// Author:            Appcheap.io
// Author URI:        https://appcheap.io

import 'package:cirilla/constants/assets.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

///
/// The widget show vendor info
///
class VendorAppBar extends StatelessWidget with AppBarMixin, VendorMixin {
  /// Layout style vendor appbar [emerge, opacity]
  final String viewAppbar;

  /// Vendor object
  final Vendor vendor;

  /// Enable center title vendor
  final bool enableCenterTitle;

  /// Enable chat button
  final bool enableChat;

  /// Enable follow button
  final bool enableFollow;

  /// Chat button widget
  final Widget chatButton;

  /// Show rating
  final bool enableRating;

  VendorAppBar({
    Key? key,
    required this.viewAppbar,
    required this.vendor,
    required this.enableCenterTitle,
    required this.enableChat,
    required this.chatButton,
    required this.enableFollow,
    this.enableRating = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    double width = MediaQuery.of(context).size.width;
    double height = (width * 219) / 375;

    double heightPlus = 32;

    Widget positionInfo = Positioned(
      bottom: 0,
      left: 20,
      right: 20,
      child: buildVendor(
        context,
        vendor: vendor,
        color: theme.cardColor,
        padding: paddingHorizontal.add(paddingVerticalLarge),
        radius: 8,
        boxShadow: initBoxShadow,
        translate: translate,
      ),
    );

    if (viewAppbar == 'opacity') {
      heightPlus = 0;
      positionInfo = _buildPositionVendor(context);
    }

    double heightView = height + heightPlus;

    return SliverPersistentHeader(
      pinned: false,
      floating: false,
      delegate: StickyTabBarDelegate(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      vendor.banner != null && vendor.banner!.isNotEmpty ? vendor.banner! : Assets.noImageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              margin: EdgeInsets.only(bottom: heightPlus),
            ),
            Container(
              decoration: _buildDecorator(viewAppbar),
              margin: EdgeInsets.only(bottom: heightPlus),
            ),
            positionInfo,
            Positioned(
              child: Column(
                children: [
                  AppBar(
                    title: Text(
                      translate('vendor_detail_txt'),
                      style: theme.appBarTheme.titleTextStyle!.copyWith(color: Colors.white),
                    ),
                    centerTitle: enableCenterTitle,
                    leading: leading(color: Colors.white),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    actions: [Container()],
                  ),
                ],
              ),
            ),
          ],
        ),
        height: heightView,
      ),
    );
  }

  /// Build decoration box image
  BoxDecoration _buildDecorator(String viewAppbar) {
    if (viewAppbar == 'opacity') {
      return BoxDecoration(
        color: Colors.black.withOpacity(0.7),
      );
    }
    return overlayContainer;
  }

  /// Build position vendor
  Widget _buildPositionVendor(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: buildVendor(context,
          vendor: vendor,
          colorName: Colors.white,
          padding: paddingHorizontal.add(paddingVerticalLarge),
          radius: 8,
          boxShadow: initBoxShadow,
          translate: translate),
    );
  }

  /// Build vendor info
  Widget buildVendor(
    BuildContext context, {
    required Vendor vendor,
    EdgeInsetsGeometry? padding,
    Color? color,
    Color? colorName,
    List<BoxShadow>? boxShadow,
    double? radius,
    required TranslateType translate,
  }) {
    ThemeData theme = Theme.of(context);

    return Container(
      padding: padding,
      decoration: BoxDecoration(color: color, boxShadow: boxShadow, borderRadius: BorderRadius.circular(radius ?? 0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildName(context, vendor: vendor, theme: theme, color: colorName),
                if (enableRating) ...[
                  const SizedBox(height: 11),
                  buildRating(context, vendor: vendor, theme: theme),
                ],
                const SizedBox(height: 14),
                Row(
                  children: [
                    if (enableFollow) _buildFollowButton(context),
                    if (enableFollow) const SizedBox(width: 12),
                    if (enableChat) chatButton,
                  ],
                )
              ],
            ),
          ),
          const SizedBox(width: 16),
          buildImage(context, vendor: vendor),
        ],
      ),
    );
  }

  /// Build follow button widget
  Widget _buildFollowButton(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SizedBox(
      height: 34,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(textStyle: theme.textTheme.bodySmall),
        child: Row(
          children: const [
            Icon(FeatherIcons.userPlus, size: 14),
            SizedBox(width: 8),
            Text('Follow'),
          ],
        ),
      ),
    );
  }
}
