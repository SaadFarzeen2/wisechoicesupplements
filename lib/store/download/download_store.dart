import 'package:cirilla/models/models.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:cirilla/utils/query.dart';
import 'package:mobx/mobx.dart';

part 'download_store.g.dart';

class DownloadStore = DownloadStoreBase with _$DownloadStore;

abstract class DownloadStoreBase with Store {
  final String? key;

  // Request helper instance
  final RequestHelper _requestHelper;

  // store for handling errors
  // final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  DownloadStoreBase(this._requestHelper, {int? userId, int? perPage, String? lang, this.key}) {
    if (perPage != null) _perPage = perPage;
    if (lang != null) _lang = lang;
    if (userId != null) _userId = userId;
    _reaction();
  }

  // store variables:-----------------------------------------------------------
  static ObservableFuture<List<Download>> emptyDownloadResponse = ObservableFuture.value([]);

  @observable
  ObservableFuture<List<Download>?> fetchDownloadsFuture = emptyDownloadResponse;

  @observable
  ObservableList<Download> _downloads = ObservableList<Download>.of([]);

  @observable
  bool success = false;

  @observable
  int _nextPage = 1;

  @observable
  int _perPage = 10;

  @observable
  String _lang = '';

  @observable
  bool _canLoadMore = true;

  @observable
  int _userId = 0;

  // computed:-------------------------------------------------------------------
  @computed
  bool get loading => fetchDownloadsFuture.status == FutureStatus.pending;

  @computed
  ObservableList<Download> get downloads => _downloads;

  @computed
  bool get canLoadMore => _canLoadMore;

  @computed
  int get perPage => _perPage;

  @computed
  String get lang => _lang;

  // actions:-------------------------------------------------------------------
  @action
  Future<void> getDownloads() async {
    Map<String, dynamic> qs = {
      "per_page": _perPage,
      'page': _nextPage,
      'lang': _lang,
    };
    final future = _requestHelper.getDownloads(userId: _userId, queryParameters: preQueryParameters(qs));
    fetchDownloadsFuture = ObservableFuture(future);
    return future.then((data) {
      // Replace state in the first time or refresh
      _downloads = ObservableList<Download>.of(data!);
    }).catchError((error) {
      avoidPrint(error);
      // errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action
  Future<void> refresh() {
    _canLoadMore = true;
    _nextPage = 1;
    _downloads.clear();
    return getDownloads();
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
