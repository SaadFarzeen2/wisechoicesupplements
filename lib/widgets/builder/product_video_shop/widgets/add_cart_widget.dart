import 'package:cirilla/mixins/cart_mixin.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/product/product_type.dart';
import 'package:cirilla/screens/auth/login_mobile_screen.dart';
import 'package:cirilla/screens/product/product.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:cirilla/utils/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cirilla/models/models.dart';

import 'package:cirilla/utils/app_localization.dart';
import 'cart_count.dart';

class AddCartVideoShop extends StatefulWidget {
  const AddCartVideoShop({
    Key? key,
    required this.product,
    required this.stockStatus,
  }) : super(key: key);
  final Product product;
  final String stockStatus;

  @override
  State<AddCartVideoShop> createState() => _AddCartVideoShopState();
}

class _AddCartVideoShopState extends State<AddCartVideoShop> with CartMixin, SnackMixin, NavigationMixin, ShapeMixin {
  late SettingStore _settingStore;
  late AuthStore _authStore;
  Map<String, dynamic> fields = {};
  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);
    _authStore = Provider.of<AuthStore>(context);

    final WidgetConfig? widgetConfig =
    _settingStore.data != null ? _settingStore.data!.settings!['general']!.widgets!['general'] : null;
    fields = widgetConfig != null ? (widgetConfig.fields ?? {}) : {};
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 15.0),
        width: 60.0,
        height: 60.0,
        child: Column(children: [
          InkWell(
            onTap: () async {
              await _handleAddToCart(context);
            },
            child: SizedBox(
              width: 35,
              height: 35,
              child: Stack(
                children: const [
                  Icon(Icons.add_shopping_cart_outlined, size: 30.0, color: Colors.white),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: CartCountVideoShop(),
                  )
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Text("Buy Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12.0)),
          )
        ]));
  }

  ///
  /// Handle add to cart
  Future<void> _handleAddToCart(BuildContext context) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    if (widget.product.id == null) return;

    if (widget.product.type == productTypeExternal) {
      await launch(widget.product.externalUrl!);
      return;
    }

    if (widget.stockStatus == 'outofstock') {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      showError(context, translate('product_status_outstock'));
      return;
    }

    bool requiredLogin = get(fields, ['forceLoginAddToCart'], false) && !_authStore.isLogin;
    bool enableProductQuickView = get(fields, ['enableProductQuickView'], false);

    if (requiredLogin) {
      Navigator.of(context).pushNamed(
        LoginMobileScreen.routeName,
        arguments: {
          'showMessage': ({String? message}) {
            avoidPrint('Login Success');
          },
        },
      );
      return;
    }

    if (enableProductQuickView) {
      _showQuickView();
      return;
    }

    if (widget.product.type == productTypeVariable ||
        widget.product.type == productTypeGrouped ||
        widget.product.type == productTypeAppointment) {
      _navigate(context);
      return;
    }

    try {
      await addToCart(productId: widget.product.id, qty: 1);
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        showSuccess(
          context,
          translate('product_add_to_cart_success'),
          action: SnackBarAction(
            label: translate('product_view_cart'),
            textColor: Colors.white,
            onPressed: () {
              navigate(context, {
                'type': 'tab',
                'route': '/',
                'args': {'key': 'screens_cart'}
              });
            },
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      showError(context, e);
    }
  }

  ///
  /// Handle navigate
  void _navigate(BuildContext context) {
    if (widget.product.id == null) return;
    Navigator.pushNamed(context, '${ProductScreen.routeName}/${widget.product.id}/${widget.product.slug}',
        arguments: {'product': widget.product});
  }

  _showQuickView() {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      shape: borderRadiusTop(),
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ProductScreen(
            store: _settingStore,
            args: {'product': widget.product},
            isQuickView: true,
          ),
        );
      },
    );
  }
}
