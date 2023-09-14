import 'package:cirilla/models/models.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'customer_store.g.dart';

class CustomerStore = CustomerStoreBase with _$CustomerStore;

abstract class CustomerStoreBase with Store {
  final RequestHelper _requestHelper;

  CustomerStoreBase(
    this._requestHelper,
  ) {
    _reaction();
  }

  @observable
  Customer? _customer;

  @observable
  bool _loading = false;

  @computed
  Customer? get customer => _customer;

  @computed
  bool get loading => _loading;

  @action
  Future<void> getCustomer({required String userId}) async {
    try {
      _loading = true;
      Customer data = await _requestHelper.getCustomer(userId: userId);
      _customer = data;
      _loading = false;
    } on DioError {
      _loading = false;
      rethrow;
    }
  }

  @action
  Future<void> updateCustomer({required String userId, Map<String, dynamic>? data}) async {
    try {
      Customer customer = await _requestHelper.postCustomer(
        userId: userId,
        data: data,
      );

      _customer = customer;
    } on DioError {
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
