// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_recently_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProductRecentlyStore on ProductRecentlyStoreBase, Store {
  Computed<ObservableList<String>>? _$dataComputed;

  @override
  ObservableList<String> get data =>
      (_$dataComputed ??= Computed<ObservableList<String>>(() => super.data, name: '_ProductRecentlyStore.data')).value;
  Computed<int>? _$countComputed;

  @override
  int get count => (_$countComputed ??= Computed<int>(() => super.count, name: '_ProductRecentlyStore.count')).value;

  final _$_dataAtom = Atom(name: '_ProductRecentlyStore._data');

  @override
  ObservableList<String> get _data {
    _$_dataAtom.reportRead();
    return super._data;
  }

  @override
  set _data(ObservableList<String> value) {
    _$_dataAtom.reportWrite(value, super._data, () {
      super._data = value;
    });
  }

  final _$addProductRecentlyAsyncAction = AsyncAction('_ProductRecentlyStore.addProductRecently');

  @override
  Future<bool> addProductRecently(String value) {
    return _$addProductRecentlyAsyncAction.run(() => super.addProductRecently(value));
  }

  final _$_ProductRecentlyStoreActionController = ActionController(name: '_ProductRecentlyStore');

  @override
  bool exist(String value) {
    final $actionInfo = _$_ProductRecentlyStoreActionController.startAction(name: '_ProductRecentlyStore.exist');
    try {
      return super.exist(value);
    } finally {
      _$_ProductRecentlyStoreActionController.endAction($actionInfo);
    }
  }

  @override
  String toString() {
    return '''
data: ${data},
count: ${count}
    ''';
  }
}
