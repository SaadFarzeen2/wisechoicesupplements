import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_detail_value.g.dart';

@JsonSerializable()
class ProductDetailValue {
  String? type;

  @JsonKey(defaultValue: 'text')
  String? customType;

  Map<String, dynamic>? text;

  Map<String, dynamic>? icon;

  Map<String, dynamic>? buttonBg;

  Map<String, dynamic>? buttonBorderColor;

  @JsonKey(fromJson: _toDouble)
  double? buttonBorderWidth;

  @JsonKey(fromJson: _toSize, toJson: _toJsonSize)
  Size? buttonSize;

  @JsonKey(fromJson: _toDouble)
  double? buttonBorderRadius;

  Map<String, dynamic>? iconColor;

  @JsonKey(fromJson: _toDouble)
  double? iconSize;

  Map<String, dynamic>? image;

  @JsonKey(fromJson: _toSize, toJson: _toJsonSize)
  Size? imageSize;

  @JsonKey(fromJson: _toMapAction)
  Map<String, dynamic>? action;

  String? customFieldName;

  ProductDetailValue({
    this.type,
    this.customType,
    this.text,
    this.image,
    this.action,
    this.buttonBg,
    this.buttonBorderColor,
    this.buttonBorderRadius,
    this.buttonBorderWidth,
    this.buttonSize,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.imageSize,
    this.customFieldName,
  });

  factory ProductDetailValue.fromJson(Map<String, dynamic> json) => _$ProductDetailValueFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDetailValueToJson(this);

  static Size? _toSize(dynamic value) {
    if (value is Map) {
      double width = ConvertData.stringToDouble(get(value, ['width'], 0));
      double height = ConvertData.stringToDouble(get(value, ['height'], 0));
      return Size(width, height);
    }
    return null;
  }

  static dynamic _toJsonSize(Size? value) {
    if (value != null) {
      return {
        'width': value.width,
        'height': value.height,
      };
    }
    return null;
  }

  static double? _toDouble(dynamic value) {
    if (value != null) {
      return ConvertData.stringToDouble(value);
    }
    return null;
  }

  static Map<String, dynamic>? _toMapAction(dynamic value) {
    if (value is Map) {
      return value.map((key, data) => MapEntry(key.toString(), data));
    }
    return null;
  }
}
