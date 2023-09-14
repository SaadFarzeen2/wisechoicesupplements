import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/product/product.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/app_store.dart';
import 'package:cirilla/store/product/products_store.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_product_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ProductRelated extends StatelessWidget {
  final Product? product;
  final EdgeInsetsDirectional padding;
  final String? align;
  final String? thumbSize;

  const ProductRelated({
    Key? key,
    this.product,
    this.padding = EdgeInsetsDirectional.zero,
    this.align = 'left',
    this.thumbSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    List<int> ids = product?.relatedIds ?? [];
    if (ids.isEmpty) {
      return Container();
    }
    return ProductListView(
      ids: ids,
      keyStore: 'related_product',
      title: translate('product_related'),
      padding: padding,
      align: align,
      thumbSize: thumbSize,
    );
  }
}

class ProductListView extends StatefulWidget {
  final List<int> ids;
  final EdgeInsetsDirectional padding;
  final String? align;
  final String keyStore;
  final String title;
  final String? thumbSize;

  const ProductListView({
    Key? key,
    required this.ids,
    required this.keyStore,
    required this.title,
    this.padding = EdgeInsetsDirectional.zero,
    this.align = 'left',
    this.thumbSize,
  }) : super(key: key);

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> with LoadingMixin, GeneralMixin {
  final ScrollController _controller = ScrollController();

  late ProductsStore _productsStore;
  late AppStore _appStore;
  late SettingStore _settingStore;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_controller.hasClients || _productsStore.loading || !_productsStore.canLoadMore) return;
    final thresholdReached = _controller.position.extentAfter < endReachedThreshold;

    if (thresholdReached) {
      _productsStore.getProducts();
    }
  }

  @override
  void didChangeDependencies() {
    RequestHelper requestHelper = Provider.of<RequestHelper>(context);
    _appStore = Provider.of<AppStore>(context);
    _settingStore = Provider.of<SettingStore>(context);

    List<Product> productRelated = widget.ids.map((e) => Product(id: e)).toList();
    String? key = StringGenerate.getProductKeyStore(
      widget.keyStore,
      includeProduct: productRelated,
      currency: _settingStore.currency,
      language: _settingStore.locale,
      limit: 10,
    );

    if (_appStore.getStoreByKey(key) == null) {
      ProductsStore store = ProductsStore(
        requestHelper,
        key: key,
        perPage: 10,
        include: productRelated,
        language: _settingStore.locale,
        currency: _settingStore.currency,
      )..getProducts();

      _appStore.addStore(store);
      _productsStore = store;
    } else {
      _productsStore = _appStore.getStoreByKey(key);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsetsDirectional paddingItems = EdgeInsetsDirectional.only(
      start: widget.padding.start,
      end: widget.padding.end,
    );
    return Container(
      padding: EdgeInsets.only(top: widget.padding.top, bottom: widget.padding.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: paddingItems,
            child: Text(
              widget.title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: ConvertData.toTextAlignDirection(widget.align),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 320,
            child: Observer(
              builder: (_) {
                List<Product> products = _productsStore.products;
                bool loading = _productsStore.loading;
                bool canLoadMore = _productsStore.canLoadMore;

                List<Product> emptyProducts = List.generate(4, (index) => Product()).toList();
                bool isShimmer = products.isEmpty && loading;
                List<Product> data = isShimmer ? emptyProducts : products;
                int count = loading ? data.length + 1 : data.length;

                return ListView.separated(
                  controller: _controller,
                  padding: paddingItems,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == data.length) {
                      return Container(
                        height: 320,
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: buildLoading(context, isLoading: canLoadMore),
                        ),
                      );
                    }
                    return CirillaProductItem(
                      product: data[index],
                      template: 'default',
                      dataTemplate: {
                        'thumbSizes': widget.thumbSize,
                      },
                      width: 142,
                      height: 169,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 16),
                  itemCount: count,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
