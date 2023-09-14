import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/service/service.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'wishlist_store.g.dart';

class WishListStore = WishListStoreBase with _$WishListStore;

abstract class WishListStoreBase with Store {
  final PersistHelper _persistHelper;
  final RequestHelper _requestHelper;
  final AuthStore _authStore;

  @observable
  ObservableList<String> _data = ObservableList<String>.of([]);

  static ObservableFuture<dynamic> emptyWishlistResponse = ObservableFuture.value([]);

  @observable
  ObservableFuture<dynamic> fetchProductsFuture = emptyWishlistResponse;

  @observable
  ObservableList<dynamic> _dataWishlistProduct = ObservableList<dynamic>.of([]);

  @computed
  ObservableList<String> get data => _data;

  @computed
  int get count => _data.length;

  @observable
  int offsetPage = 0;

  @observable
  int nxPage = 0;

  @observable
  int countPage = 99;

  @observable
  bool _enableWishlistPlugin = false;

  @computed
  ObservableList<dynamic> get dataWishlistProduct => _dataWishlistProduct;

  @computed
  bool? get enableWishlistPlugin => _enableWishlistPlugin;

  // Action: -----------------------------------------------------------------------------------------------------------
  @action
  void setWishlistPlugin(bool value) {
    _enableWishlistPlugin = value;
  }

  @action
  void addWishList(String value, {int? position}) async {
    int index = _data.indexOf(value);
    int productId = ConvertData.stringToInt(value);
    String shareKey = _persistHelper.getShareKeyWishlist() ?? '';
    if (_authStore.isLogin && _enableWishlistPlugin) {
      if (index == -1) {
        position != null ? data.insert(position, value) : _data.add(value);
        await addWishlistProductShareKey(shareKey: shareKey, productId: productId);
      } else {
        _data.removeAt(index);
        int itemId = dataWishlistProduct.where((e) => e['product_id'] == productId).first['item_id'];
        await removeWishlistProduct(productId: itemId);
      }
    } else {
      if (index == -1) {
        position != null ? data.insert(position, value) : _data.add(value);
      } else {
        _data.removeAt(index);
      }
    }
  }

  @action
  void updateWishList(List<String> newWishlist) {
    _data = ObservableList<String>.of([...newWishlist]);
  }

  // Constructor: ------------------------------------------------------------------------------------------------------
  WishListStoreBase(this._persistHelper, this._requestHelper, this._authStore) {
    _init();
    _reaction();
  }

  Future _init() async {
    _read();
  }

  void _read() {
    List<String>? data = _persistHelper.getWishList();
    if (data != null && data.isNotEmpty) {
      _data = ObservableList<String>.of(data);
    }
  }

  void _write() async {
    await _persistHelper.saveWishList(_data);
  }

  // Compare data then get a list of unique elements
  void _compareDataWishlist(dynamic wishlist) {
    List<String> data = _persistHelper.getWishList() ?? [];
    _dataWishlistProduct = ObservableList<dynamic>.of(wishlist);
    dynamic dataWishlist = _dataWishlistProduct.map((e) => '${e['product_id']}').toList();
    if (data.isEmpty) {
      _data = ObservableList<String>.of(dataWishlist);
    } else {
      if (data.length > dataWishlist.length) {
        // If the local data is larger than the returned data, the data will be returned
        _data = ObservableList<String>.of(dataWishlist);
      } else {
        _read();
        // Generates a list of local data and return data
        data.addAll(dataWishlist);

        // Remove duplicate elements in "_data"
        List<dynamic> productIds = data;
        var seen = <String>{};
        dynamic uniqueListId = productIds.where((id) => seen.add(id.toString())).toList();

        // Remove aggregate data from local data and return data
        data.clear();

        // This is the result obtained after comparing and merging
        _data = ObservableList<String>.of(uniqueListId);
      }
    }
  }

  @action
  Future<void> getDataWishlistPlugin() async {
    if (_enableWishlistPlugin) {
      try {
        String? shareKey = _persistHelper.getShareKeyWishlist();
        if (_authStore.isLogin && shareKey == '') {
          getWishlistByUser(_authStore.user!.id);
        }
        if (_authStore.isLogin && shareKey != 'noKey') {
          final res = _requestHelper.getWishlistProductShareKey(
            shareKey: shareKey ?? '',
            queryParameters: {
              'app-builder-decode': true,
              'offset': offsetPage,
              'count': countPage,
            },
          );
          fetchProductsFuture = ObservableFuture(res);
          return res.then((wishlist) {
            _compareDataWishlist(wishlist);
          }).catchError((error) {
            throw error;
          });
        } else {
          if (shareKey == 'noKey') {
            await _persistHelper.saveShareKeyWishlist('');
            _data.clear();
          }
        }
      } on DioError {
        rethrow;
      }
    }
  }

  @action
  Future<dynamic> getWishlistByUser(String id) async {
    try {
      int userId = ConvertData.stringToInt(id);

      List<dynamic> dataByUser = await _requestHelper.getWishlistByUser(
        userId: userId,
      );

      String shareKey = get(dataByUser.first, ['share_key']);
      _persistHelper.saveShareKeyWishlist(shareKey);

      // Merge local data with login account
      List<String> data = _persistHelper.getWishList() ?? [];
      for (int i = 0; i < data.length; i++) {
        await addWishlistProductShareKey(
          shareKey: shareKey,
          productId: ConvertData.stringToInt(data[i]),
        );
        avoidPrint('======== successfully merge product with id=${data[i]} into wishlist ========');
      }
    } on DioError {
      rethrow;
    }
  }

  @action
  Future<void> addWishlistProductShareKey({required String shareKey, required int productId}) async {
    try {
      await _requestHelper.addWishlistProductShareKey(
        shareKey: shareKey,
        productId: productId,
      );
    } on DioError {
      rethrow;
    }
  }

  @action
  Future<void> removeWishlistProduct({required int productId}) async {
    try {
      await _requestHelper.removeWishlistProduct(productId: productId);
    } on DioError {
      rethrow;
    }
  }

  // disposers:---------------------------------------------------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _reaction() {
    _disposers = [
      reaction((_) => _data.length, (_) => _write()),
      reaction((_) => _authStore.isLogin, (dynamic isLogin) {
        if (_enableWishlistPlugin) {
          if (isLogin) {
            getWishlistByUser(_authStore.user!.id);
          } else {
            _persistHelper.saveShareKeyWishlist('noKey');
          }
        }
      }),
    ];
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
