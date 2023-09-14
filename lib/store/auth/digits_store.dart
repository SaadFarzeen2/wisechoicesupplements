import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

import 'auth_store.dart';

part 'digits_store.g.dart';

class DigitsStore = DigitsStoreBase with _$DigitsStore;

class DigitsException implements Exception {
  String cause;

  DigitsException(this.cause);
}

abstract class DigitsStoreBase with Store {
  // Request helper instance
  late RequestHelper _requestHelper;
  late AuthStore _auth;

  // constructor:-------------------------------------------------------------------------------------------------------
  DigitsStoreBase(RequestHelper requestHelper, AuthStore auth) {
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
  Future<bool> login(Map<String, dynamic> dataParameters) async {
    _loading = true;
    try {
      Map<String, dynamic> data = await _requestHelper.digitsLogin(dataParameters: dataParameters);
      if (data['success'] == true) {
        await _auth.loginSuccess(data);
        _loading = false;
        return true;
      } else {
        _loading = false;
        throw DigitsException(data['data']['message']);
      }
    } on DioError {
      _loading = false;
      rethrow;
    }
  }

  @action
  Future<bool> register(Map<String, dynamic> dataParameters) async {
    _loading = true;
    try {
      Map<String, dynamic> data = await _requestHelper.digitsRegister(dataParameters: dataParameters);
      if (data['success'] == true) {
        await _auth.loginSuccess(data);
        _loading = false;
        return true;
      } else {
        _loading = false;
        throw DigitsException(data['data']['msg']);
      }
    } on DioError {
      _loading = false;
      rethrow;
    }
  }
}
