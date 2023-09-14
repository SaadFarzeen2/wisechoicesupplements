import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/models/cart/gateway.dart';
import 'package:cirilla/payment_methods.dart';
import 'package:flutter/material.dart';
import 'package:ui/button_select/button_select.dart';

class PaymentMethod extends StatelessWidget {
  final double padHorizontal;
  final List<Gateway> gateways;
  final int active;
  final void Function(int index) select;

  const PaymentMethod({
    Key? key,
    this.padHorizontal = layoutPadding,
    required this.gateways,
    required this.active,
    required this.select,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: padHorizontal),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(gateways.length, (index) {
              double padEnd = index < gateways.length - 1 ? itemPaddingMedium : 0;
              String? imageMethod = methods[gateways[index].id]?.logoPath;
              String? packageName = methods[gateways[index].id]?.libraryName;
              if (packageName != null) {
                if (packageName.isEmpty) {
                  packageName = null;
                }
              }
              return Padding(
                padding: EdgeInsetsDirectional.only(end: padEnd),
                child: InkWell(
                  onTap: () => select(index),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: ButtonSelect.icon(
                      isSelect: active == index,
                      colorSelect: theme.primaryColor,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            // child: const CirillaCacheImage('', width: 35, height: 35),
                            child: Image.asset(
                              imageMethod ?? "",
                              width: 35,
                              height: 35,
                              package: packageName,
                            ),
                          ),
                          const SizedBox(width: itemPaddingMedium),
                          Flexible(
                            child: Text(
                              gateways[index].title ?? '',
                              style:
                                  theme.textTheme.titleSmall?.copyWith(color: 0 == index ? theme.primaryColor : null),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        if (gateways.isNotEmpty)
          Padding(
            padding: EdgeInsets.fromLTRB(padHorizontal, itemPaddingExtraLarge, padHorizontal, 0),
            child: Container(
              padding: paddingMedium,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Text(
                gateways[active].description ?? '',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
      ],
    );
  }
}
