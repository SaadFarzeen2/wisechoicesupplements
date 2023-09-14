import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/models/order/order.dart';
import 'package:cirilla/utils/currency_format.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class OrderItem extends StatefulWidget {
  final int? quantity;
  final String? name;
  final int? price;
  final Function? onClick;
  final String? currencySymbol;
  final String? currency;
  final String? sku;
  final LineItems? productData;
  const OrderItem({
    Key? key,
    this.name,
    this.price,
    this.onClick,
    this.currencySymbol,
    this.currency,
    this.sku,
    this.productData,
    this.quantity,
  }) : super(key: key);
  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> with Utility {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData mediaQuery = MediaQuery.of(context);

    String name = get(widget.productData!.name, [], '');

    int? quantity = get(widget.productData!.quantity, [], 0);

    String? price = get(widget.productData!.subtotal, [], '');

    String? sku = get(widget.productData!.sku, [], '');

    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        double maxWidth = constraints.maxWidth != double.infinity ? constraints.maxWidth : mediaQuery.size.width;
        double widthView = maxWidth - itemPaddingMedium;

        return Column(
          children: [
            ProductCartItem(
              name: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(child: CirillaHtml(html: name)),
                  Text(' x ${quantity.toString()}', style: theme.textTheme.bodyMedium)
                ],
              ),
              price: Text(
                formatCurrency(context, price: price, symbol: widget.currencySymbol, currency: widget.currency),
                style: theme.textTheme.titleSmall,
              ),
              attribute: Table(
                columnWidths: const <int, TableColumnWidth>{
                  0: IntrinsicColumnWidth(),
                  1: FlexColumnWidth(),
                },
                children: [
                  ...List.generate(
                    widget.productData!.metaData!.length,
                    (index) {
                      Map<String, dynamic> metaData = widget.productData!.metaData!.elementAt(index);
                      var displayKey = get(metaData, ['display_key'], '');
                      var value = get(metaData, ['display_value'], '');
                      return TableRow(
                        children: [
                          Container(
                            constraints: BoxConstraints(maxWidth: widthView / 2),
                            child: !displayKey.startsWith('_')
                                ? Text("$displayKey : ", style: theme.textTheme.bodySmall)
                                : Container(),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(start: itemPaddingMedium),
                            child: !displayKey.startsWith('_')
                                ? Text(value,
                                    style:
                                        theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.titleMedium?.color))
                                : Container(),
                          )
                        ],
                      );
                    },
                  ),
                  if (sku != '')
                    TableRow(
                      children: [
                        Container(
                          constraints: BoxConstraints(maxWidth: widthView / 2),
                          child: Text('sku : ', style: theme.textTheme.bodySmall),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: itemPaddingMedium),
                          child: Text(sku!,
                              style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.titleMedium?.color)),
                        )
                      ],
                    ),
                ],
              ),
              onClick: () => widget.onClick!(),
              padding: paddingVerticalLarge,
            ),
            const Divider(height: 0, thickness: 1),
          ],
        );
      },
    );
  }
}
