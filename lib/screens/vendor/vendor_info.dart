//
// Copyright 2022 Appcheap.io All rights reserved
//
// App Name:          Cirilla - Multipurpose Flutter App For Wordpress & Woocommerce
// Source:            https://codecanyon.net/item/cirilla-multipurpose-flutter-wordpress-app/31940668
// Docs:              https://appcheap.io/docs/cirilla-developers-docs/
// Since:             2.5.0
// Author:            Appcheap.io
// Author URI:        https://appcheap.io

import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/vendor/vendor_chat_button.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/themes/themes.dart';

class VendorInfo extends StatelessWidget {
  final bool enableCenterTitle;
  final Vendor vendor;
  final String viewAppbar;
  final bool enableRating;

  const VendorInfo({
    Key? key,
    required this.enableCenterTitle,
    required this.vendor,
    required this.viewAppbar,
    this.enableRating = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VendorAppBar(
      viewAppbar: viewAppbar,
      vendor: vendor,
      enableCenterTitle: enableCenterTitle,
      enableChat: true,
      enableFollow: false,
      chatButton: VendorChatButton(vendor: vendor),
      enableRating: enableRating,
    );
  }
}
