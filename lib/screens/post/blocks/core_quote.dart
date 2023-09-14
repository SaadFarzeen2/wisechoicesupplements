import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/screens/post/blocks/html_text.dart';
import 'package:flutter/material.dart';

class Quote extends StatelessWidget with Utility {
  final Map<String, dynamic>? block;

  const Quote({Key? key, required this.block}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map? attrs = get(block, ['attrs'], {}) is Map ? get(block, ['attrs'], {}) : {};

    String? className = get(attrs, ['className'], 'is-style-default');

    return Container(
      decoration: BoxDecoration(
          border: Border(
        left: BorderSide(
          color: (className == 'is-style-default') ? Theme.of(context).dividerColor : Colors.transparent,
          width: 2.0,
        ),
      )),
      child: HtmlText(
        text: "${block!['innerHTML']}",
      ),
    );
  }
}
