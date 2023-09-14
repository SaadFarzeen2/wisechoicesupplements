import 'dart:developer';

import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/cart_mixin.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/cart/cart.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/cart/widgets/cart_coupon.dart';
import 'package:cirilla/screens/cart/widgets/cart_items.dart';
import 'package:cirilla/screens/cart/widgets/cart_shipping.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/service/constants/endpoints.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:ui/notification/notification_screen.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/utils/url_launcher.dart';

import 'widgets/cart_total.dart';

class CartScreen extends StatefulWidget {
  final Function(BuildContext context, int packageId, String rateId)?
      selectShipping;

  const CartScreen({Key? key, this.selectShipping}) : super(key: key);

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen>
    with
        LoadingMixin,
        Utility,
        CartMixin,
        SnackMixin,
        NavigationMixin,
        AppBarMixin,
        GeneralMixin {
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();
  TextEditingController myController = TextEditingController();
  late CartStore _cartStore;
  late SettingStore _settingStore;
  bool enableKey = false;
  List<CartItem>? _items = List<CartItem>.of([]);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cartStore = Provider.of<AuthStore>(context).cartStore;
    _settingStore = Provider.of<SettingStore>(context);
    getData();
  }

  Future<void> getData() async {
    try {
      await _cartStore.getCart();
      if (_cartStore.cartData != null) {
        if (mounted) {
          setState(() {
            _items = _cartStore.cartData!.items;
          });
        }
      }
    } catch (e) {
      avoidPrint(e);
      rethrow;
    }
  }

  updateQuantity(CartItem cartItem, int value) {
    _cartStore.updateQuantity(key: cartItem.key, quantity: value);
  }

  Future<void> onRemoveItem(
      BuildContext context, CartItem cartItem, int index) async {
    _listKey.currentState!.removeItem(index, (_, animation) {
      return SizeTransition(
        sizeFactor: animation,
        child: Item(
          cartItem: cartItem,
          updateQuantity: (CartItem cartItem, int value) {
            avoidPrint('removed');
          },
        ),
      );
    }, duration: const Duration(milliseconds: 250));
    _items!.removeAt(index);
    try {
      await _cartStore.removeCart(key: cartItem.key);
    } catch (e) {
      showError(context, e);
    }
  }

  void _checkoutLaunch(BuildContext context) {
    AuthStore authStore = Provider.of<AuthStore>(context, listen: false);
    SettingStore settingStore =
        Provider.of<SettingStore>(context, listen: false);
    Map<String, String?> queryParams = {
      'cart_key_restore': _cartStore.cartKey!,
      'app-builder-checkout-body-class': 'app-builder-checkout'
    };

    if (authStore.isLogin) {
      queryParams.putIfAbsent('app-builder-decode', () => 'true');
      queryParams.putIfAbsent('app-builder-token', () => authStore.token);
    }

    if (settingStore.isCurrencyChanged) {
      queryParams.putIfAbsent('currency', () => settingStore.currency);
    }

    if (settingStore.languageKey != "text") {
      queryParams.putIfAbsent(
          authStore.isLogin ? '_lang' : 'lang', () => settingStore.locale);
    }

    String url = authStore.isLogin
        ? Endpoints.restUrl + Endpoints.loginToken
        : settingStore.checkoutUrl!;

    String checkoutUrl = "$url?${Uri(queryParameters: queryParams).query}";
    launch(checkoutUrl);
  }

