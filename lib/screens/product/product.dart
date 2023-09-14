import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/product/add_on/helper.dart';
import 'package:cirilla/screens/product/add_on/model.dart';
import 'package:cirilla/screens/product/add_on/validate.dart';
import 'package:cirilla/screens/product/widgets/product_featured_image.dart';
import 'package:cirilla/utils/conditionals.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';

import 'package:cirilla/models/models.dart';
import 'package:cirilla/models/product/product_type.dart';
import 'package:cirilla/screens/auth/login_screen.dart';
import 'package:cirilla/screens/product/widgets/product_addons.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/app_store.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/store/cart/cart_store.dart';
import 'package:cirilla/store/product/variation_store.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import 'package:cirilla/store/product_recently/product_recently_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:ui/notification/notification_screen.dart';
import 'package:cirilla/utils/url_launcher.dart';
import 'package:woo_booking/product_booking.dart';

import 'layout/default.dart';
import 'layout/zoom.dart';
import 'layout/scroll.dart';

import 'widgets/product_appbar.dart';
import 'widgets/product_bottom_bar.dart';
import 'widgets/product_brand.dart';
import 'widgets/product_slideshow.dart';
import 'widgets/product_category.dart';
import 'widgets/product_name.dart';
import 'widgets/product_rating.dart';
import 'widgets/product_price.dart';
import 'widgets/product_webview.dart';
import 'widgets/product_type.dart';
import 'widgets/product_quantity.dart';
import 'widgets/product_description.dart';
import 'widgets/product_related.dart';
import 'widgets/product_upsell.dart';
import 'widgets/product_addition_information.dart';
import 'widgets/product_review.dart';
import 'widgets/product_sort_description.dart';
import 'widgets/product_status.dart';
import 'widgets/product_sku.dart';
import 'widgets/product_add_to_cart.dart';
import 'widgets/product_action.dart';
import 'widgets/product_custom.dart';
import 'widgets/product_store.dart';
import 'widgets/product_advanced_custom_field.dart';
import 'widgets/product_divider.dart';
import 'widgets/product_item.dart';

class ProductScreen extends StatefulWidget {
  static const String routeName = '/product';

  const ProductScreen({Key? key, this.args, this.store, this.isQuickView = false}) : super(key: key);

