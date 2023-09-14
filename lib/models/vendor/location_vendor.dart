import 'package:cirilla/utils/utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location_vendor.g.dart';

@JsonSerializable()
class LocationVendor {
  @JsonKey(name: 'find_address')
  String? address;

  @JsonKey(name: 'store_location')
  String? location;

  @JsonKey(name: 'store_lat', fromJson: _doubleFromJson, toJson: _doubleToJson)
  double? lat;

  @JsonKey(name: 'store_lng', fromJson: _doubleFromJson, toJson: _doubleToJson)
  double? lng;

  LocationVendor({
    this.address,
    this.location,
    this.lat,
    this.lng,
  });

  static double _doubleFromJson(dynamic value) {
    return ConvertData.stringToDouble(value, 0);
  }

  static dynamic _doubleToJson(double? data) {
    return data?.toString() ?? '0';
  }

  factory LocationVendor.fromJson(Map<String, dynamic> json) => _$LocationVendorFromJson(json);

  Map<String, dynamic> toJson() => _$LocationVendorToJson(this);
}
