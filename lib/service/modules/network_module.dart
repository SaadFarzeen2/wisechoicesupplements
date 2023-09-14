import 'dart:developer';

import 'package:cirilla/service/constants/endpoints.dart';
import 'package:cirilla/service/helpers/persist_helper.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:cirilla/utils/gen_oauth_signature.dart';
import 'package:dio/dio.dart';

abstract class NetworkLocator {
  RequestHelper get providerRequestHelper;
}

class NetworkModule {
  NetworkModule();

  Dio provideDio(PersistHelper sharedPrefHelper) {
    final dio = Dio();

    dio
      ..options.baseUrl = Endpoints.restUrl
      ..options.connectTimeout = Endpoints.connectionTimeout
      ..options.receiveTimeout = Endpoints.receiveTimeout
      ..options.headers = {'Content-Type': 'application/json; charset=utf-8'}
      ..interceptors.add(LogInterceptor(
        error: false,
        logPrint: (error) => avoidPrint(error),
        request: false,
        requestBody: false,
        requestHeader: false,
        responseHeader: false,
        responseBody: false,
      ))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest:
              (RequestOptions options, RequestInterceptorHandler handler) {
            if (isAllowPassRestApiKeys(options.path)) {
              if (Endpoints.restUrl.indexOf('https://') == 0) {
                options.queryParameters.addAll({
                  "consumer_key": Endpoints.consumerKey,
                  "consumer_secret": Endpoints.consumerSecret,
                });
              } else {
                GenOauthSignature genOauthSignature = GenOauthSignature(
                  consumerKey: Endpoints.consumerKey,
                  url: '${Endpoints.restUrl}${options.path}',
                  consumerKeySecret: Endpoints.consumerSecret,
                  requestMethod: options.method,
                );
                Map<String, String> data =
                    Map<String, String>.of(options.uri.queryParameters);
                Map<String, String> queryParameters =
                    genOauthSignature.generate(data);
                options.queryParameters.addAll(queryParameters);
              }
            } else {
              // getting token
              String? token = sharedPrefHelper.getToken();
              if (token != null) {
                options.headers
                    .putIfAbsent('Authorization', () => 'Bearer $token');
              }
            }

            return handler.next(options);
          },
        ),
      );

    return dio;
  }

  /// A singleton dio_client provider.
  ///
  /// Calling it multiple times will return the same instance.
  DioClient provideDioClient(Dio dio) => DioClient(dio);

  // DI Providers:--------------------------------------------------------------
  /// A singleton preference provider.
  ///
  /// Calling it multiple times will return the same instance.
  RequestHelper provideRequestHelper(DioClient dioClient) =>
      RequestHelper(dioClient);
}

class DioClient {
  // dio instance
  final Dio _dio;

  // injecting dio instance
  DioClient(this._dio);

  // Get: --------------------------------------------------------------------------------------------------------------
  Future<dynamic> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      log("${Endpoints.restUrl}/$uri");

      final Response response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on DioError {
      rethrow;
    }
  }

  // Post: -------------------------------------------------------------------------------------------------------------
  Future<dynamic> post(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on DioError {
      rethrow;
    }
  }

  // Delete: -------------------------------------------------------------------------------------------------------------
  Future<dynamic> delete(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final Response response = await _dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioError {
      rethrow;
    }
  }
}
