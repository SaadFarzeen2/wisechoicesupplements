// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$WishListStore on WishListStoreBase, Store {
  Computed<ObservableList<String>>? _$dataComputed;

  @override
  ObservableList<String> get data =>
      (_$dataComputed ??= Computed<ObservableList<String>>(() => super.data, name: '_WishListStore.data')).value;
  Computed<int>? _$countComputed;

  @override
  int get count => (_$countComputed ??= Computed<int>(() => super.count, name: '_WishListStore.count')).value;

  final _$_dataAtom = Atom(name: '_WishListStore._data');

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

  final _$_WishListStoreActionController = ActionController(name: '_WishListStore');

  @override
  void addWishList(String value, {int? position}) {
    final $actionInfo = _$_WishListStoreActionController.startAction(name: '_WishListStore.addWishList');
    try {
      return super.addWishList(value, position: position);
    } finally {
      _$_WishListStoreActionController.endAction($actionInfo);
    }
  }

  @override
  void updateWishList(List<String> newWishlist) {
    final $actionInfo = _$_WishListStoreActionController.startAction(name: '_WishListStore.updateWishList');
    try {
      return super.updateWishList(newWishlist);
    } finally {
      _$_WishListStoreActionController.endAction($actionInfo);
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
