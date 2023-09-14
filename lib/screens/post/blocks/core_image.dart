import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/utils/string_generate.dart';
import 'package:cirilla/widgets/cirilla_cache_image.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import 'package:photo_view/photo_view.dart';

class BlockImage extends StatelessWidget {
  final Map<String, dynamic>? block;

  const BlockImage({Key? key, this.block}) : super(key: key);

  Widget buildItem(BuildContext context, {required String url, required String tag, required Widget child}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, _, __) => _ImagePopup(url: url, tag: tag),
          ),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    dom.Document document = html_parser.parse(block!['innerHTML']);

    dom.Element image = document.getElementsByTagName("img")[0];

    if (image.attributes['src'] == null || image.attributes['src'] == "") return Container();
    return LayoutBuilder(builder: (_, BoxConstraints constraints) {
      double screenWidth = constraints.maxWidth;
      double width = ConvertData.stringToDouble(image.attributes['width'], screenWidth);
      double? height = ConvertData.stringToDouble(image.attributes['height'], screenWidth);

      if (width > screenWidth) {
        height = (screenWidth * height) / width;
        width = screenWidth;
      }
      String url = image.attributes['src'] as String;
      String tag = 'post_gallery_${StringGenerate.uuid()}';
      return buildItem(
        context,
        url: url,
        tag: tag,
        child: Hero(tag: tag, child: CirillaCacheImage(url, width: width, height: height)),
      );
    });
  }
}

class _ImagePopup extends StatelessWidget {
  final String url;
  final String tag;

  const _ImagePopup({
    Key? key,
    required this.url,
    required this.tag,
  }) : super(key: key);

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
            Center(
              child: PhotoView(
                imageProvider: NetworkImage(url),
                heroAttributes: PhotoViewHeroAttributes(tag: tag),
              ),
            ),
            PositionedDirectional(
              top: top - 18 > 0 ? top - 18 : top,
              end: 10,
              child: SizedBox(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
