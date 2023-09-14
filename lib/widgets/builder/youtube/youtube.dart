import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_html.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/models/models.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:awesome_icons/awesome_icons.dart';
import 'package:provider/provider.dart';
import 'package:cirilla/store/store.dart';

import '../../cirilla_cache_image.dart';

class YoutubeWidget extends StatefulWidget {
  final WidgetConfig? widgetConfig;
  const YoutubeWidget({
    Key? key,
    required this.widgetConfig,
  }) : super(key: key);
  @override
  State<YoutubeWidget> createState() => _YoutubeWidgetState();
}

class _YoutubeWidgetState extends State<YoutubeWidget> with Utility, ContainerMixin, SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.ease);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    SettingStore settingStore = Provider.of<SettingStore>(context);

    Map<String, dynamic> fields = widget.widgetConfig?.fields ?? {};

    dynamic uri = Uri.parse(get(fields, ['url', 'text'], ''));

    String? id = uri.queryParameters['v'];

    Map<String, dynamic> styles = widget.widgetConfig?.styles ?? {};
    String themeModeKey = settingStore.themeModeKey;
    Color background = ConvertData.fromRGBA(get(styles, ['background', themeModeKey], {}), Colors.transparent);

    double? height = ConvertData.stringToDouble(get(fields, ["height"], 315), 315);
    double? width = ConvertData.stringToDouble(get(fields, ["width"], 560), 560);

    Map? padding = get(styles, ['padding'], {});
    Map? margin = get(styles, ['margin'], {});

    double widthVideo = MediaQuery.of(context).size.width;
    double heightVideo = (widthVideo * 315) / 560;
    double top = MediaQuery.of(context).padding.top;
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierColor: Colors.black,
          barrierDismissible: false,
          builder: (_) => ScaleTransition(
            scale: scaleAnimation,
            child: Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                Center(
                  child: Html(
                      data:
                          '<iframe width="$widthVideo" height="$heightVideo" src="https://www.youtube.com/embed/$id"></iframe>',
                      customRenders: {...appCustomRenders}),
                ),
                Positioned(
                  top: top - 18 > 0 ? top - 18 : top,
                  right: 10,
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
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
      },
      child: Container(
        padding: ConvertData.space(padding, 'padding'),
        margin: ConvertData.space(margin, 'margin'),
        decoration: decorationColorImage(color: background),
        child: LayoutBuilder(
          builder: (_, BoxConstraints constraints) {
            double widthView = constraints.maxWidth;
            double heightView = widthView * height / width;
            return Stack(
              alignment: Alignment.center,
              children: [
                CirillaCacheImage(
                  'https://img.youtube.com/vi/$id/sddefault.jpg',
                  width: widthView,
                  height: heightView,
                ),
                _buildIconPlay(context),
              ],
            );
          },
        ),
      ),
    );
  }
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