  void _checkout(BuildContext context) {
    AuthStore authStore = Provider.of<AuthStore>(context, listen: false);
    SettingStore settingStore =
        Provider.of<SettingStore>(context, listen: false);

    if (getConfig(settingStore, ['forceLoginCheckout'], false) &&
        !authStore.isLogin) {
      log('asdfghjkl');
      Navigator.of(context).pushNamed(
        LoginScreen.routeName,
        arguments: {
          'showMessage': ({String? message}) {
            avoidPrint('Login Success');
          }
        },
      );
    } else {
      if (isWeb) {
        log('1111112222222222333333344444');

        _checkoutLaunch(context);
      } else {
        log('0000000000000000000000000');
        log(getConfig(settingStore, ['customCheckout'], false).toString());

        Navigator.of(context).pushNamed(
          getConfig(settingStore, ['customCheckout'], false)
              ? Checkout.routeName
              : CheckoutWebView.routeName,
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      CartData? cartData = _cartStore.cartData;

      if (_items != cartData?.items) {
        _items = cartData?.items;
      }

      enableKey = !_cartStore.loadingAddCart;

      bool isEmpty = cartData == null || _items?.isEmpty == true;

      return Scaffold(
        appBar: buildAppBar(isEmpty: isEmpty),
        body: Stack(
          children: [
            if (!isEmpty && !_cartStore.isMergeCart) buildContent(),
            if (isEmpty) buildCartEmpty(context),
            if (_cartStore.loadingRemoveCart ||
                _cartStore.isMergeCart ||
                _cartStore.loadingShipping)
              Align(
                alignment: FractionalOffset.center,
                child: buildLoadingOverlay(context),
              ),
          ],
        ),
      );
    });
  }

  Future<void> buildDialog(
      BuildContext context, TranslateType translate) async {
    String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(translate('cart_delete_dialog_title')),
        content: Text(translate('cart_delete_dialog_description')),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text(translate('cart_delete_dialog_cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: Text(translate('cart_delete_dialog_ok')),
          ),
        ],
      ),
    );
    if (result == "OK") {
      await _cartStore.cleanCart();
    }
  }

  AppBar buildAppBar({required bool isEmpty}) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    ThemeData theme = Theme.of(context);

    TextTheme textTheme = theme.textTheme;

    int? count = _items?.length;

    return AppBar(
      actions: [
        Visibility(
          visible: !isEmpty,
          child: IconButton(
            padding: const EdgeInsets.only(right: itemPadding),
            icon: const Icon(FeatherIcons.trash2),
            onPressed: () => buildDialog(context, translate),
            iconSize: 20,
          ),
        )
      ],
      title: Text(
        translate('cart_count', {'count': !isEmpty ? '($count)' : ''}),
        style: textTheme.titleMedium,
      ),
      shadowColor: Colors.transparent,
      centerTitle: true,
    );
  }

  Widget buildContent() {
    int? count = _items?.length;
    bool loading = _cartStore.loading;
    return CustomScrollView(
      slivers: <Widget>[
        SliverAnimatedList(
          key: enableKey && !loading ? _listKey : Key('$count'),
          itemBuilder: (context, index, animation) {
            CartItem? cartItem = _items?[index];
            if (cartItem == null) {
              return const SizedBox();
            }
            return buildItem(cartItem, animation, index);
          },
          initialItemCount: count!,
        ),
        SliverToBoxAdapter(child: buildBill(context)),
      ],
    );
  }

  Widget buildItem(CartItem cartItem, Animation animation, int index) {
    return SizeTransition(
      sizeFactor: animation as Animation<double>,
      child: Column(
        children: [
          Item(
            iscartpage: true,
            key: Key('${cartItem.key}'),
            cartItem: cartItem,
            onRemove: !_cartStore.loadingRemoveCart
                ? () => onRemoveItem(context, cartItem, index)
                : null,
            updateQuantity: updateQuantity,
          ),
          const Divider(height: 2, thickness: 1),
        ],
      ),
    );
  }

  Widget buildBill(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    ThemeData theme = Theme.of(context);

    TextTheme textTheme = theme.textTheme;

    // Configs
    CartData? cartData = _cartStore.cartData;

    Data data = get(_settingStore.data?.screens, ['cart']);

    Map<String, WidgetConfig> widgets = data.widgets ?? {};

    Map<String, dynamic> fields = widgets['cartPage']?.fields ?? {};

    bool enableShipping = get(fields, ['enableShipping'], true);

    bool enableCoupon = get(fields, ['enableCoupon'], true);
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: layoutPadding,
        end: layoutPadding,
        top: itemPaddingLarge,
        bottom: 150,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CartCoupon(
            cartStore: _cartStore,
            enableGuestCheckout: true,
            enableShipping: enableShipping,
            enableCoupon: enableCoupon,
          ),
          if (enableShipping == true && cartData?.needsShipping == true) ...[
            Text(translate('cart_shipping'), style: textTheme.titleMedium),
            const SizedBox(height: 4),
            CartShipping(
              cartData: cartData,
              cartStore: _cartStore,
            ),
            const SizedBox(height: itemPaddingLarge),
          ],
          CartTotal(cartData: cartData!),
          const SizedBox(height: itemPaddingExtraLarge),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48)),
            child: Text(translate('cart_proceed_to_checkout')),
            onPressed: () => _checkout(context),
          ),
        ],
      ),
    );
  }

  Widget buildCartEmpty(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    ThemeData theme = Theme.of(context);

    TextTheme textTheme = theme.textTheme;
    return NotificationScreen(
      title: Text(translate('cart_no_count'), style: textTheme.titleLarge),
      content: Text(
        translate('cart_is_currently_empty'),
        style: textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
      iconData: FeatherIcons.shoppingCart,
      textButton: Text(translate('cart_return_shop')),
      styleBtn: ElevatedButton.styleFrom(padding: paddingHorizontalLarge),
      onPressed: () => navigate(context, {
        "type": "tab",
        "router": "/",
        "args": {"key": "screens_category"}
      }),
    );
  }
}
