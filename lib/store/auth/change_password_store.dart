import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'change_password_store.g.dart';

class ChangePasswordStore = ChangePasswordStoreBase with _$ChangePasswordStore;

abstract class ChangePasswordStoreBase with Store {
  // repository instance
  late RequestHelper _requestHelper;

  // constructor:-------------------------------------------------------------------------------------------------------
  ChangePasswordStoreBase(RequestHelper requestHelper) {
    _requestHelper = requestHelper;
  }

  // store variables:-----------------------------------------------------------

  @observable
  bool _loading = false;

  @computed
  bool get loading => _loading;

  @action
  Future<dynamic> changePassword(String passwordOld, String passwordNew) async {
    _loading = true;
    try {
      final res = await _requestHelper
          .changePassword(queryParameters: {"password_old": passwordOld, "password_new": passwordNew});
      _loading = false;
      return res;
    } on DioError {
      _loading = false;
      rethrow;
    }
  }
}
