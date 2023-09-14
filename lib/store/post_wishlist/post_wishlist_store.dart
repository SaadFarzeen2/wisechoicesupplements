import 'package:cirilla/service/helpers/persist_helper.dart';
import 'package:mobx/mobx.dart';

part 'post_wishlist_store.g.dart';

class PostWishListStore = PostWishListStoreBase with _$PostWishListStore;

abstract class PostWishListStoreBase with Store {
  final PersistHelper _persistHelper;

  @observable
  ObservableList<String> _data = ObservableList<String>.of([]);

  @computed
  ObservableList<String> get data => _data;

  @computed
  int get count => _data.length;

  // Action: -----------------------------------------------------------------------------------------------------------
  @action
  Future<bool> addWishList(String value, {int? position}) async {
    int index = _data.indexOf(value);

    if (index == -1) {
      position != null ? data.insert(position, value) : _data.add(value);
    } else {
      _data.removeAt(index);
    }

    return await _persistHelper.savePostWishList(_data);
  }

  @action
  bool exist(String value) {
    if (value == '') return false;
    return _data.contains(value);
  }

  // Constructor: ------------------------------------------------------------------------------------------------------
  PostWishListStoreBase(this._persistHelper) {
    init();
  }

  Future init() async {
    restore();
  }

  void restore() async {
    List<String>? data = await _persistHelper.getPostWishList();
    if (data != null && data.isNotEmpty) {
      _data = ObservableList<String>.of(data);
    }
  }
}
