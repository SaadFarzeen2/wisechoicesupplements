// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CheckoutStore on CheckoutStoreBase, Store {
  final _$loadingAtom = Atom(name: 'CheckoutStoreBase.loading');

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  final _$loadingPaymentAtom = Atom(name: 'CheckoutStoreBase.loadingPayment');

  @override
  bool get loadingPayment {
    _$loadingPaymentAtom.reportRead();
    return super.loadingPayment;
  }

  @override
  set loadingPayment(bool value) {
    _$loadingPaymentAtom.reportWrite(value, super.loadingPayment, () {
      super.loadingPayment = value;
    });
  }

  final _$shipToDifferentAddressAtom = Atom(name: 'CheckoutStoreBase.shipToDifferentAddress');

  @override
  bool get shipToDifferentAddress {
    _$shipToDifferentAddressAtom.reportRead();
    return super.shipToDifferentAddress;
  }

  @override
  set shipToDifferentAddress(bool value) {
    _$shipToDifferentAddressAtom.reportWrite(value, super.shipToDifferentAddress, () {
      super.shipToDifferentAddress = value;
    });
  }

  final _$deliveryLocationAtom = Atom(name: 'CheckoutStoreBase.deliveryLocation');

  @override
  UserLocation? get deliveryLocation {
    _$deliveryLocationAtom.reportRead();
    return super.deliveryLocation;
  }

  @override
  set deliveryLocation(UserLocation? value) {
    _$deliveryLocationAtom.reportWrite(value, super.deliveryLocation, () {
      super.deliveryLocation = value;
    });
  }

  final _$billingAddressAtom = Atom(name: 'CheckoutStoreBase.billingAddress');

  @override
  Map<String, dynamic> get billingAddress {
    _$billingAddressAtom.reportRead();
    return super.billingAddress;
  }

  @override
  set billingAddress(Map<String, dynamic> value) {
    _$billingAddressAtom.reportWrite(value, super.billingAddress, () {
      super.billingAddress = value;
    });
  }

  final _$shippingAddressAtom = Atom(name: 'CheckoutStoreBase.shippingAddress');

  @override
  Map<String, dynamic> get shippingAddress {
    _$shippingAddressAtom.reportRead();
    return super.shippingAddress;
  }

  @override
  set shippingAddress(Map<String, dynamic> value) {
    _$shippingAddressAtom.reportWrite(value, super.shippingAddress, () {
      super.shippingAddress = value;
    });
  }

  final _$checkoutAsyncAction = AsyncAction('CheckoutStoreBase.checkout');

  @override
  Future<dynamic> checkout(List<dynamic> paymentData) {
    return _$checkoutAsyncAction.run(() => super.checkout(paymentData));
  }

  final _$updateBillingFromMapAsyncAction = AsyncAction('CheckoutStoreBase.updateBillingFromMap');

  @override
  Future<dynamic> updateBillingFromMap(
      {required Place place, required AddressDataStore addressDataStore, String? locale, String? address2}) {
    return _$updateBillingFromMapAsyncAction.run(() => super.updateBillingFromMap(
          addressDataStore: addressDataStore,
          place: place,
          locale: locale,
          address2: address2,
        ));
  }

  final _$updateShippingFromMapAsyncAction = AsyncAction('CheckoutStoreBase.updateShippingFromMap');

  @override
  Future<dynamic> updateShippingFromMap(
      {required Place place, required AddressDataStore addressDataStore, String? locale, String? address2}) {
    return _$updateShippingFromMapAsyncAction.run(() => super.updateShippingFromMap(
          addressDataStore: addressDataStore,
          place: place,
          locale: locale,
          address2: address2,
        ));
  }

  final _$progressServerAsyncAction = AsyncAction('CheckoutStoreBase.progressServer');

  @override
  Future<dynamic> progressServer({String? cartKey, required Map<String, dynamic> data}) {
    return _$progressServerAsyncAction.run(() => super.progressServer(cartKey: cartKey, data: data));
  }

  final _$changeAddressAsyncAction = AsyncAction('CheckoutStoreBase.changeAddress');

  @override
  Future<void> changeAddress({Map<String, dynamic>? billing, Map<String, dynamic>? shipping, Function? callback}) {
    return _$changeAddressAsyncAction
        .run(() => super.changeAddress(billing: billing, shipping: shipping, callback: callback));
  }

  final _$updateAddressAsyncAction = AsyncAction('CheckoutStoreBase.updateAddress');

  @override
  Future<void> updateAddress() {
    return _$updateAddressAsyncAction.run(() => super.updateAddress());
  }

  final _$CheckoutStoreBaseActionController = ActionController(name: 'CheckoutStoreBase');

  @override
  void onShipToDifferentAddress() {
    final $actionInfo =
        _$CheckoutStoreBaseActionController.startAction(name: 'CheckoutStoreBase.onShipToDifferentAddress');
    try {
      return super.onShipToDifferentAddress();
    } finally {
      _$CheckoutStoreBaseActionController.endAction($actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
loadingPayment: ${loadingPayment},
shipToDifferentAddress: ${shipToDifferentAddress},
billingAddress: ${billingAddress},
shippingAddress: ${shippingAddress}
    ''';
  }
}
