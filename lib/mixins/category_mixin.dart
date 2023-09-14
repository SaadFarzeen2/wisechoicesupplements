import 'package:cirilla/models/models.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_shimmer.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';
import 'package:cirilla/mixins/utility_mixin.dart' show get;

abstract class CategoryMixin {
  /// Exclude categories
  List<ProductCategory?>? exclude({List<ProductCategory?>? categories, required List<int> excludes}) {
    if (excludes.isEmpty || categories!.isEmpty) return categories;

    List<ProductCategory> newCategories = <ProductCategory>[];

    for (ProductCategory? productCategory in categories) {
      if (!excludes.contains(productCategory!.id)) {
        newCategories.add(ProductCategory(
          id: productCategory.id,
          name: productCategory.name,
          slug: productCategory.slug,
          description: productCategory.description,
          parent: productCategory.parent,
          count: productCategory.count,
          image: productCategory.image,
          categories: exclude(categories: productCategory.categories, excludes: excludes),
        ));
      }
    }
    return newCategories;
  }

  /// Flatten category
  List<ProductCategory?> flatten({required List<ProductCategory?> categories}) {
    if (categories.isEmpty || categories.isEmpty) return categories;

    List<ProductCategory?> newCategories = <ProductCategory>[];

    newCategories = categories
        .expand(
          (productCategory) => [
            ProductCategory(
              id: productCategory!.id,
              name: productCategory.name,
              slug: productCategory.slug,
              description: productCategory.description,
              parent: productCategory.parent,
              count: productCategory.count,
              image: productCategory.image,
              categories: [],
            ),
            ...flatten(categories: productCategory.categories!),
          ],
        )
        .toList();

    return newCategories;
  }

  /// Include categories
  List<ProductCategory?>? include({List<ProductCategory?>? categories, required List<int> includes}) {
    if (includes.isEmpty || categories!.isEmpty) return categories;

    List<ProductCategory?> newCategories = <ProductCategory?>[];

    for (ProductCategory? productCategory in categories) {
      List<ProductCategory?>? subs = include(categories: productCategory!.categories, includes: includes);

      if (includes.contains(productCategory.id)) {
        newCategories.add(ProductCategory(
          id: productCategory.id,
          name: productCategory.name,
          slug: productCategory.slug,
          description: productCategory.description,
          parent: productCategory.parent,
          count: productCategory.count,
          image: productCategory.image,
          categories: subs,
        ));
      } else {
        newCategories.addAll(subs!);
      }
    }
    return newCategories;
  }

  /// Max depth categories
  List<ProductCategory?> depth({required List<ProductCategory?> categories, int? maxDepth = 3, int level = 1}) {
    if (categories.isEmpty) return categories;

    List<ProductCategory> newCategories = <ProductCategory>[];

    for (ProductCategory? productCategory in categories) {
      newCategories.add(
        ProductCategory(
            id: productCategory!.id,
            name: productCategory.name,
            slug: productCategory.slug,
            description: productCategory.description,
            parent: productCategory.parent,
            count: productCategory.count,
            image: productCategory.image,
            categories: level < maxDepth!
                ? depth(categories: productCategory.categories!, maxDepth: maxDepth, level: level + 1)
                : []),
      );
    }
    return newCategories;
  }

  /// Get categories by parent
  List<ProductCategory?> parent({required List<ProductCategory?> categories, int? parentId = 0}) {
    if (categories.isEmpty) return categories;

    List<ProductCategory?> newCategories = <ProductCategory?>[];
    for (ProductCategory? productCategory in categories) {
      if (productCategory!.parent == parentId) {
        newCategories.add(productCategory);
      }
      newCategories.addAll(parent(categories: productCategory.categories!, parentId: parentId));
    }
    return newCategories;
  }

