import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer {
  int? id;
  String? username;
  @JsonKey(name: 'first_name')
  String? firstName;
  @JsonKey(name: 'last_name')
  String? lastName;
  String? role;
  String? email;
  Map<String, dynamic>? billing;
  Map<String, dynamic>? shipping;
  @JsonKey(name: 'avatar_url')
  String? avatar;

  @JsonKey(name: 'meta_data', fromJson: _fromListMeta)
  List<Map<String, dynamic>>? metaData;

  Customer({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.role,
    this.email,
    this.billing,
    this.shipping,
    this.avatar,
  });
  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);

  static List<Map<String, dynamic>> _fromListMeta(dynamic value) {
    List<Map<String, dynamic>> data = [];

    if (value is List) {
      for (var item in value) {
        if (item is Map) {
          data.add(item.map((key, value) => MapEntry(key.toString(), value)));
        }
      }
    }

    return data;
  }

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
