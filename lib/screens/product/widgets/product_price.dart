import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';

import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductPrice extends StatelessWidget with ProductMixin {
  final Product? product;
  final String? align;
  final double pad;

  const ProductPrice({Key? key, this.product, this.align = 'left', this.pad = 17}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    // Configs
    SettingStore settingStore = Provider.of<SettingStore>(context);

    Data data = settingStore.data!.screens!['products']!;
    WidgetConfig widgetConfig = data.widgets!['productListPage']!;

    String themeModeKey = settingStore.themeModeKey;

    AlignmentDirectional alignment = align == 'right'
        ? AlignmentDirectional.centerEnd
        // ? Alignment.centerRight
        : align == 'center'
            ? AlignmentDirectional.center
            : AlignmentDirectional.centerStart;

    Color subTextColor = ConvertData.fromRGBA(
        get(widgetConfig.styles, ['subTextColor', themeModeKey], {}), theme.textTheme.bodySmall!.color);
    Color priceColor = ConvertData.fromRGBA(
        get(widgetConfig.styles, ['priceColor', themeModeKey], {}), theme.textTheme.titleMedium!.color);
    Color salePriceColor =
        ConvertData.fromRGBA(get(widgetConfig.styles, ['salePriceColor', themeModeKey], {}), ColorBlock.red);
    Color regularPriceColor = ConvertData.fromRGBA(
        get(widgetConfig.styles, ['regularPriceColor', themeModeKey], {}), theme.textTheme.bodySmall!.color);

    return Container(
      alignment: alignment,
      child: buildPrice(
        context,
        product: product!,
        regularStyle: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.normal, color: regularPriceColor),
        saleStyle: theme.textTheme.titleMedium?.copyWith(color: salePriceColor),
        priceStyle: theme.textTheme.titleMedium?.copyWith(color: priceColor),
        styleFrom: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.normal, color: subTextColor),
        enablePercentSale: true,
        spacing: pad,
        shimmerWidth: 20,
        shimmerHeight: 90,
      ),
    );
  }
}
