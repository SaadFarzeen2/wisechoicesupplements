import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:ui/ui.dart';
import 'product_price.dart';

class ProductItem extends StatelessWidget with Utility {
  final Product? product;
  final Widget? quantity;

  const ProductItem({Key? key, this.product, this.quantity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    String image = product?.images?.isNotEmpty == true ? get(product!.images!.elementAt(0), ['src'], '') : '';

    TextStyle? descriptionStyle = theme.textTheme.bodyMedium;

    Style styleHtml = Style(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      fontFamily: descriptionStyle?.fontFamily,
      fontWeight: descriptionStyle?.fontWeight,
      fontSize: FontSize(descriptionStyle?.fontSize),
      lineHeight: LineHeight(descriptionStyle?.height),
    );

    return ProductInformationItem(
      image: CirillaCacheImage(image, width: 100, height: 100),
      name: Text(product?.name ?? '', style: theme.textTheme.titleMedium),
      description: CirillaHtml(
        html: product?.shortDescription ?? '',
        style: {
          'body': styleHtml,
          'p': styleHtml,
          'div': styleHtml,
        },
      ),
      price: ProductPrice(product: product, pad: 4),
      quantity: quantity,
    );
  }
}
