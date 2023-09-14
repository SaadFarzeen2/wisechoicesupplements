import 'package:flutter/material.dart';

// Type build item
typedef BuildItemType = Widget Function(BuildContext context, {dynamic item, int? index, double width, double? height});

class LayoutCarousel extends StatelessWidget {
  final List? items;
  final BuildItemType? buildItem;
  final double? pad;
  final EdgeInsetsDirectional? padding;
  final double height;
  final double width;

  const LayoutCarousel({
    Key? key,
    this.items,
    this.buildItem,
    this.pad = 0,
    this.padding = EdgeInsetsDirectional.zero,
    this.height = 300,
    this.width = 300,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => buildItem!(context, item: items![index], width: width, height: height),
      separatorBuilder: (context, index) => SizedBox(
        width: pad,
      ),
      itemCount: items!.length,
    );
  }
}
