// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'near_place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NearPlace _$NearPlaceFromJson(Map<String, dynamic> json) => NearPlace(
      placeId: json['place_id'] as String,
      address: json['name'] as String,
      location: NearPlace._fromGeometry(json['geometry']),
    );

Map<String, dynamic> _$NearPlaceToJson(NearPlace instance) => <String, dynamic>{
      'place_id': instance.placeId,
      'name': instance.address,
      'geometry': instance.location,
    };
