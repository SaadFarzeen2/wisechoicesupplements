import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/models/post/post.dart';
import 'package:cirilla/models/post/post_category.dart';
import 'package:cirilla/screens/post_author/post_author.dart';
import 'package:cirilla/screens/product/custom_field/custom_field.dart';
import 'package:cirilla/utils/date_format.dart';
import 'package:cirilla/widgets/cirilla_cache_image.dart';
import 'package:cirilla/widgets/cirilla_shimmer.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';
import 'package:intl/intl.dart';

mixin PostMixin {
  Widget buildName(ThemeData theme, [Post? post, Color? color, TextAlign? textAlign]) {
    if (post?.id == null) {
      return CirillaShimmer(
        child: Container(
          height: 24,
          width: 324,
          color: Colors.white,
        ),
      );
    }
    return Text(
      post?.postTitle ?? '',
      style: theme.textTheme.titleMedium?.copyWith(color: color),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }

  Widget? buildCategory(ThemeData theme,
      [Post? post, bool isCenter = false, Color? background, Color? color, double? radius, String direction = 'left']) {
    if (post?.id == null || post?.postCategories?.isNotEmpty != true) {
      return null;
    }
    WrapAlignment wrapAlignment = direction == 'center'
        ? WrapAlignment.center
        : direction == 'right'
            ? WrapAlignment.end
            : WrapAlignment.start;
    List<PostCategory> categories = post?.postCategories ?? [];
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      alignment: wrapAlignment,
      children: List.generate(
        categories.length,
        (int index) => BadgeUi(
          text: Text(
            categories[index].name!.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(color: color ?? Colors.white),
          ),
          color: background ?? ColorBlock.green,
          padding: paddingHorizontalTiny,
          radius: radius ?? 19,
        ),
      ).toList(),
    );
  }

  Widget buildDate(ThemeData theme, [Post? post, Color? color]) {
    if (post?.id == null) {
      return CirillaShimmer(
        child: Container(
          height: 16,
          width: 94,
          color: Colors.white,
        ),
      );
    }

    return Text(formatDate(date: post?.date ?? ''), style: theme.textTheme.bodySmall?.copyWith(color: color));
  }

  Widget buildAuthor(BuildContext context, ThemeData theme, [Post? post, Color? color]) {
    if (post?.id == null) {
      return CirillaShimmer(
        child: Container(
          height: 16,
          width: 50,
          color: Colors.white,
        ),
      );
    }
    return InkWell(
      onTap: () => Navigator.pushNamed(context, PostAuthorScreen.routeName, arguments: {'id': post?.author}),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            FeatherIcons.feather,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(post?.postAuthor ?? '', style: theme.textTheme.bodySmall?.copyWith(color: color)),
        ],
      ),
    );
  }

  Widget buildAuthorImage(BuildContext context, [Post? post]) {
    if (post?.id == null) {
      return CirillaShimmer(
        child: Container(
          height: 40,
          width: 40,
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        ),
      );
    }
    return InkWell(
      onTap: () => Navigator.pushNamed(context, PostAuthorScreen.routeName, arguments: {'id': post?.author}),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CirillaCacheImage(post?.postAuthorImage?.medium ?? '', width: 40, height: 40),
      ),
    );
  }

  Widget buildAuthorName(BuildContext context, ThemeData theme, [Post? post, Color? color]) {
    if (post?.id == null) {
      return CirillaShimmer(
        child: Container(
          height: 16,
          width: 50,
          color: Colors.white,
        ),
      );
    }
    return InkWell(
      onTap: () => Navigator.pushNamed(context, PostAuthorScreen.routeName, arguments: {'id': post?.author}),
      child: Text(
        post?.postAuthor ?? '',
        style: theme.textTheme.titleSmall?.copyWith(color: color, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget buildComment(ThemeData theme, [Post? post, Color? color, double? size]) {
    if (post?.id == null) {
      return CirillaShimmer(
        child: Container(
          height: 16,
          width: 50,
          color: Colors.white,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          FeatherIcons.messageCircle,
          size: size ?? 14,
          color: color,
        ),
        const SizedBox(width: 8),
        Text('${post?.postCommentCount ?? 0}', style: theme.textTheme.bodySmall?.copyWith(color: color)),
      ],
    );
  }

  Widget buildImage({
    Post? post,
    double width = 200,
    double? height = 200,
    double borderRadius = 0,
    BoxFit fit = BoxFit.cover,
  }) {
    if (post?.id == null) {
      return CirillaShimmer(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(borderRadius)),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CirillaCacheImage(
        post?.thumbMedium,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }

  Widget? buildExcept({Post? post, ThemeData? theme, Color? color}) {
    if (post?.id == null) {
      return CirillaShimmer(
        child: Container(
          height: 16,
          width: 324,
          color: Colors.white,
        ),
      );
    }

    String textHtml = Bidi.stripHtmlIfNeeded(post?.excerpt?.rendered ?? '').trim();
    if (textHtml.isNotEmpty) {
      return Text(
        textHtml,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: theme!.textTheme.bodyMedium?.copyWith(color: color, fontWeight: FontWeight.w400),
      );
    }
    return null;
  }

  Widget? buildCustomField({
    Post? post,
    String fieldName = '',
    String align = 'left',
    Color? color,
    bool isFull = false,
  }) {
    if (post?.id == null) {
      return CirillaShimmer(
        child: Container(
          height: 16,
          width: isFull ? double.infinity : 80,
          color: Colors.white,
        ),
      );
    }

    if (fieldName.isNotEmpty == true && post?.afcFields != null && post?.afcFields?[fieldName] is Map) {
      return AdvancedFieldsCustomView(
        fields: post?.afcFields,
        fieldName: fieldName,
        align: align,
        color: color,
      );
    }
    return null;
  }
}
