import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/store/cart/cart_store.dart';
import 'package:cirilla/widgets/cirilla_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class CartCountVideoShop extends StatelessWidget {

  const CartCountVideoShop({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    CartStore cartStore = Provider.of<AuthStore>(context).cartStore;
    return Observer(builder: (context) {
      return CirillaBadge(
        size: 18,
        padding: paddingHorizontalTiny,
        label: "${cartStore.cartData?.itemsCount ?? 0}",
        type: CirillaBadgeType.error,
      );
    },);
  }
}
