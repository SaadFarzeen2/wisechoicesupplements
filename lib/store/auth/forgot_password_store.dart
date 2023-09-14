import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'forgot_password_store.g.dart';

class ForgotPasswordStore = ForgotPasswordStoreBase with _$ForgotPasswordStore;

abstract class ForgotPasswordStoreBase with Store {
  // Request helper instance
  late RequestHelper _requestHelper;

  // constructor:-------------------------------------------------------------------------------------------------------
  ForgotPasswordStoreBase(RequestHelper requestHelper) {
    _requestHelper = requestHelper;
  }

  // store variables:-----------------------------------------------------------
  @observable
  bool _loading = false;

  @computed
  bool get loading => _loading;

  // actions:-------------------------------------------------------------------
  @action
  Future<bool> forgotPassword(String? userLogin) async {
    _loading = true;
    try {
      await _requestHelper.forgotPassword(userLogin: userLogin);
      _loading = false;
      return true;
    } on DioError {
      _loading = false;
      rethrow;
    }
  }
}
