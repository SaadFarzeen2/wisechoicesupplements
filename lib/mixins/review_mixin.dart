import 'package:cirilla/constants/assets.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/models/product_review/product_review.dart';
import 'package:cirilla/utils/date_format.dart';
import 'package:cirilla/widgets/cirilla_shimmer.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:cirilla/utils/url_launcher.dart';
import 'package:ui/ui.dart';

mixin ReviewMixin {
  Widget buildAvatar({ProductReview? review}) {
    if (review?.id == null) {
      return CirillaShimmer(
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: ImageLoading(
        review?.avatar?.isNotEmpty == true ? review!.avatar! : Assets.noImageUrl,
        width: 48,
        height: 48,
      ),
    );
  }

  Widget buildUser({
    ProductReview? review,
    double shimmerWidth = 60,
    double shimmerHeight = 14,
    required ThemeData theme,
  }) {
    if (review?.id == null) {
      return CirillaShimmer(
        child: Container(
          width: shimmerWidth,
          height: shimmerHeight,
          color: Colors.white,
        ),
      );
    }
    return Text(review!.reviewer ?? '', style: theme.textTheme.titleSmall);
  }

  Widget buildDate({
    ProductReview? review,
    double shimmerWidth = 95,
    double shimmerHeight = 12,
    required ThemeData theme,
  }) {
    if (review?.id == null) {
      return CirillaShimmer(
        child: Container(
          width: shimmerWidth,
          height: shimmerHeight,
          color: Colors.white,
        ),
      );
    }
    return Text(formatDate(date: review!.dateCreated!), style: theme.textTheme.bodySmall);
  }

  Widget buildRating({
    ProductReview? review,
    double shimmerWidth = 100,
    double shimmerHeight = 14,
    required ThemeData theme,
  }) {
    if (review?.id == null) {
      return CirillaShimmer(
        child: Container(
          width: shimmerWidth,
          height: shimmerHeight,
          color: Colors.white,
        ),
      );
    }
    return CirillaRating(value: review!.rating! * 1.0);
  }

  Widget buildComment({
    ProductReview? review,
    double shimmerWidth = 200,
    double shimmerHeight = 12,
    required ThemeData theme,
  }) {
    if (review?.id == null) {
      return CirillaShimmer(
        child: Container(
          width: shimmerWidth,
          height: shimmerHeight,
          color: Colors.white,
        ),
      );
    }
    Style styleDefault = Style(
      lineHeight: const LineHeight(1.5),
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      color: theme.textTheme.bodySmall?.color,
      fontSize: FontSize(theme.textTheme.bodySmall?.fontSize),
      fontWeight: theme.textTheme.bodySmall?.fontWeight,
    );

    return Html(
      data: review?.review ?? '',
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
        "a": Style(color: theme.primaryColor),
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

  Widget buildImages() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(4, (index) {
        return CirillaShimmer(
          child: Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(color: Colors.white, borderRadius: borderRadiusTiny),
          ),
        );
      }),
    );
  }
}
