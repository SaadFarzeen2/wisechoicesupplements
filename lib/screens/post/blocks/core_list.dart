import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/screens/post/blocks/html_text.dart';
import 'package:flutter/material.dart';

class ListBlock extends StatelessWidget with Utility {
  final Map<String, dynamic>? block;

  const ListBlock({Key? key, required this.block}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HtmlText(
      text: block!['innerHTML'],
    );
  }
}
