// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AddressDataStore on AddressDataStoreBase, Store {
  Computed<AddressData?>? _$addressComputed;

  @override
  AddressData? get address =>
      (_$addressComputed ??= Computed<AddressData?>(() => super.address,
              name: 'AddressDataStoreBase.address'))
          .value;
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: 'AddressDataStoreBase.loading'))
      .value;

  final _$_addressAtom = Atom(name: 'AddressDataStoreBase._address');

  @override
  AddressData? get _address {
    _$_addressAtom.reportRead();
    return super._address;
  }

  @override
  set _address(AddressData? value) {
    _$_addressAtom.reportWrite(value, super._address, () {
      super._address = value;
    });
  }

  final _$_loadingAtom = Atom(name: 'AddressDataStoreBase._loading');

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

  final _$getAddressDataAsyncAction =
      AsyncAction('AddressDataStoreBase.getAddressData');

  @override
  Future<void> getAddressData({Map<String, dynamic>? queryParameters}) {
    return _$getAddressDataAsyncAction
        .run(() => super.getAddressData(queryParameters: queryParameters));
  }

  @override
  String toString() {
    return '''
address: ${address},
loading: ${loading}
    ''';
  }
}
