import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/widgets/cirilla_video.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ProductImagesPopupArguments {
  final int current;
  final SwiperController controller;

  ProductImagesPopupArguments(this.current, this.controller);
}

class ProductImagesPopup extends StatefulWidget {
  final List<Map<String, dynamic>>? images;
  final ProductImagesPopupArguments? arguments;

  const ProductImagesPopup({Key? key, this.images, this.arguments}) : super(key: key);

  @override
  State<ProductImagesPopup> createState() => _ProductImagesPopupState();
}

class _ProductImagesPopupState extends State<ProductImagesPopup> with Utility {
  int _current = 0;
  PageController? pageController;

  @override
  void initState() {
    super.initState();
    setState(() {
      _current = widget.arguments!.current;
    });
    pageController = PageController(initialPage: widget.arguments!.current);
  }

  void onPageChanged(int index) {
    setState(() {
      _current = index;
    });
    widget.arguments!.controller.move(index);
  }

  @override
  Widget build(BuildContext context) {
    double top = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.images!.length,
              onPageChanged: onPageChanged,
              pageController: pageController,
              loadingBuilder: (context, event) => Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                  ),
                ),
              ),
            ),
            Positioned(
              top: top - 18 > 0 ? top - 18 : top,
              right: 10,
              left: 10,
              child: Row(
                children: [
                  Container(
                    width: 48,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        '${_current + 1}/${widget.images!.length}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        FeatherIcons.x,
                        size: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    Map<String, dynamic> image = widget.images![index];
    dynamic id = get(image, ['id'], '');
    String type = get(image, ['type'], '');
    String video = get(image, ['video'], '');

    bool isVideo = type == 'vimeo' || type == 'youtube' || type == 'custom';

    if (isVideo) {
      double width = MediaQuery.of(context).size.width;
      double widthVideo = width;
      double heightVideo = (widthVideo * 315) / 560;

      return PhotoViewGalleryPageOptions.customChild(
        child: SizedBox(
          width: widthVideo,
          height: heightVideo,
          child: ProductVideo(
            type: type,
            widthVideo: widthVideo,
            heightVideo: heightVideo,
            video: video,
          ),
        ),
        childSize: Size(widthVideo, heightVideo),
        initialScale: PhotoViewComputedScale.contained,
        minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
        maxScale: PhotoViewComputedScale.covered * 4.1,
        heroAttributes: PhotoViewHeroAttributes(tag: "product_images_$id"),
      );
    }

    String src = get(image, ['src'], '');

    return PhotoViewGalleryPageOptions(
      imageProvider: NetworkImage(src),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: "product_images_$id"),
    );
  }
}

class ProductVideo extends StatelessWidget {
  final String type;
  final String video;
  final double widthVideo;
  final double heightVideo;
  final bool autoPlay;

  const ProductVideo({
    Key? key,
    required this.type,
    required this.video,
    required this.widthVideo,
    required this.heightVideo,
    this.autoPlay = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (type == 'vimeo' || type == 'custom') {
      return CirillaVideoPlay(url: video, autoPlay: autoPlay);
    }

    if (type == 'youtube') {
      String videoUrl = "https://www.youtube.com/embed/$video";

      return FittedBox(
        fit: BoxFit.cover,
        child: Transform.scale(
          alignment: Alignment.center,
          scale: 1.1,
          child: SizedBox(
            width: widthVideo,
            height: heightVideo,
            child: Html(
              data: '<iframe width="$widthVideo" height="$heightVideo" src="$videoUrl"></iframe>',
              customRenders: {...appCustomRenders},
            ),
          ),
        ),
      );
    }

    return Container();
  }
}
