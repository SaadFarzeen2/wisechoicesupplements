// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digits_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DigitsStore on DigitsStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading, name: '_DigitsStore.loading')).value;

  final _$_loadingAtom = Atom(name: '_DigitsStore._loading');

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

  final _$loginAsyncAction = AsyncAction('_DigitsStore.login');

  @override
  Future<bool> login(Map<String, dynamic> dataParameters) {
    return _$loginAsyncAction.run(() => super.login(dataParameters));
  }

  final _$registerAsyncAction = AsyncAction('_DigitsStore.register');

  @override
  Future<bool> register(Map<String, dynamic> dataParameters) {
    return _$registerAsyncAction.run(() => super.register(dataParameters));
  }

  @override
  String toString() {
    return '''
loading: ${loading}
    ''';
  }
}
