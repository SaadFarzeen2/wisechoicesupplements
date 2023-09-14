import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/models/product/product_type.dart';
import 'package:cirilla/screens/vendor/vendor_chat_button.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/widgets/cirilla_cart_icon.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:awesome_icons/awesome_icons.dart';
import 'package:share/share.dart';
import 'package:cirilla/utils/url_launcher.dart';

class ProductBottomBar extends StatefulWidget {
  final Map<String, dynamic>? configs;
  final Product? product;
  final Widget? qty;

  final Function(bool? goCartPage)? onPress;
  final bool? loading;

  const ProductBottomBar({
    Key? key,
    this.configs,
    this.product,
    this.qty,
    this.onPress,
    this.loading,
  }) : super(key: key);

  @override
  State<ProductBottomBar> createState() => _ProductBottomBarState();
}

class _ProductBottomBarState extends State<ProductBottomBar>
    with AppBarMixin, Utility, NavigationMixin, WishListMixin, LoadingMixin {
  int buttonAdd = 1;

  void addToCart(bool goCart, int typeButton) async {
    if (loading) return;
    if (widget.product!.type == productTypeExternal) {
      await launch(widget.product!.externalUrl!);
      return;
    }
    setState(() {
      buttonAdd = typeButton;
    });
    widget.onPress!(goCart);
  }

  @override
  Widget build(BuildContext context) {
    bool enableBottomBarSearch = get(widget.configs, ['enableBottomBarSearch'], false);
    bool enableBottomBarHome = get(widget.configs, ['enableBottomBarHome'], false);
    bool enableBottomBarShare = get(widget.configs, ['enableBottomBarShare'], true);
    bool enableBottomBarWishList = get(widget.configs, ['enableBottomBarWishList'], true);
    bool enableBottomBarCart = get(widget.configs, ['enableBottomBarCart'], true);
    bool enableBottomBarAddToCart = get(widget.configs, ['enableBottomBarAddToCart'], true);
    bool enableBottomBarQty = get(widget.configs, ['enableBottomBarQty'], false);
    bool enableBuyNow = get(widget.configs, ['enableBuyNow'], false);
    bool enableChat = get(widget.configs, ['enableChat'], false);
    bool isOutOfStock = widget.product?.stockStatus == 'outofstock';

    bool canBuyNow = widget.product!.type == productTypeSimple || widget.product!.type == productTypeVariable;

    bool showQty = enableBottomBarQty && widget.product!.type != productTypeExternal;
    bool showBottomNow = enableBuyNow && canBuyNow;

    return BottomAppBar(
      notchMargin: 8.0,
      shape: const CircularNotchedRectangle(),
      elevation: 8,
      child: Container(
        padding: paddingVerticalTiny,
        child: Row(
          children: [
            if (enableBottomBarHome) iconHome(context),
            if (enableBottomBarSearch) iconSearch(context),
            if (showQty) qty(context),
            if (!enableBottomBarAddToCart || (!enableBottomBarAddToCart && !showBottomNow)) const Spacer(),
            if (enableBottomBarWishList) iconWishList(context),
            if (enableBottomBarShare) iconShare(context),
            if (enableBottomBarCart) iconCart(context),
            if (enableBottomBarAddToCart) addToCartBottom(context, showQty, showBottomNow, isOutOfStock),
            if (showBottomNow) buyNowBottom(context, showQty, enableBottomBarAddToCart, isOutOfStock),
            if (enableChat) chatVendor(context),
            if (showQty && enableBottomBarAddToCart && showBottomNow) const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }

  Widget chatVendor(BuildContext context) {
    Map<String, dynamic> store = widget.product?.store ?? {};
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 20),
      child: VendorChatButton(vendor: Vendor.fromJson(store)),
    );
  }

  Widget qty(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(start: 20, end: 11),
      height: 48,
      // width: 100,
      child: widget.qty,
    );
  }

  Widget buyNowBottom(BuildContext context, bool enableQty, bool enableAddCart, bool disableStock) {
    EdgeInsetsGeometry margin = !enableAddCart && !enableQty
        ? const EdgeInsets.symmetric(horizontal: 20)
        : enableAddCart && !enableQty
            ? const EdgeInsetsDirectional.only(start: 8, end: 20)
            : !enableAddCart && enableQty
                ? const EdgeInsetsDirectional.only(end: 20)
                : const EdgeInsetsDirectional.only(start: 4);
    return Expanded(
      child: Container(
        margin: margin,
        height: 48,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(elevation: 0),
          onPressed: disableStock ? null : () => addToCart(true, 2),
          child: buttonAdd == 2 && widget.loading!
              ? entryLoading(context, color: Colors.white)
              : Text(AppLocalizations.of(context)!.translate('product_buy_now')),
        ),
      ),
    );
  }

  Widget addToCartBottom(BuildContext context, bool enableQty, bool enableBuyNow, bool disableStock) {
    ThemeData theme = Theme.of(context);
    EdgeInsetsGeometry margin = !enableBuyNow && !enableQty
        ? const EdgeInsets.symmetric(horizontal: 20)
        : enableBuyNow && !enableQty
            ? const EdgeInsetsDirectional.only(start: 20, end: 8)
            : !enableBuyNow && enableQty
                ? const EdgeInsetsDirectional.only(end: 20)
                : const EdgeInsetsDirectional.only(end: 4);

    return Expanded(
      child: Container(
        margin: margin,
        height: 48,
        child: ElevatedButton(
          style: enableBuyNow
              ? ElevatedButton.styleFrom(
                  foregroundColor: theme.textTheme.titleMedium?.color,
                  backgroundColor: theme.colorScheme.surface,
                  elevation: 0,
                )
              : null,
          onPressed: disableStock ? null : () => addToCart(false, 1),
          child: buttonAdd == 1 && widget.loading!
              ? entryLoading(context,
                  color: enableBuyNow ? theme.textTheme.titleMedium?.color : theme.colorScheme.onPrimary)
              : Text(
                  widget.product!.type == productTypeExternal
                      ? widget.product!.buttonText != null && widget.product!.buttonText != ''
                          ? widget.product!.buttonText!
                          : AppLocalizations.of(context)!.translate('product_buy_now')
                      : AppLocalizations.of(context)!.translate('product_add_to_cart'),
                ),
        ),
      ),
    );
  }

  Widget iconHome(BuildContext context) {
    return IconButton(
      icon: const Icon(FeatherIcons.home, size: 20),
      onPressed: () => navigate(
        context,
        {
          'type': 'tab',
          'route': '/',
          'args': {'key': 'screens_home'}
        },
      ),
    );
  }

  Widget iconSearch(BuildContext context) {
    return IconButton(
      icon: const Icon(FeatherIcons.search, size: 20),
      onPressed: () => navigate(
        context,
        {
          'type': 'tab',
          'route': '/',
          'args': {'key': 'screens_category'}
        },
      ),
    );
  }

  Widget iconWishList(BuildContext context) {
    return IconButton(
      icon: Icon(
        existWishList(productId: widget.product!.id) ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
        size: 20,
      ),
      onPressed: () {
        addWishList(productId: widget.product!.id);
      },
    );
  }

  Widget iconShare(BuildContext context) {
    return IconButton(
      icon: const Icon(FeatherIcons.share2, size: 20),
      onPressed: () => Share.share(widget.product!.permalink!, subject: widget.product!.name),
    );
  }

  Widget iconCart(BuildContext context) {
    return Row(
      children: [
        CirillaCartIcon(
          color: Theme.of(context).appBarTheme.backgroundColor!.withOpacity(0.6),
        ),
      ],
    );
  }
}
