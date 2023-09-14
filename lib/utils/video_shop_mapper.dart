import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:flutter/cupertino.dart';

class VideoShopMapper {
  static List<Map<String, dynamic>> mapData({required List<Product> products}) {
    try {
      List<Map<String, dynamic>> listData = [];
      for (var product in products) {
        List<Map<String, dynamic>>? metaData = product.metaData;
        int? id = product.id;
        String? url = get(
            metaData?.firstWhere((element) => element['key'] == '_app_builder_shopping_video_addons_video_url',
                orElse: () {
              return {};
            }),
            ['value'],
            null);
        String? title = get(
            metaData?.firstWhere((element) => element['key'] == '_app_builder_shopping_video_addons_video_name',
                orElse: () {
              return {};
            }),
            ['value'],
            product.name);
        String? description = get(
            metaData?.firstWhere((element) => element['key'] == '_app_builder_shopping_video_addons_video_description',
                orElse: () {
              return {};
            }),
            ['value'],
            product.description);
        int likes =
        metaData?.firstWhere((element) => element['key'] == 'app_builder_shopping_video_likes', orElse: () {
          return {'value': 0};
        })['value']
        ;
        String? liked = get(
            metaData?.firstWhere((element) => element['key'] == 'app_builder_shopping_video_liked', orElse: () {
              return {};
            }),
            ['value'],
            null);
        String? productName = product.name;
        String? productPermalink = product.permalink;
        String? stockStatus = product.stockStatus;
        if(url != null){
          listData.add({
            'id': id,
            'url': url,
            'video_title': title,
            'description': description,
            'likes': likes ,
            'liked': (liked == 'true'),
            'product_name': productName,
            'product_permalink': productPermalink,
            'stock_status': stockStatus,
          });
        }
      }
      return listData;
    } catch (e) {
      debugPrint("\nError when mapping data: $e\n");
      return [];
    }
  }
}
