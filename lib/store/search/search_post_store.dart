import 'package:cirilla/service/helpers/persist_helper.dart';
import 'package:mobx/mobx.dart';

part 'search_post_store.g.dart';

class SearchPostStore = SearchPostStoreBase with _$SearchPostStore;

abstract class SearchPostStoreBase with Store {
  final PersistHelper _persistHelper;

  @observable
  ObservableList<String> _data = ObservableList<String>.of([]);

  @computed
  ObservableList<String> get data => _data;

  @computed
  int get count => _data.length;

  // Action: -----------------------------------------------------------------------------------------------------------
  @action
  Future<void> addSearch(String value) async {
    if (_data.isEmpty || _data.contains(value) != true) {
       _data.add(value);
    }
  }

  @action
  Future<void> removeSearch(String value) async {
    int index = _data.indexOf(value);
    _data.removeAt(index);
  }

  @action
  Future<void> removeAllSearch() async {
    _data.clear();
  }

  // Constructor: ------------------------------------------------------------------------------------------------------
  SearchPostStoreBase(this._persistHelper) {
    init();
  }

  Future init() async {
    restore();
    _reaction();
  }

  void restore() async {
    List<String>? data = await _persistHelper.getSearchPost();
    if (data != null && data.isNotEmpty) {
      _data = ObservableList<String>.of(data);
    }
  }

  void _write() async {
    await _persistHelper.saveSearchPost(_data);
  }

  // disposers:---------------------------------------------------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _reaction() {
    _disposers = [
      reaction((_) => _data.length, (_) => _write()),
    ];
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
