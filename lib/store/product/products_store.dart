import 'dart:convert';
import 'dart:developer';

import 'package:cirilla/constants/currencies.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/error/error_store.dart';
import 'package:cirilla/store/product/filter_store.dart';
import 'package:cirilla/utils/query.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

import '../auth/location_store.dart';

part 'products_store.g.dart';

class ProductsStore = ProductsStoreBase with _$ProductsStore;

abstract class ProductsStoreBase with Store {
  final String? key;

  // Request helper instance
  RequestHelper? _requestHelper;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  LocationStore? _locationStore;

  // Filter store
  @observable
  FilterStore? _filterStore;

  // constructor:-------------------------------------------------------------------------------------------------------
  ProductsStoreBase(
    RequestHelper requestHelper, {
    this.key,
    ProductCategory? category,
    Brand? brand,
    bool? onSale,
    bool? featured,
    int? perPage,
    String? search,
    Map? sort,
    List<Product>? include,
    List<Product>? exclude,
    List<int>? tag,
    Vendor? vendor,
    String? currency,
    String? language,
    LocationStore? locationStore,
  }) {
    _requestHelper = requestHelper;
    _filterStore = FilterStore(
      requestHelper,
      category: category,
      onSale: onSale,
      featured: featured,
      productsStore: this as ProductsStore?,
      language: language,
    );
    if (perPage != null) _perPage = perPage;
    if (brand != null) _brand = brand;
    if (search != null) _search = search;
    if (sort != null) _sort = sort as Map<String, dynamic>;
    if (include != null) _include = ObservableList<Product>.of(include);
    if (exclude != null) _exclude = ObservableList<Product>.of(exclude);
    if (tag != null) _tag = ObservableList<int>.of(tag);
    if (vendor != null) _vendor = vendor;
    if (currency != null) _currency = currency;
    if (language != null) _language = language;
    if (locationStore != null) _locationStore = locationStore;
    _reaction();
  }

  // store variables:---------------------------------------------------------------------------------------------------
  static ObservableFuture<List<Product>> emptyPostResponse =
      ObservableFuture.value([]);

  @observable
  ObservableFuture<List<Product>?> fetchProductsFuture = emptyPostResponse;

  @observable
  ObservableList<Product> _products = ObservableList<Product>.of([]);

  @observable
  Brand? _brand;

  @observable
  bool pending = false;

  @observable
  int _nextPage = 1;

  @observable
  int _perPage = 20;

  @observable
  ObservableList<Product> _include = ObservableList<Product>.of([]);

  @observable
  ObservableList<Product> _exclude = ObservableList<Product>.of([]);

  @observable
  ObservableList<int> _tag = ObservableList<int>.of([]);

  @observable
  bool _canLoadMore = true;

  @observable
  String _search = '';

  @observable
  String _currency = '';

  @observable
  String _language = '';

  @observable
  Map<String, dynamic> _sort = {
    'key': 'product_list_default',
    'query': {
      'order': 'asc',
      'orderby': 'menu_order',
    }
  };

  @observable
  Vendor? _vendor;

  // computed:----------------------------------------------------------------------------------------------------------
  @computed
  RequestHelper? get requestHelper => _requestHelper;

  @computed
  bool get loading => fetchProductsFuture.status == FutureStatus.pending;

  @computed
  ObservableList<Product> get products => _products;

  @computed
  bool get canLoadMore => _canLoadMore;

  @computed
  Map get sort => _sort;

  @computed
  int get perPage => _perPage;

  @computed
  FilterStore? get filter => _filterStore;

  @computed
  String get search => _search;

  // actions:-----------------------------------------------------------------------------------------------------------
  @action
  Future<void> nextPage({Map<String, dynamic>? customQuery}) async {
    _nextPage++;
    await getProducts(customQuery: customQuery);
  }

  @action
  Future<List<Product>> getProducts(
      {CancelToken? token, Map<String, dynamic>? customQuery}) async {
    if (pending) {
      return ObservableList<Product>.of([]);
    }

    pending = true;

    Map<String, dynamic> query = {
      "page": _nextPage,
      "category":
          _filterStore!.category != null ? _filterStore!.category!.id : '',
      "brand": _brand != null ? _brand!.id : '',
      "per_page": _perPage,
      "status": "publish",
      "search": _search,
      "order": _sort['query']['order'],
      "orderby": _sort['query']['orderby'],
      "include": _include.map((e) => e.id).toList().join(','),
      "exclude": _exclude.map((e) => e.id).toList().join(','),
      "tag": _tag.join(','),
      "vendor": _vendor != null ? _vendor!.id : null,
      "min_price": _filterStore!.rangePrices.start > 0
          ? _filterStore!.rangePrices.start
          : null,
      "max_price": _filterStore!.rangePrices.end > 0
          ? _filterStore!.rangePrices.end
          : null,
      CURRENCY_PARAM: _currency,
      "lang": _language,
      "stock_status": "instock"
    };

    if (_filterStore!.featured) {
      query['featured'] = _filterStore!.featured;
    }

    if (_filterStore!.onSale) {
      query['on_sale'] = _filterStore!.onSale;
    }

    if (_filterStore!.inStock) {
      query['stock_status'] = 'instock';
    }

    if (_filterStore!.attributeSelected.isNotEmpty) {
      query['attrs'] = jsonEncode(
          _filterStore!.attributeSelected.map((attr) => attr.query).toList());
    }

    final future = _requestHelper!.getProducts(
        queryParameters: preQueryParameters(query), cancelToken: token);
    fetchProductsFuture = ObservableFuture(future);
    return future.then((products) {
      // Replace state in the first time or refresh
      if (_nextPage <= 1) {
        _products = ObservableList<Product>.of(products!);
      } else {
        // Add products when load more page
        _products.addAll(ObservableList<Product>.of(products!));
      }

      // Check if can load more item
      if (products.length >= _perPage) {
        _nextPage++;
      } else {
        _canLoadMore = false;
      }
      pending = false;
      return products;
    }).catchError((error) {
      pending = false;
      throw error;
    });
  }

  @action
  Future<List<Product>> refresh({CancelToken? token}) {
    pending = false;
    _canLoadMore = true;
    _nextPage = 1;
    _products.clear();
    return getProducts(token: token);
  }

  @action
  void onChanged({
    Map? sort,
    String? search,
    ProductCategory? category,
    int? perPage,
    FilterStore? filterStore,
  }) {
    if (sort != null) _sort = sort as Map<String, dynamic>;
    if (search != null) _search = search;
    if (perPage != null) _perPage = perPage;
    if (filterStore != null) {
      _filterStore!.onChange(
        inStock: filterStore.inStock,
        onSale: filterStore.onSale,
        featured: filterStore.featured,
        category: filterStore.category,
        attributeSelected: filterStore.attributeSelected,
        rangePrices: filterStore.rangePrices,
        productPrices: filterStore.productPrices,
      );
    }
  }

  // disposers:---------------------------------------------------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _reaction() {
    _disposers = [
      reaction((_) => _sort, (dynamic key) => refresh()),
      reaction((_) => _locationStore?.location, (_) => refresh()),
    ];
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
