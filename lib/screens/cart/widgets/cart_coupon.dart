import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/models/cart/cart.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/mixins/cart_mixin.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/types/types.dart';

class CartCoupon extends StatefulWidget {
  final Function(BuildContext context, int packageId, String rateId)? selectShipping;
  final CartStore? cartStore;
  final bool? enableGuestCheckout;
  final bool? enableShipping;
  final bool? enableCoupon;

  const CartCoupon({
    Key? key,
    this.cartStore,
    this.enableGuestCheckout,
    this.selectShipping,
    this.enableShipping,
    this.enableCoupon,
  }) : super(key: key);

  @override
  State<CartCoupon> createState() => _CartCouponState();
}

class _CartCouponState extends State<CartCoupon> with Utility, CartMixin, SnackMixin, GeneralMixin, LoadingMixin {
  bool _loading = false;
  bool loadingRemove = false;
  bool select = false;
  int? indexSelect;
  TextEditingController myController = TextEditingController();

  Future<void> _removeCoupon(BuildContext context, int index) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    try {
      setState(() {
        loadingRemove = true;
      });
      await widget.cartStore!.removeCoupon(code: widget.cartStore!.cartData!.coupons!.elementAt(index)['code']);
      setState(() {
        loadingRemove = false;
      });
      if (mounted) showSuccess(context, translate('cart_coupon_remove'));
    } catch (e) {
      setState(() {
        loadingRemove = false;
      });
      showError(context, e);
    }
  }

  Future<void> _applyCoupon() async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    try {
      setState(() {
        _loading = true;
      });
      await widget.cartStore!.applyCoupon(code: myController.text);
      setState(() {
        _loading = false;
      });
      if (mounted) showSuccess(context, translate('cart_successfully'));
      myController.clear();
    } catch (e) {
      myController.clear();
      setState(() {
        widget.cartStore!.loading;
        _loading = false;
      });
      showError(context, e);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CartData cartData = widget.cartStore!.cartData!;

    TranslateType translate = AppLocalizations.of(context)!.translate;

    ThemeData theme = Theme.of(context);

    TextTheme textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.enableCoupon == true) ...[
          Text(translate('cart_coupon'), style: textTheme.titleSmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Padding(
                      padding:
                          const EdgeInsetsDirectional.only(end: itemPadding, top: itemPadding, bottom: itemPadding),
                      child: TextField(
                        style: textTheme.bodyMedium?.copyWith(color: theme.textTheme.titleMedium?.color),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsetsDirectional.only(start: itemPaddingMedium),
                          hintText: translate('cart_coupon_discount'),
                          hintStyle: textTheme.bodyMedium,
                          border: const OutlineInputBorder(
                            borderRadius: borderRadius,
                          ),
                        ),
                        controller: myController,
                      ))),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(89, 48)),
                onPressed: () {
                  setState(() {
                    _loading = true;
                  });
                  if (!widget.cartStore!.loading) _applyCoupon();
                },
                child: widget.cartStore!.loading && _loading
                    ? entryLoading(context, color: theme.colorScheme.onPrimary)
                    : Text(translate('cart_apply')),
              )
            ],
          ),
          Stack(
            children: [
              Column(
                children: List.generate(cartData.coupons!.length, (index) {
                  String couponTitle = get(cartData.coupons!.elementAt(index), ['code'], '');
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(couponTitle, style: textTheme.bodyMedium?.copyWith(color: theme.primaryColor)),
                      InkResponse(
                        onTap: () async {
                          setState(() {
                            loadingRemove = true;
                          });
                          if (!widget.cartStore!.loading) _removeCoupon(context, index);
                        },
                        child: const Icon(FeatherIcons.x, size: itemPaddingMedium),
                      )
                    ],
                  );
                }),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: widget.cartStore!.loading && loadingRemove
                    ? Align(
                        alignment: Alignment.center,
                        child: entryLoading(context, color: theme.colorScheme.primary),
                      )
                    : Container(),
              )
            ],
          ),
          const Divider(height: 32, thickness: 1),
        ],
      ],
    );
  }
}
