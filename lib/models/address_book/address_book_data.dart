import 'package:json_annotation/json_annotation.dart';

part 'address_book_data.g.dart';

@JsonSerializable()
class AddressBookData {
  @JsonKey(name: 'book_name')
  String? name;

  @JsonKey(name: 'book_address')
  String? address;

  @JsonKey(fromJson: _toMapString)
  Map<String, dynamic>? data;

  AddressBookData({
    this.name,
    this.address,
    this.data,
  });

  static Map<String, dynamic> _toMapString(dynamic value) {
    Map<String, dynamic> data = {};
    if (value is Map) {
      for (var key in value.keys) {
        data['$key'] = value[key];
      }
    }
    return data;
  }

  factory AddressBookData.fromJson(Map<String, dynamic> json) => _$AddressBookDataFromJson(json);

  Map<String, dynamic> toJson() => _$AddressBookDataToJson(this);
}
