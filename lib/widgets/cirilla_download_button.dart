import 'dart:io';

import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/models/download/download.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:dio/dio.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:awesome_icons/awesome_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

enum DownloadStatus {
  notDownloaded,
  fetchingDownload,
  downloading,
  downloaded,
}

abstract class DownloadController implements ChangeNotifier {
  DownloadStatus get downloadStatus;

  double get progress;

  void startDownload(Download download, String token);

  void stopDownload();

  void openDownload();
}

class HandleDownloadController extends DownloadController with ChangeNotifier {
  HandleDownloadController({
    DownloadStatus downloadStatus = DownloadStatus.notDownloaded,
    double progress = 0.0,
    required VoidCallback onOpenDownload,
    required DownloadCallbackType onCallbackDownload,
  })  : _downloadStatus = downloadStatus,
        _progress = progress,
        _onOpenDownload = onOpenDownload,
        _onCallbackDownload = onCallbackDownload;

  DownloadStatus _downloadStatus;

  late String _localPath;

  @override
  DownloadStatus get downloadStatus => _downloadStatus;

  double _progress;

  @override
  double get progress => _progress;

  final VoidCallback _onOpenDownload;

  final DownloadCallbackType _onCallbackDownload;

  bool _isDownloading = false;

  @override
  void startDownload(Download download, String token) {
    if (downloadStatus == DownloadStatus.notDownloaded || downloadStatus == DownloadStatus.downloaded) {
      _progress = 0.0;
      _handleDownload(download, token);
    }
  }

  @override
  void stopDownload() {
    if (_isDownloading) {
      _isDownloading = false;
      _downloadStatus = DownloadStatus.notDownloaded;
      _progress = 0.0;
      notifyListeners();
    }
  }

  @override
  void openDownload() {
    if (downloadStatus == DownloadStatus.downloaded) {
      _onOpenDownload();
    }
  }

  Future<String?> _findLocalPath() async {
    if (!isWeb && Platform.isAndroid) {
      return "/sdcard/download/";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return '${directory.path}${Platform.pathSeparator}Download';
    }
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;

    avoidPrint(_localPath);
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  // Requests storage permission
  Future<bool> _requestWritePermission() async {
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
      if (info.version.sdkInt >= 33) return true;
    }
    PermissionStatus status = await Permission.storage.request();
    if (!status.isGranted) {
      openAppSettings();
      return false;
    }
    return true;
  }

  String _getFileName(Download download) {
    List<String> arrFile = download.file?.file?.split('.') ?? [];
    String extensionFile = arrFile.isNotEmpty ? arrFile[arrFile.length - 1] : 'jpg';

    String fileName = download.file?.name ?? download.id!;

    if (fileName.endsWith(extensionFile)) {
      fileName.replaceAll(extensionFile, '');
    }

    return _checkExistFile(fileName, extensionFile);
  }

  String _checkExistFile(String fileName, String fileExtension) {
    String newFileName = "$fileName.$fileExtension";
    if (File('$_localPath$newFileName').existsSync()) {
      int number = 0;
      RegExp regex = RegExp("^(.+) \\((\\d+)\\)");
      if (regex.hasMatch(fileName)) {
        fileName = regex.firstMatch(fileName)?.group(1) ?? fileName;
        number = int.parse(regex.firstMatch(fileName)?.group(1) ?? number.toString());
      }
      do {
        number++;
        newFileName = "$fileName ($number).$fileExtension";
      } while (File('$_localPath$newFileName').existsSync());
    }
    debugPrint(newFileName);
    return newFileName;
  }

  String _getLocationFileDownload(Download download) {
    String fileName = _getFileName(download);
    return '$_localPath$fileName';
  }

  Future<void> _handleDownload(Download download, String token) async {
    _isDownloading = true;
    _downloadStatus = DownloadStatus.fetchingDownload;
    notifyListeners();

    // If the user chose to cancel the download, stop the simulation.
    if (!_isDownloading) {
      return;
    }

    // Requests permission for downloading the file
    bool hasPermission = await _requestWritePermission();
    avoidPrint('Has Permission Download: $hasPermission');
    if (!hasPermission) {
      return;
    }

    // Prepare save dir
    await _prepareSaveDir();

    // Shift to the downloading phase.
    _downloadStatus = DownloadStatus.downloading;
    notifyListeners();

    Dio dio = Dio();

    String url = token.isNotEmpty
        ? '${download.url}${download.url?.contains('?') == true ? '&' : '?'}app-builder-token=$token'
        : download.url ?? '';

    String locationFileDownload = _getLocationFileDownload(download);
    await dio.download(
      url,
      locationFileDownload,
      onReceiveProgress: (rec, total) {
        avoidPrint(rec / total);
        _progress = rec / total;
        notifyListeners();
      },
    );

    // If the user chose to cancel the download, stop the simulation.
    if (!_isDownloading) {
      return;
    }

    // Shift to the downloaded state, completing the simulation.
    _downloadStatus = DownloadStatus.downloaded;
    _isDownloading = false;
    notifyListeners();
    _onCallbackDownload(name: locationFileDownload.replaceFirst(_localPath, ''));
  }
}

class CirillaDownloadButton extends StatelessWidget {
  final DownloadStatus status;
  final VoidCallback onDownload;
  final VoidCallback onCancel;
  final VoidCallback onOpen;

  const CirillaDownloadButton({
    Key? key,
    required this.status,
    required this.onDownload,
    required this.onCancel,
    required this.onOpen,
  }) : super(key: key);

  void _onPressed() {
    switch (status) {
      case DownloadStatus.notDownloaded:
      case DownloadStatus.downloaded:
        onDownload();
        break;
      case DownloadStatus.downloading:
        onCancel();
        break;
      case DownloadStatus.fetchingDownload:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    IconData icon = FeatherIcons.download;

    if (status == DownloadStatus.downloading) {
      icon = FontAwesomeIcons.square;
    }

    return Column(
      children: [
        InkResponse(
          onTap: () => _onPressed(),
          radius: 25,
          child: Icon(
            icon,
            size: 20,
            color: theme.textTheme.titleMedium?.color,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

@immutable
class CirillaDownloadButtonLoading extends StatelessWidget {
  const CirillaDownloadButtonLoading({
    Key? key,
    this.downloadProgress = 0.0,
    this.transitionDuration = const Duration(milliseconds: 200),
  }) : super(key: key);

  final double downloadProgress;
  final Duration transitionDuration;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${(downloadProgress * 100).toInt()}%',
          style: theme.textTheme.labelSmall?.copyWith(color: theme.textTheme.titleMedium?.color),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: borderRadiusTiny,
          child: LinearProgressIndicator(
            value: downloadProgress,
            backgroundColor: theme.dividerColor,
            valueColor: AlwaysStoppedAnimation(theme.primaryColor),
            minHeight: 4,
          ),
        ),
      ],
    );
  }
}
