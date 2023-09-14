// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$VendorStore on VendorStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading =>
      (_$loadingComputed ??= Computed<bool>(() => super.loading, name: 'VendorStoreBase.loading')).value;
  Computed<ObservableList<Vendor>>? _$vendorsComputed;

  @override
  ObservableList<Vendor> get vendors =>
      (_$vendorsComputed ??= Computed<ObservableList<Vendor>>(() => super.vendors, name: 'VendorStoreBase.vendors'))
          .value;
  Computed<ObservableList<int>>? _$categoryVendorsComputed;

  @override
  ObservableList<int> get categoryVendors => (_$categoryVendorsComputed ??=
          Computed<ObservableList<int>>(() => super.categoryVendors, name: 'VendorStoreBase.categoryVendors'))
      .value;
  Computed<bool>? _$canLoadMoreComputed;

  @override
  bool get canLoadMore =>
      (_$canLoadMoreComputed ??= Computed<bool>(() => super.canLoadMore, name: 'VendorStoreBase.canLoadMore')).value;
  Computed<int>? _$perPageComputed;

  @override
  int get perPage => (_$perPageComputed ??= Computed<int>(() => super.perPage, name: 'VendorStoreBase.perPage')).value;
  Computed<String>? _$langComputed;

  @override
  String get lang => (_$langComputed ??= Computed<String>(() => super.lang, name: 'VendorStoreBase.lang')).value;
  Computed<String?>? _$searchComputed;

  @override
  String? get search =>
      (_$searchComputed ??= Computed<String?>(() => super.search, name: 'VendorStoreBase.search')).value;
  Computed<ObservableList<ProductCategory>>? _$categoriesComputed;

  @override
  ObservableList<ProductCategory> get categories => (_$categoriesComputed ??=
          Computed<ObservableList<ProductCategory>>(() => super.categories, name: 'VendorStoreBase.categories'))
      .value;
  Computed<Map<dynamic, dynamic>>? _$sortComputed;

  @override
  Map<dynamic, dynamic> get sort =>
      (_$sortComputed ??= Computed<Map<dynamic, dynamic>>(() => super.sort, name: 'VendorStoreBase.sort')).value;
  Computed<double>? _$rangDistanceComputed;

  @override
  double get rangDistance =>
      (_$rangDistanceComputed ??= Computed<double>(() => super.rangDistance, name: 'VendorStoreBase.rangDistance'))
          .value;

  final _$fetchVendorsFutureAtom = Atom(name: 'VendorStoreBase.fetchVendorsFuture');

  @override
  ObservableFuture<List<Vendor>?> get fetchVendorsFuture {
    _$fetchVendorsFutureAtom.reportRead();
    return super.fetchVendorsFuture;
  }

  @override
  set fetchVendorsFuture(ObservableFuture<List<Vendor>?> value) {
    _$fetchVendorsFutureAtom.reportWrite(value, super.fetchVendorsFuture, () {
      super.fetchVendorsFuture = value;
    });
  }

  final _$_vendorsAtom = Atom(name: 'VendorStoreBase._vendors');

  @override
  ObservableList<Vendor> get _vendors {
    _$_vendorsAtom.reportRead();
    return super._vendors;
  }

  @override
  set _vendors(ObservableList<Vendor> value) {
    _$_vendorsAtom.reportWrite(value, super._vendors, () {
      super._vendors = value;
    });
  }

  final _$_categoryVendorsAtom = Atom(name: 'VendorStoreBase._categoryVendors');

  @override
  ObservableList<int> get _categoryVendors {
    _$_categoryVendorsAtom.reportRead();
    return super._categoryVendors;
  }

  @override
  set _categoryVendors(ObservableList<int> value) {
    _$_categoryVendorsAtom.reportWrite(value, super._categoryVendors, () {
      super._categoryVendors = value;
    });
  }

  final _$successAtom = Atom(name: 'VendorStoreBase.success');

  @override
  bool get success {
    _$successAtom.reportRead();
    return super.success;
  }

  @override
  set success(bool value) {
    _$successAtom.reportWrite(value, super.success, () {
      super.success = value;
    });
  }

  final _$_nextPageAtom = Atom(name: 'VendorStoreBase._nextPage');

  @override
  int get _nextPage {
    _$_nextPageAtom.reportRead();
    return super._nextPage;
  }

  @override
  set _nextPage(int value) {
    _$_nextPageAtom.reportWrite(value, super._nextPage, () {
      super._nextPage = value;
    });
  }

  final _$_perPageAtom = Atom(name: 'VendorStoreBase._perPage');

  @override
  int get _perPage {
    _$_perPageAtom.reportRead();
    return super._perPage;
  }

  @override
  set _perPage(int value) {
    _$_perPageAtom.reportWrite(value, super._perPage, () {
      super._perPage = value;
    });
  }

  final _$_langAtom = Atom(name: 'VendorStoreBase._lang');

  @override
  String get _lang {
    _$_langAtom.reportRead();
    return super._lang;
  }

  @override
  set _lang(String value) {
    _$_langAtom.reportWrite(value, super._lang, () {
      super._lang = value;
    });
  }

  final _$_searchAtom = Atom(name: 'VendorStoreBase._search');

  @override
  String? get _search {
    _$_searchAtom.reportRead();
    return super._search;
  }

  @override
  set _search(String? value) {
    _$_searchAtom.reportWrite(value, super._search, () {
      super._search = value;
    });
  }

  final _$_sortAtom = Atom(name: 'VendorStoreBase._sort');

  @override
  Map<String, dynamic> get _sort {
    _$_sortAtom.reportRead();
    return super._sort;
  }

  @override
  set _sort(Map<String, dynamic> value) {
    _$_sortAtom.reportWrite(value, super._sort, () {
      super._sort = value;
    });
  }

  final _$_rangeDistanceAtom = Atom(name: 'VendorStoreBase._rangeDistance');

  @override
  double get _rangeDistance {
    _$_rangeDistanceAtom.reportRead();
    return super._rangeDistance;
  }

  @override
  set _rangeDistance(double value) {
    _$_rangeDistanceAtom.reportWrite(value, super._rangeDistance, () {
      super._rangeDistance = value;
    });
  }

  final _$_categoriesAtom = Atom(name: 'VendorStoreBase._categories');

  @override
  ObservableList<ProductCategory> get _categories {
    _$_categoriesAtom.reportRead();
    return super._categories;
  }

  @override
  set _categories(ObservableList<ProductCategory> value) {
    _$_categoriesAtom.reportWrite(value, super._categories, () {
      super._categories = value;
    });
  }

  final _$_canLoadMoreAtom = Atom(name: 'VendorStoreBase._canLoadMore');

  @override
  bool get _canLoadMore {
    _$_canLoadMoreAtom.reportRead();
    return super._canLoadMore;
  }

  @override
  set _canLoadMore(bool value) {
    _$_canLoadMoreAtom.reportWrite(value, super._canLoadMore, () {
      super._canLoadMore = value;
    });
  }

  final _$getVendorsAsyncAction = AsyncAction('VendorStoreBase.getVendors');

  @override
  Future<void> getVendors() {
    return _$getVendorsAsyncAction.run(() => super.getVendors());
  }

  final _$getIdCategoryAsyncAction = AsyncAction('VendorStoreBase.getIdCategory');

  @override
  Future<void> getIdCategory(int idVendor) {
    return _$getIdCategoryAsyncAction.run(() => super.getIdCategory(idVendor));
  }

  final _$VendorStoreBaseActionController = ActionController(name: 'VendorStoreBase');

  @override
  Future<void> refresh() {
    final $actionInfo = _$VendorStoreBaseActionController.startAction(name: 'VendorStoreBase.refresh');
    try {
      return super.refresh();
    } finally {
      _$VendorStoreBaseActionController.endAction($actionInfo);
    }
  }

  @override
  void onChanged(
      {Map<dynamic, dynamic>? sort,
      String? search,
      int? perPage,
      double? rangeDistance,
      List<ProductCategory>? categories,
      bool enableEmptyCategory = false}) {
    final $actionInfo = _$VendorStoreBaseActionController.startAction(name: 'VendorStoreBase.onChanged');
    try {
      return super.onChanged(
          sort: sort,
          search: search,
          perPage: perPage,
          rangeDistance: rangeDistance,
          categories: categories,
          enableEmptyCategory: enableEmptyCategory);
    } finally {
      _$VendorStoreBaseActionController.endAction($actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchVendorsFuture: ${fetchVendorsFuture},
success: ${success},
loading: ${loading},
vendors: ${vendors},
categoryVendors: ${categoryVendors},
canLoadMore: ${canLoadMore},
perPage: ${perPage},
lang: ${lang},
search: ${search},
categories: ${categories},
sort: ${sort},
rangDistance: ${rangDistance}
    ''';
  }
}
