import 'package:cirilla/mixins/utility_mixin.dart' show get;
import 'package:json_annotation/json_annotation.dart';

import 'file_download.dart';

part 'download.g.dart';

@JsonSerializable()
class Download {
  @JsonKey(name: 'download_id')
  String? id;

  @JsonKey(name: 'download_name')
  String? name;

  @JsonKey(name: 'access_expires')
  String? dateExpired;

  @JsonKey(name: 'downloads_remaining')
  String? downloadRemaining;

  @JsonKey(name: 'download_url')
  String? url;

  @JsonKey(name: 'product_id')
  int? productId;

  @JsonKey(name: 'product_name')
  String? productName;

  @JsonKey(fromJson: toFileDownload)
  FileDownload? file;

  Download({
    this.id,
    this.name,
    this.dateExpired,
    this.downloadRemaining,
    this.url,
    this.productId,
    this.productName,
    this.file,
  });

  static FileDownload toFileDownload(dynamic data) {
    return FileDownload(
      name: get(data, ['name'], ''),
      file: get(data, ['file'], ''),
    );
  }

  factory Download.fromJson(Map<String, dynamic> json) => _$DownloadFromJson(json);

  Map<String, dynamic> toJson() => _$DownloadToJson(this);
}
