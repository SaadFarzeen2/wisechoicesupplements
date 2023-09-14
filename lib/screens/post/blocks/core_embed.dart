import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/widgets/cirilla_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class Embed extends StatelessWidget {
  final Map<String, dynamic>? block;

  const Embed({Key? key, this.block}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Uri uri = Uri.parse(get(block, ['attrs', 'url'], ''));

    String? id = uri.queryParameters['v'];
    double width = MediaQuery.of(context).size.width;
    return Html(
      data: '<iframe width="$width" height="100%" src="https://www.youtube.com/embed/$id"></iframe>',
      customRenders: {...appCustomRenders},
    );
  }
}
