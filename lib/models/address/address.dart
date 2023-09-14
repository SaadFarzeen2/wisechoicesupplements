import 'package:json_annotation/json_annotation.dart';

import 'country_address.dart';

part 'address.g.dart';

@JsonSerializable()
class AddressData {
  String? country;

  @JsonKey(fromJson: _toMapString)
  Map<String, dynamic>? billing;

  @JsonKey(fromJson: _toMapString)
  Map<String, dynamic>? shipping;

  @JsonKey(name: 'address_format', fromJson: _toMapString)
  Map<String, dynamic>? format;

  @JsonKey(name: 'billing_countries_states', fromJson: _toMapCountryData)
  Map<String, List<CountryAddressData>>? billingStates;

  @JsonKey(name: 'billing_countries', fromJson: _toCountryData)
  List<CountryAddressData>? billingCountries;

  @JsonKey(name: 'shipping_countries', fromJson: _toCountryData)
  List<CountryAddressData>? shippingCountries;

  @JsonKey(name: 'shipping_country_states', fromJson: _toMapCountryData)
  Map<String, List<CountryAddressData>>? shippingStates;

  @JsonKey(name: 'shipping_countries_selected')
  String? shippingSelected;

  AddressData({
    this.country,
    this.billing,
    this.shipping,
    this.format,
    this.billingStates,
    this.billingCountries,
    this.shippingStates,
    this.shippingCountries,
    this.shippingSelected,
  });

  factory AddressData.fromJson(Map<String, dynamic> json) => _$AddressDataFromJson(json);

  Map<String, dynamic> toJson() => _$AddressDataToJson(this);

  static Map<String, dynamic> _toMapString(dynamic value) {
    Map<String, dynamic> data = {};
    if (value is Map) {
      for (var key in value.keys) {
        data['$key'] = value[key];
      }
    }
    return data;
  }

  static Map<String, List<CountryAddressData>> _toMapCountryData(dynamic value) {
    Map<String, List<CountryAddressData>> data = {};
    if (value is Map) {
      for (var key in value.keys) {
        data['$key'] = _toCountryData(value[key]);
      }
    }
    return data;
  }

  static List<CountryAddressData> _toCountryData(dynamic value) {
    List<CountryAddressData> data = [];
    if (value is Map) {
      for (var key in value.keys) {
        data.add(CountryAddressData(
          code: '$key',
          name: '${value[key]}',
        ));
      }
    }
    return data;
  }
}
