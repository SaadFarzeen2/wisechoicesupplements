import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/widgets/cirilla_product_category_item.dart';
import 'package:flutter/material.dart';

class LayoutBigFirst extends StatelessWidget {
  final List<ProductCategory?>? categories;
  final BuildItemProductCategoryType? buildItem;
  final double? pad;
  final Map<String, dynamic>? template;
  final Map<String, dynamic>? styles;
  final EdgeInsetsDirectional? padding;
  final double widthView;

  const LayoutBigFirst({
    Key? key,
    this.categories,
    this.buildItem,
    this.pad = 0,
    this.template,
    this.styles,
    this.padding = EdgeInsetsDirectional.zero,
    this.widthView = 300,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (categories!.isEmpty) return Container();

    List<ProductCategory?> newCategories = List<ProductCategory?>.of(categories!);
    ProductCategory? firstCategory = newCategories.removeAt(0);

    double widthWidget = widthView - padding!.end - padding!.start;

    return Padding(
      padding: padding!,
      child: Column(
        children: [
          Column(
            children: [
              FirstItem(
                category: firstCategory,
                width: widthWidget,
                template: template,
                styles: styles,
              ),
              if (categories!.isNotEmpty)
                SizedBox(
                  height: pad,
                ),
            ],
          ),
          ...List.generate(
            newCategories.length,
            (int index) {
              // double newWidth = MediaQuery.of(context).size.width;
              return Column(
                children: [
                  buildItem!(
                    context,
                    category: newCategories[index],
                    width: widthWidget,
                    height: null,
                  ),
                  if (index < newCategories.length - 1) SizedBox(height: pad)
                ],
              );
            },
          )
        ],
      ),
    );
  }
}

class FirstItem extends StatelessWidget with PostMixin {
  final ProductCategory? category;
  final double? width;
  final Map<String, dynamic>? template;
  final Map<String, dynamic>? styles;

  const FirstItem({Key? key, this.category, this.width, this.template, this.styles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fontSize = ConvertData.stringToDouble(get(styles, ['fontSize'], 16));
    return CirillaProductCategoryItem(
      category: category,
      width: width,
      height: width,
      fontSize: fontSize,
      template: {
        'template': Strings.productCategoryItemOverlay,
        'data': template is Map<String, dynamic> && template!['data'] is Map<String, dynamic> ? template!['data'] : {},
      },
    );
  }
}
