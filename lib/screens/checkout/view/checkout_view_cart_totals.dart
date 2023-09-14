import 'package:cirilla/screens/cart/widgets/cart_total.dart';
import 'package:cirilla/store/cart/cart_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class CheckoutViewCartTotals extends StatelessWidget {
  final CartStore cartStore;

  const CheckoutViewCartTotals({Key? key, required this.cartStore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) => CartTotal(cartData: cartStore.cartData!));
  }
}
