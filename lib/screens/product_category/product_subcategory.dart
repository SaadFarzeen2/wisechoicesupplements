import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

import 'package:cirilla/screens/product_list/product_list.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/mixins/mixins.dart';

class ProductSubcategoryScreen extends StatelessWidget with AppBarMixin {
  // Product category object
  final ProductCategory? category;
  final Widget parentWidget;

  const ProductSubcategoryScreen({
    super.key,
    required this.category,
    required this.parentWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: leading(),
        title: Text(category?.name ?? ''),
      ),
      body: SingleChildScrollView(
        padding: paddingHorizontal.copyWith(top: itemPaddingSmall, bottom: itemPaddingLarge),
        child: Column(
          children: [
            parentWidget,
            if (category?.categories?.isNotEmpty == true)
              ...List.generate(
                category!.categories!.length,
                (index) {
                  ProductCategory? subCategory = category!.categories!.elementAt(index);
                  return _ItemCategory(category: subCategory);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _ItemCategory extends StatefulWidget {
  // Product category object
  final ProductCategory? category;

  const _ItemCategory({this.category});

  @override
  State<_ItemCategory> createState() => _ItemCategoryState();
}

class _ItemCategoryState extends State<_ItemCategory> {
  bool enableChildren = false;

  void navigate(BuildContext context) {
    Navigator.pushNamed(context, ProductListScreen.routeName, arguments: {'category': widget.category});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.category?.categories?.isNotEmpty == true) {
      return Column(
        children: [
          CirillaTile(
            title: Text(widget.category?.name ?? ''),
            trailing: _IconButton(
              active: enableChildren,
              onPressed: () => setState(() {
                enableChildren = !enableChildren;
              }),
            ),
            height: 50,
            isChevron: false,
            onTap: () => navigate(context),
          ),
          if (enableChildren)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: itemPaddingMedium),
              child: Column(
                children: List.generate(
                  widget.category!.categories!.length,
                  (index) {
                    return _ItemCategory(
                      category: widget.category!.categories!.elementAt(index),
                    );
                  },
                ),
              ),
            ),
        ],
      );
    }

    return CirillaTile(
      title: Text(widget.category?.name ?? ''),
      height: 50,
      isChevron: false,
      onTap: () => navigate(context),
    );
  }
}

class _IconButton extends StatelessWidget {
  final Function? onPressed;
  final bool active;

  const _IconButton({Key? key, this.onPressed, this.active = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? color = Theme.of(context).textTheme.displayLarge?.color;
    Color activeColor = Theme.of(context).primaryColor;
    return InkResponse(
      onTap: onPressed as void Function()?,
      radius: 29,
      child: Icon(
        active ? FeatherIcons.chevronDown : FeatherIcons.chevronRight,
        color: active ? activeColor : color,
        size: 20,
      ),
    );
  }
}
