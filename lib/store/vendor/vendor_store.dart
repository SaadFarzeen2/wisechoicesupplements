import 'package:cirilla/models/models.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/auth/location_store.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:mobx/mobx.dart';

part 'vendor_store.g.dart';

class VendorStore = VendorStoreBase with _$VendorStore;

abstract class VendorStoreBase with Store {
  final String? key;

  // Request helper instance
  final RequestHelper _requestHelper;

  LocationStore? _locationStore;

  // store for handling errors
  // final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  VendorStoreBase(
    this._requestHelper, {
    int? perPage,
    String? lang,
    String? search,
    Map<String, dynamic>? sort,
    List<ProductCategory>? categories,
    double? rangeDistance,
    LocationStore? locationStore,
    this.key,
  }) {
    if (perPage != null) _perPage = perPage;
    if (lang != null) _lang = lang;
    if (search != null) _search = search;
    if (sort != null) _sort = sort;
    if (categories != null) _categories = ObservableList<ProductCategory>.of(categories);
    if (rangeDistance != null) _rangeDistance = rangeDistance;
    if (locationStore != null) _locationStore = locationStore;
    _reaction();
  }

  // store variables:-----------------------------------------------------------
  static ObservableFuture<List<Vendor>> emptyVendorsResponse = ObservableFuture.value([]);

  @observable
  ObservableFuture<List<Vendor>?> fetchVendorsFuture = emptyVendorsResponse;

  @observable
  ObservableList<Vendor> _vendors = ObservableList<Vendor>.of([]);

  @observable
  ObservableList<int> _categoryVendors = ObservableList<int>.of([]);

  @observable
  bool success = false;

  @observable
  int _nextPage = 1;

  @observable
  int _perPage = 10;

  @observable
  String _lang = '';

  @observable
  String? _search = '';

  @observable
  Map<String, dynamic> _sort = {
    'key': 'vendor_list_date_desc',
    'query': {
      'orderby': 'date',
      'order': 'desc',
    }
  };
  @observable
  double _rangeDistance = 50;

  @observable
  ObservableList<ProductCategory> _categories = ObservableList<ProductCategory>.of([]);

  @observable
  bool _canLoadMore = true;

  // computed:-------------------------------------------------------------------
  @computed
  bool get loading => fetchVendorsFuture.status == FutureStatus.pending;

  @computed
  ObservableList<Vendor> get vendors => _vendors;

  @computed
  ObservableList<int> get categoryVendors => _categoryVendors;

  @computed
  bool get canLoadMore => _canLoadMore;

  @computed
  int get perPage => _perPage;

  @computed
  String get lang => _lang;

  @computed
  String? get search => _search;

  @computed
  ObservableList<ProductCategory> get categories => _categories;

  @computed
  Map get sort => _sort;

  @computed
  double get rangDistance => _rangeDistance;

  // actions:-------------------------------------------------------------------
  @action
  Future<void> getVendors() async {
    List<int> categoryIds = [];
    if (_categories.isNotEmpty) {
      for (var cate in _categories) {
        if (cate.id is int) {
          categoryIds.add(cate.id!);
        }
      }
    }
    Map<String, dynamic> query = {
      'per_page': _perPage,
      'page': _nextPage,
      'lang': _lang,
      'search': _search,
      'order': _sort['query']['order'],
      'orderby': _sort['query']['orderby'],
      'category': categoryIds.join(','),
      'radius_lat': _locationStore?.location.lat,
      'radius_lng': _locationStore?.location.lng,
      'radius_range': _rangeDistance,
      'status': ['approved']
    };
    query.removeWhere((key, value) => value == null || value == "");

    final future = _requestHelper.getVendors(queryParameters: query);

    fetchVendorsFuture = ObservableFuture(future);
    return future.then((data) {
      // Replace state in the first time or refresh
      if (_nextPage <= 1) {
        _vendors = ObservableList<Vendor>.of(data!);
      } else {
        // Add posts when load more page
        _vendors.addAll(ObservableList<Vendor>.of(data!));
      }

      // Check if can load more item
      if (data.length >= _perPage) {
        _nextPage++;
      } else {
        _canLoadMore = false;
      }
    }).catchError((error) {
      avoidPrint(error);
      // errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action
  Future<void> getIdCategory(int idVendor) async {
    Map<String, dynamic> query = {
      'id': idVendor,
      'lang': _lang,
    };
    query.removeWhere((key, value) => value == null || value == "");

    final future = _requestHelper.getCategoryVendor(queryParameters: query);

    return future.then((data) {
      _categoryVendors = ObservableList<int>.of(data ?? []);
    }).catchError((error) {
      avoidPrint(error);
      // errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action
  Future<void> refresh() {
    _canLoadMore = true;
    _nextPage = 1;
    _vendors.clear();
    return getVendors();
  }

  @action
  void onChanged({
    Map? sort,
    String? search,
    int? perPage,
    double? rangeDistance,
    List<ProductCategory>? categories,
    bool enableEmptyCategory = false,
  }) {
    if (sort != null) _sort = sort as Map<String, dynamic>;
    if (search != null) _search = search;
    if (perPage != null) _perPage = perPage;
    if (rangeDistance != null) _rangeDistance = rangeDistance;
    if (enableEmptyCategory || (!enableEmptyCategory && categories != null)) {
      _categories = ObservableList<ProductCategory>.of(categories ?? []);
    }
  }

  // disposers:-----------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _reaction() {
    _disposers = [
      reaction((_) => _sort, (_) => refresh()),
      reaction((_) => _locationStore?.location, (_) => refresh()),
    ];
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
