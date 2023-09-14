import 'dart:convert';
import 'dart:developer';

import 'package:cirilla/models/address/address.dart';
import 'package:cirilla/models/address/country.dart';
import 'package:cirilla/models/message/message.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/models/order/order.dart';
import 'package:cirilla/models/order_note/order_node.dart';
import 'package:cirilla/models/post_author/post_author.dart';
import 'package:cirilla/models/product/attributes.dart';
import 'package:cirilla/models/product/product_prices.dart';
import 'package:cirilla/models/product/product_variable.dart';
import 'package:cirilla/models/product_review/product_review.dart';
import 'package:cirilla/service/constants/endpoints.dart';
import 'package:cirilla/service/modules/network_module.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:dio/dio.dart';

/// The RequestHelper contain all API for app request and serialize data
class RequestHelper {
  final DioClient _dioClient;

  RequestHelper(this._dioClient);

  Future<Map<String, dynamic>> getSettings() async {
    try {
      log(Endpoints.getSettings);
      final res = await _dioClient.get(Endpoints.getSettings);

      if (res is String) {
        return jsonDecode(res);
      }

      return res;
    } on DioError {
      rethrow;
    }
  }

  // ---------------------------------------------- Product ------------------------------------------------------------

  /// Returns list of product in response
  Future<List<Product>?> getProducts(
      {Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getProducts,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<Product>? products = <Product>[];
      products = data
          .map((product) => Product.fromJson(product))
          .toList()
          .cast<Product>();
      return products;
    } on DioError {
      rethrow;
    }
  }

  /// Retrieve a product in response
  Future<Product> getProduct(
      {int? id,
      Map<String, dynamic>? queryParameters,
      CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        "${Endpoints.getProducts}/$id",
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return Product.fromJson(data);
    } on DioError {
      rethrow;
    }
  }

  /// Returns list of product in response
  Future<List<Brand>?> getBrands(
      {Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getBrands,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<Brand>? brands = <Brand>[];
      brands =
          data.map((value) => Brand.fromJson(value)).toList().cast<Brand>();
      return brands;
    } on DioError {
      rethrow;
    }
  }

