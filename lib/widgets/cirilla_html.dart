import 'package:cirilla/widgets/cirilla_instagram.dart';
import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_all/flutter_html_all.dart';
import 'package:cirilla/utils/url_launcher.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/constants/styles.dart';

import 'cirilla_audio/cirilla_audio.dart';

CustomRenderMatcher classMatcher(String className) => (context) {
      return context.tree.element?.className == className;
    };

class CirillaHtml extends StatelessWidget {
  final String html;
  final Map<String, Style>? style;

  const CirillaHtml({
    Key? key,
    required this.html,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Html(
      data: html,
      style: {
        'p': Style(
          lineHeight: const LineHeight(1.8),
          fontSize: const FontSize(16),
        ),
        'div': Style(
          lineHeight: const LineHeight(1.8),
          fontSize: const FontSize(16),
        ),
        'img': Style(
          padding: paddingVerticalTiny,
        ),
        ...?style,
      },
      customRenders: {
        ...appCustomRenders,
      },
      onLinkTap: (
        String? url,
        RenderContext renderContext,
        Map<String, String> attributes,
        dom.Element? element,
      ) {
        if (url is String && Uri.parse(url).isAbsolute) {
          if (attributes['data-id-selector'] is String) {
            String queryString = Uri(queryParameters: {
              'app-builder-css': 'true',
              'id-selector': attributes['data-id-selector'],
            }).query;

            String urlData = url.contains("?") ? "$url&$queryString" : "$url?$queryString";
            Navigator.of(context).pushNamed(WebViewScreen.routeName, arguments: {
              'url': urlData,
              ...attributes,
              'name': element!.text,
            });
          } else {
            launch(url);
          }
        }
      },
    );
  }
}

Map<CustomRenderMatcher, CustomRender> appCustomRenders = {
  tagMatcher("audio"): CustomRender.widget(widget: (context, buildChildren) {
    dom.Document document = html_parser.parse(context.tree.element?.innerHtml ?? '');
    dom.Element source = document.getElementsByTagName('source')[0];
    String uri = source.attributes['src'] ?? '';
    if (uri.isNotEmpty) {
      return CirillaAudio(uri: uri);
    }
    return Container();
  }),
  classMatcher("wavesurfer-block wavesurfer-audio"): CustomRender.widget(widget: (context, buildChildren) {
    dom.Document document = html_parser.parse(context.tree.element?.innerHtml ?? '');
    dom.Element source = document.getElementsByClassName('wavesurfer-player')[0];
    String uri = source.attributes['data-url'] ?? '';
    if (uri.isNotEmpty) {
      return CirillaAudio(uri: uri);
    }
    return Container();
  }),
  classMatcher("yith-par-message-variation hide"): CustomRender.widget(widget: (context, buildChildren) {
    return const SizedBox();
  }),
  classMatcher("instagram-media"): CustomRender.widget(widget: (context, buildChildren) {
    String? url = context.tree.element?.attributes['data-instgrm-permalink'];
    if (url != null) {
      Uri uri = Uri.parse(url);
      return CirillaInstagram(id: uri.pathSegments[1]);
    }
    return Container();
  }),
  tagMatcher("table"): CustomRender.widget(
      widget: (context, buildChildren) => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: tableRender.call().widget!.call(context, buildChildren),
          )),
  audioMatcher(): audioRender(),
  iframeMatcher(): iframeRender(),
  svgTagMatcher(): svgTagRender(),
  svgDataUriMatcher(): svgDataImageRender(),
  svgAssetUriMatcher(): svgAssetImageRender(),
  svgNetworkSourceMatcher(): svgNetworkImageRender(),
  videoMatcher(): videoRender(),
};
