import 'package:cirilla/models/location/place.dart';
import 'package:cirilla/models/location/user_location.dart';
import 'package:cirilla/service/helpers/persist_helper.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/store.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';


part 'checkout_store.g.dart';

class CheckoutStore = CheckoutStoreBase with _$CheckoutStore;

abstract class CheckoutStoreBase with Store {
  final CartStore _cartStore;
  final PersistHelper _persistHelper;
  final RequestHelper _requestHelper;

  // Constructor: ------------------------------------------------------------------------------------------------------
  CheckoutStoreBase(this._persistHelper, this._requestHelper, this._cartStore) {
    _init();
    _reaction();
  }

  Future<void> _init() async {}

  // Observable: -------------------------------------------------------------------------------------------------------
  @observable
  bool loading = false;

  @observable
  bool loadingPayment = false;

  @observable
  bool shipToDifferentAddress = false;

  @observable
  Map<String, dynamic> billingAddress = {};

  @observable
  Map<String, dynamic> shippingAddress = {};

  @observable
  UserLocation? deliveryLocation;

  // Action: -----------------------------------------------------------------------------------------------------------
  @action
  Future<dynamic> checkout(List<dynamic> paymentData) async {
    Map<String, dynamic> billing = {...?_cartStore.cartData?.billingAddress, ...billingAddress};

    Map<String, dynamic> shipping = {...?_cartStore.cartData?.shippingAddress, ...shippingAddress};

    try {
      loading = true;
      Map<String, dynamic> cartData = {
        'billing_address': billing,
        'customer_note': '',
        'extensions': {},
        'payment_data': paymentData,
        'payment_method': _cartStore.paymentStore.method,
        'shipping_address': shipping,
        'should_create_account': false,
      };
      String? currency = await _persistHelper.getCurrency();
      Map<String, dynamic> json = await _requestHelper.checkout(
        queryParameters: {
          'cart_key': _cartStore.cartKey,
          'app-builder-token': _persistHelper.getToken(),
          'currency': currency ?? ''
        },
        data: cartData,
      );
      loading = false;
      return json;
    } on DioError {
      loading = false;
      rethrow;
    }
  }

  @action
  Future<void> updateBillingFromMap({
    required Place place,
    required AddressDataStore addressDataStore,
    String? locale,
    String? address2,
  }) async {
    Map<String, dynamic> billing = {...billingAddress};
    String country =
        place.addressComponents.firstWhereOrNull((element) => element.types?.contains('country') ?? false)?.shortName ??
            '';
    billing['address_1'] = place.address;
    billing['address_2'] = address2 ?? '';
    billing['city'] = place.addressComponents
            .firstWhereOrNull((element) => element.types?.contains('administrative_area_level_2') ?? false)
            ?.shortName ??
        '';
    billing['state'] = place.addressComponents
            .firstWhereOrNull((element) => element.types?.contains('administrative_area_level_1') ?? false)
            ?.shortName ??
        '';
    billing['country'] = country;
    billing['postcode'] = place.addressComponents
            .firstWhereOrNull((element) => element.types?.contains('postal_code') ?? false)
            ?.shortName ??
        '';
    billingAddress = billing;
    addressDataStore.getAddressData(queryParameters: {
      'country': country,
      'lang': locale,
    });
  }

  @action
  Future<void> updateShippingFromMap({
    required Place place,
    required AddressDataStore addressDataStore,
    String? locale,
    String? address2,
  }) async {
    Map<String, dynamic> shipping = {...shippingAddress};
    String country =
        place.addressComponents.firstWhereOrNull((element) => element.types?.contains('country') ?? false)?.shortName ??
            '';
    shipping['address_1'] = place.address;
    shipping['address_2'] = address2 ?? '';
    shipping['city'] = place.addressComponents
            .firstWhereOrNull((element) => element.types?.contains('administrative_area_level_2') ?? false)
            ?.shortName ??
        '';
    shipping['state'] = place.addressComponents
            .firstWhereOrNull((element) => element.types?.contains('administrative_area_level_1') ?? false)
            ?.shortName ??
        '';
    shipping['country'] = country;
    shipping['postcode'] = place.addressComponents
            .firstWhereOrNull((element) => element.types?.contains('postal_code') ?? false)
            ?.shortName ??
        '';
    shippingAddress = shipping;
    addressDataStore.getAddressData(queryParameters: {
      'country': country,
      'lang': locale,
    });
  }

  @action
  Future<dynamic> progressServer({String? cartKey, required Map<String, dynamic> data}) async {
    try {
      loadingPayment = true;
      final res = await _requestHelper.progressServer(
        cartKey: cartKey,
        data: data,
      );
      loadingPayment = false;
      return res;
    } on DioError {
      loadingPayment = false;
      rethrow;
    }
  }

  @action
  void onShipToDifferentAddress() {
    shipToDifferentAddress = !shipToDifferentAddress;
  }

  @action
  Future<void> changeAddress(
      {Map<String, dynamic>? billing, Map<String, dynamic>? shipping, Function? callback}) async {
    Map<String, dynamic> oldBillingAddress = billingAddress;
    Map<String, dynamic> oldShippingAddress = shippingAddress;

    if (billing != null) billingAddress = billing;
    if (shipping != null) shippingAddress = shipping;

    callback?.call();
    List<String> keys = ['country', 'state'];

    if ((shipToDifferentAddress &&
            shipping != null &&
            keys.any((String key) => shipping[key] != oldShippingAddress[key])) ||
        (!shipToDifferentAddress &&
            billing != null &&
            keys.any((String key) => billing[key] != oldBillingAddress[key]))) {
      await updateAddress();
    }
  }

  @action
  Future<void> updateAddress() async {
    await _cartStore.updateCustomerCart(data: {'shipping_address': shippingAddress, 'billing_address': billingAddress});
  }

  // disposers:---------------------------------------------------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _reaction() {
    _disposers = [];
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
