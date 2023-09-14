// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Download _$DownloadFromJson(Map<String, dynamic> json) => Download(
      id: json['download_id'] as String?,
      name: json['download_name'] as String?,
      dateExpired: json['access_expires'] as String?,
      downloadRemaining: json['downloads_remaining'] as String?,
      url: json['download_url'] as String?,
      productId: json['product_id'] as int?,
      productName: json['product_name'] as String?,
      file: Download.toFileDownload(json['file']),
    );

Map<String, dynamic> _$DownloadToJson(Download instance) => <String, dynamic>{
      'download_id': instance.id,
      'download_name': instance.name,
      'access_expires': instance.dateExpired,
      'downloads_remaining': instance.downloadRemaining,
      'download_url': instance.url,
      'product_id': instance.productId,
      'product_name': instance.productName,
      'file': instance.file,
    };
