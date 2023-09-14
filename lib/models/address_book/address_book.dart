import 'package:json_annotation/json_annotation.dart';

import 'address_book_data.dart';

part 'address_book.g.dart';

@JsonSerializable()
class AddressBook {
  @JsonKey(name: 'billing_enable')
  bool? billingEnable;

  @JsonKey(name: 'shipping_enable')
  bool? shippingEnable;

  @JsonKey(fromJson: _toAddressData)
  List<AddressBookData>? billing;

  @JsonKey(fromJson: _toAddressData)
  List<AddressBookData>? shipping;

  @JsonKey(name: 'new_billing_name')
  String? newBillingName;

  @JsonKey(name: 'new_shipping_name')
  String? newShippingName;

  AddressBook({
    this.billingEnable,
    this.shippingEnable,
    this.billing,
    this.shipping,
    this.newBillingName,
    this.newShippingName,
  });

  static List<AddressBookData> _toAddressData(dynamic value) {
    List<AddressBookData> data = [];
    if (value is List) {
      data = value.map((item) => AddressBookData.fromJson(item)).toList();
    }
    return data;
  }

  factory AddressBook.fromJson(Map<String, dynamic> json) => _$AddressBookFromJson(json);

  Map<String, dynamic> toJson() => _$AddressBookToJson(this);
}
