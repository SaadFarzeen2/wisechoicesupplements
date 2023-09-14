import 'package:cirilla/service/helpers/persist_helper.dart';
import 'package:mobx/mobx.dart';

part 'product_recently_store.g.dart';

class ProductRecentlyStore = ProductRecentlyStoreBase with _$ProductRecentlyStore;

abstract class ProductRecentlyStoreBase with Store {
  final PersistHelper _persistHelper;

  @observable
  ObservableList<String> _data = ObservableList<String>.of([]);

  @computed
  ObservableList<String> get data => _data;

  @computed
  int get count => _data.length;

  // Action: -----------------------------------------------------------------------------------------------------------
  @action
  Future<bool> addProductRecently(String value) async {
    int visit = _data.indexWhere((element) => element == value);
    if (visit < 0) {
      _data.add(value);
    }
    return await _persistHelper.saveProductRecently(_data);
  }

  @action
  bool exist(String value) {
    if (value == '') return false;
    return _data.contains(value);
  }

  // Constructor: ------------------------------------------------------------------------------------------------------
  ProductRecentlyStoreBase(this._persistHelper) {
    init();
  }

  Future init() async {
    restore();
  }

  void restore() async {
    List<String>? data = await _persistHelper.getProductRecently();
    if (data != null && data.isNotEmpty) {
      _data = ObservableList<String>.of(data);
    }
  }
}
