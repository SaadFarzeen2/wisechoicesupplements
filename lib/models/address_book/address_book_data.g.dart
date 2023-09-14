// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_book_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressBookData _$AddressBookDataFromJson(Map<String, dynamic> json) =>
    AddressBookData(
      name: json['book_name'] as String?,
      address: json['book_address'] as String?,
      data: AddressBookData._toMapString(json['data']),
    );

Map<String, dynamic> _$AddressBookDataToJson(AddressBookData instance) =>
    <String, dynamic>{
      'book_name': instance.name,
      'book_address': instance.address,
      'data': instance.data,
    };
