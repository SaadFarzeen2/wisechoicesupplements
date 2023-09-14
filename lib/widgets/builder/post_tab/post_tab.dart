import 'package:awesome_drawer_bar/awesome_drawer_bar.dart';
import 'package:cirilla/constants/app.dart';
import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../post/post.dart';

class PostTabWidget extends StatefulWidget {
  final WidgetConfig? widgetConfig;

  const PostTabWidget({
    Key? key,
    this.widgetConfig,
  }) : super(key: key);

  @override
  State<PostTabWidget> createState() => _PostTabWidgetState();
}

class _PostTabWidgetState extends State<PostTabWidget> with Utility, ContainerMixin, SingleTickerProviderStateMixin {
  SettingStore? _settingStore;
  TabController? _tabController;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> fields = widget.widgetConfig?.fields ?? {};
    List items = get(fields, ['items'], []);
    _tabController = TabController(vsync: this, length: items.length);
  }

  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);
    super.didChangeDependencies();
  }

  void _onChanged(index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    String themeModeKey = _settingStore?.themeModeKey ?? 'value';
    String lang = _settingStore?.locale ?? defaultLanguage;

    // Styles
    Map<String, dynamic> styles = widget.widgetConfig?.styles ?? {};
    Map? margin = get(styles, ['margin'], {});
    Map? padding = get(styles, ['padding'], {});
    Color background = ConvertData.fromRGBA(get(styles, ['background', themeModeKey], {}), Colors.transparent);

    // Config general
    Map<String, dynamic> fields = widget.widgetConfig?.fields ?? {};
    double? pad = ConvertData.stringToDouble(get(fields, ['pad'], '0'));
    bool? enableDrawer = get(fields, ['enableDrawer'], false);
    List items = get(fields, ['items'], []);

    if (items.isEmpty) {
      return Container();
    }

    String idPosts = '${widget.widgetConfig!.id}_$_index';

    return Container(
      margin: ConvertData.space(margin, 'margin'),
      padding: ConvertData.space(padding, 'padding'),
      decoration: decorationColorImage(color: background),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (enableDrawer!) ...[
                InkWell(
                  onTap: () => AwesomeDrawerBar.of(context)!.toggle(),
                  child: Icon(
                    FeatherIcons.menu,
                    size: 20,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(width: 32),
              ],
              Expanded(
                child: Theme(
                    data: theme.copyWith(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                    ),
                    child: TabBar(
                      labelPadding: const EdgeInsetsDirectional.only(end: 32),
                      onTap: _onChanged,
                      isScrollable: true,
                      labelColor: theme.primaryColor,
                      controller: _tabController,
                      labelStyle: theme.textTheme.titleSmall,
                      unselectedLabelColor: theme.textTheme.titleSmall?.color,
                      indicatorWeight: 2,
                      indicatorPadding: const EdgeInsetsDirectional.only(end: 32),
                      indicatorColor: theme.primaryColor,
                      tabs: List.generate(
                        items.length,
                        (inx) {
                          Map<String, dynamic> item = items[inx];
                          String name = ConvertData.stringFromConfigs(get(item, ['data', 'name'], ''), lang)!;
                          return Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(name),
                          );
                        },
                      ).toList(),
                    )),
              ),
            ],
          ),
          if (items[_index]['data'] is Map<String, dynamic>) ...[
            SizedBox(height: pad),
            PostListWidget(
              id: idPosts,
              key: Key(idPosts),
              fields: items[_index]['data'],
              styles: styles,
            ),
          ],
        ],
      ),
    );
  }
}

class PostListWidget extends StatefulWidget {
  final String? id;
  final Map<String, dynamic>? fields;
  final Map<String, dynamic> styles;

  const PostListWidget({
    Key? key,
    this.id,
    this.fields = const {},
    this.styles = const {},
  }) : super(key: key);

  @override
  State<PostListWidget> createState() => _PostListWidgetState();
}

class _PostListWidgetState extends State<PostListWidget> with Utility, PostMixin {
  late AppStore _appStore;
  SettingStore? _settingStore;
  PostStore? _postStore;

  @override
  void didChangeDependencies() {
    _appStore = Provider.of<AppStore>(context);
    _settingStore = Provider.of<SettingStore>(context);

    String lang = _settingStore?.locale ?? defaultLanguage;

    String? postType = get(widget.fields, ['postType'], 'posts');

    int page = ConvertData.stringToInt(get(widget.fields, ['page'], '1'));
    int perPage = ConvertData.stringToInt(get(widget.fields, ['perPage'], '10'));

    String? search = get(widget.fields, ['search', _settingStore!.languageKey], '');
    List<dynamic> tags = get(widget.fields, ['tags'], []);
    List<dynamic> categories = get(widget.fields, ['categories'], []);
    List<dynamic> post = get(widget.fields, ['post'], []);

    // Gen key for store
    List<PostTag> tagsObj = tags.map((t) => PostTag(id: ConvertData.stringToInt(t['key']))).toList();
    List<PostCategory> catsObj = categories.map((t) => PostCategory(id: ConvertData.stringToInt(t['key']))).toList();
    List<Post> includePostObj = post.map((t) => Post(id: ConvertData.stringToInt(t['key']))).toList();

    String? key = StringGenerate.getPostKeyStore(
      widget.id,
      language: _settingStore!.locale,
      search: search,
      page: page,
      perPage: perPage,
      tags: tagsObj,
      categories: catsObj,
      includePost: includePostObj,
      postType: postType,
    );

    // Add store to list store
    if (widget.id != null && _appStore.getStoreByKey(key) == null) {
      PostStore store = PostStore(_settingStore!.requestHelper,
          key: key,
          page: page,
          perPage: perPage,
          search: search,
          tags: tags.map((t) => PostTag(id: ConvertData.stringToInt(t['key']))).toList(),
          categories: categories.map((t) => PostCategory(id: ConvertData.stringToInt(t['key']))).toList(),
          include: post.map((t) => Post(id: ConvertData.stringToInt(t['key']))).toList(),
          lang: lang,
          postType: postType)
        ..getPosts();
      _appStore.addStore(store);
      _postStore ??= store;
    } else {
      _postStore = _appStore.getStoreByKey(key);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        String themeModeKey = _settingStore?.themeModeKey ?? 'value';

        bool loading = _postStore!.loading;
        List<Post> posts = _postStore!.posts;

        // Fields config
        double? height = ConvertData.stringToDoubleCanBeNull(get(widget.styles, ['height'], 300));

        // Item template
        String? layout = get(widget.fields, ['layoutItem'], Strings.postLayoutList);

        // general config
        int perPage = ConvertData.stringToInt(get(widget.fields, ['perPage'], '10'));
        List<Post> emptyPost = List.generate(perPage, (index) => Post()).toList();
        bool isShimmer = posts.isEmpty && loading;

        return SizedBox(
          height: layout == Strings.postLayoutCarousel || layout == Strings.postLayoutSlideshow
              ? ConvertData.stringToDouble(height)
              : null,
          child: LayoutPostList(
            fields: widget.fields,
            styles: widget.styles,
            posts: isShimmer ? emptyPost : posts,
            padding: EdgeInsetsDirectional.zero,
            layout: layout,
            themeModeKey: themeModeKey,
            onLoadMore: () => _postStore!.getPosts(),
            canLoadMore: _postStore!.canLoadMore,
            loading: loading,
          ),
        );
      },
    );
  }
}
