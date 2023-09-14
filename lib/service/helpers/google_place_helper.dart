import 'package:cirilla/models/location/near_place.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:dio/dio.dart';

import 'package:cirilla/constants/credentials.dart';
import 'package:cirilla/models/location/place.dart';
import 'package:cirilla/models/location/prediction.dart';
import 'package:cirilla/service/modules/network_module.dart';

BaseOptions options = BaseOptions(
  baseUrl: 'https://maps.googleapis.com/',
  connectTimeout: 5000,
  receiveTimeout: 3000,
  queryParameters: {'key': googleMapApiKey},
);

Dio dio = Dio(options);

/// The Places API Helper.
///
class GooglePlaceApiHelper {
  final DioClient _dioClient = DioClient(dio);

  static const _unEncodedPathNearBySearch = 'maps/api/place/nearbysearch/json';
  static const _unEncodedPathPlaceAutocomplete = 'maps/api/place/autocomplete/json';
  static const _unEncodedPathQueryAutocomplete = 'maps/api/place/queryautocomplete/json';
  static const _unEncodedPathPlaceDetailAutocomplete = 'maps/api/place/details/json';

  GooglePlaceApiHelper();

  /// Nearby Search
  ///
  Future<List<NearPlace>> getNearbySearch({
    required Map<String, dynamic> queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      Map<String, dynamic> data = await _dioClient.get(
        _unEncodedPathNearBySearch,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<NearPlace> results = <NearPlace>[];
      results = data['results'].map((p) => NearPlace.fromJson(p)).toList().cast<NearPlace>();
      return results;
    } catch (e) {
      rethrow;
    }
  }

  /// Place Autocomplete
  ///
  Future<List<Prediction>> getPlaceAutocomplete({
    required Map<String, dynamic> queryParameters,
    CancelToken? cancelToken,
  }) async {
    avoidPrint(queryParameters);
    try {
      Map<String, dynamic> data = await _dioClient.get(
        _unEncodedPathPlaceAutocomplete,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<Prediction> result = data['predictions'].map<Prediction>((p) => Prediction.fromJson(p)).toList();
      return result;
    } catch (e) {
      rethrow;
    }
  }

  /// Query Autocomplete
  ///
  Future<Map<String, dynamic>> getQueryAutocomplete({
    required Map<String, dynamic> queryParameters,
    CancelToken? cancelToken,
  }) async {
    avoidPrint(queryParameters);
    try {
      Map<String, dynamic> data = await _dioClient.get(
        _unEncodedPathQueryAutocomplete,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return data;
    } catch (e) {
      rethrow;
    }
  }

  /// Get place place from id
  ///
  Future<Place> getPlaceDetailFromId({
    required Map<String, dynamic> queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      Map<String, dynamic> result = await _dioClient.get(
        _unEncodedPathPlaceDetailAutocomplete,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return Place.fromJson(result['result']);
    } catch (e) {
      rethrow;
    }
  }
}
