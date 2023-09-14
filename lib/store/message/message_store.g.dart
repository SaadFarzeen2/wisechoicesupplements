// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MessageStore on MessageStoreBase, Store {
  Computed<bool>? _$canLoadMoreComputed;

  @override
  bool get canLoadMore =>
      (_$canLoadMoreComputed ??= Computed<bool>(() => super.canLoadMore, name: '_MessageStore.canLoadMore')).value;
  Computed<bool>? _$loadingDataComputed;

  @override
  bool get loadingData =>
      (_$loadingDataComputed ??= Computed<bool>(() => super.loadingData, name: '_MessageStore.loadingData')).value;
  Computed<ObservableList<MessageData>>? _$messagesComputed;

  @override
  ObservableList<MessageData> get messages => (_$messagesComputed ??=
          Computed<ObservableList<MessageData>>(() => super.messages, name: '_MessageStore.messages'))
      .value;
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading, name: '_MessageStore.loading')).value;
  Computed<int>? _$countComputed;

  @override
  int get count => (_$countComputed ??= Computed<int>(() => super.count, name: '_MessageStore.count')).value;
  Computed<int>? _$countUnReadComputed;

  @override
  int get countUnRead =>
      (_$countUnReadComputed ??= Computed<int>(() => super.countUnRead, name: '_MessageStore.countUnRead')).value;

  final _$_loadingDataAtom = Atom(name: '_MessageStore._loadingData');

  @override
  bool get _loadingData {
    _$_loadingDataAtom.reportRead();
    return super._loadingData;
  }

  @override
  set _loadingData(bool value) {
    _$_loadingDataAtom.reportWrite(value, super._loadingData, () {
      super._loadingData = value;
    });
  }

  final _$_nextPageAtom = Atom(name: '_MessageStore._nextPage');

  @override
  int get _nextPage {
    _$_nextPageAtom.reportRead();
    return super._nextPage;
  }

  @override
  set _nextPage(int value) {
    _$_nextPageAtom.reportWrite(value, super._nextPage, () {
      super._nextPage = value;
    });
  }

  final _$perPageAtom = Atom(name: '_MessageStore.perPage');

  @override
  int get perPage {
    _$perPageAtom.reportRead();
    return super.perPage;
  }

  @override
  set perPage(int value) {
    _$perPageAtom.reportWrite(value, super.perPage, () {
      super.perPage = value;
    });
  }

  final _$_countUnReadAtom = Atom(name: '_MessageStore._countUnRead');

  @override
  int get _countUnRead {
    _$_countUnReadAtom.reportRead();
    return super._countUnRead;
  }

  @override
  set _countUnRead(int value) {
    _$_countUnReadAtom.reportWrite(value, super._countUnRead, () {
      super._countUnRead = value;
    });
  }

  final _$fetchMessFutureAtom = Atom(name: '_MessageStore.fetchMessFuture');

  @override
  ObservableFuture<List<MessageData>?> get fetchMessFuture {
    _$fetchMessFutureAtom.reportRead();
    return super.fetchMessFuture;
  }

  @override
  set fetchMessFuture(ObservableFuture<List<MessageData>?> value) {
    _$fetchMessFutureAtom.reportWrite(value, super.fetchMessFuture, () {
      super.fetchMessFuture = value;
    });
  }

  final _$_messagesAtom = Atom(name: '_MessageStore._messages');

  @override
  ObservableList<MessageData> get _messages {
    _$_messagesAtom.reportRead();
    return super._messages;
  }

  @override
  set _messages(ObservableList<MessageData> value) {
    _$_messagesAtom.reportWrite(value, super._messages, () {
      super._messages = value;
    });
  }

  final _$_canLoadMoreAtom = Atom(name: '_MessageStore._canLoadMore');

  @override
  bool get _canLoadMore {
    _$_canLoadMoreAtom.reportRead();
    return super._canLoadMore;
  }

  @override
  set _canLoadMore(bool value) {
    _$_canLoadMoreAtom.reportWrite(value, super._canLoadMore, () {
      super._canLoadMore = value;
    });
  }

  final _$getListNotifyAsyncAction = AsyncAction('_MessageStore.getListNotify');

  @override
  Future<void> getListNotify() {
    return _$getListNotifyAsyncAction.run(() => super.getListNotify());
  }

  final _$removeMessageByIdAsyncAction = AsyncAction('_MessageStore.removeMessageById');

  @override
  Future<void> removeMessageById({String? id}) {
    return _$removeMessageByIdAsyncAction.run(() => super.removeMessageById(id: id));
  }

  final _$removeAllNotifyAsyncAction = AsyncAction('_MessageStore.removeAllNotify');

  @override
  Future<void> removeAllNotify() {
    return _$removeAllNotifyAsyncAction.run(() => super.removeAllNotify());
  }

  final _$getUnReadAsyncAction = AsyncAction('_MessageStore.getUnRead');

  @override
  Future<void> getUnRead() {
    return _$getUnReadAsyncAction.run(() => super.getUnRead());
  }

  final _$putReadAsyncAction = AsyncAction('_MessageStore.putRead');

  @override
  Future<void> putRead(MessageData message) {
    return _$putReadAsyncAction.run(() => super.putRead(message));
  }

  final _$refreshAsyncAction = AsyncAction('_MessageStore.refresh');

  @override
  Future<void> refresh() {
    return _$refreshAsyncAction.run(() => super.refresh());
  }

  @override
  String toString() {
    return '''
perPage: ${perPage},
fetchMessFuture: ${fetchMessFuture},
canLoadMore: ${canLoadMore},
loadingData: ${loadingData},
messages: ${messages},
loading: ${loading},
count: ${count},
countUnRead: ${countUnRead}
    ''';
  }
}
