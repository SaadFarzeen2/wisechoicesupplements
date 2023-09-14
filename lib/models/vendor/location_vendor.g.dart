// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_vendor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationVendor _$LocationVendorFromJson(Map<String, dynamic> json) => LocationVendor(
      address: json['find_address'] as String?,
      location: json['store_location'] as String?,
      lat: LocationVendor._doubleFromJson(json['store_lat']),
      lng: LocationVendor._doubleFromJson(json['store_lng']),
    );

Map<String, dynamic> _$LocationVendorToJson(LocationVendor instance) => <String, dynamic>{
      'find_address': instance.address,
      'store_location': instance.location,
      'store_lat': LocationVendor._doubleToJson(instance.lat),
      'store_lng': LocationVendor._doubleToJson(instance.lng),
    };