  Widget buildImage(
      {required ProductCategory category,
      double? width,
      double? height,
      String? borderStyle = 'none',
      Color? borderColor,
      double? pad = 0,
      double? radius = 0,
      bool? enableRoundImage = false,
      String? sizes = 'src'}) {
    // Category image
    String? image = get(category.image, [sizes], '');

    if (borderStyle == 'none') {
      double radiusImage = enableRoundImage!
          ? width! > height!
              ? width / 2
              : height / 2
          : radius!;

      return ClipRRect(
        borderRadius: BorderRadius.circular(radiusImage),
        child: CirillaCacheImage(
          image,
          width: width,
          height: height,
        ),
      );
    }

    double? widthImage = width! - 2 * pad! < 0 ? width : width - 2 * pad;
    double? heightImage = height! - 2 * pad < 0 ? height : height - 2 * pad;
    double? radiusImageBox = enableRoundImage!
        ? width > height
            ? width / 2
            : height / 2
        : radius;
    double? radiusImage = enableRoundImage
        ? widthImage > heightImage
            ? widthImage / 2
            : heightImage / 2
        : radius;

    if (borderStyle == 'solid') {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radiusImageBox!),
          border: Border.all(width: 1, color: borderColor!),
        ),
        padding: EdgeInsets.all(pad),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radiusImage!),
          child: CirillaCacheImage(
            image,
            width: widthImage,
            height: height,
          ),
        ),
      );
    }

    List<double> dashPattern = borderStyle == 'dashed' ? [5, 3] : [2, 2];

    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(radiusImageBox!),
      padding: EdgeInsets.all(pad),
      dashPattern: dashPattern,
      color: borderColor!,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radiusImage!),
        child: CirillaCacheImage(
          image,
          width: widthImage,
          height: heightImage,
        ),
      ),
    );
  }

  Widget buildName({
    required ProductCategory category,
    TextStyle? style,
    TextAlign? textAlign,
    ThemeData? theme,
  }) {
    return Text(category.name!, style: style ?? theme!.textTheme.titleSmall, textAlign: textAlign);
  }

  Widget buildCount({
    ProductCategory? category,
    TextStyle? style,
    TextAlign? textAlign,
    ThemeData? theme,
    TranslateType? translate,
  }) {
    String text = category?.count is int && category!.count! > 1
        ? translate!('product_category_items', {'count': '${category.count}'})
        : translate!('product_category_item', {'count': '${category?.count ?? 0}'});
    return Text(text, style: style ?? theme!.textTheme.bodySmall, textAlign: textAlign);
  }

  Widget buildNamePostCategory({required PostCategory category, ThemeData? theme, Color? color, TextStyle? style}) {
    if (category.id == null) {
      return CirillaShimmer(
        child: Container(
          height: 24,
          width: 140,
          color: Colors.white,
        ),
      );
    }
    return Text(category.name!, style: theme!.textTheme.titleSmall?.merge(style).copyWith(color: color));
  }

  Widget buildImagePostCategory({
    required PostCategory category,
    double width = 109,
    double? height = 109,
    double? radius = 8,
    bool enableRound = false,
  }) {
    double? borderRadius = !enableRound
        ? radius
        : width > height!
            ? width / 2
            : height / 2;
    if (category.id == null) {
      return CirillaShimmer(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius!),
          ),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius!),
      child: CirillaCacheImage(
        category.image ?? '',
        width: width,
        height: height,
      ),
    );
  }

  Widget buildCountPostCategory({
    required PostCategory category,
    double size = 22,
    double? radius = 11,
    Color? color = Colors.black,
    TextStyle? countStyle,
  }) {
    if (category.id == null) {
      return CirillaShimmer(
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius!),
          ),
        ),
      );
    }
    return BadgeUi(
      text: Text(
        category.count.toString(),
        style: countStyle,
      ),
      color: color,
      size: size,
      radius: radius,
    );
  }

  Widget buildTextCountPostCategory(
    BuildContext context, {
    required PostCategory category,
    TextStyle? countStyle,
    double shimmerWidth = 70,
    double shimmerHeight = 12,
  }) {
    if (category.id == null) {
      return CirillaShimmer(
        child: Container(
          height: shimmerHeight,
          width: shimmerWidth,
          color: Colors.white,
        ),
      );
    }

    TranslateType translate = AppLocalizations.of(context)!.translate;
    String text = category.count! > 1
        ? translate('post_count', {'count': category.count.toString()})
        : translate('post_count_single', {'count': category.count.toString()});
    return Text(
      text,
      style: countStyle,
    );
  }
}
