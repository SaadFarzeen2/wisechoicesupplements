import 'package:cirilla/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:ui/button_select/button_select.dart';

import 'total_view.dart';

class ShippingMethod extends StatelessWidget {
  final double padHorizontal;

  const ShippingMethod({Key? key, this.padHorizontal = layoutPadding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(padHorizontal, 0, padHorizontal, 5),
          child: Text('Zara Shipping', style: theme.textTheme.titleLarge),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: padHorizontal),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(5, (index) {
              double padEnd = index < 4 ? itemPaddingMedium : 0;
              return Padding(
                padding: EdgeInsetsDirectional.only(end: padEnd),
                child: ButtonSelect.icon(
                  isSelect: index == 0,
                  colorSelect: theme.primaryColor,
                  child: Text('Flat Rate : \$10',
                      style: theme.textTheme.titleSmall?.copyWith(color: index == 0 ? theme.primaryColor : null)),
                ),
              );
            }),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(padHorizontal, itemPaddingMedium, padHorizontal, 0),
          child: const TotalView(title: 'Door Bumper ×1', price: '\$190.00', type: TotalType.containerPrice),
        ),
      ],
    );
  }
}
