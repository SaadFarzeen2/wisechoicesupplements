// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PaymentStore on PaymentStoreBase, Store {
  Computed<String>? _$methodComputed;

  @override
  String get method => (_$methodComputed ??= Computed<String>(() => super.method, name: '_PaymentStore.method')).value;

  final _$loadingAtom = Atom(name: '_PaymentStore.loading');

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

  final _$activeAtom = Atom(name: '_PaymentStore.active');

  @override
  int get active {
    _$activeAtom.reportRead();
    return super.active;
  }

  @override
  set active(int value) {
    _$activeAtom.reportWrite(value, super.active, () {
      super.active = value;
    });
  }

  final _$gatewaysAtom = Atom(name: '_PaymentStore.gateways');

  @override
  ObservableList<Gateway> get gateways {
    _$gatewaysAtom.reportRead();
    return super.gateways;
  }

  @override
  set gateways(ObservableList<Gateway> value) {
    _$gatewaysAtom.reportWrite(value, super.gateways, () {
      super.gateways = value;
    });
  }

  final _$getGatewaysAsyncAction = AsyncAction('_PaymentStore.getGateways');

  @override
  Future<void> getGateways() {
    return _$getGatewaysAsyncAction.run(() => super.getGateways());
  }

  final _$_PaymentStoreActionController = ActionController(name: '_PaymentStore');

  @override
  void select(int index) {
    final $actionInfo = _$_PaymentStoreActionController.startAction(name: '_PaymentStore.select');
    try {
      return super.select(index);
    } finally {
      _$_PaymentStoreActionController.endAction($actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
active: ${active},
gateways: ${gateways},
method: ${method}
    ''';
  }
}
