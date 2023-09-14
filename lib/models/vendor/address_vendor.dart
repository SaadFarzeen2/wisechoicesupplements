import 'package:json_annotation/json_annotation.dart';

part 'address_vendor.g.dart';

@JsonSerializable()
class AddressVendor {
  String? address1;

  String? address2;

  String? country;

  String? state;

  String? city;

  @JsonKey(name: 'street_1')
  String? street1;

  @JsonKey(name: 'street_2')
  String? street2;

  String? zip;

  String? phone;

  String? email;

  AddressVendor({
    this.address1,
    this.address2,
    this.country,
    this.state,
    this.city,
    this.street1,
    this.street2,
    this.zip,
    this.phone,
    this.email,
  });

  factory AddressVendor.fromJson(Map<String, dynamic> json) => _$AddressVendorFromJson(json);

  Map<String, dynamic> toJson() => _$AddressVendorToJson(this);
}
