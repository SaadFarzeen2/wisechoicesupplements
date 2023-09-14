import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/product_review/product_review.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

import 'review_image.dart';

class CirillaReviewProductItem extends StatelessWidget with ReviewMixin {
  final ProductReview? review;

  CirillaReviewProductItem({Key? key, this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: paddingVerticalLarge,
          child: CommentContainedItem(
            image: buildAvatar(review: review),
            name: buildUser(review: review, theme: theme),
            comment: buildComment(review: review, theme: theme),
            date: buildDate(review: review, theme: theme),
            rating: buildRating(review: review, theme: theme),
            images: review?.id != null && review?.images?.isNotEmpty == true
                ? ReviewImage(
                    images: review!.images!,
                    reviewId: review!.id!,
                  )
                : review?.id == null
                    ? buildImages()
                    : null,
            onClick: () {},
          ),
        ),
        const Divider(height: 1, thickness: 1),
      ],
    );
  }
}
