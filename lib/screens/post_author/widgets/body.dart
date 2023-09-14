import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/models/post_author/post_author.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_post_item.dart';
import 'package:cirilla/widgets/widgets.dart';
// import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  final PostAuthor? author;

  const Body({
    Key? key,
    this.author,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> with PostAuthorMixin, LoadingMixin, AppBarMixin {
  final ScrollController _controller = ScrollController();

  late PostStore _postStore;
  late SettingStore _settingStore;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_controller.hasClients || _postStore.loading || !_postStore.canLoadMore) return;
    final thresholdReached = _controller.position.extentAfter < endReachedThreshold;
    if (thresholdReached) {
      _postStore.getPosts();
    }
  }

  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);
    _postStore =
        PostStore(_settingStore.requestHelper, perPage: 10, authors: [ConvertData.stringToInt(widget.author?.id)]);

    if (!_postStore.loading) {
      _postStore.getPosts();
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;
    PostAuthor? author = widget.author;
    if (author == null) {
      return CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: leading(),
            title: Text(translate('post_author_txt')),
            centerTitle: true,
            elevation: 0,
          )
        ],
      );
    }
    return Observer(
      builder: (_) {
        bool loading = _postStore.loading;
        List<Post> posts = _postStore.posts;
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          controller: _controller,
          slivers: <Widget>[
            buildAppbar(author: author, theme: theme, translate: translate),
            CupertinoSliverRefreshControl(
              onRefresh: _postStore.refresh,
              builder: buildAppRefreshIndicator,
            ),
            SliverPadding(
              padding: paddingHorizontal.copyWith(top: itemPaddingLarge),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Column(
                      children: [
                        CirillaPostItem(
                          post: loading && posts.isEmpty ? Post() : posts[index],
                          template: Strings.postItemHorizontal,
                          width: 120,
                          height: 120,
                        ),
                        const Divider(height: 48, thickness: 1),
                      ],
                    );
                  },
                  childCount: loading && posts.isEmpty ? 10 : posts.length,
                ),
              ),
            ),
            if (loading)
              SliverToBoxAdapter(
                child: buildLoading(context, isLoading: _postStore.canLoadMore),
              ),
          ],
        );
      },
    );
  }

  SliverAppBar buildAppbar({required PostAuthor author, required ThemeData theme, required TranslateType translate}) {
    double expandHeight = author.description is String && author.description != '' ? 350 : 300;
    return SliverAppBar(
      pinned: true,
      expandedHeight: expandHeight,
      title: Text(translate('post_author_txt')),
      centerTitle: true,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const <StretchMode>[
          StretchMode.zoomBackground,
        ],
        centerTitle: true,
        background: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              bottom: 0,
              right: 20,
              left: 20,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(45),
                    child: CirillaCacheImage(
                      author.avatar?.medium ?? '',
                      width: 90,
                      height: 90,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(author.name!, style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  if (author.description is String && author.description != '') ...[
                    Padding(
                      padding: paddingHorizontalLarge,
                      child: Text(
                        author.description!,
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  buildCount(
                    context,
                    author: author,
                    theme: theme,
                    color: theme.primaryColor,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: [
                      CirillaButtonSocial.facebook(
                        size: 34,
                        sizeIcon: 14,
                        boxFit: SocialBoxFit.outline,
                        type: SocialType.square,
                        onPressed: () {
                          avoidPrint('face');
                        },
                      ),
                      CirillaButtonSocial.google(
                        size: 34,
                        sizeIcon: 14,
                        boxFit: SocialBoxFit.outline,
                        type: SocialType.square,
                        onPressed: () {
                          avoidPrint('google');
                        },
                      ),
                      CirillaButtonSocial.twitter(
                        size: 34,
                        sizeIcon: 14,
                        boxFit: SocialBoxFit.outline,
                        type: SocialType.square,
                        onPressed: () {
                          avoidPrint('twitter');
                        },
                      ),
                      CirillaButtonSocial.pinterest(
                        size: 34,
                        sizeIcon: 14,
                        boxFit: SocialBoxFit.outline,
                        type: SocialType.square,
                        onPressed: () {
                          avoidPrint('pinterest');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Divider(height: 1, thickness: 1),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
