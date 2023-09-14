import 'dart:math';

import 'package:cirilla/models/models.dart';

class StringGenerate {
  static String uuid([int length = 9]) {
    Random r = Random();
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(length, (index) => chars[r.nextInt(chars.length)]).join();
  }

  // Generate product store key
  static String? getProductKeyStore(
    String? id, {
    List<Product>? excludeProduct,
    List<Product>? includeProduct,
    List<int>? tags,
    String? currency,
    String? language,
    int? limit,
    int? category,
    String? search,
  }) {
    String? key = id;

    if (excludeProduct != null && excludeProduct.isNotEmpty) {
      String keyExcludes = excludeProduct.map((product) => "${product.id}").join('_');

      key = "${key}_exclude=$keyExcludes";
    }

    if (includeProduct != null && includeProduct.isNotEmpty) {
      String keyIncludes = includeProduct.map((product) => "${product.id}").join('_');

      key = "${key}_include=$keyIncludes";
    }

    if (tags != null && tags.isNotEmpty) {
      String keyTags = tags.map((tag) => "$tag").join('_');

      key = "${key}_tag=$keyTags";
    }

    if (currency != null && currency != "") {
      key = "${key}_currency=$currency";
    }

    if (language != null && language != "") {
      key = "${key}_language=$language";
    }

    if (limit != null) {
      key = "${key}_limit=$limit";
    }

    if (category != null) {
      key = "${key}_category=$category";
    }

    if (search != null) {
      key = "${key}_search=$search";
    }

    return key;
  }

  // Generate post store key
  static String? getPostKeyStore(
    String? id, {
    String? language,
    List<Post>? excludePost,
    List<Post>? includePost,
    int? page,
    int? perPage,
    List<PostCategory>? categories,
    List<PostTag>? tags,
    String? search,
    String? postType,
  }) {
    String? key = id;

    if (postType?.isNotEmpty == true) {
      key = "${key}_postType=$postType";
    }

    if (excludePost != null && excludePost.isNotEmpty) {
      String keyExcludes = excludePost.map((post) => "${post.id}").join('_');

      key = "${key}_exclude=$keyExcludes";
    }

    if (includePost != null && includePost.isNotEmpty) {
      String keyIncludes = includePost.map((post) => "${post.id}").join('_');

      key = "${key}_include=$keyIncludes";
    }

    if (tags != null && tags.isNotEmpty) {
      String keyTags = tags.map((tag) => "$tag").join('_');

      key = "${key}_tag=$keyTags";
    }

    if (language != null && language != "") {
      key = "${key}_language=$language";
    }

    if (page != null) {
      key = "${key}_page=$page";
    }

    if (perPage != null) {
      key = "${key}_perPage=$perPage";
    }

    if (categories != null) {
      String keyCategories = categories.map((category) => "${category.id}").join('_');

      key = "${key}_categories=$keyCategories";
    }

    if (tags != null) {
      String keyTags = tags.map((tag) => "${tag.id}").join('_');

      key = "${key}_tags=$keyTags";
    }

    if (search != null) {
      key = "${key}_search=$search";
    }

    return key;
  }

  // Generate post author store key
  static String? getPostAuthorKeyStore(
    String? id, {
    String? language,
    int? limit,
  }) {
    String? key = id;

    if (language != null && language != "") {
      key = "${key}_language=$language";
    }

    if (limit != null) {
      key = "${key}_limit=$limit";
    }

    return key;
  }

  // Generate vendor store key
  static String? getVendorKeyStore(
    String? id, {
    String? language,
    int? limit,
    double? radius,
    String? search,
  }) {
    String? key = id;

    if (language != null && language != "") {
      key = "${key}_language=$language";
    }

    if (limit != null) {
      key = "${key}_limit=$limit";
    }

    if (search != null) {
      key = "${key}_search=$search";
    }

    if (radius != null) {
      key = "${key}_radius=$radius";
    }

    return key;
  }

  // Generate brand store key
  static String? getBrandKeyStore(
    String? id, {
    int? limit,
  }) {
    String? key = id;

    if (limit != null) {
      key = "${key}_limit=$limit";
    }

    return key;
  }

  // Generate brand store key
  static String? getWalletKeyStore(
    String? id, {
    String? userId,
  }) {
    String? key = id;

    if (userId != null) {
      key = "${key}_userId=$userId";
    }

    return key;
  }
}
