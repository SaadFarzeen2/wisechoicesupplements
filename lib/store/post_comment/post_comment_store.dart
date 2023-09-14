import 'package:cirilla/models/post/post_comment.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:cirilla/utils/query.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'post_comment_store.g.dart';

class PostCommentStore = PostCommentStoreBase with _$PostCommentStore;

abstract class PostCommentStoreBase with Store {
  final String? key;

  // Request helper instance
  final RequestHelper? _requestHelper;

  // store for handling errors
  // final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  PostCommentStoreBase(this._requestHelper,
      {this.key, int? perPage, String? lang, int? post, int? parent, String? order}) {
    if (perPage != null) _perPage = perPage;
    if (lang != null) _lang = lang;
    if (post != null) _post = post;
    if (parent != null) _parent = parent;
    if (order != null) _order = order;
    _orderBy = 'date';
    _reaction();
  }

  // store variables:-----------------------------------------------------------
  static ObservableFuture<List<PostComment>> emptyPostCommentResponse = ObservableFuture.value([]);

  @observable
  ObservableFuture<List<PostComment>?> fetchPostCommentsFuture = emptyPostCommentResponse;

  @observable
  ObservableList<PostComment> _postComments = ObservableList<PostComment>.of([]);

  @observable
  bool success = false;

  @observable
  int? _post;

  @observable
  int _parent = 0;

  @observable
  int _nextPage = 1;

  @observable
  int _perPage = 10;

  @observable
  String _lang = '';

  @observable
  String _order = 'asc';

  @observable
  String _orderBy = 'date';

  @observable
  bool _canLoadMore = true;

  // computed:-------------------------------------------------------------------
  @computed
  bool get loading => fetchPostCommentsFuture.status == FutureStatus.pending;

  @computed
  ObservableList<PostComment> get postComments => _postComments;

  @computed
  bool get canLoadMore => _canLoadMore;

  @computed
  int get perPage => _perPage;

  @computed
  String get lang => _lang;

  // actions:-------------------------------------------------------------------
  @action
  Future<void> getPostComments() async {
    Map<String, dynamic> qs = {
      "post": _post,
      "parent": _parent,
      "per_page": _perPage,
      "page": _nextPage,
      "lang": _lang,
      "order": "asc",
      "orderby": _orderBy,
    };
    final future = _requestHelper!.getPostComments(queryParameters: preQueryParameters(qs));
    fetchPostCommentsFuture = ObservableFuture(future);
    return future.then((data) {
      // Replace state in the first time or refresh
      if (_nextPage <= 1) {
        _postComments = ObservableList<PostComment>.of(data!);
      } else {
        // Add posts when load more page
        _postComments.addAll(ObservableList<PostComment>.of(data!));
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

  /// Write a comment
  Future<PostComment> writeComment({
    String? content,
    int? parent,
    String? captcha,
    String? phrase,
  }) async {
    Map<String, dynamic> data = {
      'content': content,
      'post': _post,
      'parent': parent ?? _parent,
      'captcha': captcha,
      'phrase': phrase,
    };

    try {
      PostComment comment = await _requestHelper!.writeComments(queryParameters: data);
      return comment;
    } on DioError {
      rethrow;
    }
  }

  @action
  Future<void> refresh() {
    _canLoadMore = true;
    _nextPage = 1;
    return getPostComments();
  }

  @action
  void onChange({int? parent}) {
    if (parent != null) _parent = parent;
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
