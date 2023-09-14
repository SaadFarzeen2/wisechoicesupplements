// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DownloadStore on DownloadStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading, name: '_DownloadStore.loading')).value;
  Computed<ObservableList<Download>>? _$downloadsComputed;

  @override
  ObservableList<Download> get downloads => (_$downloadsComputed ??=
          Computed<ObservableList<Download>>(() => super.downloads, name: '_DownloadStore.downloads'))
      .value;
  Computed<bool>? _$canLoadMoreComputed;

  @override
  bool get canLoadMore =>
      (_$canLoadMoreComputed ??= Computed<bool>(() => super.canLoadMore, name: '_DownloadStore.canLoadMore')).value;
  Computed<int>? _$perPageComputed;

  @override
  int get perPage => (_$perPageComputed ??= Computed<int>(() => super.perPage, name: '_DownloadStore.perPage')).value;
  Computed<String>? _$langComputed;

  @override
  String get lang => (_$langComputed ??= Computed<String>(() => super.lang, name: '_DownloadStore.lang')).value;

  final _$fetchDownloadsFutureAtom = Atom(name: '_DownloadStore.fetchDownloadsFuture');

  @override
  ObservableFuture<List<Download>?> get fetchDownloadsFuture {
    _$fetchDownloadsFutureAtom.reportRead();
    return super.fetchDownloadsFuture;
  }

  @override
  set fetchDownloadsFuture(ObservableFuture<List<Download>?> value) {
    _$fetchDownloadsFutureAtom.reportWrite(value, super.fetchDownloadsFuture, () {
      super.fetchDownloadsFuture = value;
    });
  }

  final _$_downloadsAtom = Atom(name: '_DownloadStore._downloads');

  @override
  ObservableList<Download> get _downloads {
    _$_downloadsAtom.reportRead();
    return super._downloads;
  }

  @override
  set _downloads(ObservableList<Download> value) {
    _$_downloadsAtom.reportWrite(value, super._downloads, () {
      super._downloads = value;
    });
  }

  final _$successAtom = Atom(name: '_DownloadStore.success');

  @override
  bool get success {
    _$successAtom.reportRead();
    return super.success;
  }

  @override
  set success(bool value) {
    _$successAtom.reportWrite(value, super.success, () {
      super.success = value;
    });
  }

  final _$_nextPageAtom = Atom(name: '_DownloadStore._nextPage');

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

  final _$_perPageAtom = Atom(name: '_DownloadStore._perPage');

  @override
  int get _perPage {
    _$_perPageAtom.reportRead();
    return super._perPage;
  }

  @override
  set _perPage(int value) {
    _$_perPageAtom.reportWrite(value, super._perPage, () {
      super._perPage = value;
    });
  }

  final _$_langAtom = Atom(name: '_DownloadStore._lang');

  @override
  String get _lang {
    _$_langAtom.reportRead();
    return super._lang;
  }

  @override
  set _lang(String value) {
    _$_langAtom.reportWrite(value, super._lang, () {
      super._lang = value;
    });
  }

  final _$_canLoadMoreAtom = Atom(name: '_DownloadStore._canLoadMore');

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

  final _$_userIdAtom = Atom(name: '_DownloadStore._userId');

  @override
  int get _userId {
    _$_userIdAtom.reportRead();
    return super._userId;
  }

  @override
  set _userId(int value) {
    _$_userIdAtom.reportWrite(value, super._userId, () {
      super._userId = value;
    });
  }

  final _$getDownloadsAsyncAction = AsyncAction('_DownloadStore.getDownloads');

  @override
  Future<void> getDownloads() {
    return _$getDownloadsAsyncAction.run(() => super.getDownloads());
  }

  final _$_DownloadStoreActionController = ActionController(name: '_DownloadStore');

  @override
  Future<void> refresh() {
    final $actionInfo = _$_DownloadStoreActionController.startAction(name: '_DownloadStore.refresh');
    try {
      return super.refresh();
    } finally {
      _$_DownloadStoreActionController.endAction($actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fetchDownloadsFuture: ${fetchDownloadsFuture},
success: ${success},
loading: ${loading},
downloads: ${downloads},
canLoadMore: ${canLoadMore},
perPage: ${perPage},
lang: ${lang}
    ''';
  }
}
