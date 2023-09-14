import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../product/product.dart';

class ProductByCategoryWidget extends StatefulWidget {
  final WidgetConfig? widgetConfig;

  const ProductByCategoryWidget({
    Key? key,
    this.widgetConfig,
  }) : super(key: key);

  @override
  State<ProductByCategoryWidget> createState() => _ProductByCategoryState();
}

class _ProductByCategoryState extends State<ProductByCategoryWidget> with Utility, PostMixin, ContainerMixin {
  late AppStore _appStore;
  SettingStore? _settingStore;
  AuthStore? _authStore;
  ProductsStore? _productsStore;

  @override
  void didChangeDependencies() {
    _appStore = Provider.of<AppStore>(context);
    _settingStore = Provider.of<SettingStore>(context);
    _authStore = Provider.of<AuthStore>(context);

    Map<String, dynamic> fields = widget.widgetConfig?.fields ?? {};
    List<dynamic> categories = get(fields, ['categories'], []);
    List<dynamic> excludeProduct = get(fields, ['excludeProduct'], []);

    // Filter
    int limit = ConvertData.stringToInt(get(fields, ['limit'], '4'));

    List<Product> exProducts = excludeProduct.map((e) => Product(id: ConvertData.stringToInt(e['key']))).toList();
    List<ProductCategory> cate = categories.map((t) => ProductCategory(id: ConvertData.stringToInt(t['key']))).toList();

    String? key = StringGenerate.getProductKeyStore(
      widget.widgetConfig!.id,
      currency: _settingStore!.currency,
      language: _settingStore!.locale,
      excludeProduct: exProducts,
      category: cate.isNotEmpty ? cate[0].id : null,
      limit: limit,
    );

    // Add store to list store
    if (widget.widgetConfig != null && _appStore.getStoreByKey(key) == null) {
      ProductsStore store = ProductsStore(
        _settingStore!.requestHelper,
        key: key,
        perPage: limit,
        language: _settingStore!.locale,
        currency: _settingStore!.currency,
        sort: Map<String, dynamic>.from({
          'key': 'product_list_default',
          'query': {
            'orderby': 'date',
            'order': 'desc',
          }
        }),
        category: cate.isNotEmpty ? cate[0] : null,
        exclude: exProducts,
        locationStore: _authStore?.locationStore,
      )..getProducts();
      _appStore.addStore(store);
      _productsStore ??= store;
    } else {
      _productsStore = _appStore.getStoreByKey(key);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    String themeModeKey = _settingStore?.themeModeKey ?? 'value';

    // Item style
    WidgetConfig configs = widget.widgetConfig!;

    // Item template
    String layout = configs.layout ?? Strings.productLayoutList;

    // Style
    Map<String, dynamic>? margin = get(configs.styles, ['margin'], {});
    Map<String, dynamic>? padding = get(configs.styles, ['padding'], {});
    Map<String, dynamic>? background = get(configs.styles, ['background', themeModeKey], {});

    return Container(
      margin: ConvertData.space(margin, 'margin'),
      decoration: decorationColorImage(
        color: ConvertData.fromRGBA(background, Colors.transparent),
      ),
      child: ProductWidget(
        fields: configs.fields,
        styles: configs.styles,
        productsStore: _productsStore,
        layout: layout,
        padding: ConvertData.space(padding, 'padding'),
      ),
    );
  }
}
