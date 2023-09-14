import 'package:cirilla/models/location/user_location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'place.g.dart';

@JsonSerializable()
class Place {
  @JsonKey(name: 'place_id')
  String placeId;

  @JsonKey(name: 'address_components')
  List<AddressComponent> addressComponents;

  @JsonKey(name: 'formatted_address')
  String address;

  @JsonKey(name: 'geometry', fromJson: _fromGeometry)
  LatLng location;

  Place({required this.placeId, required this.addressComponents, required this.address, required this.location});

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceToJson(this);

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
@JsonSerializable()
class AddressComponent{

  @JsonKey(name: 'long_name')
  String? longName;

  @JsonKey(name: 'short_name')
  String? shortName;

  List<String>? types;

  AddressComponent({ this.longName, this.shortName,  this.types,});

  factory AddressComponent.fromJson(Map<String, dynamic> json) => _$AddressComponentFromJson(json);

  Map<String, dynamic> toJson() => _$AddressComponentToJson(this);

}
