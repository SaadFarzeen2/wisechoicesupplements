import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

import 'auth_store.dart';

part 'login_store.g.dart';

class LoginStore = LoginStoreBase with _$LoginStore;

abstract class LoginStoreBase with Store {
  // Request helper instance
  late RequestHelper _requestHelper;
  late AuthStore _auth;

  // constructor:-------------------------------------------------------------------------------------------------------
  LoginStoreBase(RequestHelper requestHelper, AuthStore auth) {
    _requestHelper = requestHelper;
    _auth = auth;
  }

  // store variables:-----------------------------------------------------------
  @observable
  bool _loading = false;

  @computed
  bool get loading => _loading;

  // actions:-------------------------------------------------------------------
  @action
  Future<bool> login(Map<String, dynamic> queryParameters) async {
    _loading = true;
    try {
      Map<String, dynamic> data = await _requestHelper.login(queryParameters: queryParameters);
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
