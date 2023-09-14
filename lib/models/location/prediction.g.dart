// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prediction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Prediction _$PredictionFromJson(Map<String, dynamic> json) => Prediction(
      description: json['description'] as String,
      matchedSubstrings: (json['matched_substrings'] as List<dynamic>)
          .map((e) => MatchedSubstring.fromJson(e as Map<String, dynamic>))
          .toList(),
      structuredFormatting: StructuredFormatting.fromJson(json['structured_formatting'] as Map<String, dynamic>),
      terms: (json['terms'] as List<dynamic>).map((e) => Term.fromJson(e as Map<String, dynamic>)).toList(),
      types: Prediction.fromType(json['types'] as List?),
      placeId: json['place_id'] as String?,
    );

Map<String, dynamic> _$PredictionToJson(Prediction instance) => <String, dynamic>{
      'description': instance.description,
      'matched_substrings': instance.matchedSubstrings,
      'place_id': instance.placeId,
      'structured_formatting': instance.structuredFormatting,
      'terms': instance.terms,
      'types': instance.types,
    };

MatchedSubstring _$MatchedSubstringFromJson(Map<String, dynamic> json) => MatchedSubstring(
      length: json['length'] as int,
      offset: json['offset'] as int,
    );

Map<String, dynamic> _$MatchedSubstringToJson(MatchedSubstring instance) => <String, dynamic>{
      'length': instance.length,
      'offset': instance.offset,
    };

Term _$TermFromJson(Map<String, dynamic> json) => Term(
      offset: json['offset'] as int,
      value: json['value'] as String,
    );

Map<String, dynamic> _$TermToJson(Term instance) => <String, dynamic>{
      'offset': instance.offset,
      'value': instance.value,
    };

StructuredFormatting _$StructuredFormattingFromJson(Map<String, dynamic> json) => StructuredFormatting(
      mainText: json['main_text'] as String,
      mainTextMatchedSubstrings: (json['main_text_matched_substrings'] as List<dynamic>)
          .map((e) => MainTextMatchedSubstring.fromJson(e as Map<String, dynamic>))
          .toList(),
      secondaryText: json['secondary_text'] as String,
    );

Map<String, dynamic> _$StructuredFormattingToJson(StructuredFormatting instance) => <String, dynamic>{
      'main_text': instance.mainText,
      'main_text_matched_substrings': instance.mainTextMatchedSubstrings,
      'secondary_text': instance.secondaryText,
    };

MainTextMatchedSubstring _$MainTextMatchedSubstringFromJson(Map<String, dynamic> json) => MainTextMatchedSubstring(
      length: json['length'] as int,
      offset: json['offset'] as int,
    );

Map<String, dynamic> _$MainTextMatchedSubstringToJson(MainTextMatchedSubstring instance) => <String, dynamic>{
      'length': instance.length,
      'offset': instance.offset,
    };
