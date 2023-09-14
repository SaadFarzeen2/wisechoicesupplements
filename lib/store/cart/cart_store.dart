import 'package:cirilla/constants/app.dart';
import 'package:cirilla/models/cart/cart.dart';
import 'package:cirilla/service/helpers/persist_helper.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/store/cart/checkout_store.dart';
import 'package:cirilla/store/cart/payment_store.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:cirilla/utils/string_generate.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'cart_store.g.dart';

class CartStore = CartStoreBase with _$CartStore;

abstract class CartStoreBase with Store {
  late PaymentStore paymentStore;
  late CheckoutStore checkoutStore;

  final PersistHelper _persistHelper;
  final RequestHelper _requestHelper;
  final AuthStore _authStore;

  final CancelToken _token = CancelToken();

  @observable
  bool _loading = false;

  @observable
  bool _loadingShipping = false;

  @observable
  bool _loadingAddCart = false;

  @observable
  String? _cartKey;

  @observable
  CartData? _cartData;

  @observable
  bool _canLoadMore = true;

  @observable
  bool _isMergeCart = false;

  @observable
  bool _loadingRemoveCart = false;

  @computed
  bool get canLoadMore => _canLoadMore;

  @computed
  bool get loading => _loading;

  @computed
  bool get loadingShipping => _loadingShipping;

  @computed
  bool get loadingAddCart => _loadingAddCart;

  @computed
  CartData? get cartData => _cartData;

  @computed
  int? get count => _cartData != null ? _cartData!.itemsCount : 0;

  @computed
  String? get cartKey => _cartKey;

  @computed
  bool get isMergeCart => _isMergeCart;

  @computed
  bool get loadingRemoveCart => _loadingRemoveCart;

  // Action: -----------------------------------------------------------------------------------------------------------
  @action
  Future<bool> setCartKey(String value, [guest = true]) async {
    _cartKey = value;
    if (guest) {
      await _persistHelper.saveGuestCartKey(value);
    }
    return await _persistHelper.saveCartKey(value);
  }

  @action
  Future<void> mergeCart({bool? isLogin}) async {
    if (isLogin == true && _authStore.user != null) {
      await setCartKey(_authStore.user!.id, false);
      _isMergeCart = true;
    } else {
      String? guest = _persistHelper.getGuestCartKey();
      String id = guest is String ? guest : StringGenerate.uuid();
      await setCartKey(id);
      _isMergeCart = true;
    }
  }

  @action
  Future<void> getCart() async {
    _loading = true;
    try {
      String lang = await _persistHelper.getLanguage();
      String? currency = await _persistHelper.getCurrency();

      Map<String, String?> queryParameters = {
        'cart_key': _cartKey,
        'wpml_language': lang,
        'app-builder-decode': 'true',
        'currency': currency ?? '',
      };

      Map<String, dynamic> json = await _requestHelper.getCart(
        queryParameters: queryParameters,
        cancelToken: _token,
      );
      _cartData = CartData.fromJson(json);
      _loading = false;
      _canLoadMore = false;
      _isMergeCart = false;
    } on DioError {
      _loading = false;
      _canLoadMore = false;
      _isMergeCart = false;
      rethrow;
    }
  }

  @action
  Future<void> refresh() async {
    _canLoadMore = true;
    return getCart();
  }

  @action
  Future<void> updateQuantity({String? key, int? quantity}) async {
    String? currency = await _persistHelper.getCurrency();
    try {
      if (key != null) {
        String lang = await _persistHelper.getLanguage();
        Map<String, dynamic> json = await _requestHelper.updateQuantity(
          cartKey: _cartKey,
          queryParameters: {
            'key': key,
            'quantity': quantity ?? 1,
            'wpml_language': lang,
            'currency': currency ?? '',
          },
        );
        _cartData = CartData.fromJson(json);
      }
    } on DioError {
      rethrow;
    }
  }

  @action
  Future<void> selectShipping({int? packageId, String? rateId}) async {
    try {
      String? currency = await _persistHelper.getCurrency();
      if (packageId != null && rateId != null) {
        _loadingShipping = true;
        Map<String, dynamic> json = await _requestHelper.selectShipping(
          cartKey: _cartKey,
          queryParameters: {
            'package_id': packageId,
            'rate_id': rateId,
            'currency': currency ?? '',
          },
        );
        _cartData = CartData.fromJson(json);
        _loadingShipping = false;
      }
    } on DioError {
      _loadingShipping = false;
      rethrow;
    }
  }

