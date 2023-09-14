import 'package:json_annotation/json_annotation.dart';

part 'country_address.g.dart';

@JsonSerializable()
class CountryAddressData {
  String? name;
  String? code;

  CountryAddressData({this.name, this.code});
  factory CountryAddressData.fromJson(Map<String, dynamic> json) => _$CountryAddressDataFromJson(json);

  Map<String, dynamic> toJson() => _$CountryAddressDataToJson(this);
}
