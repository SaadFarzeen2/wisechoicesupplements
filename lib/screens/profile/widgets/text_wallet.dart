import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class TextWallet extends StatefulWidget {
  final TextStyle? style;

  const TextWallet({Key? key, this.style}) : super(key: key);

  @override
  State<TextWallet> createState() => _TextWalletState();
}

class _TextWalletState extends State<TextWallet> {
  late AppStore _appStore;
  late AuthStore _authStore;
  late WalletStore _walletStore;

  @override
  void didChangeDependencies() {
    _appStore = Provider.of<AppStore>(context);
    _authStore = Provider.of<AuthStore>(context);
    SettingStore settingStore = Provider.of<SettingStore>(context);

    String? key = StringGenerate.getWalletKeyStore(
      'wallet_balance',
      userId: _authStore.user?.id,
    );

    // Add store to list store
    if (_appStore.getStoreByKey(key) == null) {
      WalletStore store = WalletStore(settingStore.requestHelper, _authStore, key: key)..getAmountBalance();
      _appStore.addStore(store);
      _walletStore = store;
    } else {
      _walletStore = _appStore.getStoreByKey(key);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Text(
          formatCurrency(context, price: '${_walletStore.amountBalance}'),
          style: widget.style,
        );
      },
    );
  }
}
