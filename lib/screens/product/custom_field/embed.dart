import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/webview_flutter.dart';
import 'package:cirilla/widgets/cirilla_html.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import 'package:iframe_view/iframe_view.dart';

class FieldEmbed extends StatelessWidget with Utility {
  final dynamic value;

  const FieldEmbed({
    Key? key,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (value is String && value.isNotEmpty == true) {
      if (value.contains('<iframe')) {
        return _IframeView(iframe: value);
      }
      return CirillaHtml(html: '<div>$value</div>');
    }
    return Container();
  }
}

class _IframeView extends StatefulWidget {
  final String iframe;
  const _IframeView({
    Key? key,
    required this.iframe,
  }) : super(key: key);

  @override
  State<_IframeView> createState() => _IframeViewState();
}

class _IframeViewState extends State<_IframeView> {
  final _iframeViewPlugin = IframeView();

  Widget buildIframe() {
    if (kIsWeb) {
      return FutureBuilder<Widget?>(
          future: _iframeViewPlugin.show(Uri.dataFromString(widget.iframe, mimeType: 'text/html').toString()),
          builder: (BuildContext context, AsyncSnapshot<Widget?> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return snapshot.data!;
            }
            return const SizedBox();
          });
    }

    return WebView(
      initialUrl: Uri.dataFromString(widget.iframe, mimeType: 'text/html').toString(),
      javascriptMode: JavascriptMode.unrestricted,
      allowsInlineMediaPlayback: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    dom.Document document = html_parser.parse(widget.iframe);
    dom.Element iframe = document.getElementsByTagName('iframe')[0];
    double width = ConvertData.stringToDouble(get(iframe.attributes, ['width'], 16), 16);
    double height = ConvertData.stringToDouble(get(iframe.attributes, ['height'], 9), 9);

    return AspectRatio(
      aspectRatio: width / height,
      child: buildIframe(),
    );
  }
}
