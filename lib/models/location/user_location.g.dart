// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLocation _$UserLocationFromJson(Map<String, dynamic> json) => UserLocation(
      id: json['id'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      address: json['address'] as String?,
      tag: json['tag'] as String?,
    );

Map<String, dynamic> _$UserLocationToJson(UserLocation instance) => <String, dynamic>{
      'id': instance.id,
      'lat': instance.lat,
      'lng': instance.lng,
      'address': instance.address,
      'tag': instance.tag,
    };

PlaceDetail _$PlaceDetailFromJson(Map<String, dynamic> json) => PlaceDetail(
      streetNumber: json['streetNumber'] as String?,
      street: json['street'] as String?,
      administrativeArea: json['administrativeArea'] as String?,
      administrativeArea2: json['administrativeArea2'] as String?,
      countryCode: json['countryCode'] as String?,
      types: json['types'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PlaceDetailToJson(PlaceDetail instance) => <String, dynamic>{
      'streetNumber': instance.streetNumber,
      'street': instance.street,
      'administrativeArea': instance.administrativeArea,
      'administrativeArea2': instance.administrativeArea2,
      'countryCode': instance.countryCode,
      'types': instance.types,
      'lat': instance.lat,
      'lng': instance.lng,
    };
