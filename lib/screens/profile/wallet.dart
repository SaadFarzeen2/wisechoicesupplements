import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'widgets/text_wallet.dart';

class WalletScreen extends StatefulWidget {
  static const String routeName = '/profile/wallet';

  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> with AppBarMixin, LoadingMixin {
  late TransactionStore _transactionStore;
  final ScrollController _controller = ScrollController();

  @override
  void didChangeDependencies() {
    AuthStore authStore = Provider.of<AuthStore>(context);
    SettingStore settingStore = Provider.of<SettingStore>(context);
    _transactionStore = TransactionStore(
      settingStore.requestHelper,
      userId: authStore.user?.id,
    )..getTransactionWallets();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_controller.hasClients || _transactionStore.loading || !_transactionStore.canLoadMore) return;
    final thresholdReached = _controller.position.extentAfter < endReachedThreshold;

    if (thresholdReached) {
      _transactionStore.getTransactionWallets();
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Observer(
      builder: (_) {
        List<TransactionWallet> transactionWallets = _transactionStore.transactionWallets;
        bool loading = _transactionStore.loading;

        bool isShimmer = transactionWallets.isEmpty && loading;
        List<TransactionWallet> loadingProduct = List.generate(10, (index) => TransactionWallet()).toList();

        List<TransactionWallet> data = isShimmer ? loadingProduct : transactionWallets;
        return Scaffold(
          appBar: baseStyleAppBar(context, title: translate('wallet_txt')),
          body: CustomScrollView(
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: _transactionStore.refresh,
                builder: buildAppRefreshIndicator,
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      TextWallet(style: theme.textTheme.headlineMedium),
                      Text(translate('wallet_balance_subtitle'), style: theme.textTheme.bodySmall),
                      const SizedBox(height: 32),
                      Column(
                        children: List.generate(data.length, (index) {
                          double padBottom = index < data.length - 1 ? 16 : 0;
                          return Padding(
                            padding: EdgeInsets.only(bottom: padBottom),
                            child: CirillaTransactionWalletItem(item: data[index]),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              if (loading)
                SliverToBoxAdapter(
                  child: buildLoading(context, isLoading: _transactionStore.canLoadMore),
                ),
            ],
          ),
        );
      },
    );
  }
}
