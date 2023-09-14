import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/product/filter_store.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'widgets/body.dart';
import 'widgets/refine.dart';
import 'widgets/heading_list.dart';
import 'widgets/filter_list.dart';
import 'widgets/sort.dart';

class ProductListScreen extends StatefulWidget {
  static const routeName = '/product_list';

  const ProductListScreen({Key? key, this.args, this.store}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();

  final Map? args;
  final SettingStore? store;
}

class _ProductListScreenState extends State<ProductListScreen>
    with ShapeMixin, Utility, HeaderListMixin, ProductListMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ProductsStore? _productsStore;
  FilterStore? _filterStore;
  int typeView = 0;

  @override
  void initState() {
    super.initState();
    AuthStore authStore = Provider.of<AuthStore>(context, listen: false);

    // Configs
    Data data = widget.store!.data!.screens!['products']!;
    WidgetConfig widgetConfig = data.widgets!['productListPage']!;
    ProductCategory? category = getCategory(widget.args);
    Brand? brand = getBrand(widget.args);
    List<int>? tag = getTag(widget.args);
    String? orderby = widget.args?['orderby'];

    _productsStore = ProductsStore(
      widget.store!.requestHelper,
      category: category,
      brand: brand,
      tag: tag,
      perPage: ConvertData.stringToInt(get(widgetConfig.fields, ['itemPerPage'], 10)),
      currency: widget.store!.currency,
      language: widget.store!.locale,
      sort: getSort(orderby),
      locationStore: authStore.locationStore,
    );
    _filterStore = FilterStore(
      widget.store!.requestHelper,
      category: category,
      language: widget.store!.locale,
    );
    init();
  }

  Map getSort(String? orderBy) {
    switch (orderBy) {
      case 'popularity':
        return listSortBy[2];
      case 'rating':
        return listSortBy[3];
      case 'date':
        return listSortBy[4];
      case 'price':
        return listSortBy[5];
      case 'price-desc':
        return listSortBy[6];
      default:
        return listSortBy[1];
    }
  }

  Future<void> init() async {
    await _productsStore!.getProducts();
    await _filterStore!.getAttributes();
    await _filterStore!.getMinMaxPrices();
  }

  // Fetch product data
  Future<List<Product>> _getProducts() async {
    return _productsStore!.getProducts();
  }

  Future _refresh() {
    return _productsStore!.refresh();
  }

  void _clearAll() {
    _filterStore!.onChange(
      inStock: _productsStore!.filter!.inStock,
      onSale: _productsStore!.filter!.onSale,
      featured: _productsStore!.filter!.featured,
      category: _productsStore!.filter!.category,
      attributeSelected: _productsStore!.filter!.attributeSelected,
      productPrices: _productsStore!.filter!.productPrices,
      rangePrices: _productsStore!.filter!.rangePrices,
    );
  }

  void onSubmit(FilterStore? filter) {
    if (filter != null) {
      _productsStore!.onChanged(filterStore: filter);
    } else {
      _clearAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Configs
    Data data = widget.store!.data!.screens!['products']!;
    WidgetConfig widgetConfig = data.widgets!['productListPage']!;

    String? refinePosition = get(widgetConfig.fields, ['refinePosition'], Strings.refinePositionBottom);
    String? refineItemStyle = get(widgetConfig.fields, ['refineItemStyle'], Strings.refineItemStyleListTitle);
    int itemPerPage = ConvertData.stringToInt(get(widgetConfig.fields, ['itemPerPage'], 10));
    String thumbSizes = get(widgetConfig.fields, ['thumbSizes'], 'src');

    List<Product> loadingProduct = List.generate(itemPerPage, (index) => Product()).toList();
    ProductCategory? category = getCategory(widget.args);
    Brand? brand = getBrand(widget.args);

    return Observer(
      builder: (_) {
        bool isShimmer = _productsStore!.products.isEmpty && _productsStore!.loading;
        return Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            child: buildRefine(context,
                category: category, min: 1, refinePosition: refinePosition, refineItemStyle: refineItemStyle),
          ),
          endDrawer: Drawer(
            child: buildRefine(context,
                category: category, min: 1, refinePosition: refinePosition, refineItemStyle: refineItemStyle),
          ),
          body: SafeArea(
            child: Body(
              brand: brand,
              category: category,
              products: isShimmer ? loadingProduct : _productsStore!.products.where(productCatalog).toList(),
              loading: _productsStore!.loading,
              refresh: _refresh,
              getProducts: _getProducts,
              canLoadMore: _productsStore!.canLoadMore,
              thumbSizes: thumbSizes,
              heading: HeadingList(
                height: 58,
                sort: _productsStore!.sort,
                onchangeSort: (Map sort) => _productsStore!.onChanged(sort: sort),
                clickRefine: () async {
                  if (refinePosition == Strings.refinePositionLeft) {
                    _scaffoldKey.currentState!.openDrawer();
                  } else if (refinePosition == Strings.refinePositionRight) {
                    _scaffoldKey.currentState!.openEndDrawer();
                  } else {
                    showModalBottomSheet<FilterStore>(
                      isScrollControlled: true,
                      context: context,
                      shape: borderRadiusTop(),
                      builder: (context) => buildRefine(context,
                          category: category, refinePosition: refinePosition, refineItemStyle: refineItemStyle),
                    );
                  }
                },
                typeView: typeView,
                onChangeType: (int visit) => setState(() {
                  typeView = visit;
                }),
              ),
              filter: FilterList(
                productsStore: _productsStore,
                filter: _filterStore,
                category: category,
              ),
              heightHeading: 58,
              configs: data.configs,
              styles: widgetConfig.styles,
              typeView: typeView,
            ),
          ),
        );
      },
    );
  }

  Widget buildRefine(
    BuildContext context, {
    ProductCategory? category,
    double min = 0.8,
    String? refinePosition = Strings.refinePositionBottom,
    String? refineItemStyle = Strings.refineItemStyleListTitle,
  }) {
    return Refine(
      filterStore: _filterStore,
      category: category,
      clearAll: _clearAll,
      onSubmit: onSubmit,
      min: min,
      refineItemStyle: refineItemStyle,
      refinePosition: refinePosition,
    );
  }
}
