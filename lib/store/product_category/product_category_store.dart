import 'dart:convert';

import 'package:cirilla/constants/app.dart' as app_configs;
import 'package:cirilla/models/product_category/product_category.dart';
import 'package:cirilla/service/helpers/persist_helper.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/error/error_store.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:cirilla/utils/query.dart';
import 'package:mobx/mobx.dart';

part 'product_category_store.g.dart';

class ProductCategoryStore = ProductCategoryStoreBase with _$ProductCategoryStore;

abstract class ProductCategoryStoreBase with Store {
  // Request helper instance
  final RequestHelper _requestHelper;

  final PersistHelper _persistHelper;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:-------------------------------------------------------------------------------------------------------
  ProductCategoryStoreBase(
    this._requestHelper,
    this._persistHelper, {
    int? parent,
    int? perPage,
    bool? hideEmpty,
    String? language,
  }) {
    if (parent != null) _parent = parent;
    if (perPage != null) _perPage = perPage;
    if (hideEmpty != null) _hideEmpty = hideEmpty;
    if (language != null && language != '') _language = language;
    _reaction();
    _restore();
  }

  Future<void> _restore() async {
    try {
      String lang = await _persistHelper.getLanguage();
      String? cats = _persistHelper.getCategories();

      if (cats != null) {
        List<dynamic> data = jsonDecode(cats);

        List<ProductCategory> categories = <ProductCategory>[];
        categories = data.map((category) => ProductCategory.fromJson(category)).toList().cast<ProductCategory>();

        _categories = ObservableList<ProductCategory>.of(categories);
        loading = false;
      }

      if (lang != _language) {
        _language = lang;
      }

      getCategories();
    } catch (e) {
      avoidPrint('Restore categories error.');
    }
  }

  // store variables:---------------------------------------------------------------------------------------------------
  @observable
  ObservableList<ProductCategory> _categories = ObservableList<ProductCategory>.of([]);

  @observable
  bool loading = true;

  @observable
  bool _canLoadMore = true;

  @observable
  String _language = app_configs.defaultLanguage;

  @observable
  int _nextPage = 1;

  @observable
  int _perPage = 10;

  @observable
  int _parent = 0;

  /// Whether to hide resources not assigned to any products
  @observable
  bool _hideEmpty = false;

  @observable
  String _search = '';

  @observable
  Map _sort = {
    'key': 'latest',
    'query': {
      'order': 'desc',
      'orderby': 'date',
    }
  };

  // computed:----------------------------------------------------------------------------------------------------------
  @computed
  ObservableList<ProductCategory> get categories => _categories;

  @computed
  bool get canLoadMore => _canLoadMore;

  @computed
  Map get sort => _sort;

  @computed
  int get parent => _parent;

  @computed
  int get perPage => _perPage;

  // actions:-----------------------------------------------------------------------------------------------------------
  @action
  Future<void> getCategories() async {
    try {
      Map<String, dynamic> qs = {
        "page": _nextPage,
        "search": _search,
        "parent": _parent,
        "per_page": _perPage,
        "hide_empty": _hideEmpty,
        "lang": _language,
      };
      List<dynamic> data = await _requestHelper.getProductCategories(queryParameters: preQueryParameters(qs));

      List<ProductCategory>? categories = <ProductCategory>[];
      categories = data.map((category) => ProductCategory.fromJson(category)).toList().cast<ProductCategory>();

      _categories = ObservableList<ProductCategory>.of(categories);

      loading = false;

      if (data.isNotEmpty) {
        await _persistHelper.saveCategories(jsonEncode(data));
      }
    } catch (e) {
      avoidPrint('Get categories error.');
    }
  }

  @action
  Future<void> refresh() {
    _canLoadMore = true;
    _nextPage = 1;
    return getCategories();
  }

  @action
  void onChanged({
    Map? sort,
    String? search,
    int? parent,
    int? perPage,
    String? language,
  }) {
    if (sort != null) _sort = sort;
    if (search != null) _search = search;
    if (parent != null) _parent = parent;
    if (perPage != null) _perPage = perPage;
    if (language != null) _language = language;
  }

  // disposers:---------------------------------------------------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _reaction() {
    _disposers = [
      reaction((_) => _language, (dynamic key) => refresh()),
    ];
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
