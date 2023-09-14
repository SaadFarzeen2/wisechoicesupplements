import 'package:cirilla/models/message/message.dart';
import 'package:cirilla/service/service.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mobx/mobx.dart';

part 'message_store.g.dart';

class MessageStore = MessageStoreBase with _$MessageStore;

abstract class MessageStoreBase with Store {
  final RequestHelper _requestHelper;
  final AuthStore _authStore;

  final String? key;

  @observable
  bool _loadingData = false;

  @observable
  int _nextPage = 1;

  @observable
  int perPage = 10;

  @observable
  int _countUnRead = 0;

  static ObservableFuture<List<MessageData>> emptyMessResponse = ObservableFuture.value([]);
  @observable
  ObservableFuture<List<MessageData>?> fetchMessFuture = emptyMessResponse;

  @observable
  ObservableList<MessageData> _messages = ObservableList<MessageData>.of([]);

  @observable
  bool _canLoadMore = true;

  @computed
  bool get canLoadMore => _canLoadMore;

  @computed
  bool get loadingData => _loadingData;

  @computed
  ObservableList<MessageData> get messages => _messages;

  @computed
  bool get loading => fetchMessFuture.status == FutureStatus.pending;

  @computed
  int get count => _messages.length;

  @computed
  int get countUnRead => _countUnRead;

  // Action: -----------------------------------------------------------------------------------------------------------

  @action
  Future<void> getListNotify() async {
    final qs = {
      "page": _nextPage,
      "per_page": perPage,
    };

    qs.removeWhere((key, value) => value == 0 || value == 0);

    final future = _requestHelper.getListNotify(
      userId: _authStore.user?.id,
      queryParameters: qs,
    );

    fetchMessFuture = ObservableFuture(future);

    return future.then((messages) {
      // Replace state in the first time or refresh
      _loadingData = true;
      if (_nextPage <= 1) {
        _messages = ObservableList<MessageData>.of(messages!);
      } else {
        // Add posts when load more page
        _messages.addAll(ObservableList<MessageData>.of(messages!));
      }
      // Check if can load more item

      if (messages.length >= perPage) {
        _nextPage++;
      } else {
        _canLoadMore = false;
      }
      _loadingData = false;
    }).catchError((error) {
      throw error;
    });
  }

  @action
  Future<void> removeMessageById({String? id}) async {
    try {
      _loadingData = true;
      if (id != null) {
        _messages.removeWhere((MessageData e) {
          if (e.id == id) {
            _countUnRead = _countUnRead == 0 ? 0 : _countUnRead - 1;
            return true;
          }
          return false;
        });
        await _requestHelper.removeMessageById(id: id, userId: _authStore.user?.id);
      }
      _loadingData = false;
      await refresh();
    } on DioError {
      _loadingData = false;
      rethrow;
    }
  }

  @action
  Future<void> removeAllNotify() async {
    try {
      await _requestHelper.removeAllNotify();
      _messages = ObservableList<MessageData>.of([]);
      _countUnRead = 0;
    } on DioError {
      rethrow;
    }
  }

  @action
  Future<void> getUnRead() async {
    try {
      Map<String, dynamic>? data = await _requestHelper.getUnRead();
      _countUnRead = data!['count'];
    } on DioError {
      rethrow;
    }
  }

  @action
  Future<void> putRead(MessageData message) async {
    try {
      await _requestHelper.putRead(data: {'id': message.id});
      if (_countUnRead > 0 && message.seen == 0) {
        _countUnRead = _countUnRead - 1;
      }

      MessageData messageRead = message;
      message.read();

      List<MessageData> messages = _messages.map((MessageData e) => e.id == message.id ? messageRead : e).toList();

      _messages = ObservableList<MessageData>.of(messages);
    } on DioError {
      rethrow;
    }
  }

  @action
  Future<void> refresh() async {
    _canLoadMore = true;
    _nextPage = 1;
    await getListNotify();
  }

  // Constructor: ------------------------------------------------------------------------------------------------------
  MessageStoreBase(this._requestHelper, this._authStore, {this.key}) {
    _reaction();
    _init();
  }

  Future _init() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (_authStore.isLogin) {
        getUnRead();
        refresh();
      }
    });
  }

  Future<void> restore() async {}

  // Disposers:---------------------------------------------------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _reaction() {
    _disposers = [
      when((_) => _authStore.isLogin, () => getUnRead()),
    ];
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
