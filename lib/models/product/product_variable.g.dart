// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_variable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductVariable _$ProductVariableFromJson(Map<String, dynamic> json) => ProductVariable(
      ids: ProductVariable._toMapInt(json['attribute_ids']),
      labels: ProductVariable._toMapString(json['attribute_labels']),
      terms: ProductVariable._toMapListString(json['attribute_terms']),
      variations: (json['variations'] as List<dynamic>?)?.map((e) => e as Map<String, dynamic>).toList(),
    )
      ..termsLabels = ProductVariable._toMapString(json['attribute_terms_labels'])
      ..values = (json['attribute_terms_values'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, Map<String, String>.from(e as Map)),
      );

Map<String, dynamic> _$ProductVariableToJson(ProductVariable instance) => <String, dynamic>{
      'attribute_ids': instance.ids,
      'attribute_labels': instance.labels,
      'attribute_terms': instance.terms,
      'attribute_terms_labels': instance.termsLabels,
      'attribute_terms_values': instance.values,
      'variations': instance.variations,
    };
