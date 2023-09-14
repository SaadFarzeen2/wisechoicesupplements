// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CartStore on CartStoreBase, Store {
  Computed<bool>? _$canLoadMoreComputed;

  @override
  bool get canLoadMore =>
      (_$canLoadMoreComputed ??= Computed<bool>(() => super.canLoadMore,
              name: 'CartStoreBase.canLoadMore'))
          .value;
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??=
          Computed<bool>(() => super.loading, name: 'CartStoreBase.loading'))
      .value;
  Computed<bool>? _$loadingShippingComputed;

  @override
  bool get loadingShipping =>
      (_$loadingShippingComputed ??= Computed<bool>(() => super.loadingShipping,
              name: 'CartStoreBase.loadingShipping'))
          .value;
  Computed<bool>? _$loadingAddCartComputed;

  @override
  bool get loadingAddCart =>
      (_$loadingAddCartComputed ??= Computed<bool>(() => super.loadingAddCart,
              name: 'CartStoreBase.loadingAddCart'))
          .value;
  Computed<CartData?>? _$cartDataComputed;

  @override
  CartData? get cartData =>
      (_$cartDataComputed ??= Computed<CartData?>(() => super.cartData,
              name: 'CartStoreBase.cartData'))
          .value;
  Computed<int?>? _$countComputed;

  @override
  int? get count => (_$countComputed ??=
          Computed<int?>(() => super.count, name: 'CartStoreBase.count'))
      .value;
  Computed<String?>? _$cartKeyComputed;

  @override
  String? get cartKey => (_$cartKeyComputed ??=
          Computed<String?>(() => super.cartKey, name: 'CartStoreBase.cartKey'))
      .value;
  Computed<bool>? _$isMergeCartComputed;

  @override
  bool get isMergeCart =>
      (_$isMergeCartComputed ??= Computed<bool>(() => super.isMergeCart,
              name: 'CartStoreBase.isMergeCart'))
          .value;
  Computed<bool>? _$loadingRemoveCartComputed;

  @override
  bool get loadingRemoveCart => (_$loadingRemoveCartComputed ??= Computed<bool>(
          () => super.loadingRemoveCart,
          name: 'CartStoreBase.loadingRemoveCart'))
      .value;

  late final _$_loadingAtom =
      Atom(name: 'CartStoreBase._loading', context: context);

  @override
  bool get _loading {
    _$_loadingAtom.reportRead();
    return super._loading;
  }

  @override
  set _loading(bool value) {
    _$_loadingAtom.reportWrite(value, super._loading, () {
      super._loading = value;
    });
  }

  late final _$_loadingShippingAtom =
      Atom(name: 'CartStoreBase._loadingShipping', context: context);

  @override
  bool get _loadingShipping {
    _$_loadingShippingAtom.reportRead();
    return super._loadingShipping;
  }

  @override
  set _loadingShipping(bool value) {
    _$_loadingShippingAtom.reportWrite(value, super._loadingShipping, () {
      super._loadingShipping = value;
    });
  }

  late final _$_loadingAddCartAtom =
      Atom(name: 'CartStoreBase._loadingAddCart', context: context);

  @override
  bool get _loadingAddCart {
    _$_loadingAddCartAtom.reportRead();
    return super._loadingAddCart;
  }

  @override
  set _loadingAddCart(bool value) {
    _$_loadingAddCartAtom.reportWrite(value, super._loadingAddCart, () {
      super._loadingAddCart = value;
    });
  }

  late final _$_cartKeyAtom =
      Atom(name: 'CartStoreBase._cartKey', context: context);

  @override
  String? get _cartKey {
    _$_cartKeyAtom.reportRead();
    return super._cartKey;
  }

  @override
  set _cartKey(String? value) {
    _$_cartKeyAtom.reportWrite(value, super._cartKey, () {
      super._cartKey = value;
    });
  }

  late final _$_cartDataAtom =
      Atom(name: 'CartStoreBase._cartData', context: context);

  @override
  CartData? get _cartData {
    _$_cartDataAtom.reportRead();
    return super._cartData;
  }

  @override
  set _cartData(CartData? value) {
    _$_cartDataAtom.reportWrite(value, super._cartData, () {
      super._cartData = value;
    });
  }

  late final _$_canLoadMoreAtom =
      Atom(name: 'CartStoreBase._canLoadMore', context: context);

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

  late final _$_isMergeCartAtom =
      Atom(name: 'CartStoreBase._isMergeCart', context: context);

  @override
  bool get _isMergeCart {
    _$_isMergeCartAtom.reportRead();
    return super._isMergeCart;
  }

  @override
  set _isMergeCart(bool value) {
    _$_isMergeCartAtom.reportWrite(value, super._isMergeCart, () {
      super._isMergeCart = value;
    });
  }

  late final _$_loadingRemoveCartAtom =
      Atom(name: 'CartStoreBase._loadingRemoveCart', context: context);

  @override
  bool get _loadingRemoveCart {
    _$_loadingRemoveCartAtom.reportRead();
    return super._loadingRemoveCart;
  }

  @override
  set _loadingRemoveCart(bool value) {
    _$_loadingRemoveCartAtom.reportWrite(value, super._loadingRemoveCart, () {
      super._loadingRemoveCart = value;
    });
  }

  late final _$setCartKeyAsyncAction =
      AsyncAction('CartStoreBase.setCartKey', context: context);

  @override
  Future<bool> setCartKey(String value, [dynamic guest = true]) {
    return _$setCartKeyAsyncAction.run(() => super.setCartKey(value, guest));
  }

  late final _$mergeCartAsyncAction =
      AsyncAction('CartStoreBase.mergeCart', context: context);

  @override
  Future<void> mergeCart({bool? isLogin}) {
    return _$mergeCartAsyncAction.run(() => super.mergeCart(isLogin: isLogin));
  }

  late final _$getCartAsyncAction =
      AsyncAction('CartStoreBase.getCart', context: context);

  @override
  Future<void> getCart() {
    return _$getCartAsyncAction.run(() => super.getCart());
  }

  late final _$refreshAsyncAction =
      AsyncAction('CartStoreBase.refresh', context: context);

  @override
  Future<void> refresh() {
    return _$refreshAsyncAction.run(() => super.refresh());
  }

  late final _$updateQuantityAsyncAction =
      AsyncAction('CartStoreBase.updateQuantity', context: context);

  @override
  Future<void> updateQuantity({String? key, int? quantity}) {
    return _$updateQuantityAsyncAction
        .run(() => super.updateQuantity(key: key, quantity: quantity));
  }

  late final _$selectShippingAsyncAction =
      AsyncAction('CartStoreBase.selectShipping', context: context);

  @override
  Future<void> selectShipping({int? packageId, String? rateId}) {
    return _$selectShippingAsyncAction
        .run(() => super.selectShipping(packageId: packageId, rateId: rateId));
  }

  late final _$updateCustomerCartAsyncAction =
      AsyncAction('CartStoreBase.updateCustomerCart', context: context);

  @override
  Future<void> updateCustomerCart({Map<String, dynamic>? data}) {
    return _$updateCustomerCartAsyncAction
        .run(() => super.updateCustomerCart(data: data));
  }

  late final _$applyCouponAsyncAction =
      AsyncAction('CartStoreBase.applyCoupon', context: context);

  @override
  Future<void> applyCoupon({required String code}) {
    return _$applyCouponAsyncAction.run(() => super.applyCoupon(code: code));
  }

  late final _$removeCouponAsyncAction =
      AsyncAction('CartStoreBase.removeCoupon', context: context);

  @override
  Future<void> removeCoupon({required String code}) {
    return _$removeCouponAsyncAction.run(() => super.removeCoupon(code: code));
  }

  late final _$removeCartAsyncAction =
      AsyncAction('CartStoreBase.removeCart', context: context);

  @override
  Future<void> removeCart({String? key}) {
    return _$removeCartAsyncAction.run(() => super.removeCart(key: key));
  }

  late final _$cleanCartAsyncAction =
      AsyncAction('CartStoreBase.cleanCart', context: context);

  @override
  Future<void> cleanCart() {
    return _$cleanCartAsyncAction.run(() => super.cleanCart());
  }

  late final _$addToCartAsyncAction =
      AsyncAction('CartStoreBase.addToCart', context: context);

  @override
  Future<void> addToCart(Map<String, dynamic> data) {
    return _$addToCartAsyncAction.run(() => super.addToCart(data));
  }

  @override
  String toString() {
    return '''
canLoadMore: ${canLoadMore},
loading: ${loading},
loadingShipping: ${loadingShipping},
loadingAddCart: ${loadingAddCart},
cartData: ${cartData},
count: ${count},
cartKey: ${cartKey},
isMergeCart: ${isMergeCart},
loadingRemoveCart: ${loadingRemoveCart}
    ''';
  }
}
