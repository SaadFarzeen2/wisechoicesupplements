import 'package:json_annotation/json_annotation.dart';

part 'file_download.g.dart';

@JsonSerializable()
class FileDownload {
  String? name;
  String? file;

  FileDownload({
    this.name,
    this.file,
  });

  factory FileDownload.fromJson(Map<String, dynamic> json) => _$FileDownloadFromJson(json);

  Map<String, dynamic> toJson() => _$FileDownloadToJson(this);
}
