import 'dart:async';

import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/extension/list.dart';
import 'package:cirilla/mixins/general_mixin.dart';
import 'package:cirilla/mixins/loading_mixin.dart';
import 'package:cirilla/mixins/navigation_mixin.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/wishlist/widget/button_delete.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_product_item.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:ui/notification/notification_screen.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> with NavigationMixin, LoadingMixin, GeneralMixin {
  late SettingStore _settingStore;
  late ProductsStore _productsStore;
  late AppStore _appStore;
  late AuthStore _authStore;
  List<String> showedWishlist = [];
  late ReactionDisposer auto;
  late ReactionDisposer react;
  Timer? _debounceReload;

  WishListStore? _wishListStore;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _wishListStore!.setWishlistPlugin(enableWishlistPlugin);
      _wishListStore?.getDataWishlistPlugin();

      /// Add listen when wishlist data was changed.
      auto = autorun(
        (_) {
          List<String> wishlistIds = _wishListStore!.data.map((element) => element.toString()).toList();
          if (!showedWishlist.equals(wishlistIds) && wishlistIds.length >= showedWishlist.length) {
            _reloadWishlist(wishlistIds);
          }
          showedWishlist = [...wishlistIds];
        },
      );

      /// Add listen when products data was changed (when open page).
      react = reaction((p0) => _productsStore.products, (p0) {
        List<String> products = _productsStore.products.map((Product product) => '${product.id}').toList();
        if (_wishListStore!.data.isNotEmpty && products.isNotEmpty) {
          _wishListStore!.updateWishList(products);
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    auto.reaction.dispose();
    react.reaction.dispose();
    _debounceReload?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);
    _appStore = Provider.of<AppStore>(context);
    _authStore = Provider.of<AuthStore>(context);
    _wishListStore = _authStore.wishListStore;

    List<Product> productWishList = _wishListStore!.data.map((String id) => Product(id: int.parse(id))).toList();

    String? key = StringGenerate.getProductKeyStore(
      'wishlist_product',
      includeProduct: productWishList,
      currency: _settingStore.currency,
      language: _settingStore.locale,
    );

    if (_appStore.getStoreByKey(key) == null) {
      ProductsStore store = ProductsStore(
        perPage: _wishListStore!.data.length,
        _settingStore.requestHelper,
        include: productWishList,
        key: key,
        language: _settingStore.locale,
        currency: _settingStore.currency,
      );

      if (productWishList.isNotEmpty) {
        store.getProducts();
      }

      _appStore.addStore(store);
      _productsStore = store;
    } else {
      _productsStore = _appStore.getStoreByKey(key);
    }

    showedWishlist = [..._wishListStore!.data];

    super.didChangeDependencies();
  }

  /// For case: update wishlist then press back to wishlist screen.
  Future<void> _reloadWishlist(List<String> wishlistIds) async {
    List<Product> productWishList = wishlistIds.map((String id) => Product(id: int.parse(id))).toList();
    String? key = StringGenerate.getProductKeyStore(
      'wishlist_product',
      includeProduct: productWishList,
      currency: _settingStore.currency,
      language: _settingStore.locale,
    );

    if (_appStore.getStoreByKey(key) == null) {
      ProductsStore store = ProductsStore(
        _settingStore.requestHelper,
        perPage: _wishListStore!.data.length,
        include: productWishList,
        key: key,
        language: _settingStore.locale,
        currency: _settingStore.currency,
      );
      if (productWishList.isNotEmpty) {
        store.getProducts();
      }

      _appStore.addStore(store);
      _productsStore = store;
    } else {
      _productsStore = _appStore.getStoreByKey(key);
    }

    /// When reload done, check and update wishlist if products data missing.
    if (_debounceReload?.isActive ?? false) _debounceReload?.cancel();
    _debounceReload = Timer(const Duration(seconds: 2), () {
      if (_productsStore.products.length < _wishListStore!.data.length) {
        List<String> products = _productsStore.products.map((Product product) => '${product.id}').toList();
        if (_wishListStore!.data.isNotEmpty && products.isNotEmpty) {
          _wishListStore!.updateWishList(products);
        }
      }
    });
  }

  void dismissItem(
    BuildContext context,
    int index,
    Product product,
  ) {
    String id = _wishListStore!.data[index];

    _wishListStore!.addWishList(id);

    final snackBar = SnackBar(
      content: Text(AppLocalizations.of(context)!.translate('wishlist_notification_deleted', {'name': product.name})),
      action: SnackBarAction(
        label: AppLocalizations.of(context)!.translate('undo'),
        onPressed: () {
          _wishListStore!.addWishList(id, position: index);
        },
      ),
    );
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    double widthItem = width - 40;
    double heightItem = (widthItem * 102) / 86;

    return Observer(builder: (_) {
      List<Product> productsFromResponse = _productsStore.products;
      return Scaffold(
        appBar: _buildAppbar(context) as PreferredSizeWidget?,
        body: _wishListStore!.data.isEmpty
            ? _buildNoWishList(context)
            : ListView.builder(
                itemCount: _wishListStore!.data.length,
                itemBuilder: (context, index) {
                  Product product = productsFromResponse.firstWhere(
                    (p) => '${p.id}' == _wishListStore!.data[index],
                    orElse: () => Product(),
                  );

                  Widget child = Column(
                    children: [
                      Padding(
                        padding: paddingHorizontal.add(paddingVerticalLarge),
                        child: CirillaProductItem(
                          product: product,
                          template: Strings.productItemHorizontal,
                          width: widthItem,
                          height: heightItem,
                        ),
                      ),
                      const Divider(height: 1, thickness: 1),
                    ],
                  );

                  if (product.id == null) {
                    return child;
                  }
                  return Slidable(
                    key: ValueKey(product.id),
                    endActionPane: ActionPane(
                      extentRatio: 0.2,
                      motion: const ScrollMotion(),
                      children: [
                        Expanded(
                          child: ButtonSlidable(
                            icon: Icons.delete_forever,
                            colorIcon: const Color(0xFFFF5200),
                            onPressed: () => dismissItem(context, index, product),
                          ),
                        )
                      ],
                    ),
                    child: child,
                  );
                },
              ),
      );
    });
  }

  Widget _buildAppbar(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return AppBar(
      title: Column(
        children: [
          Text(
            translate('wishlist'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
              translate(
                'wishlist_items',
                {
                  'count': _wishListStore!.count.toString(),
                },
              ),
              style: Theme.of(context).textTheme.bodySmall)
        ],
      ),
      actions: const [
        Padding(
          padding: EdgeInsetsDirectional.only(end: 17),
          child: CirillaCartIcon(
            icon: Icon(FeatherIcons.shoppingCart),
            enableCount: true,
            color: Colors.transparent,
          ),
        )
      ],
      elevation: 0,
      titleSpacing: 20,
      centerTitle: true,
    );
  }

  Widget _buildNoWishList(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return NotificationScreen(
      iconData: FeatherIcons.heart,
      title: SizedBox(
        width: 147,
        child: Text(
          translate('wishlist'),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      content: SizedBox(
        width: 220,
        child: Text(
          translate('wishlist_empty_description'),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      styleBtn: ElevatedButton.styleFrom(padding: paddingHorizontalLarge),
      textButton: Text(translate('wishlist_return_shop')),
      onPressed: () => navigate(context, {
        "type": "tab",
        "router": "/",
        "args": {"key": "screens_category"}
      }),
    );
  }
}
