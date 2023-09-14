import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/service/helpers/persist_helper.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/utils/video_shop_mapper.dart';
import 'package:cirilla/widgets/builder/product_video_shop/widgets/video_infomation.dart';
import 'package:flutter/services.dart';
import 'widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:video_shop_flutter/video_shop_flutter.dart';

const currentVideoStoreKey = "current_video_store_key";

class CurrentVideoStore {
  String key;
  int page;
  CurrentVideoStore({required this.key, required this.page});
}

class LikeStore {
  String key;
  int likes;
  bool liked;
  String userId;
  LikeStore({
    required this.key,
    required this.likes,
    required this.liked,
    required this.userId,
  });
}

class ProductVideoShopWidget extends StatefulWidget {
  final WidgetConfig? widgetConfig;

  const ProductVideoShopWidget({
    Key? key,
    this.widgetConfig,
  }) : super(key: key);

  @override
  State<ProductVideoShopWidget> createState() => _ProductVideoShopWidgetState();
}

class _ProductVideoShopWidgetState extends State<ProductVideoShopWidget> with Utility, ContainerMixin {
  late AppStore _appStore;
  SettingStore? _settingStore;
  AuthStore? _authStore;
  ProductsStore? _productsStore;
  final List<String> _watchedVideo = [];
  PersistHelper? _persistHelper;
  List<String> _watchedVideoStored = [];
  int _limit = 0;
  int _currentVideoPosition = 0;
  List<Product> exProducts = [];
  List<int> tags = [];
  String keyword = '';

  _reloadProduct() {
    if (_productsStore!.products.isEmpty) {
      // If products is empty, clear watched video & load more products.
      _persistHelper?.setWatchedVideo([]);
      _watchedVideoStored = [];
      _productsStore!.getProducts(customQuery: {
        'user_id': _authStore?.user?.id.toString(),
        'page': 1,
        'exclude': [...exProducts.map((e) => (e.id ?? '').toString()).toList()].join(','),
        'per_page': _limit,
      });
    } else if (_productsStore!.products.length < _limit) {
      // If amount of product less than limit, clear watched video & load more products.
      _persistHelper?.setWatchedVideo([]);
      _watchedVideoStored = [];
      _nextPage(_productsStore!.products);
    }
  }

