import 'package:cirilla/constants/assets.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';

class FeaturedImage extends StatefulWidget with Utility {
  final List<Map<String, dynamic>>? images;
  final double? width;
  final double? height;

  const FeaturedImage({
    Key? key,
    this.images,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<FeaturedImage> createState() => _FeaturedImageState();
}

class _FeaturedImageState extends State<FeaturedImage> with Utility {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> images = widget.images ?? [];
    String image = images.isNotEmpty ? get(images[0], ['woocommerce_thumbnail'], Assets.noImageUrl) : Assets.noImageUrl;
    return CirillaCacheImage(
      image,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
    );
  }
}
