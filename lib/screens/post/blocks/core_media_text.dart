import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/screens/post/blocks/core_paragraph.dart';
import 'package:cirilla/screens/post/blocks/core_video.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;

class MediaText extends StatelessWidget with Utility {
  final Map<String, dynamic>? block;

  const MediaText({Key? key, this.block}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List document = block!['innerBlocks'];

    Map? attrs = get(block, ['attrs'], {}) is Map ? get(block, ['attrs'], {}) : {};

    String? mediaType = get(attrs, ['mediaType'], '');

    dom.Document img = html_parser.parse(block!['innerHTML']);

    dom.Element src = img.getElementsByTagName('div')[0];

    return Column(
      children: [
        if (mediaType == 'image')
          Image.network(
            src.getElementsByTagName('img')[0].attributes['src'] ?? '',
            fit: BoxFit.fill,
          ),
        if (mediaType == 'video') Video(block: block),
        Paragraph(block: document.elementAt(0)),
      ],
    );
  }
}
