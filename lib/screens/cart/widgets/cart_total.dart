import 'dart:developer';

import 'package:cirilla/models/cart/cart.dart';
import 'package:flutter/material.dart';

import '../../../mixins/utility_mixin.dart';
import '../../../types/types.dart';
import '../../../utils/app_localization.dart';
import '../../../utils/currency_format.dart';
import 'package:cirilla/extension/strings.dart';

class CartTotal extends StatefulWidget {
  final CartData cartData;
  const CartTotal({Key? key, required this.cartData}) : super(key: key);

  @override
  State<CartTotal> createState() => _CartTotalState();
}

class _CartTotalState extends State<CartTotal> {
  @override
  void initState() {
    // TODO: implement initState
    log(widget.cartData.totals.toString());
    log(widget.cartData.shippingRate!.elementAt(0).shipItem.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? subTotal = get(widget.cartData.totals, ['total_items'], '0');

    String? subTax = get(widget.cartData.totals, ['total_tax'], '0');
    String? discount = get(widget.cartData.totals, ['total_fees'], '0');

    log(" ffff " + discount.toString());
    String? totalPrice = get(widget.cartData.totals, ['total_price'], '0');

    int? unit = get(widget.cartData.totals, ['currency_minor_unit'], 0);

    String? currencyCode = get(widget.cartData.totals, ['currency_code'], null);
    TranslateType translate = AppLocalizations.of(context)!.translate;
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return Column(
      children: [
        buildCartTotal(
          title: translate('cart_sub_total'),
          price: convertCurrency(context,
              unit: unit, currency: currencyCode, price: subTotal)!,
          style: textTheme.titleSmall,
        ),
        ...List.generate(
          widget.cartData.coupons!.length,
          (index) {
            String? coupon = get(widget.cartData.coupons!.elementAt(index),
                ['totals', 'total_discount'], '0');
            String? couponTitle =
                get(widget.cartData.coupons!.elementAt(index), ['code'], '');
            return Column(
              children: [
                const SizedBox(height: 4),
                buildCartTotal(
                  title: translate('cart_code_coupon', {'code': couponTitle!}),
                  price:
                      '- ${convertCurrency(context, unit: unit, currency: currencyCode, price: coupon)}',
                  style: textTheme.bodyMedium,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 4),
        ...List.generate(
          widget.cartData.shippingRate!.length,
          (index) {
            ShippingRate shippingRate =
                widget.cartData.shippingRate!.elementAt(index);

            List data = shippingRate.shipItem!;

            return Column(
              children: List.generate(data.length, (index) {
                ShipItem dataShipInfo = data.elementAt(index);

                String name = get(dataShipInfo.name, [], '');

                String? price = get(dataShipInfo.price, [], '');

                bool selected = get(dataShipInfo.selected, [], '');

                String? currencyCode = get(dataShipInfo.currencyCode, [], '');
                log('message $index  $selected');
                return selected
                    ? buildCartTotal(
                        title: StringParse(translate(name)).unescape,
                        price: convertCurrency(context,
                            unit: unit, currency: currencyCode, price: price)!,
                        style: textTheme.bodyMedium,
                      )
                    : Container();
              }),
            );
          },
        ),
        const SizedBox(height: 31),
        (double.parse(discount!)) * -1 > 0
            ? buildCartTotal(
                title: translate('order_discount'),
                price: convertCurrency(context,
                    unit: unit, currency: currencyCode, price: discount)!,
                style: textTheme.titleSmall)
            : SizedBox(),
        // buildCartTotal(
        //     title: translate('cart_tax'),
        //     price: convertCurrency(context,
        //         unit: unit, currency: currencyCode, price: subTax)!,
        //     style: textTheme.titleSmall),
        const SizedBox(height: 4),
        buildCartTotal(
          title: translate('cart_total'),
          price: convertCurrency(context,
              unit: unit, currency: currencyCode, price: totalPrice)!,
          style: textTheme.titleMedium,
        ),
      ],
    );
  }
}

Widget buildCartTotal(
    {BuildContext? context,
    required String title,
    required String price,
    TextStyle? style}) {
  log('   $title  $price');

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(
        child: Text(title, style: style),
      ),
      Text(price, style: style)
    ],
  );
}
