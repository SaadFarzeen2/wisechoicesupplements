import 'package:cirilla/constants/constants.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/material.dart';

import 'layout_carousel.dart';

class LayoutSlideshow extends StatefulWidget {
  final List? items;
  final BuildItemType? buildItem;
  final Color? indicatorColor;
  final Color? indicatorActiveColor;
  final EdgeInsetsDirectional? padding;
  final double height;

  const LayoutSlideshow({
    Key? key,
    this.items,
    this.buildItem,
    this.indicatorColor,
    this.indicatorActiveColor,
    this.padding = EdgeInsetsDirectional.zero,
    this.height = 300,
  }) : super(key: key);

  @override
  State<LayoutSlideshow> createState() => _LayoutSlideshowState();
}

class _LayoutSlideshowState extends State<LayoutSlideshow> {
  int pagination = 0;
  void changePagination(int value) {
    setState(() {
      pagination = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding!,
      child: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          double size = constraints.maxWidth;

          return SizedBox(
            width: size,
            height: size,
            child: Swiper(
              itemWidth: size,
              itemHeight: size,
              containerWidth: size,
              containerHeight: size,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: size,
                  child: widget.buildItem!(context, item: widget.items![index], width: size, height: widget.height),
                );
              },
              itemCount: widget.items!.length,
              curve: Curves.linear,
              pagination: SwiperPagination(
                margin: secondPaddingMedium,
                builder: DotSwiperPaginationBuilder(
                  space: 4,
                  activeSize: 6,
                  size: 6,
                  color: widget.indicatorColor,
                  activeColor: widget.indicatorActiveColor,
                ),
              ),
              // onIndexChanged: (int value) => changePagination(value),
            ),
          );
        },
      ),
    );
  }
}
