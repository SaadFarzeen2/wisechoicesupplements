import 'package:cirilla/mixins/mixins.dart';

class GatewayError{
  static String? mapErrorMessage(Map<String, dynamic>? error){
    if (error == null) {
      return null;
    }
    if (error['message'] != null) {
      if(get(error, ['data'], null) != null){
        String message = "<h3>${error['message']}</h3>";
        if(get(error, ['data', 'params'], null) != null){
          final params = get(error, ['data', 'params']);
          if(params is Map){
            params.forEach((key, value) {message = "$message<li>* $key : $value</li>";});
          }
          return message;
        }else if(get(error, ['data', 'errors'], null) != null){
          final errs = get(error, ['data', 'errors']);
          if(errs is Map){
            errs.forEach((key, value) {message = "$message<li>* $key : $value</li>";});
          }
          return message;
        }
      }
      return error['message'];
    }
    return null;
  }
}