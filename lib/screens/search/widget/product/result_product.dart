import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/search/search_store.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:ui/notification/notification_screen.dart';

class Result extends StatefulWidget {
  final String? search;
  final Function? clearText;

  const Result({
    Key? key,
    this.search,
    this.clearText,
  }) : super(key: key);

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> with LoadingMixin {
  late SearchStore _searchStore;
  late SettingStore _settingStore;
  late ProductsStore _productStore;
  late AuthStore _authStore;
  late AppStore _appStore;
  final ScrollController _controller = ScrollController();
  late String productKey;
  @override
  void initState() {
    _controller.addListener(_onScroll);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);
    _searchStore = SearchStore(_settingStore.persistHelper);
    _appStore = Provider.of<AppStore>(context);
    _authStore = Provider.of<AuthStore>(context);
    productKey = 'product_search_${widget.search}_${_settingStore.currency}';
    if (_appStore.getStoreByKey(productKey) == null) {
      _productStore = ProductsStore(
        Provider.of<RequestHelper>(context),
        search: widget.search,
        key: productKey,
        language: _settingStore.locale,
        currency: _settingStore.currency,
        sort: sort,
        locationStore: _authStore.locationStore,
      )..getProducts();
      _appStore.addStore(_productStore);
    } else {
      _productStore = _appStore.getStoreByKey(productKey);
    }
    super.didChangeDependencies();
  }

  void _onScroll() {
    if (!_controller.hasClients || _productStore.loading || !_productStore.canLoadMore) return;
    final thresholdReached = _controller.position.extentAfter < endReachedThreshold;

    if (thresholdReached) {
      _productStore.getProducts();
    }
  }

  Map<String, dynamic> sort = {
    'key': 'product_list_default',
    'query': {
      'order': 'desc',
      'orderby': 'date',
    }
  };
  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Observer(
      key: Key(productKey),
      builder: (context) {
        if (widget.search!.trim() != '') {
          _searchStore.addSearch('${widget.search}');
        }
        List<Product> products = _productStore.products;
        List<Product> loadingProduct = List.generate(_productStore.perPage, (index) => Product()).toList();

        bool loading = _productStore.loading;
        bool isShimmer = products.isEmpty && loading;

        List<Product> data = isShimmer ? loadingProduct : products;
        if (data.isNotEmpty) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            controller: _controller,
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: _productStore.refresh,
                builder: buildAppRefreshIndicator,
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: List.generate(
                    data.length,
                    (index) {
                      return ProductSearchItem(
                        product: data[index],
                        searchStore: _searchStore,
                      );
                    },
                  ),
                ),
              ),
              if (loading)
                SliverToBoxAdapter(
                  child: buildLoading(context, isLoading: _productStore.canLoadMore),
                ),
            ],
          );
        }

        return NotificationScreen(
          title: Text(translate('product_search_results'), style: Theme.of(context).textTheme.titleLarge),
          content: Padding(
              padding: paddingHorizontal,
              child: Text(
                translate("product_no_products_were_found"),
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              )),
          iconData: FeatherIcons.search,
          textButton: Text(
            translate('product_clear'),
            style: TextStyle(color: Theme.of(context).textTheme.titleMedium?.color),
          ),
          styleBtn: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 61),
            backgroundColor: Theme.of(context).colorScheme.surface,
            shadowColor: Colors.transparent,
          ),
          onPressed: () {
            widget.clearText?.call();
          },
        );
      },
    );
  }
}

class ProductSearchItem extends StatelessWidget with ProductMixin {
  final Product? product;
  final SearchStore? searchStore;
  const ProductSearchItem({
    Key? key,
    this.product,
    this.searchStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: buildImage(context, product: product!, width: 60, height: 60),
      title: buildName(context, product: product!),
      subtitle: buildPrice(context, product: product!),
      onTap: () {
        searchStore!.addSearch('${product!.name}');
        Navigator.pushNamed(
          context,
          '${ProductScreen.routeName}/${product?.id}/${product?.slug}',
          arguments: {'product': product},
        );
      },
    );
  }
}
