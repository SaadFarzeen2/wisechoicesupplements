import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

import 'auth_store.dart';

part 'register_store.g.dart';

class RegisterStore = RegisterStoreBase with _$RegisterStore;

abstract class RegisterStoreBase with Store {
  // repository instance
  late RequestHelper _requestHelper;
  late AuthStore _auth;

  // constructor:-------------------------------------------------------------------------------------------------------
  RegisterStoreBase(RequestHelper requestHelper, AuthStore authStore) {
    _requestHelper = requestHelper;
    _auth = authStore;
  }

  @observable
  bool _loading = false;

  @computed
  bool get loading => _loading;

  // actions:-------------------------------------------------------------------
  @action
  Future<dynamic> register(Map<String, dynamic> queryParameters) async {
    _loading = true;
    try {
      Map<String, dynamic> data = await _requestHelper.register(queryParameters);
      await _auth.loginSuccess(data);
      _loading = false;
      if (queryParameters['callback'] != null) {
        await queryParameters['callback'].call();
      }
      return true;
    } on DioError {
      _loading = false;
      rethrow;
    }
  }
}