  @action
  Future<void> updateCustomerCart({Map<String, dynamic>? data}) async {
    try {
      String? currency = await _persistHelper.getCurrency();

      Map<String, dynamic>? queryParameters = {'currency': currency ?? ''};

      Map<String, dynamic> json = await _requestHelper.updateCustomerCart(
        cartKey: _cartKey,
        data: data,
        queryParameters: queryParameters,
      );
      _cartData = CartData.fromJson(json);
    } on DioError {
      rethrow;
    }
  }

  @action
  Future<void> applyCoupon({required String code}) async {
    _loading = true;
    try {
      String lang = await _persistHelper.getLanguage();
      String? currency = await _persistHelper.getCurrency();
      Map<String, dynamic> json = await _requestHelper.applyCoupon(
        cartKey: _cartKey,
        queryParameters: {
          'code': code,
          'wpml_language': lang,
          'currency': currency ?? '',
        },
      );
      _cartData = CartData.fromJson(json);
      _loading = false;
    } on DioError {
      _loading = false;
      rethrow;
    }
  }

  @action
  Future<void> removeCoupon({required String code}) async {
    _loading = true;
    try {
      String lang = await _persistHelper.getLanguage();
      String? currency = await _persistHelper.getCurrency();
      Map<String, dynamic> json = await _requestHelper.removeCoupon(
        cartKey: _cartKey,
        queryParameters: {
          'code': code,
          'wpml_language': lang,
          'currency': currency ?? '',
        },
      );
      _cartData = CartData.fromJson(json);
      _loading = false;
    } on DioError {
      _loading = false;
      rethrow;
    }
  }

  @action
  Future<void> removeCart({String? key}) async {
    try {
      if (key != null) {
        _loadingRemoveCart = true;
        String lang = await _persistHelper.getLanguage();
        String? currency = await _persistHelper.getCurrency();
        Map<String, String?> queryParameters = {
          'key': key,
          'wpml_language': lang,
          'currency': currency ?? '',
        };
        if (lang != defaultLanguage) {
          queryParameters.putIfAbsent('lang', () => lang);
        }
        Map<String, dynamic> json =
            await _requestHelper.removeCart(cartKey: _cartKey, queryParameters: queryParameters);
        _cartData = CartData.fromJson(json);
        _loadingRemoveCart = false;
      }
    } on DioError {
      _loadingRemoveCart = false;
      rethrow;
    }
  }

  ///
  /// clean cart contents when language change
  ///
  /// https://wpml.org/documentation/related-projects/woocommerce-multilingual/clearing-cart-contents-when-language-or-currency-change/
  ///
  @action
  Future<void> cleanCart() async {
    try {
      await _requestHelper.cleanCart(cartKey: _cartKey);
      _cartData = null;
      checkoutStore.updateAddress();
    } on DioError {
      rethrow;
    }
  }

  @action
  Future<void> addToCart(Map<String, dynamic> data) async {
    try {
      String lang = await _persistHelper.getLanguage();
      String? currency = await _persistHelper.getCurrency();

      Map<String, dynamic> cartData = Map<String, dynamic>.of(data);

      cartData.putIfAbsent('wpml_language', () => lang);

      Map<String, String?> queryParams = {
        'cart_key': cartKey,
        'app-builder-decode': 'true',
        'currency': currency ?? ''
      };
      _loadingAddCart = true;
      Map<String, dynamic> json = await _requestHelper.addToCart(
        queryParams: queryParams,
        data: cartData,
      );
      _cartData = CartData.fromJson(json);
      _loadingAddCart = false;
    } on DioError {
      _loadingAddCart = false;
      rethrow;
    }
  }

  // Constructor: ------------------------------------------------------------------------------------------------------
  CartStoreBase(this._persistHelper, this._requestHelper, this._authStore) {
    _init();
    _reaction();
    paymentStore = PaymentStore(_requestHelper);
    checkoutStore = CheckoutStore(_persistHelper, _requestHelper, this as CartStore);
  }

  Future _init() async {
    await _restore();
    try {
      await getCart();
    } catch (e) {
      avoidPrint('GetCart - cancel.');
    }
  }

  Future<void> _restore() async {
    String? cartKey = _persistHelper.getCartKey();
    if (cartKey != null && cartKey != "") {
      _cartKey = cartKey;
      await setCartKey(cartKey);
    } else {
      String? guest = _persistHelper.getGuestCartKey();
      String id = guest is String ? guest : StringGenerate.uuid();
      await setCartKey(id);
    }
  }

  // disposers:---------------------------------------------------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _reaction() {
    _disposers = [
      reaction((_) => _authStore.isLogin, (dynamic isLogin) => mergeCart(isLogin: isLogin)),
    ];
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
    _token.cancel('Cancel get cart.');
  }
}
