// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressBook _$AddressBookFromJson(Map<String, dynamic> json) => AddressBook(
      billingEnable: json['billing_enable'] as bool?,
      shippingEnable: json['shipping_enable'] as bool?,
      billing: AddressBook._toAddressData(json['billing']),
      shipping: AddressBook._toAddressData(json['shipping']),
      newBillingName: json['new_billing_name'] as String?,
      newShippingName: json['new_shipping_name'] as String?,
    );

Map<String, dynamic> _$AddressBookToJson(AddressBook instance) =>
    <String, dynamic>{
      'billing_enable': instance.billingEnable,
      'shipping_enable': instance.shippingEnable,
      'billing': instance.billing,
      'shipping': instance.shipping,
      'new_billing_name': instance.newBillingName,
      'new_shipping_name': instance.newShippingName,
    };