  final Map? args;
  final SettingStore? store;
  final bool isQuickView;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen>
    with Utility, SnackMixin, LoadingMixin, NavigationMixin, GeneralMixin, AppBarMixin, ContainerMixin {
  late AppStore _appStore;
  RequestHelper? _requestHelper;
  late CartStore _cartStore;
  late AuthStore _authStore;
  ProductRecentlyStore? _productRecentStore;

  // Add to cart loading
  bool _addToCartLoading = false;

  Product? _product;
  int _qty = 1;
  VariationStore? _variationStore;
  Map<int?, int> _groupQty = {};
  Map<String, AddOnData> _addOns = {};
  Map<String, String> _errorAddOns = {};
  Map<String, dynamic> _appointments = {};

  bool _loading = true;

  @override
  void didChangeDependencies() async {
    _appStore = Provider.of<AppStore>(context);
    _requestHelper = Provider.of<RequestHelper>(context);
    _authStore = Provider.of<AuthStore>(context);
    _cartStore = _authStore.cartStore;
    _productRecentStore = Provider.of<AuthStore>(context).productRecentlyStore;

    Map<String, dynamic> query = {'lang': widget.store?.locale, 'currency': widget.store?.currency};
    if (widget.args != null && widget.args?['product'] != null) {
      setState(() {
        _loading = false;
      });
      Product p = widget.args!['product'];
      _product = p;
      _productRecentStore?.addProductRecently(p.id.toString());
    } else if (widget.args?['id'] != null && widget.args?['type'] == 'variable') {
      await getProductVariation(ConvertData.stringToInt(widget.args!['id']), query);
    } else if (widget.args?['id'] != null) {
      await getProduct(ConvertData.stringToInt(widget.args!['id']), query);
    }
    init();
    super.didChangeDependencies();
  }

  void init() {
    if (_product != null && _product!.type == productTypeVariable) {
      String key = 'variation_${_product!.id} - ${widget.store!.locale}';
      if (_appStore.getStoreByKey(key) == null) {
        VariationStore store = VariationStore(
          _requestHelper,
          productId: _product!.id,
          key: key,
          lang: widget.store!.locale,
          currency: widget.store?.currency,
        )..getVariation(_product?.defaultAttributes);
        _appStore.addStore(store);
        _variationStore ??= store;
      } else {
        _variationStore = _appStore.getStoreByKey(key);
      }
    }
  }

  Future<void> getProductVariation(int? id, Map<String, dynamic> query) async {
    try {
      Product product = await _requestHelper!.getProduct(id: id, queryParameters: query);
      await getProduct(product.parentId, query);
    } catch (e) {
      showError(context, e);
    }
  }

  Future<void> getProduct(int? id, Map<String, dynamic> query) async {
    try {
      Product p = await _requestHelper!.getProduct(id: id, queryParameters: query);
      _product = p;
      _productRecentStore?.addProductRecently(p.id.toString());
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  void setLoading(bool value) {
    setState(() {
      _addToCartLoading = value;
    });
  }

  void _updateGroupQty({required Product product, qty = 1}) {
    Map<int?, int> groupQty = Map<int?, int>.of(_groupQty);
    if (_groupQty.containsKey(product.id)) {
      groupQty.update(product.id, (value) => qty);
    } else {
      groupQty.putIfAbsent(product.id, () => qty);
    }
    setState(() {
      _groupQty = groupQty;
    });
  }

  void _updateAppointment(Map<String, dynamic> data) {
    setState(() {
      _appointments = data;
    });
  }

  Map<String, String?> _preAddons() {
    Map<String, String> addOns = {};
    for (var key in _addOns.keys) {
      AddOnData data = _addOns[key]!;
      if (data.type == AddOnDataType.string) {
        addOns.putIfAbsent(key, () => data.string?.value ?? '');
      } else if (data.type == AddOnDataType.option) {
        addOns.putIfAbsent(key, () => data.option?.value ?? '');
      } else if (data.type == AddOnDataType.listOption) {
        if (data.listOption?.isNotEmpty == true) {
          for (int i = 0; i < data.listOption!.length; i++) {
            AddOnOption v = data.listOption![i];
            addOns.putIfAbsent('$key[$i]', () => v.value);
          }
        }
      }
    }
    return addOns;
  }

  // Handle for Woo booking.
  Map<String, String?> _handleWooBookingData() {
    Map<String, String> data = {};
    List<String> date = get(_appointments, ['date'], '').split('-');
    String hour = get(_appointments, ['time'], '');
    int? persons = get(_appointments, ['wc_bookings_field_persons'], null);
    if (persons != null) {
      data['wc_bookings_field_persons'] = persons.toString();
    }
    try {
      WooBookingType type = get(_appointments, ['type'], WooBookingType.defaultBooking);
      switch (type) {
        case WooBookingType.customMonth:
          data['wc_bookings_field_duration'] = get(_appointments, ['wc_bookings_field_duration'], '').toString();
          data['wc_bookings_field_start_date_yearmonth'] =
              get(_appointments, ['wc_bookings_field_start_date_yearmonth'], '');
          break;
        case WooBookingType.customDay:
          data['wc_bookings_field_duration'] = get(_appointments, ['wc_bookings_field_duration'], '').toString();
          break;
        case WooBookingType.customHourMinute:
          data['wc_bookings_field_duration'] = get(_appointments, ['wc_bookings_field_duration'], '').toString();
          data['end_time'] = get(_appointments, ['wc_bookings_field_duration'], '').toString();
          DateTime? time;
          try {
            time = DateTime(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]), int.parse(hour.substring(0, 2)),
                int.parse(hour.substring(3)));
          } catch (_) {}
          if (time != null) {
            data['wc_bookings_field_start_date_time'] = time.toIso8601String();
            data['start_time'] = time.toIso8601String();
          } else {
            data['wc_bookings_field_start_date_time'] = get(_appointments, ['time'], '');
            data['start_time'] = get(_appointments, ['time'], '');
          }
          break;
        default:
          DateTime? time;
          try {
            time = DateTime(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]), int.parse(hour.substring(0, 2)),
                int.parse(hour.substring(3)));
          } catch (_) {}
          if (time != null) {
            data['wc_bookings_field_start_date_time'] = time.toIso8601String();
          } else {
            data['wc_bookings_field_start_date_time'] = get(_appointments, ['time'], '');
          }
          break;
      }
      if (type != WooBookingType.customMonth) {
        if (date.length == 3) {
          data['wc_bookings_field_start_date_year'] = date[0];
          data['wc_bookings_field_start_date_month'] = date[1];
          data['wc_bookings_field_start_date_day'] = date[2];
        }
      }
    } catch (_) {}
    debugPrint("Booking data:\n$data");
    return data;
  }

  Map<String, String?> _preAppointment() {
    Map<String, String> data = {
      'wc_appointments_field_addons_duration': getAddonDurationAppointment(
        data: _addOns,
        qty: _qty,
      ).toString(),
      'wc_appointments_field_addons_cost': getAddonPriceAppointment(
        data: _addOns,
        price: ConvertData.stringToDouble(_product?.price),
        qty: _qty,
      ).toString(),
    };
    data['wc_appointments_field_start_date_time'] = get(_appointments, ['time'], '');
    List<String> date = get(_appointments, ['date'], '').split('-');
    if (date.length == 3) {
      data['wc_appointments_field_start_date_year'] = date[0];
      data['wc_appointments_field_start_date_month'] = date[1];
      data['wc_appointments_field_start_date_day'] = date[2];
    }
    String staff = get(_appointments, ['staff_id'], '');
    if (staff.isNotEmpty) {
      data['wc_appointments_field_staff'] = staff;
    }
    return data;
  }

  ///
  /// Handle add to cart
  Future<void> _handleAddToCart([bool? goCartPage]) async {
    if (_product?.type == productTypeExternal) {
      await launch(_product!.externalUrl!);
      return;
    }

    if (getConfig(widget.store!, ['forceLoginAddToCart'], false) && !_authStore.isLogin) {
      Navigator.of(context).pushNamed(
        LoginScreen.routeName,
        arguments: {
          'showMessage': ({String? message}) {
            avoidPrint('Login Success');
          }
        },
      );
      return;
    }

    TranslateType translate = AppLocalizations.of(context)!.translate;

    if (_product?.type != productTypeGrouped && _product?.type != productTypeExternal) {
      Map<String, String> addOnError = validateAddOn(product: _product, data: _addOns, translate: translate);

      if (addOnError.isNotEmpty) {
        showError(context, translate('product_message_addon'));
        setState(() {
          _errorAddOns = addOnError;
        });
        return;
      }
    }

    if (_product == null || _product!.id == null) return;
    setState(() {
      _errorAddOns = {};
    });
    setLoading(true);
    try {
      // Check product appointment
      if (_product!.type == productTypeAppointment) {
        if (_appointments.isEmpty) {
          showError(context, translate('product_add_to_cart_error_appointment'));
          setLoading(false);
          return;
        }
        await _cartStore.addToCart({'id': _product!.id, 'quantity': _qty, ..._preAddons(), ..._preAppointment()});
      } else if (_product!.type == productTypeBooking) {
        if (_appointments.isEmpty) {
          showError(context, translate('product_add_to_cart_error_appointment'));
          setLoading(false);
          return;
        }
        await _cartStore.addToCart({'id': _product!.id, 'quantity': _qty, ..._preAddons(), ..._handleWooBookingData()});
      } else if (_product!.type == productTypeVariable) {
        // Check product variable
        // Exist variation store not exist
        if (_variationStore == null || !_variationStore!.canAddToCart) {
          showError(context, translate('product_add_to_cart_error_option'));
          setLoading(false);
          return;
        }

        // Prepare variation data for cart
        List<Map<String, dynamic>> variation = _variationStore!.selected.entries.map((e) {
          bool isInlineAttribute = _variationStore!.data!['attribute_ids'][e.key] == 0;
          return {
            'attribute': isInlineAttribute ? _variationStore!.data!['attribute_labels'][e.key] : e.key,
            'value': e.value,
          };
        }).toList();

        // Add to cart
        await _cartStore.addToCart({
          'id': _variationStore!.productVariation!.id,
          'quantity': _qty,
          'variation': variation,
          ..._preAddons(),
        });
      } else if (_product!.type == productTypeGrouped) {
        if (_groupQty.keys.isEmpty) {
          showError(context, translate('product_add_to_cart_error_group'));
          setLoading(false);
          return;
        }
        int i = 0;
        List<int?> keys = _groupQty.keys.toList();
        await Future.doWhile(() async {
          await _cartStore.addToCart({'id': keys[i], 'quantity': _groupQty[keys[i]]});
          i++;
          return i < keys.length;
        });
      } else {
        await _cartStore.addToCart({'id': _product!.id, 'quantity': _qty, ..._preAddons()});
      }
      if (mounted) {
        showSuccess(
          context,
          AppLocalizations.of(context)!.translate('product_add_to_cart_success'),
          action: goCartPage != true
              ? SnackBarAction(
                  label: translate('product_view_cart'),
                  textColor: Colors.white,
                  onPressed: () {
                    navigate(context, {
                      'type': 'tab',
                      'route': '/',
                      'args': {'key': 'screens_cart'}
                    });
                  },
                )
              : null,
        );
      }
      setState(() {
        _addToCartLoading = false;
        _qty = 1;
      });
      if (goCartPage == true && mounted) {
        navigate(context, {
          'type': 'tab',
          'route': '/',
          'args': {'key': 'screens_cart'}
        });
      }
    } catch (e) {
      showError(context, e);
      setLoading(false);
    }
  }

  _updateCartData(Map<String, AddOnData> data) {
    setState(() {
      _addOns = data;
    });
  }

  int? _getQty(Product? product) {
    // status out of stock
    if (product?.stockStatus == 'outofstock') {
      return null;
    }
    // status on back order
    if (product?.stockStatus == 'onbackorder') {
      if (product?.stockQuantity == null) {
        // ( Init "stock_quantity: null")
        return null;
      } else {
        // ( Changed "do not allow => allow" )
        return CirillaQuantity.maxQty;
      }
    }
    // status in stock (stock_quantity: null Or stock_quantity:value)
    return product?.stockQuantity ?? CirillaQuantity.maxQty;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.store!.data == null) return Container();

    SettingStore settingStore = Provider.of<SettingStore>(context);
    String themeModeKey = settingStore.themeModeKey;

    if (_loading) {
      return Scaffold(
        body: Center(child: buildLoading(context, isLoading: _loading)),
      );
    }

    if (_product == null) {
      return Scaffold(
        appBar: baseStyleAppBar(context, title: ''),
        body: NotificationScreen(
          title: Text(AppLocalizations.of(context)!.translate('product_no'),
              style: Theme.of(context).textTheme.titleLarge),
          content: Text(AppLocalizations.of(context)!.translate('product_you_currently'),
              style: Theme.of(context).textTheme.bodyMedium),
          iconData: FeatherIcons.box,
          textButton: Text(AppLocalizations.of(context)!.translate('product_back')),
          styleBtn: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 61)),
          onPressed: () => Navigator.pop(context),
        ),
      );
    }

    return Observer(builder: (_) {
      // Settings
      Data data = (widget.isQuickView)
          ? widget.store!.data!.screens!['productQuickView']!
          : widget.store!.data!.screens!['product']!;
      String? appBarType = get(data.configs, ['appBarType'], 'floating');
      bool? extendBodyBehindAppBar = get(data.configs, ['extendBodyBehindAppBar'], true);
      bool enableAppbar = get(data.configs, ['enableAppbar'], true);
      bool enableBottomBar = get(data.configs, ['enableBottomBar'], false);
      bool enableCartIcon = get(data.configs, ['enableCartIcon'], false);
      String? cartIconType = get(data.configs, ['cartIconType'], 'pinned');
      String? floatingActionButtonLocation = get(data.configs, ['floatingActionButtonLocation'], 'centerDocked');

      // Configs
      WidgetConfig configs =
          (widget.isQuickView) ? data.widgets!['productQuickView']! : data.widgets!['productDetailPage']!;

      // Config slideshow size
      dynamic size = get(configs.fields, ['productGallerySize'], {'width': 375, 'height': 440});
      double? height = ConvertData.stringToDouble(size is Map ? size['height'] : '440');

      // Layout
      String layout = configs.layout ?? Strings.productDetailLayoutDefault;

      // Style
      Color background = ConvertData.fromRGBA(
          get(configs.styles, ['background', themeModeKey]), Theme.of(context).scaffoldBackgroundColor);

      // Build Product Content
      List<dynamic>? rows = get(configs.fields, ['rows'], []);

      // Map<String, Widget> blocks = buildBlocksInfo(configs);

      Product? productData = _variationStore != null && _variationStore?.productVariation != null
          ? _variationStore?.productVariation
          : _product!;

      List<Widget> rowList = buildRows(
        rows,
        background: background,
        themeModeKey: themeModeKey,
        languageKey: widget.store?.languageKey,
      );

      Widget? appbar = enableAppbar
          ? ProductAppbar(
              configs: data.configs,
              product: _product,
            )
          : null;

      Widget? bottomBar = enableBottomBar
          ? ProductBottomBar(
              configs: data.configs,
              product: productData,
              onPress: _handleAddToCart,
              loading: _addToCartLoading,
              qty: ProductQuantity(
                max: _getQty(productData),
                qty: _qty,
                onChanged: (int value) {
                  setState(() {
                    _qty = value;
                  });
                },
              ),
            )
          : null;

      Widget? cartIcon = enableCartIcon ? buildCartIcon(context) : null;

      if (widget.isQuickView) {
        return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            builder: (_, controller) {
              return ProductLayoutDefault(
                controller: controller,
                isQuickView: true,
                product: _product,
                appbar: appbar,
                bottomBar: bottomBar,
                slideshow: buildSlideshow(configs),
                productInfo: rowList,
                extendBodyBehindAppBar: extendBodyBehindAppBar,
                cartIcon: cartIcon,
                cartIconType: cartIconType,
                floatingActionButtonLocation: floatingActionButtonLocation,
              );
            });
      }

      if (layout == Strings.productDetailLayoutZoom) {
        return ProductLayoutZoomSlideshow(
          product: _product,
          appbar: appbar,
          bottomBar: bottomBar,
          slideshow: buildSlideshow(configs),
          productInfo: rowList,
          extendBodyBehindAppBar: extendBodyBehindAppBar,
          height: height,
          appBarType: appBarType,
          cartIcon: cartIcon,
          cartIconType: cartIconType,
          floatingActionButtonLocation: floatingActionButtonLocation,
        );
      }

      if (layout == Strings.productDetailLayoutScroll) {
        return ProductLayoutDraggableScrollableSheet(
          product: _product,
          appbar: appbar,
          bottomBar: bottomBar,
          slideshow: buildSlideshow(configs),
          productInfo: rowList,
          extendBodyBehindAppBar: extendBodyBehindAppBar,
          // height: height,
          // appBarType: appBarType,
          addToCart: _handleAddToCart,
          addToCartLoading: _addToCartLoading,
          cartIcon: cartIcon,
          cartIconType: cartIconType,
          floatingActionButtonLocation: floatingActionButtonLocation,
        );
      }

      return ProductLayoutDefault(
        product: _product,
        appbar: appbar,
        bottomBar: bottomBar,
        slideshow: buildSlideshow(configs),
        productInfo: rowList,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        cartIcon: cartIcon,
        cartIconType: cartIconType,
        floatingActionButtonLocation: floatingActionButtonLocation,
      );
    });
  }

  Widget buildCartIcon(BuildContext context) {
    bool isOutOfStock = _product?.stockStatus == 'outofstock';
    return FloatingActionButton(
      onPressed: isOutOfStock ? null : _handleAddToCart,
      child: _addToCartLoading
          ? entryLoading(context, color: Theme.of(context).colorScheme.onPrimary)
          : const Icon(Icons.shopping_cart),
      // backgroundColor: Theme.of(context).primaryColor,
    );
  }

  List<Widget> buildRows(
    List<dynamic>? rows, {
    Color background = Colors.white,
    String? themeModeKey,
    String? languageKey,
  }) {
    if (rows == null) return [Container()];

    return rows.map((e) {
      String? mainAxisAlignment = get(e, ['data', 'mainAxisAlignment'], 'start');
      String? crossAxisAlignment = get(e, ['data', 'crossAxisAlignment'], 'start');
      bool divider = get(e, ['data', 'divider'], false);
      List<dynamic>? columns = get(e, ['data', 'columns']);

      return Container(
        decoration: decorationColorImage(color: background),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: ConvertData.mainAxisAlignment(mainAxisAlignment),
              crossAxisAlignment: ConvertData.crossAxisAlignment(crossAxisAlignment),
              children: buildColumn(
                columns,
                themeModeKey: themeModeKey,
                languageKey: languageKey,
              ),
            ),
            if (divider)
              const Divider(
                height: 1,
                thickness: 1,
                endIndent: 20,
                indent: 20,
              ),
          ],
        ),
      );
    }).toList();
  }

  dynamic toVariable(String variable) {
    if (variable.startsWith('meta:') && variable.length > 5) {
      return getMetaValue(key: variable.substring(5), meta: _product?.metaData, defaultValue: '');
    }

    if (variable.startsWith('acf:') && variable.length > 4) {
      return getAcfValue(key: variable.substring(4), acf: _product?.acf, defaultValue: '');
    }

    if (variable == 'isLogin') {
      return _authStore.isLogin ? 'true' : 'false';
    }

    return _product!.toVariable(variable);
  }

  List<Widget> buildColumn(
    List<dynamic>? columns, {
    String? themeModeKey,
    String? languageKey,
  }) {
    if (columns == null) return [Container()];
    return columns.map((e) {
      Map configData = get(e, ['value'], {});

      String? type = get(configData, ['type'], '');

      int flex = ConvertData.stringToInt(get(configData, ['flex'], '1'), 1);

      bool? expand = get(configData, ['expand'], false);

      EdgeInsetsDirectional margin = ConvertData.space(
        get(configData, ['margin'], null),
        'margin',
        EdgeInsetsDirectional.zero,
      );

      EdgeInsetsDirectional padding = ConvertData.space(
        get(configData, ['padding'], null),
        'padding',
        const EdgeInsetsDirectional.only(start: 20, end: 20),
      );

      String align = get(configData, ['align'], 'left');

      Color foreground = ConvertData.fromRGBA(
          get(configData, ['foreground', themeModeKey]), Theme.of(context).scaffoldBackgroundColor);

      String thumbSize = get(configData, ['thumbSize'], 'src');

      dynamic conditional = get(configData, ['conditional'], null);

      if (conditional != null && conditional['when_conditionals'] != null && conditional['conditionals'] != null) {
        bool check = conditionalCheck(
          conditional['when_conditionals'],
          conditional['conditionals'],
          [
            'isLogin',
            ...Product.variableKeys,
            ...getMetaKeys(meta: _product?.metaData),
            ...getAcfKeys(acf: _product?.acf),
          ],
          toVariable,
        );

        if (!check) {
          return Container();
        }
      }

      // Removed block Type
      if ((type == ProductBlocks.type && _product!.type == productTypeSimple) ||
          (type == ProductBlocks.type && _product!.type == productTypeExternal)) {
        return Container();
      }

      // Removed block Quantity
      if (type == ProductBlocks.quantity && _product!.type == productTypeExternal) {
        return Container();
      }

      // Removed block Add-ons
      if (type == ProductBlocks.addOns && _product!.metaData!.indexWhere((e) => e['key'] == 'product_addons') == -1) {
        return Container();
      }

      return Expanded(
        flex: flex,
        child: Container(
          margin: margin,
          padding:
              type == ProductBlocks.relatedProduct || type == ProductBlocks.upsellProduct ? EdgeInsets.zero : padding,
          decoration: decorationColorImage(
            color: foreground,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: align == 'center'
                ? CrossAxisAlignment.center
                : align == 'right'
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            children: [
              buildBlock(
                type,
                padding: padding,
                align: align,
                expand: expand,
                thumbSize: thumbSize,
                configData: configData,
                theme: Theme.of(context),
                languageKey: languageKey,
                themeModeKey: themeModeKey,
              )
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget buildBlock(
    String? type, {
    EdgeInsetsDirectional margin = EdgeInsetsDirectional.zero,
    EdgeInsetsDirectional padding = EdgeInsetsDirectional.zero,
    bool? expand = false,
    String align = 'left',
    String? thumbSize,
    required Map configData,
    required ThemeData theme,
    String? themeModeKey,
    String? languageKey,
  }) {
    if (type == ProductBlocks.relatedProduct) {
      return (widget.isQuickView)
          ? const SizedBox.shrink()
          : ProductRelated(product: _product, padding: padding, align: align, thumbSize: thumbSize);
    }
    if (type == ProductBlocks.upsellProduct) {
      return ProductUpsell(product: _product, padding: padding, align: align);
    }

    if (type == ProductBlocks.quantity && _product!.type == productTypeGrouped) {
      return Container();
    }
    Product? productOrVariableProduct = _variationStore != null && _variationStore!.productVariation != null
        ? _variationStore?.productVariation
        : _product;

    switch (type) {
      case ProductBlocks.category:
        return ProductCategoryList(product: _product, align: align);
      case ProductBlocks.name:
        return ProductName(product: _product, align: align);
      case ProductBlocks.rating:
        return ProductRating(product: _product, align: align);
      case ProductBlocks.price:
        return ProductPrice(
          product: productOrVariableProduct,
          align: align,
        );
      case ProductBlocks.status:
        String typeStatus = get(configData, ['typeStatus'], 'text');
        return ProductStatus(
          product: productOrVariableProduct,
          align: align,
          typeStatus: typeStatus,
        );
      case ProductBlocks.sku:
        return ProductSku(
          product: productOrVariableProduct,
          align: align,
        );
      case ProductBlocks.featuredImage:
        return FeaturedImage(images: _product!.images);
      case ProductBlocks.addOns:
        if (_product?.type != productTypeGrouped && _product?.type != productTypeExternal) {
          return ProductAddOns(
            product: _product,
            onChange: _updateCartData,
            value: _addOns,
            errors: _errorAddOns,
          );
        }
        return Container();
      case ProductBlocks.type:
        return ProductTypeWidget(
          product: _product,
          store: _variationStore,
          align: align,
          qty: _groupQty,
          onChangedGrouped: _updateGroupQty,
          appointment: _appointments,
          onChangedAppointment: _updateAppointment,
        );
      case ProductBlocks.quantity:
        return ProductQuantity(
          max: _getQty(productOrVariableProduct),
          qty: _qty,
          onChanged: (int value) {
            setState(() {
              _qty = value;
            });
          },
          align: align,
        );
      case ProductBlocks.sortDescription:
        return ProductSortDescription(product: _product);
      case ProductBlocks.description:
        return ProductDescription(
          product: _product,
          expand: expand,
          align: align,
        );
      case ProductBlocks.additionInformation:
        return ProductAdditionInformation(product: _product, expand: expand);
      case ProductBlocks.review:
        return ProductReview(
          product: _product,
          expand: expand,
          align: align,
        );
      case ProductBlocks.relatedProduct:
        return ProductRelated(product: _product, padding: padding, align: align, thumbSize: thumbSize);
      case ProductBlocks.upsellProduct:
        return ProductUpsell(product: _product, padding: padding, align: align);
      case ProductBlocks.addToCart:
        return ProductAddToCart(
          product: productOrVariableProduct,
          onPress: _handleAddToCart,
          loading: _addToCartLoading,
        );
      case ProductBlocks.action:
        return ProductAction(product: _product, align: align);
      case ProductBlocks.custom:
        ProductDetailValue configs =
            ProductDetailValue.fromJson(Map.castFrom<dynamic, dynamic, String, dynamic>(configData));
        return ProductCustom(configs: configs, align: align);
      case ProductBlocks.store:
        return ProductStore(product: _product);
      case ProductBlocks.brand:
        String layoutBlock = get(configData, ['layout'], 'horizontal');
        return ProductBrandWidget(product: _product, layoutBlock: layoutBlock);
      case ProductBlocks.html:
        String textHtml = get(configData, ['textHtml', languageKey], '');
        return CirillaHtml(html: textHtml);
      case ProductBlocks.advancedField:
        String customFieldName = get(configData, ['customFieldName'], '');
        return ProductAdvancedFieldsCustom(
          product: _product,
          align: align,
          fieldName: customFieldName,
        );
      case ProductBlocks.webview:
        String url = get(configData, ['url', languageKey], '');
        bool syncAuth = get(configData, ['syncAuth'], false);
        double height = ConvertData.stringToDouble(get(configData, ['height'], '200'), 200);
        return ProductWebView(
          product: _product,
          syncAuth: syncAuth,
          padding: padding,
          height: height,
          url: url,
        );
      case ProductBlocks.productItem:
        return ProductItem(
          product: _product,
          quantity: ProductQuantity(
            max: _getQty(productOrVariableProduct),
            qty: _qty,
            onChanged: (int value) {
              setState(() {
                _qty = value;
              });
            },
          ),
        );
      case ProductBlocks.divider:
        double heightDivider = ConvertData.stringToDouble(get(configData, ['heightDivider'], 1), 1);
        Color colorDivider =
            ConvertData.fromRGBA(get(configData, ['colorDivider', themeModeKey], {}), theme.dividerColor);
        return ProductDivider(height: heightDivider, color: colorDivider);
      default:
        return Text(type!);
    }
  }

  Widget buildSlideshow(WidgetConfig configs) {
    int scrollDirection = ConvertData.stringToInt(get(configs.fields, ['productGalleryScrollDirection'], 0));

    // Config size
    dynamic size = get(configs.fields, ['productGallerySize'], {'width': 375, 'height': 440});
    double? width = ConvertData.stringToDouble(size is Map ? size['width'] : '375');
    double? height = ConvertData.stringToDouble(size is Map ? size['height'] : '440');

    // Image fit
    String? productGalleryFit = get(configs.fields, ['productGalleryFit'], 'cover');

    // Thumb size image
    String? productGalleryThumbSizes = get(configs.fields, ['productGalleryThumbSizes'], 'woocommerce_thumbnail');

    return ProductSlideshow(
      images: _variationStore != null &&
              _variationStore!.productVariation != null &&
              _variationStore!.productVariation!.images!.isNotEmpty
          ? _variationStore!.productVariation!.images
          : [],
      product: _variationStore != null &&
              _variationStore!.productVariation != null &&
              _variationStore!.productVariation!.images!.isNotEmpty
          ? _variationStore!.productVariation!
          : _product!,
      scrollDirection: scrollDirection,
      width: width,
      height: height,
      productGalleryFit: productGalleryFit,
      productGalleryThumbSizes: productGalleryThumbSizes,
      configs: configs,
    );
  }
}
