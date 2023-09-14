// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vendor _$VendorFromJson(Map<String, dynamic> json) => Vendor(
      id: json['id'] as int?,
      storeName: json['store_name'] as String?,
      description: json['shop_description'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      vendorAddress: json['vendor_address'] as String?,
      showEmail: json['show_email'] as bool?,
      social: json['social'],
      banner: Vendor._imageFromJson(json['banner']),
      gravatar: Vendor._imageFromJson(json['gravatar']),
      rating: json['rating'] == null ? null : RatingVendor.fromJson(json['rating'] as Map<String, dynamic>),
      featured: json['featured'] as bool?,
      address: Vendor._addressFromJson(json['address']),
      location: Vendor._locationFromJson(json['geolocation']),
      customer: Vendor._addressFromJson(json['customer_support']),
      duration: Vendor._toMap(json['duration']),
      distance: Vendor._toMap(json['distance']),
    );

Map<String, dynamic> _$VendorToJson(Vendor instance) => <String, dynamic>{
      'id': instance.id,
      'store_name': instance.storeName,
      'phone': instance.phone,
      'email': instance.email,
      'shop_description': instance.description,
      'vendor_address': instance.vendorAddress,
      'show_email': instance.showEmail,
      'social': instance.social,
      'banner': Vendor._imageToJson(instance.banner),
      'gravatar': Vendor._imageToJson(instance.gravatar),
      'rating': instance.rating,
      'featured': instance.featured,
      'address': Vendor._addressToJson(instance.address),
      'customer_support': Vendor._addressToJson(instance.customer),
      'geolocation': Vendor._locationToJson(instance.location),
      'duration': instance.duration,
      'distance': instance.distance,
    };

RatingVendor _$RatingVendorFromJson(Map<String, dynamic> json) => RatingVendor(
      rating: (json['rating'] as num?)?.toDouble(),
      count: json['count'] as int?,
      avg: (json['avg'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$RatingVendorToJson(RatingVendor instance) => <String, dynamic>{
      'rating': instance.rating,
      'count': instance.count,
      'avg': instance.avg,
    };
