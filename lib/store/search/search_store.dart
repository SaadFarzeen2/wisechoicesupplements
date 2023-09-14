import 'package:cirilla/service/helpers/persist_helper.dart';
import 'package:mobx/mobx.dart';

part 'search_store.g.dart';

class SearchStore = SearchStoreBase with _$SearchStore;

abstract class SearchStoreBase with Store {
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
  SearchStoreBase(this._persistHelper) {
    init();
    _reaction();
  }

  Future init() async {
    restore();
  }

  void restore() async {
    List<String>? data = await _persistHelper.getSearch();
    if (data != null && data.isNotEmpty) {
      _data = ObservableList<String>.of(data);
    }
  }

  void _write() async {
    await _persistHelper.saveSearch(_data);
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
