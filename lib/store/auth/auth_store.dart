import 'package:cirilla/models/auth/user.dart';
import 'package:cirilla/service/helpers/persist_helper.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/auth/country_store.dart';
import 'package:cirilla/store/auth/digits_store.dart';
import 'package:cirilla/store/cart/cart_store.dart';
import 'package:cirilla/store/wishlist/wishlist_store.dart';
import 'package:cirilla/store/post_wishlist/post_wishlist_store.dart';
import 'package:cirilla/store/product_recently/product_recently_store.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:cirilla/service/messaging.dart';

import 'change_password_store.dart';
import 'forgot_password_store.dart';
import 'login_store.dart';
import 'register_store.dart';
import 'location_store.dart';

part 'auth_store.g.dart';

class AuthStore = AuthStoreBase with _$AuthStore;

abstract class AuthStoreBase with Store {
  final PersistHelper _persistHelper;
  final RequestHelper _requestHelper;

  late LoginStore loginStore;
  late RegisterStore registerStore;
  late DigitsStore digitsStore;
  late ForgotPasswordStore forgotPasswordStore;
  late ChangePasswordStore changePasswordStore;
  late LocationStore locationStore;
  late AddressStore addressStore;
  late WishListStore? wishListStore;
  late ProductRecentlyStore? productRecentlyStore;
  late PostWishListStore? postWishListStore;
  late CartStore cartStore;

  @observable
  bool _isLogin = false;

  @action
  void setLogin(bool value) {
    _isLogin = value;
  }

  @observable
  String? _token;

  @action
  Future<bool> setToken(String value) async {
    _token = value;
    // Save tokens for biometrics
    await _persistHelper.saveTokenBiometric(value);

    return await _persistHelper.saveToken(value);
  }

  @observable
  User? _user;

  @observable
  bool? _loadingEditAccount;

  @computed
  bool get isLogin => _isLogin;

  @computed
  User? get user => _user;

  @computed
  String? get token => _token;

  @computed
  bool? get loadingEditAccount => _loadingEditAccount;

  // Action: -----------------------------------------------------------------------------------------------------------
  @action
  void setUser(value) {
    _user = value;
  }

  @action
  Future<void> loginSuccess(Map<String, dynamic> data) async {
    try {
      _isLogin = true;
      // In the case data response from digits plugin ex: { "data": { "user": {} }}
      bool isSub = data.containsKey('success') && data.containsKey('data');
      _user = User.fromJson(isSub ? data['data']['user'] : data['user']);
      await setToken(isSub ? data['data']['token'] : data['token']);

      // Update FCM token to database
      String? token = await getToken();
      await updateTokenToDatabase(_requestHelper, token, topics: user?.roles);
    } catch (e) {
      avoidPrint('Error in loginSuccess ${e.toString()}');
    }
  }

  @action
  Future<bool> logout() async {
    _isLogin = false;
    _token = null;

    // Remove FCM token in database
    String? token = await getToken();
    try {
      await removeTokenInDatabase(_requestHelper, token, _user!.id, topics: _user?.roles);
    } catch (e) {
      avoidPrint('Logout error or not logged!');
    }
    // Remove user tokens when biometrics is off
    if (!_persistHelper.getUsingBiometric()) {
      await _persistHelper.removeToken();
      await _persistHelper.removeWishlist();
      return await _persistHelper.removeTokenBiometric();
    }
    await _persistHelper.removeWishlist();
    // Remove user token
    return await _persistHelper.removeToken();
  }

  @action
  Future<bool> editAccount(Map<String, dynamic> data) async {
    _loadingEditAccount = true;
    try {
      await _requestHelper.postAccount(
        userId: _user!.id,
        data: data,
      );
      Map<String, dynamic> userCustomer = _user!.toJson();
      userCustomer.addAll({
        'first_name': data['first_name'] is String ? data['first_name'] : _user!.firstName,
        'last_name': data['last_name'] is String ? data['last_name'] : _user!.lastName,
        'display_name': data['name'] is String ? data['name'] : _user!.displayName,
        'user_email': data['email'] is String ? data['email'] : _user!.userEmail,
      });
      _user = User.fromJson(userCustomer);
      _loadingEditAccount = false;
      return true;
    } on DioError {
      _loadingEditAccount = false;
      rethrow;
    }
  }

  // Constructor: ------------------------------------------------------------------------------------------------------
  AuthStoreBase(this._persistHelper, this._requestHelper) {
    loginStore = LoginStore(_requestHelper, this as AuthStore);
    registerStore = RegisterStore(_requestHelper, this as AuthStore);
    digitsStore = DigitsStore(_requestHelper, this as AuthStore);
    forgotPasswordStore = ForgotPasswordStore(_requestHelper);
    changePasswordStore = ChangePasswordStore(_requestHelper);
    addressStore = AddressStore(_requestHelper);
    wishListStore = WishListStore(_persistHelper, _requestHelper, this as AuthStore);
    productRecentlyStore = ProductRecentlyStore(_persistHelper);
    postWishListStore = PostWishListStore(_persistHelper);
    locationStore = LocationStore(_persistHelper);
    cartStore = CartStore(_persistHelper, _requestHelper, this as AuthStore);
    _init();
  }

  Future _init() async {
    _restore();
  }

  void _restore() async {
    String? token = _persistHelper.getToken();
    if (token != null && token != '') {
      // set isLogin, token without check
      _isLogin = true;
      _token = token;
      try {
        // Call API check token
        Map<String, dynamic> json = await _requestHelper.current();
        _user = User.fromJson(json);
      } catch (e) {
        _isLogin = false;
        _token = '';
        avoidPrint(
            'Error in validate the token user on the app, maybe the token expired, or the server not support Authentication on header.');
        await _persistHelper.removeToken();
      }
    }
  }

  ///
  /// The action help user can login via JWT token
  /// token JWT token
  ///
  /// The flow in this function
  /// 1. Persist token then network service can used on Authentication header
  /// 2. Call API get current info to get user info
  /// 3. Update user info to state
  @action
  Future<void> loginByToken(String token) async {
    await _persistHelper.saveToken(token);
    try {
      Map<String, dynamic> json = await _requestHelper.current();
      _user = User.fromJson(json);
      _token = null;
      _isLogin = true;
    } catch (e) {
      await _persistHelper.removeToken();
      rethrow;
    }
  }
}
