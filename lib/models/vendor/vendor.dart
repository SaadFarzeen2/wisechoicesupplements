import 'package:json_annotation/json_annotation.dart';
import 'address_vendor.dart';
import 'location_vendor.dart';

part 'vendor.g.dart';

@JsonSerializable()
class Vendor {
  int? id;

  @JsonKey(name: 'store_name')
  String? storeName;

  String? phone;

  String? email;

  @JsonKey(name: 'shop_description')
  String? description;

  @JsonKey(name: 'vendor_address')
  String? vendorAddress;

  @JsonKey(name: 'show_email')
  bool? showEmail;

  dynamic social;

  @JsonKey(name: 'banner', fromJson: _imageFromJson, toJson: _imageToJson)
  String? banner;

  @JsonKey(name: 'gravatar', fromJson: _imageFromJson, toJson: _imageToJson)
  String? gravatar;

  RatingVendor? rating;

  bool? featured;

  @JsonKey(fromJson: _addressFromJson, toJson: _addressToJson)
  AddressVendor? address;

  @JsonKey(name: 'customer_support', fromJson: _addressFromJson, toJson: _addressToJson)
  AddressVendor? customer;

  @JsonKey(name: 'geolocation', fromJson: _locationFromJson, toJson: _locationToJson)
  LocationVendor? location;

  @JsonKey(fromJson: _toMap)
  Map? distance;

  @JsonKey(fromJson: _toMap)
  Map? duration;

  static String _imageFromJson(dynamic value) => value is String ? value : '';

  static dynamic _imageToJson(String? data) {
    return data;
  }

  static AddressVendor? _addressFromJson(dynamic value) {
    if (value is Map<String, dynamic>) {
      return AddressVendor.fromJson(value);
    }
    return null;
  }

  static dynamic _addressToJson(AddressVendor? data) {
    if (data != null) {
      return data.toJson();
    }
    return {};
  }

  static LocationVendor? _locationFromJson(dynamic value) {
    if (value is Map<String, dynamic>) {
      return LocationVendor.fromJson(value);
    }
    return null;
  }

  static dynamic _locationToJson(LocationVendor? data) {
    if (data != null) {
      return data.toJson();
    }
    return {};
  }

  static Map? _toMap(dynamic value) {
    if (value is Map) {
      return value;
    }
    return null;
  }

  Vendor({
    this.id,
    this.storeName,
    this.description,
    this.phone,
    this.email,
    this.vendorAddress,
    this.showEmail,
    this.social,
    this.banner,
    this.gravatar,
    this.rating,
    this.featured,
    this.address,
    this.location,
    this.customer,
    this.duration,
    this.distance,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) => _$VendorFromJson(json);

  Map<String, dynamic> toJson() => _$VendorToJson(this);
}

@JsonSerializable()
class RatingVendor {
  double? rating;
  int? count;
  double? avg;

  RatingVendor({
    this.rating,
    this.count,
    this.avg,
  });

  factory RatingVendor.fromJson(Map<String, dynamic> json) => _$RatingVendorFromJson(json);

  Map<String, dynamic> toJson() => _$RatingVendorToJson(this);
}
