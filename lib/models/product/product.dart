import 'package:json_annotation/json_annotation.dart';
import 'package:cirilla/mixins/unescape_mixin.dart' show unescape;
import '../../utils/convert_data.dart';
import 'product_brand.dart';
import 'product_category.dart';
import 'product_price_format.dart';

part 'product.g.dart';

@JsonSerializable(createToJson: false)
class Product {
  int? id;

  @JsonKey(fromJson: unescape)
  String? name;

  String? slug;

  String? type;

  String? status;

  String? sku;

  String? description;

  @JsonKey(name: 'short_description')
  String? shortDescription;

  @JsonKey(fromJson: _fromJsonImage)
  List<Map<String, dynamic>>? images;

  List<ProductCategory?>? categories;

  @JsonKey(fromJson: _fromJson)
  String? price;

  @JsonKey(name: 'regular_price', fromJson: _fromJson)
  String? regularPrice;

  @JsonKey(name: 'sale_price', fromJson: _fromJson)
  String? salePrice;

  @JsonKey(name: 'on_sale')
  bool? onSale;

  @JsonKey(name: 'date_created')
  String? date;

  @JsonKey(name: 'average_rating')
  String? averageRating;

  @JsonKey(name: 'rating_count')
  int? ratingCount;

  @JsonKey(name: 'format_price')
  ProductPriceFormat? formatPrice;

  @JsonKey(name: 'catalog_visibility')
  String? catalogVisibility;

  @JsonKey(name: 'stock_status')
  String? stockStatus;

  @JsonKey(name: 'stock_quantity', defaultValue: 0)
  int? stockQuantity;

  @JsonKey(name: 'total_sales', fromJson: _toInt, defaultValue: 0)
  int? totalSales;

  @JsonKey(name: 'related_ids', fromJson: _toListInt)
  List<int>? relatedIds;

  @JsonKey(name: 'upsell_ids', fromJson: _toListInt)
  List<int>? upsellIds;

  @JsonKey(name: 'grouped_products')
  List<int>? groupedIds;

  @JsonKey(name: 'external_url')
  String? externalUrl;

  @JsonKey(name: 'permalink')
  String? permalink;

  @JsonKey(name: 'button_text')
  String? buttonText;

  bool? purchasable;

  List<Map<String, dynamic>>? attributes;

  @JsonKey(name: 'default_attributes')
  List<Map<String, dynamic>>? defaultAttributes;

  Map<String, dynamic>? store;

  @JsonKey(name: 'parent_id', defaultValue: 0)
  int? parentId;

  @JsonKey(name: 'meta_data')
  List<Map<String, dynamic>>? metaData;

  Map<String, dynamic>? acf;

  List<ProductBrand?>? brands;

  @JsonKey(name: 'price_html')
  String? priceHtml;

  @JsonKey(name: 'afc_fields', fromJson: _fromAcfFields)
  Map? afcFields;

  Product({
    this.id,
    this.name,
    this.slug,
    this.type,
    this.status,
    this.sku,
    this.description,
    this.shortDescription,
    this.images,
    this.price,
    this.regularPrice,
    this.salePrice,
    this.onSale,
    this.date,
    this.averageRating,
    this.ratingCount,
    this.formatPrice,
    this.catalogVisibility,
    this.stockStatus,
    this.stockQuantity,
    this.totalSales,
    this.relatedIds,
    this.upsellIds,
    this.groupedIds,
    this.categories,
    this.externalUrl,
    this.buttonText,
    this.purchasable,
    this.store,
    this.attributes,
    this.defaultAttributes,
    this.parentId,
    this.metaData,
    this.acf,
    this.brands,
    this.priceHtml,
    this.afcFields,
  });

  static String _fromJson(dynamic value) {
    if (value == '') return '0';
    if (value is String) return value;
    if (value is int || value is double) return value.toString();
    return '0';
  }

  static List<Map<String, dynamic>> _fromJsonImage(dynamic data) {
    if (data is! List) return [];
    List<Map<String, dynamic>> value = [];
    for (int i = 0; i < data.length; i++) {
      if (data[i] is Map) {
        value.add(data[i]);
      }
    }
    return value;
  }

  static Map _fromAcfFields(dynamic data) {
    if (data is! Map) return {};

    return data;
  }

  static List<int>? _toListInt(dynamic data) {
    if (data is List<dynamic>?) {
      return data?.map((e) => e as int).toList();
    }
    return null;
  }

  static int? _toInt(dynamic json) {
    return ConvertData.stringToInt(json);
  }

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  factory Product.fromVariation(Map<String, dynamic> json) => _productFromVariation(json);

  dynamic toVariable(String variable) {
    switch (variable) {
      case 'id':
        return id;
      case 'name':
        return name;
      case 'slug':
        return slug;
      case 'type':
        return type;
      case 'status':
        return status;
      case 'sku':
        return sku;
      case 'stock_status':
        return stockStatus;
      case 'categories':
        return categories?.map((e) => '${e?.id}').toList() ?? [];
      default:
        return '';
    }
  }

  static List<String> variableKeys = ['id', 'name', 'slug', 'type', 'status', 'sku', 'stock_status', 'categories'];
}

Product _productFromVariation(dynamic json) {
  Map<String, dynamic> product = Map<String, dynamic>.of(json);
  product.update('attributes', (value) => null, ifAbsent: () => null);
  return Product.fromJson(product);
}

class ProductBlocks {
  ProductBlocks._();

  static const String category = 'Category';
  static const String name = 'Name';
  static const String rating = 'Rating';
  static const String price = 'Price';
  static const String status = 'Status';
  static const String type = 'Type';
  static const String sku = 'Sku';
  static const String quantity = 'Quantity';
  static const String sortDescription = 'SortDescription';
  static const String description = 'Description';
  static const String additionInformation = 'AdditionInformation';
  static const String review = 'Review';
  static const String relatedProduct = 'RelatedProduct';
  static const String upsellProduct = 'UpsellProduct';
  static const String addToCart = 'AddToCart';
  static const String action = 'Action';
  static const String custom = 'Custom';
  static const String store = 'Store';
  static const String featuredImage = 'FeaturedImage';
  static const String addOns = 'AddOns';
  static const String brand = 'Brand';
  static const String html = 'Html';
  static const String advancedField = 'AdvancedCustomFields';
  static const String webview = 'Webview';
  static const String productItem = 'ProductItem';
  static const String divider = 'Divider';
}
