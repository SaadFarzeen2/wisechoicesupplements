import 'package:mobx/mobx.dart';

part 'app_store.g.dart';

class AppStore = AppStoreBase with _$AppStore;

abstract class AppStoreBase with Store {
  final ObservableList<dynamic> stores = ObservableList<dynamic>.of([]);

  @action
  void addStore(dynamic store) {
    int index = stores.indexWhere((s) => s.key == store.key);
    if (index == -1) {
      stores.add(store);
    }
  }

  @action
  void removeStore(int index) {
    stores.removeAt(index);
  }

  @action
  dynamic getStoreByIndex(int index) {
    return stores[index];
  }

  @action
  dynamic getStoreByKey(String? key) {
    return stores.firstWhere((element) => element != null && element.key == key, orElse: () => null);
  }

  @action
  void removeStoreByKey(String? key){
    stores.removeWhere((element) => element.key == key);
  }
}
