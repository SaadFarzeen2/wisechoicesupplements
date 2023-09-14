import 'package:cirilla/models/models.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:mobx/mobx.dart';

part 'transaction_store.g.dart';

class TransactionStore = TransactionStoreStoreBase with _$TransactionStore;

abstract class TransactionStoreStoreBase with Store {
  final String? key;
  // Request helper instance
  final RequestHelper _requestHelper;

  // store for handling errors
  // final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  TransactionStoreStoreBase(
    this._requestHelper, {
    this.key,
    int? perPage,
    String? userId,
  }) {
    if (perPage != null) _perPage = perPage;
    if (userId != null) _userId = userId;
    _reaction();
  }

  // store variables:-----------------------------------------------------------
  static ObservableFuture<List<TransactionWallet>> emptyTransactionWalletResponse = ObservableFuture.value([]);

  @observable
  String? _userId;

  @observable
  ObservableFuture<List<TransactionWallet>?> fetchTransactionWalletsFuture = emptyTransactionWalletResponse;

  @observable
  ObservableList<TransactionWallet> _transactionWallets = ObservableList<TransactionWallet>.of([]);

  @observable
  bool success = false;

  @observable
  int _nextPage = 1;

  @observable
  int _perPage = 1;

  @observable
  bool _canLoadMore = true;

  // computed:-------------------------------------------------------------------
  @computed
  bool get loading => fetchTransactionWalletsFuture.status == FutureStatus.pending;

  @computed
  ObservableList<TransactionWallet> get transactionWallets => _transactionWallets;

  @computed
  bool get canLoadMore => _canLoadMore;

  @computed
  int get perPage => _perPage;

  // actions:-------------------------------------------------------------------
  @action
  Future<void> getTransactionWallets() async {
    if (_userId?.isNotEmpty == true) {
      final future = _requestHelper.getTransactionWallet(userId: _userId ?? '');
      fetchTransactionWalletsFuture = ObservableFuture(future);
      return future.then((data) {
        // Replace state in the first time or refresh
        if (_nextPage <= 1) {
          _transactionWallets = ObservableList<TransactionWallet>.of(data!);
        } else {
          // Add posts when load more page
          _transactionWallets.addAll(ObservableList<TransactionWallet>.of(data!));
        }

        // Check if can load more item
        if (data.length >= _perPage) {
          _nextPage++;
        } else {
          _canLoadMore = false;
        }
      }).catchError((error) {
        avoidPrint(error);
        // errorStore.errorMessage = DioErrorUtil.handleError(error);
      });
    }
  }

  @action
  Future<void> refresh() {
    _canLoadMore = true;
    _nextPage = 1;
    return getTransactionWallets();
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
