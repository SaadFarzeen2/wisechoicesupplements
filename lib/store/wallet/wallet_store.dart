import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:mobx/mobx.dart';

part 'wallet_store.g.dart';

class WalletStore = WalletStoreBase with _$WalletStore;

abstract class WalletStoreBase with Store {
  late AuthStore _auth;

  // Request helper instance
  late RequestHelper _requestHelper;

  final String? key;

  // store for handling errors
  // final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  WalletStoreBase(RequestHelper requestHelper, AuthStore auth, {this.key}) {
    _requestHelper = requestHelper;
    _auth = auth;
    _reaction();
  }

  // store variables:-----------------------------------------------------------

  @observable
  double _amountBalance = 0;

  // computed:-------------------------------------------------------------------

  @computed
  double get amountBalance => _amountBalance;

  // actions:-------------------------------------------------------------------

  @action
  Future<void> getAmountBalance() async {
    try {
      if (_auth.isLogin) {
        double amount = await _requestHelper.getAmountBalance(userId: _auth.user?.id ?? '');
        _amountBalance = amount;
      }
    } catch (e) {
      _amountBalance = 0;
    }
  }

  // disposers:-----------------------------------------------------------------
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
