import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/post_mixin.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/widgets/cirilla_post_category_item.dart';
import 'package:flutter/material.dart';

class LayoutBigFirst extends StatelessWidget {
  final List<PostCategory>? categories;
  final BuildItemPostCategoryType? buildItem;
  final double? pad;
  final Map<String, dynamic>? template;
  final EdgeInsetsDirectional padding;
  final double? widthView;

  const LayoutBigFirst({
    Key? key,
    this.categories,
    this.buildItem,
    this.pad = 0,
    this.template,
    this.padding = EdgeInsetsDirectional.zero,
    this.widthView = 300,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (categories!.isEmpty) return Container();

    double widthWidget = widthView! - padding.end - padding.start;

    List<PostCategory> newCategories = List<PostCategory>.of(categories!);
    PostCategory firstCategory = newCategories.removeAt(0);

    return Padding(
      padding: padding,
      child: Column(
        children: [
          Column(
            children: [
              FirstItem(category: firstCategory, width: widthWidget, template: template),
              if (newCategories.isNotEmpty)
                SizedBox(
                  height: pad,
                ),
            ],
          ),
          ...List.generate(
            newCategories.length,
            (int index) {
              return Column(
                children: [
                  buildItem!(
                    context,
                    category: newCategories[index],
                    width: widthWidget,
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
  final PostCategory? category;
  final double? width;
  final Map<String, dynamic>? template;

  const FirstItem({Key? key, this.category, this.width, this.template}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CirillaPostCategoryItem(
      category: category,
      width: width,
      template: {
        'template': Strings.postCategoryItemGradient,
        'data': template is Map<String, dynamic> && template!['data'] is Map<String, dynamic> ? template!['data'] : {},
      },
    );
  }
}
