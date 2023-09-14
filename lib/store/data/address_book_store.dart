import 'package:cirilla/models/models.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'address_book_store.g.dart';

class AddressBookStore = AddressBookStoreBase with _$AddressBookStore;

abstract class AddressBookStoreBase with Store {
  final String? key;
  final RequestHelper _requestHelper;

  AddressBookStoreBase(this._requestHelper, {this.key}) {
    _reaction();
  }

  @observable
  AddressBook? _addressBook;

  @observable
  bool _loading = false;

  @observable
  bool _loadingPrimary = false;

  @observable
  bool _loadingDelete = false;

  @computed
  AddressBook? get addressBook => _addressBook;

  @computed
  bool get loading => _loading;

  @computed
  bool get loadingPrimary => _loadingPrimary;

  @computed
  bool get loadingDelete => _loadingDelete;

  @action
  Future<void> getAddressBook({Map<String, dynamic>? queryParameters}) {
    _loading = true;
    return getAddress(queryParameters: queryParameters);
  }

  @action
  Future<void> getAddress({Map<String, dynamic>? queryParameters}) async {
    try {
      AddressBook data = await _requestHelper.getAddressBook(queryParameters: queryParameters);
      _addressBook = data;
      _loading = false;
    } on DioError {
      _loading = false;
      rethrow;
    }
  }

  @action
  Future<void> changePrimaryBook(String key) async {
    try {
      _loadingPrimary = true;
      bool data = await _requestHelper.makePrimaryAddressBook(data: {'name': key});
      if (data == true) {
        getAddress();
      }
      _loadingPrimary = false;
    } on DioError {
      _loadingPrimary = false;
      rethrow;
    }
  }

  @action
  Future<void> deleteAddressBook(String key) async {
    try {
      _loadingDelete = true;
      bool data = await _requestHelper.deleteAddressBook(data: {'name': key});
      if (data == true) {
        getAddress();
      }
      _loadingDelete = false;
    } on DioError {
      _loadingDelete = false;
      rethrow;
    }
  }

  // disposers:---------------------------------------------------------------------------------------------------------
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
