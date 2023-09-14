import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/models/product/product.dart';
import 'package:cirilla/models/product/product_brand.dart';

import 'package:cirilla/models/product/product_category.dart';
import 'package:cirilla/models/product/product_type.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_shimmer.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:awesome_icons/awesome_icons.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ui/ui.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:cirilla/filters/filter_price.dart' show b2bkingFilterPrice;

import 'utility_mixin.dart' show get;

mixin ProductMixin {
  Widget buildImage(
    BuildContext context, {
    required Product product,
    double width = 100,
    double height = 100,
    double? borderRadius,
    BoxFit fit = BoxFit.cover,
    String thumbSizes = 'src',
  }) {
    if (product.id == null) {
      return CirillaShimmer(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          ),
        ),
      );
    }
    dynamic imageFirst = product.images?.isNotEmpty == true ? product.images![0] : null;

    String defaultImage = get(imageFirst, ['src'], '');
    String image = get(imageFirst, [thumbSizes], defaultImage);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 8),
      child: CirillaCacheImage(
        image,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }

  Widget buildName(
    BuildContext context, {
    required Product product,
    TextStyle? style,
    double shimmerWidth = 140,
    double shimmerHeight = 16,
  }) {
    if (product.id == null) {
      return CirillaShimmer(
        child: Container(
          height: shimmerHeight,
          width: shimmerWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      );
    }

    return Text(
      product.name!,
      style: style,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  double getPercent(double salePrice, double regularPrice) {
    if (salePrice > 0 && salePrice <= regularPrice) {
      return ((regularPrice - salePrice) * 100) / (regularPrice == 0 ? 1 : regularPrice);
    }
    return 0;
  }

  bool hideQuantity(Product? product) {
    // status out of stock
    if (product?.stockStatus == 'outofstock') {
      return true;
    }
    // status on back order
    if (product?.stockStatus == 'onbackorder') {
      if (product?.stockQuantity == null) {
        // ( Init "stock_quantity: null")
        return true;
      } else {
        // ( Changed "do not allow => allow" )
        return false;
      }
    }
    // status in stock (stock_quantity: null Or stock_quantity:value)
    return false;
  }

  Widget buildPrice(
    BuildContext context, {
    required Product product,
    TextStyle? priceStyle,
    TextStyle? saleStyle,
    TextStyle? regularStyle,
    TextStyle? styleFrom,
    TextStyle? stylePercentSale,
    bool enablePercentSale = false,
    Color colorPercentSale = ColorBlock.red,
    double sizePercentSale = 19,
    double spacing = 4,
    double shimmerWidth = 50,
    double shimmerHeight = 12,
  }) {
    if (product.id == null) {
      return CirillaShimmer(
        child: Container(
          margin: const EdgeInsets.only(top: 4),
          height: shimmerHeight,
          width: shimmerWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      );
    }

    // Return empty widget if price not exist
    if (product.priceHtml == null || product.priceHtml == '') {
      return Container();
    }

    // Return empty widget if price zero
    if (product.salePrice == '0' && product.regularPrice == '0' && product.price == '0') {
      return Container();
    }

    ThemeData theme = Theme.of(context);
    TextStyle? stylePrice = priceStyle is TextStyle ? priceStyle : theme.textTheme.titleSmall;
    TextStyle? styleSale =
        saleStyle is TextStyle ? saleStyle : theme.textTheme.titleSmall?.copyWith(color: ColorBlock.red);
    TextStyle? styleRegular = regularStyle is TextStyle ? regularStyle : theme.textTheme.titleSmall;
    TextStyle? stylePercent =
        stylePercentSale is TextStyle ? stylePercentSale : theme.textTheme.labelSmall?.copyWith(color: Colors.white);

    String? price = product.regularPrice != '0' ? product.regularPrice : product.price;
    String? salePrice = product.salePrice;

    if (product.type == productTypeVariable || product.type == productTypeGrouped) {
      if (product.priceHtml?.contains('<del') ?? false) {
        return Html(
          data: product.priceHtml?.replaceFirst('del>', 'del>&nbsp;'),
          shrinkWrap: true,
          style: {
            'html': Style(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
            ),
            'body': Style(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
            ),
            'del': Style.fromTextStyle(styleRegular!.copyWith(decoration: TextDecoration.lineThrough)),
            'ins': Style.fromTextStyle(styleSale ?? const TextStyle()),
          },
        );
      }

      return Html(
        data: "<span>${product.priceHtml}</span>",
        shrinkWrap: true,
        style: {
          'html': Style(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
          ),
          'body': Style(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
          ),
          'span': Style.fromTextStyle(stylePrice!),
        },
      );
    }

    String? filterRegularPrice = b2bkingFilterPrice(context, price, product, 'regular');
    String? filterSalePrice = b2bkingFilterPrice(context, salePrice, product, 'sale');

    if ((product.onSale != null && product.onSale! && filterSalePrice == salePrice) ||
        (filterSalePrice != null && filterSalePrice != '' && filterSalePrice != '0')) {
      TranslateType translate = AppLocalizations.of(context)!.translate;
      double percent = getPercent(ConvertData.stringToDouble(salePrice), ConvertData.stringToDouble(price));
      String value = percent.toStringAsFixed(percent.truncateToDouble() == percent ? 0 : 1);
      String valuePercent = translate('sale_percent', {'percent': value});

      return Wrap(
        spacing: spacing,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            formatCurrency(context, price: filterRegularPrice),
            style: styleRegular!.copyWith(decoration: TextDecoration.lineThrough),
          ),
          Text(
            formatCurrency(context, price: filterSalePrice),
            style: styleSale,
          ),
          if (enablePercentSale)
            BadgeUi(
              text: Text(valuePercent, style: stylePercent),
              size: sizePercentSale,
              color: colorPercentSale,
              padding: paddingHorizontalTiny,
            )
        ],
      );
    }
    return Text(
      formatCurrency(context, price: filterRegularPrice),
      style: stylePrice,
    );
  }

  Widget buildTagExtra(
    BuildContext context, {
    required Product product,
    double shimmerWidth = 0,
    double shimmerHeight = 0,
    bool? enableNew = true,
    Color? newColor,
    Color? newTextColor,
    double? newRadius,
    bool? enableSale = true,
    Color? saleColor,
    Color? saleTextColor,
    double? saleRadius,
  }) {
    if (product.id == null) {
      return CirillaShimmer(
        child: Container(
          height: shimmerHeight,
          width: shimmerWidth,
          color: Colors.white,
        ),
      );
    }

    TextStyle? style = Theme.of(context).textTheme.labelSmall;

    List<Widget> children = [];

    if (enableNew == true &&
        (product.date?.isNotEmpty == true && compareSpaceDate(date: product.date!, space: spaceTimeNew))) {
      children.add(
        BadgeUi(
          text: Text(
            AppLocalizations.of(context)!.translate('product_new'),
            style: style?.copyWith(color: newTextColor ?? Colors.white),
          ),
          color: newColor ?? ColorBlock.green,
          padding: paddingHorizontalTiny,
          radius: newRadius,
        ),
      );
    }

    if (enableSale == true && product.onSale == true) {
      if (product.type == productTypeVariable || product.type == productTypeGrouped) {
        children.add(
          BadgeUi(
            text: Text(
              AppLocalizations.of(context)!.translate('product_sale'),
              style: style?.copyWith(color: saleTextColor ?? Colors.white),
            ),
            color: saleColor ?? ColorBlock.red,
            padding: paddingHorizontalTiny,
            radius: saleRadius,
          ),
        );
      } else {
        TranslateType translate = AppLocalizations.of(context)!.translate;

        String? price = product.regularPrice != '0' ? product.regularPrice : product.price;

        double numberPrice = ConvertData.stringToDouble(price);
        double numberSale = ConvertData.stringToDouble(product.salePrice);
        double percent = ((numberPrice - numberSale) * 100) / numberPrice;
        String value = percent.toStringAsFixed(percent.truncateToDouble() == percent ? 0 : 1);
        String text = translate('sale_percent', {'percent': value});
        children.add(
          BadgeUi(
            text: Text(
              text,
              style: style?.copyWith(color: saleTextColor ?? Colors.white),
            ),
            color: saleColor ?? ColorBlock.red,
            padding: paddingHorizontalTiny,
            radius: saleRadius,
          ),
        );
      }
    }
    return Wrap(
      spacing: 8,
      children: children,
    );
  }

  Widget buildRating(
    BuildContext context, {
    required Product product,
    Color? color,
    bool showNumber = false,
    double shimmerWidth = 80,
    double shimmerHeight = 12,
    WrapAlignment wrapAlignment = WrapAlignment.start,
  }) {
    if (product.id == null) {
      return CirillaShimmer(
        child: Container(
            width: shimmerWidth,
            height: shimmerHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(1),
            )),
      );
    }

    double rating = ConvertData.stringToDouble(product.averageRating ?? 0);

    return Wrap(
      spacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: wrapAlignment,
      children: [
        if (showNumber)
          CirillaRating.number(value: rating, textColor: color)
        else
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: CirillaRating(value: rating),
          ),
        Text('(${product.ratingCount})', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color))
      ],
    );
  }

  Widget buildWishlist(
    BuildContext context, {
    required Product product,
    Color? color,
    bool isSelected = false,
    GestureTapCallback? onTap,
    double shimmerWidth = 0,
    double shimmerHeight = 0,
  }) {
    if (product.id == null) {
      return CirillaShimmer(
        child: Container(
          height: shimmerHeight,
          width: shimmerWidth,
          color: Colors.white,
        ),
      );
    }
    return InkWell(
      onTap: onTap,
      child: Icon(isSelected ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart, size: 16, color: color),
    );
  }

  Widget buildQuantityItem(
    BuildContext context, {
    required Product product,
    Color? color,
    int quantity = 1,
    ValueChanged<int>? onChanged,
    double shimmerWidth = 90,
    double shimmerHeight = 34,
  }) {
    if (product.id == null) {
      return CirillaShimmer(
        child: Container(
          height: shimmerHeight,
          width: shimmerWidth,
          color: Colors.white,
        ),
      );
    }

    if (hideQuantity(product)) {
      return SizedBox(
        height: shimmerHeight,
        width: shimmerWidth,
      );
    }

    ThemeData theme = Theme.of(context);
    int? stockQty = product.stockQuantity;
    return CirillaQuantity(
      max: stockQty != null && stockQty > 0 ? stockQty : CirillaQuantity.maxQty,
      value: quantity,
      width: shimmerWidth,
      height: shimmerHeight,
      borderColor: theme.dividerColor,
      onChanged: onChanged,
    );
  }

  Widget buildAddCart(
    BuildContext context, {
    required Product product,
    bool isButtonOutline = false,
    bool enableIconCart = true,
    IconData? icon,
    String? text,
    double? radius,
    bool enableAllRadius = true,
    GestureTapCallback? onTap,
    double shimmerWidth = 0,
    double shimmerHeight = 0,
  }) {
    if (product.id == null) {
      return CirillaShimmer(
        child: Container(
          height: shimmerHeight,
          width: shimmerWidth,
          color: Colors.white,
        ),
      );
    }

    ThemeData theme = Theme.of(context);
    String titleText = text ?? '';

    Radius valueRadius = Radius.circular(radius ?? 8);
    BorderRadiusGeometry borderRadius = enableAllRadius
        ? BorderRadius.all(valueRadius)
        : BorderRadiusDirectional.only(
            topStart: valueRadius,
            bottomEnd: valueRadius,
          );
    ButtonStyle style = ElevatedButton.styleFrom(
      minimumSize: titleText.isEmpty ? const Size(34, 0) : null,
      padding: EdgeInsets.zero,
      textStyle: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      elevation: 0,
    );
    if (isButtonOutline) {
      style = style.merge(ElevatedButton.styleFrom(
        foregroundColor: theme.primaryColor,
        backgroundColor: theme.primaryColor.withOpacity(0.1),
      ));
    }
    Icon iconWidget = Icon(icon ?? FeatherIcons.plus, size: 14);
    Widget? titleWidget = titleText.isNotEmpty ? Text(titleText) : null;
    Widget child = titleWidget == null
        ? iconWidget
        : Padding(
            padding: paddingHorizontalMedium,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (enableIconCart && icon != null) ...[
                  iconWidget,
                  const SizedBox(width: 8),
                ],
                Flexible(child: titleWidget),
              ],
            ),
          );
    Widget button = SizedBox(
      height: 34,
      width: titleWidget == null ? 34 : null,
      child: ElevatedButton(
        onPressed: product.stockStatus != 'outofstock' ? onTap : null,
        style: style,
        child: child,
      ),
    );
    return isButtonOutline
        ? DottedBorder(
            borderType: BorderType.RRect,
            radius: valueRadius,
            padding: EdgeInsets.zero,
            color: theme.primaryColor,
            child: button,
          )
        : button;
  }

  Widget buildCategory(
    BuildContext context, {
    required Product product,
    Color? color,
    double shimmerWidth = 0,
    double shimmerHeight = 0,
  }) {
    if (product.id == null) {
      return CirillaShimmer(
        child: Container(
          height: shimmerHeight,
          width: shimmerWidth,
          color: Colors.white,
        ),
      );
    }
    List<ProductCategory?> categories = product.categories ?? [];
    String name = categories.map((ProductCategory? category) => category!.name).toList().join(' | ');
    return Text(name, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color));
  }

  Widget buildBrand(
    BuildContext context, {
    Product? product,
    Color? color,
    double shimmerWidth = 70,
    double shimmerHeight = 14,
  }) {
    if (product?.id == null) {
      return CirillaShimmer(
        child: Container(
          height: shimmerHeight,
          width: shimmerWidth,
          color: Colors.white,
        ),
      );
    }
    List<ProductBrand?> brands = product?.brands ?? [];
    String name = brands.map((ProductBrand? brand) => brand?.name ?? '').toList().join(' | ');
    return Text(name, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color));
  }
}