  @override
  void didChangeDependencies() {
    _appStore = Provider.of<AppStore>(context);
    _authStore = Provider.of<AuthStore>(context);
    _settingStore = Provider.of<SettingStore>(context);
    _persistHelper = _settingStore?.persistHelper;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));

    // Get watched videos.
    if (_persistHelper != null) {
      _watchedVideoStored = _persistHelper!.getWatchedVideo();
    }
    // Get current video position.
    if (_appStore.getStoreByKey(currentVideoStoreKey) != null) {
      _currentVideoPosition = _appStore.getStoreByKey(currentVideoStoreKey).page;
    }

    Map<String, dynamic> fields = widget.widgetConfig?.fields ?? {};
    List<dynamic> excludeProduct = get(fields, ['excludeProduct'], []);

    List<dynamic> tagsProduct = get(fields, ['tags'], []);

    keyword = get(fields, ['search', 'text'], '');

    // Filter
    _limit = ConvertData.stringToInt(get(fields, ['limit'], '4'));

    // Gen key for store
    exProducts = excludeProduct.map((e) => Product(id: ConvertData.stringToInt(e['key']))).toList();

    tags = tagsProduct.map((e) => ConvertData.stringToInt(e['key'])).toList();

    List<dynamic> categories = get(fields, ['categories'], []);

    List<ProductCategory> cate = categories.map((t) => ProductCategory(id: ConvertData.stringToInt(t['key']))).toList();
    String? key = StringGenerate.getProductKeyStore(
      widget.widgetConfig!.id,
      currency: _settingStore!.currency,
      language: _settingStore!.locale,
      excludeProduct: exProducts,
      limit: _limit,
      category: cate.isNotEmpty ? cate[0].id : null,
    );

    // Add store to list store
    if (widget.widgetConfig != null && _appStore.getStoreByKey(key) == null) {
      ProductsStore store = ProductsStore(
        _settingStore!.requestHelper,
        key: key,
        perPage: _limit,
        language: _settingStore!.locale,
        currency: _settingStore!.currency,
        sort: Map<String, dynamic>.from({
          'query': {
            'orderby': 'rand',
            'order': 'asc',
          }
        }),
        search: keyword,
        tag: tags,
        locationStore: _authStore?.locationStore,
        category: cate.isNotEmpty ? cate[0] : null,
      )..getProducts(customQuery: {
          'user_id': _authStore?.user?.id.toString(),
          // 'watched_video': _watchedVideoStored,
          'exclude': [..._watchedVideoStored, ...exProducts.map((e) => (e.id ?? '').toString()).toList()].join(','),
          'page': 1,
          'per_page': _limit,
        }).then((value) {
          _reloadProduct();
        });
      _appStore.addStore(store);
      _productsStore ??= store;
    } else {
      _productsStore = _appStore.getStoreByKey(key);
      _reloadProduct();
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // Store current position of video for next time play video.
    if (_watchedVideo.isNotEmpty) {
      _appStore.removeStoreByKey(currentVideoStoreKey);
      _appStore.addStore(
        CurrentVideoStore(key: currentVideoStoreKey, page: _currentVideoPosition),
      );
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    String themeModeKey = _settingStore?.themeModeKey ?? 'value';
    // Item style
    WidgetConfig configs = widget.widgetConfig!;
    // Style
    Map<String, dynamic>? margin = get(configs.styles, ['margin'], {});
    Map<String, dynamic>? padding = get(configs.styles, ['padding'], {});
    Map<String, dynamic>? background = get(configs.styles, ['background', themeModeKey], {});
    // Enable/Disable action widgets.
    bool enableLikeButton = get(configs.fields, ['enableLike'], false);
    bool enableShareButton = get(configs.fields, ['enableShare'], false);
    bool enableCartButton = get(configs.fields, ['enableAddCart'], false);
    bool enableView = get(configs.fields, ['enableView'], false);

    AlignmentDirectional actionsAlignment =
        ConvertData.toAlignmentDirectional(get(configs.styles, ['actionsAlignment'], 'bottom-end'));

    return Observer(builder: (_) {
      if (_productsStore == null) return Container();

      List<Product> products = _productsStore!.products;

      return Container(
          width: width,
          height: height,
          padding: ConvertData.space(padding, 'padding'),
          margin: ConvertData.space(margin, 'margin'),
          decoration: decorationColorImage(
            color: ConvertData.fromRGBA(background, Colors.transparent),
          ),
          child: VideoShopFlutter(
            lastSeenPage: _currentVideoPosition,
            updateLastSeenPage: (pageIndex) async {
              _currentVideoPosition = pageIndex;
              _updateWatchedVideo(pageIndex);
            },
            videoWatched: _watchedVideo,
            listData: VideoShopMapper.mapData(products: products),
            loadMore: (page, pageSize) async {
              await _loadMore(products);
            },
            actionsAlign: actionsAlignment,
            pageSize: _limit,
            likeWidget: (enableLikeButton)
                ? (video, updateData) {
                    return LikeWidgetVideoShop(
                      liked: video?.liked ?? false,
                      likes: video?.likes ?? 0,
                      updateData: updateData,
                      id: video?.id ?? 0,
                      appStore: _appStore,
                      userId: _authStore?.user?.id ?? "",
                    );
                  }
                : (_, __) => const SizedBox.shrink(),
            buyWidget: (enableCartButton)
                ? (video) {
                    return AddCartVideoShop(
                      product: products.firstWhere((element) => video?.id != null && element.id == video?.id),
                      stockStatus: video?.stockStatus ?? '',
                    );
                  }
                : (_) => const SizedBox.shrink(),
            shareWidget: (enableShareButton)
                ? (video) {
                    return ShareVideoShop(
                      permalink: video?.productPermalink,
                      name: video?.productName,
                    );
                  }
                : (_) => const SizedBox.shrink(),
            viewWidget: (enableView)
                ? (_, index) {
                    return ViewProductVideoShop(product: products[index]);
                  }
                : null,
            customVideoInfo: (video) {
              return InformationVideoShop(
                videoTitle: video?.videoTitle,
                videoDescription: video?.videoDescription,
                maxHeight: height,
              );
            },
            enableBackgroundContent: true,
            informationPadding: const EdgeInsetsDirectional.only(bottom: 120, start: 16, end: 96),
            informationAlign: AlignmentDirectional.bottomStart,
          ));
    });
  }

  /// Handle watched video then call get list data
  Future<void> _loadMore(List<Product> products) async {
    _productsStore!.getProducts(
      customQuery: {
        'user_id': _authStore?.user?.id.toString(),
        //exclude watched videos & loaded videos
        'exclude': [
          ..._watchedVideoStored,
          ...products.map((e) => e.id.toString()).toList(),
          ...exProducts.map((e) => e.id.toString()).toList()
        ].join(','),
        'page': 1,
        'per_page': _limit,
      },
    ).then((value) {
      //If all of data is loaded, clear preference for the next time open app.
      if (!_productsStore!.canLoadMore) {
        _persistHelper?.setWatchedVideo([]);
      }
    });
  }

  /// Increase page and get product
  Future<void> _nextPage(List<Product> products) async {
    _productsStore!.nextPage(
      customQuery: {
        'user_id': _authStore?.user?.id.toString(),
        //exclude watched videos & loaded videos
        'exclude': [
          ..._watchedVideoStored,
          ...products.map((e) => e.id.toString()).toList(),
          ...exProducts.map((e) => e.id.toString()).toList()
        ].join(','),
        'page': 1,
        'per_page': _limit,
      },
    ).then((value) {
      //If all of data is loaded, clear preference for the next time open app.
      if (!_productsStore!.canLoadMore) {
        _persistHelper?.setWatchedVideo([]);
      }
    });
  }

  /// Set watched video to preference.
  void _updateWatchedVideo(int pageIndex) async {
    List<String> lastFiftyWatched = [];
    lastFiftyWatched = [..._watchedVideoStored, ..._watchedVideo];
    if (lastFiftyWatched.length > 50) {
      lastFiftyWatched = lastFiftyWatched.sublist(lastFiftyWatched.length - 50);
    }
    _persistHelper?.setWatchedVideo(lastFiftyWatched);
  }
}
