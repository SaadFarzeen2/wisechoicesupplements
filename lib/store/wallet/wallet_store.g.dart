// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$WalletStore on WalletStoreBase, Store {
  Computed<double>? _$amountBalanceComputed;

  @override
  double get amountBalance =>
      (_$amountBalanceComputed ??= Computed<double>(() => super.amountBalance, name: '_WalletStore.amountBalance'))
          .value;

  final _$_amountBalanceAtom = Atom(name: '_WalletStore._amountBalance');

  @override
  double get _amountBalance {
    _$_amountBalanceAtom.reportRead();
    return super._amountBalance;
  }

  @override
  set _amountBalance(double value) {
    _$_amountBalanceAtom.reportWrite(value, super._amountBalance, () {
      super._amountBalance = value;
    });
  }

  final _$getAmountBalanceAsyncAction = AsyncAction('_WalletStore.getAmountBalance');

  @override
  Future<void> getAmountBalance() {
    return _$getAmountBalanceAsyncAction.run(() => super.getAmountBalance());
  }

  @override
  String toString() {
    return '''
amountBalance: ${amountBalance}
    ''';
  }
}
