import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:ui/image/image_loading.dart';
import 'package:cirilla/mixins/utility_mixin.dart' show get;

class ProductSlideshowPagination {
  SwiperCustomPagination numberPagination({
    TextStyle? textStyle,
    Color? background,
    double? size,
    double? space,
    double? borderRadius = 0,
  }) {
    return SwiperCustomPagination(
      builder: (BuildContext context, SwiperPluginConfig? config) {
        return ConstrainedBox(
          constraints: BoxConstraints(minWidth: size!, minHeight: size),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: space!, horizontal: space * 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius!),
              color: background,
            ),
            child: Text(
              "${config!.activeIndex! + 1}/${config.itemCount}",
              style: textStyle,
            ),
          ),
        );
      },
    );
  }

  SwiperCustomPagination imagePagination({
    List<Map<String, dynamic>>? images = const [],
    SwiperController? controller,
    Color? activeColor,
    double? size,
    double? space,
    double? borderRadius,
  }) {
    return SwiperCustomPagination(
      builder: (BuildContext context, SwiperPluginConfig? config) {
        ScrollController scrollController = ScrollController();
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: (size! * 3) + (2 * space!), maxHeight: size),
          child: ListView.separated(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              bool active = index == config!.activeIndex;
              String url = get(images?[index] ?? {}, ['woocommerce_thumbnail'], '');
              return InkWell(
                onTap: () => controller!.move(index),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius!),
                    color: activeColor,
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Opacity(
                    opacity: active ? 0.5 : 1,
                    child: ImageLoading(
                      url,
                      width: size,
                      height: size,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              );
            },
            itemCount: images!.length,
            separatorBuilder: (BuildContext context, int index) => SizedBox(width: space),
          ),
        );
      },
    );
  }
}
