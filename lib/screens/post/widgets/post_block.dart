import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/builder/product_detail_value.dart';
import 'package:cirilla/models/post/post.dart';
import 'package:cirilla/screens/product/widgets/product_custom.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'post_action.dart';
import 'post_author.dart';
import 'post_category.dart';
import 'post_comment_count.dart';
import 'post_comments.dart';
import 'post_content.dart';
import 'post_date.dart';
import 'post_image.dart';
import 'post_name.dart';
import 'post_tag.dart';
import 'post_related.dart';
import 'post_advenced_custom_field.dart';

class PostBlock extends StatelessWidget with PostMixin, ContainerMixin {
  final Post? post;
  final List<dynamic>? rows;
  final Map<String, dynamic>? styles;
  final Color? color;
  final bool enableBlock;
  final GlobalKey? dataKey;

  PostBlock({
    Key? key,
    this.post,
    this.rows,
    this.styles,
    this.color,
    this.enableBlock = true,
    this.dataKey,
  }) : super(key: key);

  List<Widget> buildColumn(
    List<dynamic>? columns, {
    required ThemeData theme,
    required String themeModeKey,
    required String languageKey,
  }) {
    if (columns == null) return [Container()];
    return columns.map((e) {
      ProductDetailValue configs = ProductDetailValue.fromJson(get(e, ['value'], {}));
      String type = get(e, ['value', 'type'], '');

      int flex = ConvertData.stringToInt(get(e, ['value', 'flex'], '1'), 1);
      bool enableFlex = get(e, ['value', 'enableFlex'], true);
      String queryBy = get(e, ['value', 'queryBy'], 'tag');

      EdgeInsetsDirectional margin = ConvertData.space(
        get(e, ['value', 'margin'], null),
        'margin',
        EdgeInsetsDirectional.zero,
      );

      EdgeInsetsDirectional padding = ConvertData.space(
        get(e, ['value', 'padding'], null),
        'padding',
        const EdgeInsetsDirectional.only(start: 20, end: 20),
      );
      Color foreground = ConvertData.fromRGBA(get(e, ['value', 'foreground', themeModeKey]), Colors.transparent);
      String textHtml = get(e, ['value', 'textHtml', languageKey], '');

      Widget child = Container(
        margin: margin,
        padding: padding,
        decoration: decorationColorImage(
          color: foreground,
        ),
        child: buildBlock(type, queryBy, configs, textHtml),
      );

      if (enableFlex) {
        return Expanded(
          flex: flex,
          child: child,
        );
      }
      return child;
    }).toList();
  }

  Widget buildBlock(String type, String queryBy, ProductDetailValue configs, String textHtml) {
    switch (type) {
      case PostBlocks.category:
        return PostCategory(
          post: post,
          styles: styles,
        );
      case PostBlocks.name:
        return PostName(
          post: post,
          color: color,
        );
      case PostBlocks.featureImage:
        return Column(
          children: [
            LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
              double maxWidth = constraints.maxWidth;
              double width = MediaQuery.of(context).size.width;

              double widthImage = maxWidth != double.infinity ? maxWidth : width;
              double heightImage = widthImage * 0.8;

              return PostImage(
                post: post,
                width: widthImage,
                height: heightImage,
                styles: styles ?? {},
              );
            }),
          ],
        );
      case PostBlocks.author:
        return PostAuthor(
          post: post,
          color: color,
        );
      case PostBlocks.countComment:
        return PostCommentCount(
          post: post,
          color: color,
        );
      case PostBlocks.date:
        return PostDate(
          post: post,
          color: color,
        );
      case PostBlocks.wishlist:
        return PostWishlist(
          post: post,
          color: color,
        );
      case PostBlocks.share:
        return PostShare(post: post, color: color);
      case PostBlocks.navigateComment:
        return PostNavigateComment(
          post: post,
          color: color,
          dataKey: dataKey,
        );
      case PostBlocks.content:
        if (!enableBlock) {
          return CirillaHtml(html: post?.content?.rendered ?? '');
        }
        return PostContent(post: post);
      case PostBlocks.tag:
        return PostTagWidget(
          post: post,
          paddingHorizontal: 0,
        );
      case PostBlocks.comments:
        return PostComments(
          key: dataKey,
          post: post,
        );
      case PostBlocks.relatedPost:
        return PostRelated(
          post: post,
          queryBy: queryBy,
        );
      case PostBlocks.custom:
        return ProductCustom(configs: configs);
      case PostBlocks.html:
        return CirillaHtml(html: textHtml);
      case PostBlocks.advencedCustomFields:
        return PostAdvancedFieldsCustom(
          post: post,
          fieldName: configs.customFieldName,
        );
      default:
        return Text(type);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (rows == null || rows!.isEmpty) {
      return Container();
    }
    ThemeData theme = Theme.of(context);

    SettingStore settingStore = Provider.of<SettingStore>(context);
    String themeModeKey = settingStore.themeModeKey;
    String languageKey = settingStore.languageKey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(rows!.length, (index) {
        dynamic e = rows![index];
        String? mainAxisAlignment = get(e, ['data', 'mainAxisAlignment'], 'start');
        String? crossAxisAlignment = get(e, ['data', 'crossAxisAlignment'], 'start');
        bool divider = get(e, ['data', 'divider'], false);
        List<dynamic>? columns = get(e, ['data', 'columns']);
        return Column(
          children: [
            Row(
              mainAxisAlignment: ConvertData.mainAxisAlignment(mainAxisAlignment),
              crossAxisAlignment: ConvertData.crossAxisAlignment(crossAxisAlignment),
              children: buildColumn(columns, theme: theme, themeModeKey: themeModeKey, languageKey: languageKey),
            ),
            if (divider)
              const Divider(
                height: 1,
                thickness: 1,
                endIndent: 20,
                indent: 20,
              ),
          ],
        );
      }),
    );
  }
}
