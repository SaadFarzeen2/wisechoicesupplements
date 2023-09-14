import 'dart:convert';
import 'dart:math';

import 'package:cirilla/constants/assets.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/product/product.dart';
import 'package:cirilla/models/setting/setting.dart';
import 'package:cirilla/screens/product/widgets/product_image_popup.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_sirv_image.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:awesome_icons/awesome_icons.dart';
import 'package:provider/provider.dart';

import 'product_slideshow_pagination.dart';

class ProductSlideshow extends StatefulWidget {
  final List<Map<String, dynamic>>? images;
  final Product? product;
  final int scrollDirection;
  final double? width;
  final double? height;
  final String? productGalleryFit;
  final String? productGalleryThumbSizes;

  final WidgetConfig? configs;

  const ProductSlideshow({
    Key? key,
    this.images,
    this.product,
    this.scrollDirection = 0,
    this.width,
    this.height,
    this.productGalleryFit,
    this.productGalleryThumbSizes,
    this.configs,
  }) : super(key: key);

  @override
  State<ProductSlideshow> createState() => _ProductSlideshowState();
}

class _ProductSlideshowState extends State<ProductSlideshow> with ProductSlideshowPagination, Utility, LoadingMixin {
  final SwiperController _controller = SwiperController();
  List<Map<String, dynamic>> _images = [];
  bool _loading = true;

  @override
  void didChangeDependencies() async {
    setState(() {
      _images = widget.product?.images ?? [];
    });
    await _getVideoLinkFromMetaData();
    setState(() {
      _loading = false;
    });
    super.didChangeDependencies();
  }

