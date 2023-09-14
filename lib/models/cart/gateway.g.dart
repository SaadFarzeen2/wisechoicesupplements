// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gateway.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Gateway _$GatewayFromJson(Map<String, dynamic> json) => Gateway(
      id: json['id'] as String,
      title: json['title'] as String?,
      description: json['description'] as String?,
      enabled: json['enabled'] as bool,
      settings: Gateway._toMap(json['settings']),
    );

Map<String, dynamic> _$GatewayToJson(Gateway instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'enabled': instance.enabled,
      'settings': instance.settings,
    };
