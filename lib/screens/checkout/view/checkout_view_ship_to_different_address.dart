import 'package:cirilla/store/cart/checkout_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class CheckoutViewShipToDifferentAddress extends StatelessWidget {
  final CheckoutStore checkoutStore;

  const CheckoutViewShipToDifferentAddress({Key? key, required this.checkoutStore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Observer(
      builder: (_) => CirillaTile(
        title: Text(translate('checkout_shipping_address'), style: theme.textTheme.titleMedium),
        trailing: Icon(
          checkoutStore.shipToDifferentAddress ? FeatherIcons.minus : FeatherIcons.plus,
          size: 16,
          color: theme.textTheme.titleMedium?.color,
        ),
        isChevron: false,
        isDivider: false,
        onTap: checkoutStore.onShipToDifferentAddress,
      ),
    );
  }
}
