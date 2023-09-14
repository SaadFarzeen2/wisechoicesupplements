import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/search/search_post_store.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:ui/notification/notification_screen.dart';

import '../../../../mixins/mixins.dart';

class ResultPost extends StatefulWidget {
  final String? search;
  final Function? clearText;

  const ResultPost({
    Key? key,
    this.search,
    this.clearText,
  }) : super(key: key);

  @override
  State<ResultPost> createState() => _ResultPostState();
}

class _ResultPostState extends State<ResultPost> with LoadingMixin {
  late SearchPostStore _searchPostStore;
  late SettingStore _settingStore;
  late PostStore _postStore;
  late AppStore _appStore;
  final ScrollController _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settingStore = Provider.of<SettingStore>(context);
    _searchPostStore = SearchPostStore(_settingStore.persistHelper);
    _appStore = Provider.of<AppStore>(context);

    if (_appStore.getStoreByKey('post_search_${widget.search}') == null) {
      _postStore = PostStore(
        Provider.of<RequestHelper>(context),
        search: widget.search,
        key: 'post_search_${widget.search}',
        lang: _settingStore.locale,
      )..getPosts();

      _appStore.addStore(_postStore);
    } else {
      _postStore = _appStore.getStoreByKey('post_search_${widget.search}');
    }
  }

  void _onScroll() {
    if (!_controller.hasClients || _postStore.loading || !_postStore.canLoadMore) return;
    final thresholdReached = _controller.position.extentAfter < endReachedThreshold;

    if (thresholdReached) {
      _postStore.getPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Observer(
      key: Key('post_search_${widget.search}'),
      builder: (context) {
        if (widget.search!.trim() != '') {
          _searchPostStore.addSearch('${widget.search}');
        }
        List<Post> posts = _postStore.posts;
        List<Post> loadingProduct = List.generate(_postStore.perPage, (index) => Post()).toList();

        bool loading = _postStore.loading;
        bool isShimmer = posts.isEmpty && loading;

        List<Post> data = isShimmer ? loadingProduct : posts;
        if (data.isNotEmpty) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            controller: _controller,
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: _postStore.refresh,
                builder: buildAppRefreshIndicator,
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: List.generate(
                    data.length,
                    (index) {
                      return PostSearchItem(
                        post: data[index],
                        searchPostStore: _searchPostStore,
                      );
                    },
                  ),
                ),
              ),
              if (loading)
                SliverToBoxAdapter(
                  child: buildLoading(context, isLoading: _postStore.canLoadMore),
                ),
            ],
          );
        }

        return NotificationScreen(
          title: Text(translate('post_search_results'), style: Theme.of(context).textTheme.titleLarge),
          content: Padding(
              padding: paddingHorizontal,
              child: Text(
                translate('post_no_post_were_found'),
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              )),
          iconData: FeatherIcons.search,
          textButton: Text(
            translate('product_clear'),
            style: TextStyle(color: Theme.of(context).textTheme.titleMedium?.color),
          ),
          styleBtn: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 61),
              backgroundColor: Theme.of(context).colorScheme.surface,
              shadowColor: Colors.transparent),
          onPressed: () {
            widget.clearText?.call();
          },
        );
      },
    );
  }
}

class PostSearchItem extends StatelessWidget with PostMixin {
  final Post post;
  final SearchPostStore searchPostStore;
  const PostSearchItem({
    Key? key,
    required this.post,
    required this.searchPostStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ListTile(
      title: buildName(theme, post),
      onTap: () {
        searchPostStore.addSearch('${post.title}');
        Navigator.pushNamed(
          context,
          '${PostScreen.routeName}/${post.id}/${post.slug}',
          arguments: {'post': post},
        );
      },
    );
  }
}
