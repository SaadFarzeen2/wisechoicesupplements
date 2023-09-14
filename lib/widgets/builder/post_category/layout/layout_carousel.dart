import 'package:cirilla/models/models.dart';
import 'package:cirilla/types/types.dart';
import 'package:flutter/material.dart';

class LayoutCarousel extends StatelessWidget {
  final List<PostCategory>? categories;
  final BuildItemPostCategoryType? buildItem;
  final double pad;
  final double height;
  final double? heightImage;
  final EdgeInsetsDirectional padding;

  const LayoutCarousel({
    Key? key,
    this.categories,
    this.buildItem,
    this.pad = 0,
    this.padding = EdgeInsetsDirectional.zero,
    this.height = 200,
    this.heightImage = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => Column(
        children: [buildItem!(context, category: categories![index], height: height, heightImage: heightImage)],
      ),
      separatorBuilder: (context, index) => SizedBox(width: pad),
      itemCount: categories!.length,
    );
  }
}
