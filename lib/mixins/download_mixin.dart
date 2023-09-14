import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_shimmer.dart';
import 'package:flutter/material.dart';

mixin DownloadMixin {
  Widget buildProductName(BuildContext context, {Download? download, required ThemeData theme}) {
    if (download?.id == null) {
      return CirillaShimmer(
        child: Container(
          height: 20,
          width: 200,
          color: Colors.white,
        ),
      );
    }
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushNamed('${ProductScreen.routeName}/${download!.productId}');
      },
      style: TextButton.styleFrom(
        minimumSize: const Size(0, 0),
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: theme.textTheme.titleSmall,
      ),
      child: Text(download!.productName!),
    );
  }

  Widget _buildView({required String title, required String subTitle, required ThemeData theme}) {
    return RichText(
      text: TextSpan(
        text: title,
        children: [
          TextSpan(text: '  $subTitle', style: theme.textTheme.bodySmall),
        ],
        style:
            theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.titleMedium?.color, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget buildRemaining(BuildContext context, {Download? download, required ThemeData theme}) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    if (download?.id == null) {
      return CirillaShimmer(
        child: Container(
          height: 14,
          width: 120,
          color: Colors.white,
        ),
      );
    }
    return _buildView(
      title: translate('download_remain'),
      subTitle: download?.downloadRemaining != 'unlimited' ? download!.downloadRemaining! : '∞',
      theme: theme,
    );
  }

  Widget buildExpire(BuildContext context, {Download? download, required ThemeData theme}) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    if (download?.id == null) {
      return CirillaShimmer(
        child: Container(
          height: 14,
          width: 90,
          color: Colors.white,
        ),
      );
    }
    return _buildView(
      title: translate('download_expire'),
      subTitle: download?.dateExpired != 'never'
          ? formatDate(
              date: download!.dateExpired!,
              dateFormat: 'MM/dd/yyyy',
            )
          : translate('download_never'),
      theme: theme,
    );
  }

  Widget buildFileName(BuildContext context, {Download? download, required ThemeData theme}) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    if (download?.id == null) {
      return CirillaShimmer(
        child: Container(
          height: 14,
          width: 75,
          color: Colors.white,
        ),
      );
    }
    return _buildView(
      title: translate('download_file_name'),
      subTitle: download!.file!.name!,
      theme: theme,
    );
  }

  Widget buildButtonDownload({
    Download? download,
    required Widget button,
  }) {
    if (download?.id == null) {
      return CirillaShimmer(
        child: Container(
          height: 30,
          width: 30,
          color: Colors.white,
        ),
      );
    }
    return button;
  }
}