  /// Get video URL in product meta data
  Future<void> _getVideoLinkFromMetaData() async {
    if (widget.product != null && widget.product!.metaData != null && widget.product!.metaData!.isNotEmpty) {
      // YITH WooCommerce Featured Video
      Map<String, dynamic> video = widget.product!.metaData!.firstWhere(
        (e) => get(e, ['key'], '') == '_video_url',
        orElse: () => {'value': null},
      );
      if (video['value'] != null && video['value'] != '') {
        await _parserVideoUrl(video['value'], '', featured: true);
      }

      // Rehub theme
      Map<String, dynamic> videosRehubTheme = widget.product!.metaData!.firstWhere(
        (e) => get(e, ['key'], '') == 'rh_product_video',
        orElse: () => {'value': null},
      );
      if (videosRehubTheme['value'] != null && videosRehubTheme['value'] != '') {
        List<String> videos = LineSplitter.split(videosRehubTheme['value']).toList();
        int i = 0;
        if (videos.isNotEmpty) {
          await Future.doWhile(() async {
            await _parserVideoUrl(videos[i], '', featured: false);
            i++;
            return i < videos.length;
          });
        }
      }

      // Product Video for WooCommerce
      Map<String, dynamic> productVideoForWoo = widget.product!.metaData!.firstWhere(
        (e) => get(e, ['key'], '') == 'afpv_featured_video_type',
        orElse: () => {'value': ''},
      );

      Map<String, dynamic> productVideoForWooFeatured = widget.product!.metaData!.firstWhere(
        (e) => get(e, ['key'], '') == 'afpv_enable_featured_video_product_page',
        orElse: () => {'value': ''},
      );

      Map<String, dynamic> productVideoForThumb = widget.product!.metaData!.firstWhere(
        (e) => get(e, ['key'], '') == 'afpv_video_thumb',
        orElse: () => {'value': ''},
      );

      String productVideoForWooType = productVideoForWoo['value'];
      String urlThumb = productVideoForThumb['value'];

      // Vimeo
      Map<String, dynamic> productVideoForWooVimeo = widget.product!.metaData!.firstWhere(
        (e) => get(e, ['key'], '') == 'afpv_vm_featured_video_id',
        orElse: () => {'value': ''},
      );

      if (productVideoForWooType == 'vimeo' && productVideoForWooVimeo['value'] != '') {
        await _parserVideoUrl(
          'http://vimeo.com/${productVideoForWooVimeo['value']}',
          urlThumb,
          featured: productVideoForWooFeatured['value'] == 'yes',
        );
      }

      // Youtube
      Map<String, dynamic> productVideoForWooYoutube = widget.product!.metaData!.firstWhere(
        (e) => get(e, ['key'], '') == 'afpv_yt_featured_video_id',
        orElse: () => {'value': ''},
      );

      if (productVideoForWooType == 'youtube' && productVideoForWooYoutube['value'] != '') {
        await _parserVideoUrl(
          'https://youtu.be/${productVideoForWooYoutube['value']}',
          urlThumb,
          featured: productVideoForWooFeatured['value'] == 'yes',
        );
      }

      // Custom video
      Map<String, dynamic> productVideoForCustom = widget.product!.metaData!.firstWhere(
        (e) => get(e, ['key'], '') == 'afpv_cus_featured_video_id',
        orElse: () => {'value': ''},
      );

      if (productVideoForWooType == 'custom' && productVideoForCustom['value'] != '') {
        await _parserVideoUrl(
          productVideoForCustom['value'],
          urlThumb,
          featured: productVideoForWooFeatured['value'] == 'yes',
        );
      }
    }

    // Sirv image
    Map<String, dynamic> sirvImage = widget.product!.metaData!
        .firstWhere((e) => get(e, ['key'], '') == '_sirv_woo_gallery_data', orElse: () => {'value': ''});
    String sirvThumb = 'https://demo.sirv.com/support/68292/spin360-thumb.jpg';

    if (sirvImage['value'] != '') {
      Map<String, dynamic> sirvImageData = jsonDecode(sirvImage['value']);
      List<Map<String, dynamic>> images = List<Map<String, dynamic>>.of(_images);

      if (sirvImageData['items'].length > 0) {
        for (int i = 0; i < sirvImageData['items'].length; i++) {
          Map<String, dynamic> sirvImage = sirvImageData['items'][i];
          images.insert(0, {
            'id': Random().nextInt(100000),
            'src': sirvThumb,
            'type': 'sirv',
            'video': sirvImage['url'],
            'name': sirvThumb,
            'woocommerce_thumbnail': sirvThumb,
            'woocommerce_single': sirvThumb,
            'woocommerce_gallery_thumbnail': sirvThumb,
          });
        }

        setState(() {
          _images = images;
        });
      }
    }
  }

  /// Get Id video
  Future<void> _parserVideoUrl(String url, String urlThumb, {bool featured = false}) async {
    List<Map<String, dynamic>> images = List<Map<String, dynamic>>.of(_images);

    // Parser Youtube video
    if (VideoParserUrl.isValidFullYoutubeUrl(url) || VideoParserUrl.isValidSortYoutubeUrl(url)) {
      String? videoId = VideoParserUrl.getYoutubeId(url);
      if (videoId != null) {
        Map<String, dynamic> image = await _getYoutubeThumb(videoId);
        featured ? images.insert(0, image) : images.add(image);
      }
    } else if (VideoParserUrl.isValidVimeoUrl(url)) {
      String? videoId = VideoParserUrl.getVimeoId(url);
      if (videoId != null) {
        Map<String, dynamic>? image = await _getVimeoThumb(videoId);
        featured && image != null ? images.insert(0, image) : images.add(image!);
      }
    } else {
      Map<String, dynamic>? image = _getCustomThumb(url, urlThumb);
      featured && image != null ? images.insert(0, image) : images.add(image!);
    }
    setState(() {
      _images = images;
    });
  }