  /// Returns list of product in response
  Future<Brand> getBrand({required int id, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        "${Endpoints.getBrands}/$id",
        cancelToken: cancelToken,
      );
      return Brand.fromJson(data);
    } on DioError {
      rethrow;
    }
  }

  /// Returns list of product category in response
  Future<dynamic> getProductCategories(
      {Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getCategories,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return data;
    } on DioError {
      rethrow;
    }
  }

  /// Returns list of post in response
  Future<List<PostCategory>?> getPostCategories(
      {Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getPostCategories,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<PostCategory>? postCategories = <PostCategory>[];
      postCategories = data
          .map((post) => PostCategory.fromJson(post))
          .toList()
          .cast<PostCategory>();
      return postCategories;
    } on DioError {
      rethrow;
    }
  }

  /// Returns product variable data
  Future<ProductVariable> getProductVariations({
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final json = await _dioClient.get(
        Endpoints.getProductVariable,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return ProductVariable.fromJson(json);
    } on DioError {
      rethrow;
    }
  }

  /// Get attributes by terms
  Future<Attributes> getAttributes({
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final json = await _dioClient.get(
        Endpoints.getAttributes,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return Attributes.fromJson(json);
    } on DioError {
      rethrow;
    }
  }

  // Get Min - Max prices
  Future<ProductPrices> getMinMaxPrices({
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final json = await _dioClient.get(
        Endpoints.getMinMaxPrices,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return ProductPrices.fromJson(json);
    } on DioError {
      rethrow;
    }
  }

  /// Get active hours in appointments product
  Future<Map<String, dynamic>> getActiveHours({
    Map<String, dynamic>? queryParameters,
    String? endPoint,
  }) async {
    try {
      final data = await _dioClient.get(
        endPoint ?? Endpoints.getAppointmentTimeStamp,
        queryParameters: queryParameters,
      );
      return data is Map
          ? data.map((key, value) => MapEntry(key.toString(), value))
          : {};
    } on DioError {
      rethrow;
    }
  }

  /// Get staffs in appointments product
  Future<List> getStaffs({
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getAppointmentStaffs,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return data is List ? data : [];
    } on DioError {
      rethrow;
    }
  }

  /// Get appointments product
  Future<Map<String, dynamic>> getAppointmentProduct({
    Map<String, dynamic>? queryParameters,
    required String productId,
    String? endPoint,
  }) async {
    try {
      final data = await _dioClient.get(
        "${endPoint ?? Endpoints.getAppointmentProduct}/$productId",
        queryParameters: queryParameters,
      );
      return data is Map
          ? data.map((key, value) => MapEntry(key.toString(), value))
          : {};
    } on DioError {
      rethrow;
    }
  }

  /// get bookable day
  Future<Map<String, dynamic>> getBookableDays({
    Map<String, dynamic>? queryParameters,
    required String endPoint,
  }) async {
    try {
      final data = await _dioClient.get(
        endPoint,
        queryParameters: queryParameters,
      );
      return data is Map
          ? data.map((key, value) => MapEntry(key.toString(), value))
          : {};
    } on DioError {
      rethrow;
    }
  }

  /// Like product video
  Future<void> likeProductVideo({
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    CancelToken? cancelToken,
  }) async {
    try {
      await _dioClient.post(
        Endpoints.likeProductVideo,
        queryParameters: queryParameters,
        data: body,
        cancelToken: cancelToken,
      );
    } on DioError {
      rethrow;
    }
  }

  // ---------------------------------------------- Post ---------------------------------------------------------------

  /// Returns list of post in response
  Future<List<Post>?> getPosts({
    String postType = 'posts',
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final data = await _dioClient.get(
        '/wp/v2/$postType',
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<Post>? posts = <Post>[];
      posts = data.map((post) => Post.fromJson(post)).toList().cast<Post>();
      return posts;
    } on DioError {
      rethrow;
    }
  }

  /// Retrieve a post in response
  Future<Post> getPost(
      {String postType = 'posts', int? id, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        '/wp/v2/$postType/$id',
        cancelToken: cancelToken,
      );
      return Post.fromJson(data);
    } on DioError {
      rethrow;
    }
  }

  /// Returns list of comment in response
  Future<List<PostComment>?> getPostComments(
      {Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getPostComments,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<PostComment>? comments = <PostComment>[];
      comments = data
          .map((comment) => PostComment.fromJson(comment))
          .toList()
          .cast<PostComment>();
      return comments;
    } on DioError {
      rethrow;
    }
  }

  /// Write a comment
  Future<PostComment> writeComments(
      {required Map<String, dynamic> queryParameters,
      CancelToken? cancelToken}) async {
    try {
      final json = await _dioClient.post(
        Endpoints.getPostComments,
        queryParameters: {
          ...queryParameters,
          'app-builder-decode': true,
        },
        cancelToken: cancelToken,
      );
      return PostComment.fromJson(json);
    } on DioError {
      rethrow;
    }
  }

  /// Returns list of tags in response
  Future<List<PostTag>?> getPostTags(
      {Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getPostTags,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<PostTag>? tags = <PostTag>[];
      tags = data
          .map((comment) => PostTag.fromJson(comment))
          .toList()
          .cast<PostTag>();
      return tags;
    } on DioError {
      rethrow;
    }
  }

  /// Returns list of tags in response
  Future<List<PostAuthor>?> getPostAuthors(
      {Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getPostAuthor,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<PostAuthor>? users = <PostAuthor>[];
      users = data
          .map((comment) => PostAuthor.fromJson(comment))
          .toList()
          .cast<PostAuthor>();
      return users;
    } on DioError {
      rethrow;
    }
  }

  /// Retrieve a post in response
  Future<PostAuthor> getPostAuthor({int? id, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        "${Endpoints.getPostAuthor}/$id",
        cancelToken: cancelToken,
      );
      return PostAuthor.fromJson(data);
    } on DioError {
      rethrow;
    }
  }

  /// Returns list of tags in response
  Future<List<PostArchive>?> getPostArchives({CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.archives,
        cancelToken: cancelToken,
      );
      List<PostArchive>? archives = <PostArchive>[];
      archives = data
          .map((value) => PostArchive.fromJson(value))
          .toList()
          .cast<PostArchive>();
      return archives;
    } on DioError {
      rethrow;
    }
  }

  /// Search post
  Future<List<PostSearch>?> searchPost(
      {Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.search,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<PostSearch>? search = <PostSearch>[];
      search = data
          .map((value) => PostSearch.fromJson(value))
          .toList()
          .cast<PostSearch>();
      return search;
    } on DioError {
      rethrow;
    }
  }

  /// Get amount balance
  Future<double> getAmountBalance(
      {required String userId, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        '${Endpoints.getAmountBalance}/$userId',
        queryParameters: {
          'app-builder-decode': true,
        },
        cancelToken: cancelToken,
      );
      return ConvertData.stringToDouble(data);
    } on DioError {
      rethrow;
    }
  }

  /// Get transaction wallet
  Future<List<TransactionWallet>?> getTransactionWallet(
      {required String userId, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        '${Endpoints.getTransactionWallet}/$userId',
        queryParameters: {
          'app-builder-decode': true,
        },
        cancelToken: cancelToken,
      );
      List<TransactionWallet>? result = <TransactionWallet>[];
      result = data
          .map((value) => TransactionWallet.fromJson(value))
          .toList()
          .cast<TransactionWallet>();
      return result;
    } on DioError {
      rethrow;
    }
  }

  // ---------------------------------------------- Media ---------------------------------------------------------------

  /// Get a media
  Future<Map?> getMedia(
      {required String mediaId, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        '${Endpoints.getMedia}/$mediaId',
        queryParameters: {
          'app-builder-decode': true,
        },
        cancelToken: cancelToken,
      );
      return data;
    } on DioError {
      rethrow;
    }
  }

  // ---------------------------------------------- Auth ---------------------------------------------------------------

  /// Login with Email or Username
  Future<Map<String, dynamic>> login(
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final res = await _dioClient.post(Endpoints.login,
          queryParameters: queryParameters);
      return res;
    } on DioError {
      rethrow;
    }
  }

  /// Register user
  Future<Map<String, dynamic>> register(
      Map<String, dynamic> queryParameters) async {
    try {
      final res = await _dioClient.post(Endpoints.register,
          queryParameters: queryParameters);
      return res;
    } on DioError {
      rethrow;
    }
  }

  /// Forgot password
  Future<dynamic> forgotPassword({String? userLogin}) async {
    try {
      final res = await _dioClient.post(Endpoints.forgotPassword,
          queryParameters: {'user_login': userLogin});
      return res;
    } on DioError {
      rethrow;
    }
  }

  /// Change password
  Future<dynamic> changePassword(
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final res = await _dioClient.post(
          '${Endpoints.changePassword}?app-builder-decode=true',
          queryParameters: queryParameters);

      return res;
    } on DioError {
      rethrow;
    }
  }

  /// Current user
  Future<Map<String, dynamic>> current() async {
    try {
      final res = await _dioClient.get(Endpoints.current,
          queryParameters: {'app-builder-decode': true});
      return res;
    } on DioError {
      rethrow;
    }
  }

  // ---------------------------------------------- Digits -------------------------------------------------------------
  /// Digits login
  Future<Map<String, dynamic>> digitsLogin(
      {required Map<String, dynamic> dataParameters}) async {
    try {
      final res = await _dioClient.post(Endpoints.digitsLogin,
          data: dataParameters,
          options: Options(
            headers: {
              Headers.contentTypeHeader:
                  'application/x-www-form-urlencoded', // set content-length
            },
          ));
      return res;
    } on DioError {
      rethrow;
    }
  }

  /// Digits create user
  Future<Map<String, dynamic>> digitsRegister(
      {required Map<String, dynamic> dataParameters}) async {
    try {
      final res = await _dioClient.post(Endpoints.digitsRegister,
          data: dataParameters,
          options: Options(
            headers: {
              Headers.contentTypeHeader:
                  'application/x-www-form-urlencoded', // set content-length
            },
          ));
      return res;
    } on DioError {
      rethrow;
    }
  }

  /// Digits send otp
  Future<Map<String, dynamic>> digitsSendOtp(
      Map<String, dynamic> dataParameters) async {
    try {
      final res = await _dioClient.post(Endpoints.digitsSendOtp,
          data: dataParameters,
          options: Options(
            headers: {
              Headers.contentTypeHeader:
                  'application/x-www-form-urlencoded', // set content-length
            },
          ));
      return res;
    } on DioError {
      rethrow;
    }
  }

  /// Digits re send otp
  Future<Map<String, dynamic>> digitsReSendOtp(
      Map<String, dynamic> dataParameters) async {
    try {
      final res = await _dioClient.post(Endpoints.digitsReSendOtp,
          data: dataParameters,
          options: Options(
            headers: {
              Headers.contentTypeHeader:
                  'application/x-www-form-urlencoded', // set content-length
            },
          ));
      return res;
    } on DioError {
      rethrow;
    }
  }

  /// Register verify otp
  Future<Map<String, dynamic>> digitsVerifyOtp(
      Map<String, dynamic> dataParameters) async {
    try {
      final res = await _dioClient.post(Endpoints.digitsVerifyOtp,
          data: dataParameters,
          options: Options(
            headers: {
              Headers.contentTypeHeader:
                  'application/x-www-form-urlencoded', // set content-length
            },
          ));
      return res;
    } on DioError {
      rethrow;
    }
  }

  /// Delete account
  Future<Map<String, dynamic>> deleteAccount({
    Map<String, dynamic>? dataParameters,
    Map<String, dynamic>? data,
    CancelToken? cancelToken,
  }) async {
    try {
      Map<String, dynamic> query = {
        ...?dataParameters,
        'app-builder-decode': true,
      };
      final res = await _dioClient.post(
        Endpoints.deleteAccount,
        queryParameters: query,
        data: data,
        cancelToken: cancelToken,
      );
      return res;
    } on DioError {
      rethrow;
    }
  }

  /// Send opt delete account
  Future<Map<String, dynamic>> sendOptDeleteAccount({
    Map<String, dynamic>? dataParameters,
    Map<String, dynamic>? data,
    CancelToken? cancelToken,
  }) async {
    try {
      Map<String, dynamic> query = {
        ...?dataParameters,
        'app-builder-decode': true,
      };
      final res = await _dioClient.post(
        Endpoints.sendOptDeleteAccount,
        queryParameters: query,
        data: data,
        cancelToken: cancelToken,
      );
      return res;
    } on DioError {
      rethrow;
    }
  }

  // ---------------------------------------------- Token --------------------------------------------------------------

  /// Update user token
  Future<Map<String, dynamic>?> updateUserToken(String? token) async {
    try {
      final res = await _dioClient.post(
        Endpoints.updateUserToken,
        data: {'token': token},
        queryParameters: {'app-builder-decode': true},
      );
      return res;
    } on DioError {
      rethrow;
    }
  }

  /// Update user token
  Future<Map<String, dynamic>?> removeUserToken(
      String? token, String? userId) async {
    try {
      final res = await _dioClient.post(
        Endpoints.removeUserToken,
        data: {'token': token, 'user_id': userId},
      );
      return res;
    } on DioError {
      rethrow;
    }
  }

  /// Get captcha
  Future<Map?> getCaptcha({Map<String, dynamic>? queryParameters}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getCaptcha,
        queryParameters: queryParameters,
      );
      return data;
    } on DioError {
      rethrow;
    }
  }

  /// Validate captcha
  Future<dynamic> validateCaptcha(
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? data}) async {
    try {
      final res = await _dioClient.post(
        Endpoints.validateCaptcha,
        queryParameters: queryParameters,
        data: data,
      );
      return res;
    } on DioError {
      rethrow;
    }
  }

  /// Get list notification by user_id
  Future<List<MessageData>?> getListNotify(
      {Map<String, dynamic>? queryParameters, String? userId}) async {
    try {
      final data = await _dioClient.get(
        '${Endpoints.getNotify}?user_id=$userId&app-builder-decode=true',
        queryParameters: queryParameters,
      );
      List<MessageData>? res = <MessageData>[];
      res = data
          .map((mess) => MessageData.fromJson(mess))
          .toList()
          .cast<MessageData>();
      return res;
    } on DioError {
      rethrow;
    }
  }

  /// Get a notification by user_id
  Future<Map<String, dynamic>?> getANotify({int? id, String? userId}) async {
    try {
      final res = await _dioClient.get(
          '${Endpoints.getNotify}/$id?user_id=$userId&app-builder-decode=true');
      return res;
    } on DioError {
      rethrow;
    }
  }

  /// Get unRead
  Future<Map<String, dynamic>?> getUnRead() async {
    try {
      final res = await _dioClient
          .get('${Endpoints.getUnRead}?app-builder-decode=true');
      return res;
    } on DioError {
      rethrow;
    }
  }

  /// Get postRead
  Future<void> putRead({Map<String, dynamic>? data}) async {
    try {
      final res = await _dioClient.post(
        '${Endpoints.putRead}?app-builder-decode=true',
        data: data,
      );
      return res;
    } on DioError {
      rethrow;
    }
  }

  /// Delete a notification by user_id
  Future<Map<String, dynamic>?> removeMessageById(
      {String? id, String? userId}) async {
    try {
      final res = await _dioClient.delete(
          '${Endpoints.getNotify}/$id?user_id=$userId&app-builder-decode=true');
      return res;
    } on DioError {
      rethrow;
    }
  }

  /// Delete a notification by user_id
  Future<Map<String, dynamic>?> removeAllNotify() async {
    try {
      final res = await _dioClient
          .delete('${Endpoints.removeAllNotify}?app-builder-decode=true');
      return res;
    } on DioError {
      rethrow;
    }
  }

  // ---------------------------------------------- Cart ---------------------------------------------------------------
  /// Get list cart
  Future<Map<String, dynamic>> getCart(
      {Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      String url =
          "${Endpoints.getCart}?${Uri(queryParameters: queryParameters).query}";
      final res = await _dioClient.get(url, cancelToken: cancelToken);
      return res;
    } on DioError {
      rethrow;
    }
  }

  /// Add to cart
  Future<Map<String, dynamic>> addToCart(
      {required Map<String, String?> queryParams,
      Map<String, dynamic>? data}) async {
    try {
      final res = await _dioClient.post(Endpoints.addToCart,
          queryParameters: queryParams,
          data: data,
          options: Options(
            headers: {
              Headers.contentTypeHeader: 'application/x-www-form-urlencoded',
            },
          ));
      return res;
    } on DioError {
      rethrow;
    }
  }

  /// Update quantity
  Future<Map<String, dynamic>> updateQuantity(
      {String? cartKey, Map<String, dynamic>? queryParameters}) async {
    try {
      final res = await _dioClient.post(
          '${Endpoints.updateCart}?cart_key=$cartKey&app-builder-decode=true',
          queryParameters: queryParameters);
      return res;
    } on DioError {
      rethrow;
    }
  }

  /// Select shipping cart
  Future<Map<String, dynamic>> selectShipping(
      {String? cartKey, Map<String, dynamic>? queryParameters}) async {
    try {
      final res = await _dioClient.post(
          '${Endpoints.shippingCart}?cart_key=$cartKey&app-builder-decode=true',
          queryParameters: queryParameters);
      return res;
    } on DioError {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateCustomerCart(
      {String? cartKey,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? data}) async {
    try {
      final res = await _dioClient.post(
          '${Endpoints.updateCustomerCart}?cart_key=$cartKey&app-builder-decode=true',
          queryParameters: queryParameters,
          data: data);
      return res;
    } on DioError {
      rethrow;
    }
  }

  /// Apply Coupon
  Future<Map<String, dynamic>> applyCoupon(
      {String? cartKey, Map<String, dynamic>? queryParameters}) async {
    try {
      final res = await _dioClient.post(
          '${Endpoints.applyCoupon}?cart_key=$cartKey&app-builder-decode=true',
          queryParameters: queryParameters);
      return res;
    } on DioError {
      rethrow;
    }
  }

  /// Remove Coupon
  Future<Map<String, dynamic>> removeCoupon(
      {String? cartKey, Map<String, dynamic>? queryParameters}) async {
    try {
      final res = await _dioClient.post(
          '${Endpoints.removeCoupon}?cart_key=$cartKey&app-builder-decode=true',
          queryParameters: queryParameters);
      return res;
    } on DioError {
      rethrow;
    }
  }

  /// Remove cart
  Future<Map<String, dynamic>> removeCart(
      {String? cartKey, Map<String, dynamic>? queryParameters}) async {
    try {
      final res = await _dioClient.post(
          '${Endpoints.removeCart}?cart_key=$cartKey&app-builder-decode=true',
          data: queryParameters);
      return res;
    } on DioError {
      rethrow;
    }
  }

  /// Clean cart
  Future<bool> cleanCart({String? cartKey}) async {
    try {
      final res = await _dioClient.post(
          '${Endpoints.cleanCart}?cart_key=$cartKey&app-builder-decode=true');
      return res;
    } on DioError {
      rethrow;
    }
  }

  /// Checkout
  Future<dynamic> checkout(
      {Map<String, dynamic>? queryParameters, dynamic data}) async {
    try {
      final res = await _dioClient.post(Endpoints.checkout,
          queryParameters: queryParameters, data: data);
      return res;
    } on DioError {
      rethrow;
    }
  }

  Future<dynamic> progressServer({
    String? cartKey,
    required Map<String, dynamic> data,
  }) async {
    Map<String, dynamic> body = Map<String, dynamic>.of(data);
    body.addAll({"cart_key": cartKey});
    try {
      final res = await _dioClient.post(Endpoints.progressServer,
          queryParameters: {"app-builder-decode": true}, data: body);
      return res;
    } on DioError {
      rethrow;
    }
  }

  /// Checkout
  Future<dynamic> gateways() async {
    try {
      final res = await _dioClient.get(Endpoints.gateways);
      return res;
    } on DioError {
      rethrow;
    }
  }

  // ---------------------------------------------- Order --------------------------------------------------------------
  /// Get list orders
  Future<List<OrderData>?> getOrders(
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getOrders,
        queryParameters: queryParameters,
      );
      List<OrderData>? orders = <OrderData>[];
      orders = data
          .map((order) => OrderData.fromJson(order))
          .toList()
          .cast<OrderData>();
      return orders;
    } on DioError {
      rethrow;
    }
  }

  /// Get orders detail
  Future<OrderData> getOrderDetail(
      {Map<String, dynamic>? queryParameters, int? orderId}) async {
    try {
      final data = await _dioClient.get(
        '${Endpoints.getOrders}/$orderId',
        queryParameters: queryParameters,
      );
      OrderData result = OrderData.fromJson(data);
      return result;
    } on DioError {
      rethrow;
    }
  }

  /// Get list orders node
  Future<List<OrderNode>?> getOrderNodes(
      {Map<String, dynamic>? queryParameters, int? orderId}) async {
    try {
      final data = await _dioClient.get(
        '${Endpoints.getOrders}/$orderId/notes',
        queryParameters: queryParameters,
      );
      List<OrderNode>? orders = <OrderNode>[];
      orders = data
          .map((order) => OrderNode.fromJson(order))
          .toList()
          .cast<OrderNode>();
      return orders;
    } on DioError {
      rethrow;
    }
  }

  /// Get cancel order
  Future<List<dynamic>> getCancelOrder() async {
    try {
      final data = await _dioClient.get(Endpoints.cancelOrder);
      return data;
    } on DioError {
      rethrow;
    }
  }

  /// Post cancel order
  Future<void> postCancelOrder({Map<String, dynamic>? dataCancel}) async {
    try {
      await _dioClient.post(
        '${Endpoints.cancelOrder}/post?app-builder-decode=true',
        queryParameters: dataCancel,
      );
    } on DioError {
      rethrow;
    }
  }

  // ---------------------------------------------- Contact ------------------------------------------------------------
  /// Send contact or Subscription
  Future<Map<String, dynamic>> sendContact(
      {required Map<String, dynamic> queryParameters, String? formId}) async {
    try {
      final data =
          await _dioClient.post('${Endpoints.contactForm7}/$formId/feedback',
              data: FormData.fromMap(queryParameters),
              options: Options(
                headers: {
                  Headers.contentTypeHeader:
                      'application/x-www-form-urlencoded', // set content-length
                },
              ));
      return data;
    } on DioError {
      rethrow;
    }
  }

  // ---------------------------------------------- My Account ---------------------------------------------------------
  /// Address book
  Future<List<CountryData>> getCountry(
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getCountries,
        queryParameters: queryParameters,
      );
      List<CountryData> countries = <CountryData>[];
      countries = data
          .map((country) => CountryData.fromJson(country))
          .toList()
          .cast<CountryData>();
      return countries;
    } on DioError {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getCountryLocale(
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getCountryLocale,
        queryParameters: queryParameters,
      );
      if (data is Map<String, dynamic>) {
        return data;
      }
      return {};
    } on DioError {
      rethrow;
    }
  }

  Future<AddressData> getAddress(
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getAddress,
        queryParameters: queryParameters,
      );
      if (data is Map) {
        Map<String, dynamic> dataJson =
            data.map((key, value) => MapEntry(key.toString(), value));
        return AddressData.fromJson(dataJson);
      }
      return AddressData();
    } on DioError {
      rethrow;
    }
  }

  Future<AddressBook> getAddressBook(
      {Map<String, dynamic>? queryParameters}) async {
    try {
      Map<String, dynamic> query = {
        ...?queryParameters,
        'app-builder-decode': true,
      };

      final data = await _dioClient.get(
        Endpoints.addressBooks,
        queryParameters: query,
      );
      if (data is Map) {
        Map<String, dynamic> dataJson =
            data.map((key, value) => MapEntry(key.toString(), value));
        return AddressBook.fromJson(dataJson);
      }
      return AddressBook();
    } on DioError {
      rethrow;
    }
  }

  Future<bool> makePrimaryAddressBook(
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? data}) async {
    try {
      Map<String, dynamic> query = {
        ...?queryParameters,
        'app-builder-decode': true,
      };
      final result = await _dioClient.post(
        '${Endpoints.addressBooks}/make-primary',
        queryParameters: query,
        data: data,
        options: Options(
          headers: {
            Headers.contentTypeHeader:
                'application/x-www-form-urlencoded', // set content-length
          },
        ),
      );
      return result is Map && result['success'] == true;
    } on DioError {
      rethrow;
    }
  }

  Future<bool> deleteAddressBook(
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? data}) async {
    try {
      Map<String, dynamic> query = {
        ...?queryParameters,
        'app-builder-decode': true,
      };
      final result = await _dioClient.post(
        '${Endpoints.addressBooks}/delete',
        queryParameters: query,
        data: data,
        options: Options(
          headers: {
            Headers.contentTypeHeader:
                'application/x-www-form-urlencoded', // set content-length
          },
        ),
      );
      return result is Map && result['success'] == true;
    } on DioError {
      rethrow;
    }
  }

  Future<Customer> postCustomer(
      {String? userId,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? data}) async {
    try {
      Map<String, dynamic> query = queryParameters != null
          ? {
              ...queryParameters,
              'app-builder-decode': true,
            }
          : {
              'app-builder-decode': true,
            };

      final res = await _dioClient.post(
        '${Endpoints.postCustomer}/$userId',
        queryParameters: query,
        data: data,
      );
      return Customer.fromJson(res);
    } on DioError {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> postAccount(
      {String? userId,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? data}) async {
    try {
      Map<String, dynamic> query = queryParameters != null
          ? {
              ...queryParameters,
              'app-builder-decode': true,
            }
          : {
              'app-builder-decode': true,
            };

      final res = await _dioClient.post(
        '${Endpoints.postAccount}/$userId',
        queryParameters: query,
        data: data,
      );
      return res;
    } on DioError {
      rethrow;
    }
  }

  Future<Customer> getCustomer({
    String? userId,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final res = await _dioClient.get(
        '${Endpoints.getCustomer}/$userId',
        queryParameters: queryParameters,
      );
      return Customer.fromJson(res);
    } on DioError {
      rethrow;
    }
  }

  // ------------------------------------------------ Reviews ----------------------------------------------------------
  /// Get list review
  Future<List<ProductReview>?> getReviews(
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final data = await _dioClient.get(Endpoints.getReviews,
          queryParameters: queryParameters);

      List<ProductReview>? reviews = <ProductReview>[];
      reviews = data
          .map((review) => ProductReview.fromJson(review))
          .toList()
          .cast<ProductReview>();
      return reviews;
    } on DioError {
      rethrow;
    }
  }

  /// Add review
  Future<ProductReview> writeReviews(
      {Map<String, dynamic>? queryParameters, dynamic data}) async {
    try {
      final res = await _dioClient.post(Endpoints.writeReview,
          data: data, queryParameters: queryParameters);
      return ProductReview.fromJson(res);
    } on DioError {
      rethrow;
    }
  }

  /// Rating count
  Future<RatingCount> getRatingCount(
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final res = await _dioClient.get(Endpoints.ratingCount,
          queryParameters: queryParameters);
      return RatingCount.fromJson(res);
    } on DioError {
      rethrow;
    }
  }

  /// Returns list of vendor in response
  Future<List<Vendor>?> getVendors(
      {Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getVendor,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<Vendor>? vendors = <Vendor>[];
      vendors = data
          .map((comment) => Vendor.fromJson(comment))
          .toList()
          .cast<Vendor>();
      return vendors;
    } on DioError {
      rethrow;
    }
  }

  /// Returns list of id category vendor in response
  Future<List<int>?> getCategoryVendor(
      {Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        Endpoints.getCategoryVendor,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<int> result = <int>[];
      for (int i = 0; i < data.length; i++) {
        result.add(ConvertData.stringToInt(data[i]));
      }

      return result;
    } on DioError {
      rethrow;
    }
  }

  /// Returns data of page in response
  Future<PageData> getPageDetail(
      {int? idPage, CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get('${Endpoints.getPage}/$idPage',
          cancelToken: cancelToken);
      return PageData.fromJson(data);
    } on DioError {
      rethrow;
    }
  }

  /// Returns list of downloads in response
  Future<List<Download>?> getDownloads(
      {required int userId,
      Map<String, dynamic>? queryParameters,
      CancelToken? cancelToken}) async {
    try {
      final data = await _dioClient.get(
        '${Endpoints.getCustomer}/$userId/downloads',
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      List<Download>? downloads = <Download>[];
      downloads = data
          .map((comment) => Download.fromJson(comment))
          .toList()
          .cast<Download>();
      return downloads;
    } on DioError {
      rethrow;
    }
  }

  // ---------------------------------------------- Wishlist ---------------------------------------------------------------
  Future<dynamic> getWishlistByUser({required int userId}) async {
    try {
      final data = await _dioClient.get(
        '${Endpoints.getWishlistByUser}/$userId',
        queryParameters: {
          'app-builder-decode': true,
        },
      );
      return data;
    } on DioError {
      rethrow;
    }
  }

  Future<dynamic> getWishlistProductShareKey({
    required String shareKey,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      List<dynamic> data = await _dioClient.get(
        '${Endpoints.wishlistProduct}/$shareKey/get_products',
        queryParameters: queryParameters,
      );
      return data;
    } on DioError {
      rethrow;
    }
  }

  Future<void> addWishlistProductShareKey(
      {required String shareKey, required int productId}) async {
    try {
      await _dioClient.post(
          '${Endpoints.wishlistProduct}/$shareKey/add_product',
          queryParameters: {
            'app-builder-decode': true,
          },
          data: {
            'product_id': productId
          });
    } on DioError {
      rethrow;
    }
  }

  Future<void> removeWishlistProduct({required int productId}) async {
    try {
      await _dioClient.get(
        '${Endpoints.removeWishlistProduct}/$productId',
        queryParameters: {
          'app-builder-decode': true,
        },
      );
    } on DioError {
      rethrow;
    }
  }
}
