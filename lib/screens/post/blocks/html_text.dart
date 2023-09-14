import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/widgets/cirilla_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:cirilla/utils/url_launcher.dart';

class HtmlText extends StatelessWidget {
  final String? text;
  final Color? fontColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final Color? colorLink;
  final TextAlign? textAlign;

  const HtmlText({
    Key? key,
    this.text,
    this.fontColor,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.colorLink,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Style styleDefault = Style(
      lineHeight: const LineHeight(1.8),
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      color: fontColor ?? theme.textTheme.titleLarge?.color,
      fontSize: FontSize(fontSize ?? 14),
      fontWeight: fontWeight ?? FontWeight.w400,
      fontStyle: fontStyle,
      textAlign: textAlign ?? TextAlign.start,
    );

    return Html(
      data: "<div>$text</div>",
      style: {
        'html': styleDefault,
        'body': Style(
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
        ),
        'p': Style(
          margin: EdgeInsets.zero,
        ),
        'blockquote': Style(
          margin: const EdgeInsets.only(left: itemPaddingMedium),
        ),
        'h1': Style(margin: EdgeInsets.zero),
        'h2': Style(margin: EdgeInsets.zero),
        'h3': Style(margin: EdgeInsets.zero),
        'h4': Style(margin: EdgeInsets.zero),
        'h5': Style(margin: EdgeInsets.zero),
        'h6': Style(margin: EdgeInsets.zero),
        "div": styleDefault,
        "a": Style(color: colorLink ?? theme.primaryColor),
      },
      customRenders: {
        ...appCustomRenders,
      },
      onLinkTap: (
        String? url,
        RenderContext context,
        Map<String, String> attributes,
        dom.Element? element,
      ) {
        if (url is String && Uri.parse(url).isAbsolute) {
          launch(url);
        }
      },
    );
  }
}
