// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OrderStore on OrderStoreBase, Store {
  Computed<bool>? _$canLoadMoreComputed;

  @override
  bool get canLoadMore =>
      (_$canLoadMoreComputed ??= Computed<bool>(() => super.canLoadMore,
              name: 'OrderStoreBase.canLoadMore'))
          .value;
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??=
          Computed<bool>(() => super.loading, name: 'OrderStoreBase.loading'))
      .value;
  Computed<ObservableList<OrderData>>? _$ordersComputed;

  @override
  ObservableList<OrderData> get orders => (_$ordersComputed ??=
          Computed<ObservableList<OrderData>>(() => super.orders,
              name: 'OrderStoreBase.orders'))
      .value;
  Computed<ObservableList<dynamic>>? _$orderCancelComputed;

  @override
  ObservableList<dynamic> get orderCancel => (_$orderCancelComputed ??=
          Computed<ObservableList<dynamic>>(() => super.orderCancel,
              name: 'OrderStoreBase.orderCancel'))
      .value;
  Computed<bool>? _$loadingCancelComputed;

  @override
  bool get loadingCancel =>
      (_$loadingCancelComputed ??= Computed<bool>(() => super.loadingCancel,
              name: 'OrderStoreBase.loadingCancel'))
          .value;

  late final _$fetchOrdersFutureAtom =
      Atom(name: 'OrderStoreBase.fetchOrdersFuture', context: context);

  @override
  ObservableFuture<List<OrderData>?> get fetchOrdersFuture {
    _$fetchOrdersFutureAtom.reportRead();
    return super.fetchOrdersFuture;
  }

  @override
  set fetchOrdersFuture(ObservableFuture<List<OrderData>?> value) {
    _$fetchOrdersFutureAtom.reportWrite(value, super.fetchOrdersFuture, () {
      super.fetchOrdersFuture = value;
    });
  }

  late final _$_ordersAtom =
      Atom(name: 'OrderStoreBase._orders', context: context);

  @override
  ObservableList<OrderData> get _orders {
    _$_ordersAtom.reportRead();
    return super._orders;
  }

  @override
  set _orders(ObservableList<OrderData> value) {
    _$_ordersAtom.reportWrite(value, super._orders, () {
      super._orders = value;
    });
  }

  late final _$_orderCancelAtom =
      Atom(name: 'OrderStoreBase._orderCancel', context: context);

  @override
  ObservableList<dynamic> get _orderCancel {
    _$_orderCancelAtom.reportRead();
    return super._orderCancel;
  }

  @override
  set _orderCancel(ObservableList<dynamic> value) {
    _$_orderCancelAtom.reportWrite(value, super._orderCancel, () {
      super._orderCancel = value;
    });
  }

  late final _$_nextPageAtom =
      Atom(name: 'OrderStoreBase._nextPage', context: context);

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

  late final _$perPageAtom =
      Atom(name: 'OrderStoreBase.perPage', context: context);

  @override
  int get perPage {
    _$perPageAtom.reportRead();
    return super.perPage;
  }

  @override
  set perPage(int value) {
    _$perPageAtom.reportWrite(value, super.perPage, () {
      super.perPage = value;
    });
  }

  late final _$_customerAtom =
      Atom(name: 'OrderStoreBase._customer', context: context);

  @override
  int? get _customer {
    _$_customerAtom.reportRead();
    return super._customer;
  }

  @override
  set _customer(int? value) {
    _$_customerAtom.reportWrite(value, super._customer, () {
      super._customer = value;
    });
  }

  late final _$_canLoadMoreAtom =
      Atom(name: 'OrderStoreBase._canLoadMore', context: context);

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

  late final _$_loadingCancelAtom =
      Atom(name: 'OrderStoreBase._loadingCancel', context: context);

  @override
  bool get _loadingCancel {
    _$_loadingCancelAtom.reportRead();
    return super._loadingCancel;
  }

  @override
  set _loadingCancel(bool value) {
    _$_loadingCancelAtom.reportWrite(value, super._loadingCancel, () {
      super._loadingCancel = value;
    });
  }

  late final _$searchAtom =
      Atom(name: 'OrderStoreBase.search', context: context);

  @override
  String get search {
    _$searchAtom.reportRead();
    return super.search;
  }

  @override
  set search(String value) {
    _$searchAtom.reportWrite(value, super.search, () {
      super.search = value;
    });
  }

  late final _$getOrdersAsyncAction =
      AsyncAction('OrderStoreBase.getOrders', context: context);

  @override
  Future<void> getOrders() {
    return _$getOrdersAsyncAction.run(() => super.getOrders());
  }

  late final _$getCancelOrderAsyncAction =
      AsyncAction('OrderStoreBase.getCancelOrder', context: context);

  @override
  Future<void> getCancelOrder() {
    return _$getCancelOrderAsyncAction.run(() => super.getCancelOrder());
  }

  late final _$postCancelOrderAsyncAction =
      AsyncAction('OrderStoreBase.postCancelOrder', context: context);

  @override
  Future<void> postCancelOrder({Map<String, dynamic>? dataCancel}) {
    return _$postCancelOrderAsyncAction
        .run(() => super.postCancelOrder(dataCancel: dataCancel));
  }

  late final _$OrderStoreBaseActionController =
      ActionController(name: 'OrderStoreBase', context: context);

  @override
  Future<void> refresh() {
    final _$actionInfo = _$OrderStoreBaseActionController.startAction(
        name: 'OrderStoreBase.refresh');
    try {
      return super.refresh();
    } finally {
      _$OrderStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchOrdersFuture: ${fetchOrdersFuture},
perPage: ${perPage},
search: ${search},
canLoadMore: ${canLoadMore},
loading: ${loading},
orders: ${orders},
orderCancel: ${orderCancel},
loadingCancel: ${loadingCancel}
    ''';
  }
}
