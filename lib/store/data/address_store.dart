import 'package:cirilla/models/address/address.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'address_store.g.dart';

class AddressDataStore = AddressDataStoreBase with _$AddressDataStore;

abstract class AddressDataStoreBase with Store {
  final String? key;
  final RequestHelper _requestHelper;

  AddressDataStoreBase(this._requestHelper, {this.key}) {
    _reaction();
  }

  @observable
  AddressData? _address;

  @observable
  bool _loading = false;

  @computed
  AddressData? get address => _address;

  @computed
  bool get loading => _loading;

  @action
  Future<void> getAddressData({Map<String, dynamic>? queryParameters}) async {
    try {
      _loading = true;
      AddressData data = await _requestHelper.getAddress(queryParameters: preQueryParameters(queryParameters ?? {}));
      _address = data;
      _loading = false;
    } on DioError {
      _loading = false;
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
