// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_vendor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressVendor _$AddressVendorFromJson(Map<String, dynamic> json) => AddressVendor(
      address1: json['address1'] as String?,
      address2: json['address2'] as String?,
      country: json['country'] as String?,
      state: json['state'] as String?,
      city: json['city'] as String?,
      street1: json['street_1'] as String?,
      street2: json['street_2'] as String?,
      zip: json['zip'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$AddressVendorToJson(AddressVendor instance) => <String, dynamic>{
      'address1': instance.address1,
      'address2': instance.address2,
      'country': instance.country,
      'state': instance.state,
      'city': instance.city,
      'street_1': instance.street1,
      'street_2': instance.street2,
      'zip': instance.zip,
      'phone': instance.phone,
      'email': instance.email,
    };
