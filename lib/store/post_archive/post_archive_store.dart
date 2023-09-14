import 'package:cirilla/models/post/post_archive.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:mobx/mobx.dart';

part 'post_archive_store.g.dart';

class PostArchiveStore = PostArchiveStoreBase with _$PostArchiveStore;

abstract class PostArchiveStoreBase with Store {
  final String? key;

  // Request helper instance
  final RequestHelper _requestHelper;

  // store for handling errors
  // final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  PostArchiveStoreBase(this._requestHelper, {this.key}) {
    _reaction();
  }

  // store variables:-----------------------------------------------------------
  static ObservableFuture<List<PostArchive>> emptyPostArchiveResponse = ObservableFuture.value([]);

  @observable
  ObservableFuture<List<PostArchive>?> fetchPostArchivesFuture = emptyPostArchiveResponse;

  @observable
  ObservableList<PostArchive> _postArchives = ObservableList<PostArchive>.of([]);

  @observable
  bool success = false;

  // computed:-------------------------------------------------------------------
  @computed
  bool get loading => fetchPostArchivesFuture.status == FutureStatus.pending;

  @computed
  ObservableList<PostArchive> get postArchives => _postArchives;

  // actions:-------------------------------------------------------------------
  @action
  Future<void> getPostArchives() async {
    final future = _requestHelper.getPostArchives();
    fetchPostArchivesFuture = ObservableFuture(future);
    return future.then((data) {
      // Replace state in the first time or refresh
      _postArchives = ObservableList<PostArchive>.of(data!);
    }).catchError((error) {
      avoidPrint(error);
      // errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
  }

  @action
  Future<void> refresh() {
    return getPostArchives();
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
