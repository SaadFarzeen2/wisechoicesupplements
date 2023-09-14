import 'package:json_annotation/json_annotation.dart';

part 'user_location.g.dart';

@JsonSerializable()
class UserLocation {
  String? id;

  double? lat;

  double? lng;

  String? address;

  String? tag;

  UserLocation({this.id, this.lat, this.lng, this.address, this.tag});

  factory UserLocation.fromJson(Map<String, dynamic> json) => _$UserLocationFromJson(json);

  Map<String, dynamic> toJson() => _$UserLocationToJson(this);

  @override
  String toString() {
    return '{"id": "$id", "lat": $lat, "lng": $lng, "address": "$address", "tag": "$tag"}';
  }
}

@JsonSerializable()
class PlaceDetail {
  String? streetNumber;

  String? street;

  String? administrativeArea;

  String? administrativeArea2;

  String? countryCode;

  String? types;

  double? lat;

  double? lng;

  PlaceDetail({
    this.streetNumber,
    this.street,
    this.administrativeArea,
    this.administrativeArea2,
    this.countryCode,
    this.types,
    this.lat,
    this.lng,
  });
  factory PlaceDetail.fromJson(Map<String, dynamic> json) => _$PlaceDetailFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceDetailToJson(this);
}
