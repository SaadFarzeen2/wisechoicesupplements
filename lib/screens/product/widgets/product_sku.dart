import 'package:cirilla/models/product/product.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';

class ProductSku extends StatelessWidget {
  final Product? product;
  final String? align;

  const ProductSku({
    Key? key,
    this.product,
    this.align = 'left',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextAlign textAlign = ConvertData.toTextAlignDirection(align);
    return Text(
      product?.sku ?? '',
      style: Theme.of(context).textTheme.bodyMedium,
      textAlign: textAlign,
    );
  }
}
