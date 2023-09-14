import 'package:cirilla/constants/assets.dart';
import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ReviewImage extends StatelessWidget with Utility {
  final List<Map<String, dynamic>> images;
  final int reviewId;

  ReviewImage({
    Key? key,
    required this.images,
    required this.reviewId,
  }) : super(key: key);

  Widget buildImage(BuildContext context,
      {required int index, required Map<String, dynamic> image, int add = 0, required ThemeData theme}) {
    String url = get(image, ['thumb'], Assets.noImageUrl);
    String heroTag = 'review_images_${reviewId}_$index';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, _, __) => _ReviewImagesPopup(
              images: images,
              current: index,
              reviewId: reviewId,
            ),
          ),
        );
      },
      child: Hero(
        tag: heroTag,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            border: Border.all(color: theme.dividerColor),
            borderRadius: BorderRadius.circular(4),
            image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: add > 0
              ? Container(
                  alignment: Alignment.center,
                  color: ColorBlock.black.withOpacity(0.8),
                  child: Text(
                    '$add+',
                    style: theme.textTheme.titleLarge?.copyWith(color: ColorBlock.white),
                  ),
                )
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    int length = images.length < 4 ? images.length : 4;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(length, (index) {
        Map<String, dynamic> image = images[index];
        return buildImage(
          context,
          index: index,
          image: image,
          theme: theme,
          add: index == 3 && images.length > 4 ? images.length - 4 : 0,
        );
      }),
    );
  }
}

class _ReviewImagesPopup extends StatefulWidget {
  final List<Map<String, dynamic>> images;
  final int current;
  final int reviewId;

  const _ReviewImagesPopup({
    Key? key,
    required this.images,
    required this.reviewId,
    this.current = 0,
  }) : super(key: key);

  @override
  _ReviewImagesPopupState createState() => _ReviewImagesPopupState();
}

class _ReviewImagesPopupState extends State<_ReviewImagesPopup> with Utility {
  int _current = 0;
  PageController? pageController;

  @override
  void initState() {
    super.initState();
    setState(() {
      _current = widget.current;
    });
    pageController = PageController(initialPage: widget.current);
  }

  void onPageChanged(int index) {
    setState(() {
      _current = index;
    });
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
            GestureDetector(
              onVerticalDragStart: (details) {
                Navigator.pop(context);
              },
              child: PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: _buildItem,
                itemCount: widget.images.length,
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
                        '${_current + 1}/${widget.images.length}',
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
    Map<String, dynamic> image = widget.images[index];
    String url = get(image, ['src'], Assets.noImageUrl);

    return PhotoViewGalleryPageOptions(
      imageProvider: NetworkImage(url),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: 'review_images_${widget.reviewId}_$index'),
    );
  }
}
