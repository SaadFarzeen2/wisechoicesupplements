import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_download_button.dart';
import 'package:flutter/material.dart';

class FieldFile extends StatefulWidget with Utility {
  final dynamic value;
  final String format;

  const FieldFile({
    Key? key,
    this.value,
    this.format = 'array',
  }) : super(key: key);

  @override
  State<FieldFile> createState() => _FieldFileState();
}

class _FieldFileState extends State<FieldFile> {
  late final DownloadController _downloadController;

  @override
  void initState() {
    _downloadController = HandleDownloadController(
      onOpenDownload: () {
        _openDownload();
      },
      onCallbackDownload: ({required String name}) => downloadSuccess(),
    );
    super.initState();
  }

  void _openDownload() {
    avoidPrint('Open download');
  }

  void downloadSuccess() {
    ThemeData theme = Theme.of(context);
    final snackBar = SnackBar(
      backgroundColor: ColorBlock.green,
      content: Text(
        'Download success',
        style: theme.textTheme.titleSmall?.copyWith(color: Colors.white),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Download? getDataDownload(String url) {
    if (url.isNotEmpty) {
      late String name;
      List<String> arrUrl = url.split('/');
      String nameFile = arrUrl[arrUrl.length - 1];
      List<String> arrName = nameFile.split('.');
      name = arrName[0];
      return Download(
        url: url,
        file: FileDownload(
          name: name,
          file: url,
        ),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.format == 'id') {
      return Text('${widget.value}');
    }

    String url = '';
    switch (widget.format) {
      case 'array':
        if (widget.value is Map) {
          dynamic link = get(widget.value, ['url'], '');
          if (link is String) {
            url = link;
          }
        }
        break;
      case 'url':
        if (widget.value is String && widget.value.isNotEmpty == true) {
          url = widget.value;
        }
        break;
    }
    Download? download = getDataDownload(url);
    if (download == null) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AnimatedBuilder(
              animation: _downloadController,
              builder: (_, child) {
                return CirillaDownloadButton(
                  status: _downloadController.downloadStatus,
                  onDownload: () => _downloadController.startDownload(download, ''),
                  onCancel: _downloadController.stopDownload,
                  onOpen: _downloadController.openDownload,
                );
              },
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(download.url ?? ''))
          ],
        ),
        AnimatedBuilder(
          animation: _downloadController,
          builder: (context, child) {
            if (_downloadController.downloadStatus == DownloadStatus.downloading) {
              return Padding(
                padding: const EdgeInsets.only(top: itemPaddingMedium),
                child: CirillaDownloadButtonLoading(
                  downloadProgress: _downloadController.progress,
                ),
              );
            }
            return Container();
          },
        ),
      ],
    );
  }
}
