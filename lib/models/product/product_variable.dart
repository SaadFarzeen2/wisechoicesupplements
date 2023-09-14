import 'package:json_annotation/json_annotation.dart';

part 'product_variable.g.dart';

@JsonSerializable()
class ProductVariable {
  @JsonKey(name: 'attribute_ids', fromJson: _toMapInt)
  Map<String, int>? ids;

  @JsonKey(name: 'attribute_labels', fromJson: _toMapString)
  Map<String, String>? labels;

  @JsonKey(name: 'attribute_terms', fromJson: _toMapListString)
  Map<String, List<String>>? terms;

  @JsonKey(name: 'attribute_terms_labels', fromJson: _toMapString)
  Map<String, String>? termsLabels;

  @JsonKey(name: 'attribute_terms_values')
  Map<String, Map<String, String>>? values;

  @JsonKey(name: 'variations')
  List<Map<String, dynamic>>? variations;

  ProductVariable({
    this.ids,
    this.labels,
    this.terms,
    this.variations,
  });

  factory ProductVariable.fromJson(Map<String, dynamic> json) => _$ProductVariableFromJson(json);

  Map<String, dynamic> toJson() => _$ProductVariableToJson(this);

  static Map<String, int>? _toMapInt(dynamic value) {
    Map<String, int>? data;
    if (value is Map) {
      data = value.map(
        (k, e) => MapEntry(k, e as int),
      );
    }
    return data;
  }

  static Map<String, String>? _toMapString(dynamic value) {
    Map<String, String>? data;
    if (value is Map) {
      data = value.map(
        (k, e) => MapEntry(k, e as String),
      );
    }
    return data;
  }

  static Map<String, List<String>>? _toMapListString(dynamic value) {
    Map<String, List<String>>? data;
    if (value is Map) {
      data = value.map(
        (k, e) => MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      );
    }
    return data;
  }
}
