// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_detail_value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDetailValue _$ProductDetailValueFromJson(Map<String, dynamic> json) => ProductDetailValue(
      type: json['type'] as String?,
      customType: json['customType'] as String? ?? 'text',
      text: json['text'] as Map<String, dynamic>?,
      image: json['image'] as Map<String, dynamic>?,
      action: ProductDetailValue._toMapAction(json['action']),
      buttonBg: json['buttonBg'] as Map<String, dynamic>?,
      buttonBorderColor: json['buttonBorderColor'] as Map<String, dynamic>?,
      buttonBorderRadius: ProductDetailValue._toDouble(json['buttonBorderRadius']),
      buttonBorderWidth: ProductDetailValue._toDouble(json['buttonBorderWidth']),
      buttonSize: ProductDetailValue._toSize(json['buttonSize']),
      icon: json['icon'] as Map<String, dynamic>?,
      iconColor: json['iconColor'] as Map<String, dynamic>?,
      iconSize: ProductDetailValue._toDouble(json['iconSize']),
      imageSize: ProductDetailValue._toSize(json['imageSize']),
      customFieldName: json['customFieldName'] as String?,
    );

Map<String, dynamic> _$ProductDetailValueToJson(ProductDetailValue instance) => <String, dynamic>{
      'type': instance.type,
      'customType': instance.customType,
      'text': instance.text,
      'icon': instance.icon,
      'buttonBg': instance.buttonBg,
      'buttonBorderColor': instance.buttonBorderColor,
      'buttonBorderWidth': instance.buttonBorderWidth,
      'buttonSize': ProductDetailValue._toJsonSize(instance.buttonSize),
      'buttonBorderRadius': instance.buttonBorderRadius,
      'iconColor': instance.iconColor,
      'iconSize': instance.iconSize,
      'image': instance.image,
      'imageSize': ProductDetailValue._toJsonSize(instance.imageSize),
      'action': instance.action,
      'customFieldName': instance.customFieldName,
    };