  Future<Map<String, dynamic>?> _getVimeoThumb(String videoId) async {
    try {
      final dio = Dio();
      Response response = await dio.get('https://player.vimeo.com/video/$videoId/config');
      Map<String, dynamic> data = response.data;

      String linkBasic = get(data, ['video', 'thumbs', 'base'], Assets.noImageUrl);
      String linkSmall = get(data, ['video', 'thumbs', '960'], Assets.noImageUrl);
      String linkTiny = get(data, ['video', 'thumbs', '640'], Assets.noImageUrl);

      dynamic video = get(data, ['request', 'files', 'progressive'], null);

      return {
        'id': Random().nextInt(100000),
        'src': linkBasic,
        'type': 'vimeo',
        'video': video[0]['url'],
        'name': videoId,
        'woocommerce_thumbnail': linkSmall,
        'woocommerce_single': linkBasic,
        'woocommerce_gallery_thumbnail': linkTiny,
      };
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> _getYoutubeThumb(String videoId) async {
    String linkBasic = 'https://img.youtube.com/vi/$videoId/sddefault.jpg';
    String linkSmall = 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
    String linkTiny = 'https://img.youtube.com/vi/$videoId/default.jpg';
    return {
      'id': Random().nextInt(100000),
      'src': linkBasic,
      'type': 'youtube',
      'video': videoId,
      'name': videoId,
      'woocommerce_thumbnail': linkSmall,
      'woocommerce_single': linkBasic,
      'woocommerce_gallery_thumbnail': linkTiny,
    };
  }

  Map<String, dynamic>? _getCustomThumb(String url, String urlThumb) {
    String thumb = urlThumb.isNotEmpty ? urlThumb : Assets.noImageUrl;
    return {
      'id': Random().nextInt(100000),
      'src': thumb,
      'type': 'custom',
      'video': url,
      'name': url,
      'woocommerce_thumbnail': thumb,
      'woocommerce_single': thumb,
      'woocommerce_gallery_thumbnail': thumb,
    };
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> images = widget.images != null && widget.images!.isNotEmpty ? widget.images! : _images;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double containerHeight = widget.height == 0 ? screenHeight : (screenWidth * widget.height!) / widget.width!;

    // Indicator
    Map<String, dynamic>? styles = widget.configs!.styles;
    AlignmentDirectional indicatorAlignment =
        ConvertData.toAlignmentDirectional(get(styles, ['indicatorAlignment'], 'bottom-start'));
    Map<String, dynamic>? indicatorMargin = get(styles, ['indicatorMargin'], null);

    // Video & 360 image configs
    Map<String, dynamic>? fields = widget.configs!.fields;
    bool disableSwiper = get(fields, ['disableSwiper'], false);
    bool playVideoInSameScreen = get(fields, ['playVideoInSameScreen'], false);
    bool autoPlayVideo = get(fields, ['autoPlayVideo'], false);

    if (_loading) {
      return SizedBox(
        height: containerHeight,
        width: screenWidth,
        child: entryLoading(context, size: 24),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: containerHeight, width: screenWidth),
      child: Swiper(
        physics: disableSwiper ? const NeverScrollableScrollPhysics() : null,
        controller: _controller,
        loop: false,
        scrollDirection: Axis.values[widget.scrollDirection],
        itemBuilder: (BuildContext context, int index) {
          Map<String, dynamic> image = images[index];
          dynamic id = get(image, ['id'], '');
          String video = get(image, ['video'], '');
          String urlImageDefault = get(image, ['src'], '');
          String urlImage = get(image, [widget.productGalleryThumbSizes], urlImageDefault);
          String type = get(image, ['type'], '');

          /// Check is video
          bool isVideo = type == 'youtube' || type == 'vimeo' || type == 'custom';

          return Builder(
            builder: (BuildContext context) {
              /// Image Sirv
              if (type == 'sirv') {
                return CirillaSirvImage(video: video);
              }

              /// Play video inline
              if (isVideo && playVideoInSameScreen) {
                return ProductVideo(
                  autoPlay: autoPlayVideo,
                  type: type,
                  widthVideo: screenWidth,
                  heightVideo: containerHeight,
                  video: video,
                );
              }

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, _, __) => ProductImagesPopup(
                          images: images,
                          arguments: ProductImagesPopupArguments(
                            index,
                            _controller,
                          )),
                    ),
                  );
                },
                child: Hero(
                  tag: "product_images_$id",
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CirillaCacheImage(
                        urlImage,
                        fit: ConvertData.toBoxFit(widget.productGalleryFit),
                        width: screenWidth,
                        height: containerHeight,
                      ),
                      if (isVideo) _buildIconPlay(context),
                    ],
                  ),
                ),
              );
            },
          );
        },
        itemCount: images.length,
        pagination: CirillaPaginationSwiper(
          alignment: indicatorAlignment,
          margin: ConvertData.space(indicatorMargin, 'indicatorMargin', EdgeInsetsDirectional.zero),
          builder: _buildPagination(context),
        ),
      ),
    );
  }

  Widget _buildIconPlay(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          // shape: BoxShape.circle,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white),
        ),
        child: const Icon(
          FontAwesomeIcons.play,
          size: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  SwiperPlugin _buildPagination(BuildContext context) {
    ThemeData theme = Theme.of(context);
    SettingStore settingStore = Provider.of<SettingStore>(context);
    String themeModeKey = settingStore.themeModeKey;

    // Indicator
    Map<String, dynamic>? styles = widget.configs!.styles;

    String? productGalleryIndicator = get(styles, ['productGalleryIndicator'], 'dot');

    Map<String, dynamic>? indicatorColor = get(styles, ['indicatorColor', themeModeKey], null);
    Map<String, dynamic>? indicatorActiveColor = get(styles, ['indicatorActiveColor', themeModeKey], null);
    double? indicatorSize = ConvertData.stringToDouble(get(styles, ['indicatorSize'], 6));
    double? indicatorActiveSize = ConvertData.stringToDouble(get(styles, ['indicatorActiveSize'], 10));
    double? indicatorSpace = ConvertData.stringToDouble(get(styles, ['indicatorSpace'], 4));

    Color colorIndicator = ConvertData.fromRGBA(indicatorColor, theme.indicatorColor);
    Color colorIndicatorActive = ConvertData.fromRGBA(indicatorActiveColor, theme.indicatorColor);
    double? indicatorBorderRadius = ConvertData.stringToDouble(get(styles, ['indicatorBorderRadius'], 8));

    if (productGalleryIndicator == 'image') {
      return imagePagination(
        images: widget.images!.isNotEmpty ? widget.images : _images,
        controller: _controller,
        activeColor: colorIndicatorActive,
        size: indicatorSize,
        space: indicatorSpace,
        borderRadius: indicatorBorderRadius,
      );
    }
    if (productGalleryIndicator!.toLowerCase() == 'number') {
      return numberPagination(
        textStyle: theme.textTheme.labelSmall?.apply(color: colorIndicatorActive),
        background: colorIndicator,
        size: indicatorSize,
        space: indicatorSpace,
        borderRadius: indicatorBorderRadius,
      );
    }

    return DotSwiperPaginationBuilder(
      color: colorIndicator,
      activeColor: colorIndicatorActive,
      size: indicatorSize,
      activeSize: indicatorActiveSize,
      space: indicatorSpace,
    );
  }
}

/// Get meta keys
List<String> getMetaKeys({List<Map<String, dynamic>>? meta}) {
  // return empty string if meta not provider
  if (meta == null || meta.isEmpty) {
    return [];
  }

  List<String> keys = [];

  for (Map<String, dynamic> metaItem in meta) {
    if (metaItem['key'] != null && metaItem['key'].isNotEmpty) {
      keys.add('meta:${metaItem['key']}');
    }
  }

  return keys;
}

/// Get meta value
dynamic getMetaValue({List<Map<String, dynamic>>? meta, required String key, dynamic defaultValue = ''}) {
  // return empty string if meta not provider
  if (meta == null || meta.isEmpty) {
    return defaultValue;
  }

  Map<String, dynamic> metaData = meta.firstWhere(
    (e) => e['key'] == key,
    orElse: () => {'value': ''},
  );

  if (metaData['value'] == null) {
    return defaultValue;
  }

  return metaData['value'];
}
