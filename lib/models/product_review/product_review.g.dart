// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductReview _$ProductReviewFromJson(Map<String, dynamic> json) => ProductReview(
      id: json['id'] as int?,
      dateCreated: json['date_created'] as String?,
      dateCreatedGmt: json['date_created_gmt'] as String?,
      productId: json['product_id'] as int?,
      status: $enumDecodeNullable(_$ProductReviewStatusEnumMap, json['status']),
      reviewer: json['reviewer'] as String?,
      reviewerEmail: json['reviewer_email'] as String?,
      review: json['review'] as String?,
      rating: json['rating'] as int?,
      verified: json['verified'] as bool?,
      images: ProductReview._fromJsonImages(json['reviews_images']),
    )..avatar = ProductReview._fromJsonAvatar(json['reviewer_avatar_urls']);

Map<String, dynamic> _$ProductReviewToJson(ProductReview instance) => <String, dynamic>{
      'id': instance.id,
      'date_created': instance.dateCreated,
      'date_created_gmt': instance.dateCreatedGmt,
      'product_id': instance.productId,
      'status': _$ProductReviewStatusEnumMap[instance.status],
      'reviewer': instance.reviewer,
      'reviewer_email': instance.reviewerEmail,
      'review': instance.review,
      'rating': instance.rating,
      'verified': instance.verified,
      'reviewer_avatar_urls': instance.avatar,
      'reviews_images': instance.images,
    };

const _$ProductReviewStatusEnumMap = {
  ProductReviewStatus.all: 'all',
  ProductReviewStatus.hold: 'hold',
  ProductReviewStatus.approved: 'approved',
  ProductReviewStatus.spam: 'spam',
  ProductReviewStatus.trash: 'trash',
};

RatingCount _$RatingCountFromJson(Map<String, dynamic> json) => RatingCount(
      r1: json['1'] as int?,
      r2: json['2'] as int?,
      r3: json['3'] as int?,
      r4: json['4'] as int?,
      r5: json['5'] as int?,
    );

Map<String, dynamic> _$RatingCountToJson(RatingCount instance) => <String, dynamic>{
      '1': instance.r1,
      '2': instance.r2,
      '3': instance.r3,
      '4': instance.r4,
      '5': instance.r5,
    };
