import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class DownloadScreen extends StatefulWidget {
  static const String routeName = '/profile/download';

  const DownloadScreen({Key? key}) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> with AppBarMixin, LoadingMixin {
  final ScrollController _controller = ScrollController();
  DownloadStore? _downloadStore;
  SettingStore? _settingStore;
  late AuthStore _authStore;
  int typeView = 0;

  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);
    _authStore = Provider.of<AuthStore>(context);

    _downloadStore = DownloadStore(
      _settingStore!.requestHelper,
      userId: ConvertData.stringToInt(_authStore.user!.id),
    );
    _downloadStore!.getDownloads();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _controller.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (!_controller.hasClients || _downloadStore!.loading || !_downloadStore!.canLoadMore) return;
    final thresholdReached = _controller.position.extentAfter < endReachedThreshold;

    if (thresholdReached) {
      _downloadStore!.getDownloads();
    }
  }

  Widget buildList(List<Download> data, ThemeData theme) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Column(
      children: List.generate(data.length, (index) {
        double padBottom = index < data.length - 1 ? itemPaddingMedium : 0;
        return Padding(
          padding: EdgeInsets.only(bottom: padBottom),
          child: CirillaDownloadItem(
            download: data[index],
            callbackDownload: ({required String name}) {
              final snackBar = SnackBar(
                backgroundColor: ColorBlock.green,
                content: Text(
                  translate('download_completed', {'download': '"$name"'}),
                  style: theme.textTheme.titleSmall?.copyWith(color: Colors.white),
                ),
              );

              // Find the ScaffoldMessenger in the widget tree
              // and use it to show a SnackBar.
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              _downloadStore?.getDownloads();
            },
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Observer(builder: (_) {
      bool loading = _downloadStore!.loading;
      List<Download> downloads = _downloadStore!.downloads;
      List<Download> emptyDownloads = List.generate(_downloadStore!.perPage, (index) => Download());
      bool isShimmer = downloads.isEmpty && loading;

      return Scaffold(
        appBar: baseStyleAppBar(context, title: translate('download_title')),
        body: CustomScrollView(
          controller: _controller,
          physics: const BouncingScrollPhysics(),
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: _downloadStore!.refresh,
              builder: buildAppRefreshIndicator,
            ),
            SliverPadding(
              padding: paddingHorizontal,
              sliver: SliverToBoxAdapter(
                child: buildList(isShimmer ? emptyDownloads : downloads, theme),
              ),
            ),
          ],
        ),
      );
    });
  }
}
