import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/models/product/product.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ProductStatus extends StatelessWidget {
  final Product? product;
  final String align;
  final String typeStatus;

  const ProductStatus({
    Key? key,
    this.product,
    this.align = 'left',
    this.typeStatus = 'text',
  }) : super(key: key);

  Widget buildText({required ThemeData theme, required TranslateType translate}) {
    String? textStatus = translate('product_status_outstock');
    Color colorStatus = ColorBlock.red;

    if (product?.stockStatus == 'instock') {
      colorStatus = ColorBlock.green;
      if (product?.stockQuantity != null && product!.stockQuantity! > 0) {
        textStatus = translate('product_status_instock_count', {'count': '${product?.stockQuantity ?? 0}'});
      } else {
        textStatus = translate('product_status_instock');
      }
    } else if (product?.stockStatus == 'onbackorder') {
      colorStatus = ColorBlock.yellow;
      textStatus = translate('product_status_backorder');
    }

    return Text(
      textStatus,
      style: theme.textTheme.bodySmall?.copyWith(color: colorStatus),
      textAlign: ConvertData.toTextAlignDirection(align),
    );
  }

  Widget buildProgressIndicator({required ThemeData theme, required TranslateType translate}) {
    String? textStatus = translate('product_status_outstock');
    Color colorStatus = ColorBlock.red;
    double percent = 1;
    bool enableIndicator = false;

    if (product?.stockStatus == 'instock') {
      colorStatus = theme.primaryColor;
      if (product?.stockQuantity != null && product!.stockQuantity! > 0) {
        int quantity = product?.stockQuantity ?? 0;
        int sale = product?.totalSales ?? 0;

        percent = double.parse((sale / (sale + quantity)).toStringAsFixed(2));

        textStatus = translate('product_sold_count', {
          'count': '$sale',
        });
        enableIndicator = true;
      } else {
        textStatus = translate('product_status_instock');
      }
    } else if (product?.stockStatus == 'onbackorder') {
      colorStatus = ColorBlock.yellow;
      textStatus = translate('product_status_backorder');
    }

    return Stack(
      children: [
        enableIndicator
            ? CirillaAnimationIndicator(
                value: percent,
                strokeWidth: 18,
                indicatorColor: colorStatus,
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: Divider(
                  height: 18,
                  thickness: 18,
                  color: colorStatus,
                ),
              ),
        Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          right: 0,
          child: Center(
            child: Text(
              textStatus,
              style: theme.textTheme.bodySmall
                  ?.copyWith(fontWeight: FontWeight.w600, color: theme.textTheme.titleMedium?.color),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildProgressPercent({required ThemeData theme, required TranslateType translate}) {
    String? textStatus = translate('product_status_outstock');
    Color colorStatus = ColorBlock.red;
    double percent = 1;
    bool enableIndicator = false;

    if (product?.stockStatus == 'instock') {
      colorStatus = theme.primaryColor;
      if (product?.stockQuantity != null && product!.stockQuantity! > 0) {
        int quantity = product?.stockQuantity ?? 0;
        int sale = product?.totalSales ?? 0;

        percent = double.parse((sale / (sale + quantity)).toStringAsFixed(2));
        enableIndicator = true;
      } else {
        textStatus = translate('product_status_instock');
      }
    } else if (product?.stockStatus == 'onbackorder') {
      colorStatus = ColorBlock.yellow;
      textStatus = translate('product_status_backorder');
    }
    if (enableIndicator) {
      return Row(
        children: [
          Expanded(
            child: CirillaAnimationIndicator(
              value: percent,
              strokeWidth: 18,
              indicatorColor: colorStatus,
            ),
          ),
          const SizedBox(width: itemPadding),
          Text('${(percent * 100).toStringAsFixed(0)}%'),
        ],
      );
    }
    return Text(
      textStatus,
      style: theme.textTheme.bodySmall?.copyWith(color: colorStatus),
      textAlign: ConvertData.toTextAlignDirection(align),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    if (typeStatus == 'progress_indicator') {
      return buildProgressIndicator(theme: theme, translate: translate);
    } else if (typeStatus == 'progress_percent') {
      return buildProgressPercent(theme: theme, translate: translate);
    }
    return buildText(theme: theme, translate: translate);
  }
}
