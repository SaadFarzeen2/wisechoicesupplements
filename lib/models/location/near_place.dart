import 'package:cirilla/models/location/user_location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'near_place.g.dart';

@JsonSerializable()
class NearPlace {
  @JsonKey(name: 'place_id')
  String placeId;

  @JsonKey(name: 'name')
  String address;

  @JsonKey(name: 'geometry', fromJson: _fromGeometry)
  LatLng location;

  NearPlace({required this.placeId, required this.address, required this.location});

  factory NearPlace.fromJson(Map<String, dynamic> json) => _$NearPlaceFromJson(json);

  Map<String, dynamic> toJson() => _$NearPlaceToJson(this);

  static LatLng _fromGeometry(dynamic value) {
    Map<String, dynamic> location = value['location'];
    double lat = location['lat'];
    double lng = location['lng'];
    return LatLng(lat, lng);
  }

  UserLocation toUserLocation() {
    return UserLocation(id: placeId, address: address, lat: location.latitude, lng: location.longitude, tag: '');
  }
}
