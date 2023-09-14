import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/utils/url_launcher.dart';

class FieldLink extends StatelessWidget with Utility {
  final dynamic value;
  final String? align;
  final String format;

  const FieldLink({
    Key? key,
    this.value,
    this.align,
    this.format = 'array',
  }) : super(key: key);

  void launchType(String data) {
    bool validURL = Uri.parse(data).isAbsolute;
    if (validURL) {
      launch(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    TextAlign textAlign = ConvertData.toTextAlignDirection(align);

    AlignmentGeometry alignment = align == 'center'
        ? AlignmentDirectional.center
        : align == 'right'
            ? AlignmentDirectional.centerEnd
            : AlignmentDirectional.centerStart;

    String textUrl = '';
    String textButton = '';

    switch (format) {
      case 'array':
        if (value is Map) {
          textUrl = get(value, ['url'], '');
          textButton = get(value, ['title'], '');
        }
        break;
      case 'url':
        if (value is String) {
          textUrl = value;
          textButton = value;
        }
        break;
    }
    Widget textWidget = Text(
      textButton,
      textAlign: textAlign,
    );

    return TextButton(
      onPressed: () => launchType(textUrl),
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.bodyMedium,
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        alignment: alignment,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: textWidget,
    );
  }
}
