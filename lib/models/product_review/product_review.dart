import 'package:json_annotation/json_annotation.dart';
part 'product_review.g.dart';

@JsonSerializable()
class ProductReview {
  int? id;

  @JsonKey(name: 'date_created')
  String? dateCreated;

  @JsonKey(name: 'date_created_gmt')
  String? dateCreatedGmt;

  @JsonKey(name: 'product_id')
  int? productId;

  ProductReviewStatus? status;

  String? reviewer;

  @JsonKey(name: 'reviewer_email')
  String? reviewerEmail;

  String? review;

  int? rating;

  bool? verified;

  @JsonKey(name: 'reviewer_avatar_urls', fromJson: _fromJsonAvatar)
  String? avatar;

  @JsonKey(name: 'reviews_images', fromJson: _fromJsonImages)
  List<Map<String, dynamic>>? images;

  ProductReview({
    this.id,
    this.dateCreated,
    this.dateCreatedGmt,
    this.productId,
    this.status,
    this.reviewer,
    this.reviewerEmail,
    this.review,
    this.rating,
    this.verified,
    this.images,
  });

  static String? _fromJsonAvatar(dynamic value) {
    if (value is Map) return value['48'];
    return null;
  }

  static List<Map<String, dynamic>> _fromJsonImages(dynamic value) {
    List<Map<String, dynamic>> data = [];

    if (value is List && value.isNotEmpty) {
      for (int i = 0; i < value.length; i++) {
        dynamic item = value[i];
        if (item is Map<String, dynamic>) {
          data.add(item);
        }
      }
    }
    return data;
  }

  factory ProductReview.fromJson(Map<String, dynamic> json) => _$ProductReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ProductReviewToJson(this);
}

enum ProductReviewStatus {
  all,
  hold,
  approved,
  spam,
  trash,
}

@JsonSerializable()
class RatingCount {
  @JsonKey(name: '1')
  int? r1;

  @JsonKey(name: '2')
  int? r2;

  @JsonKey(name: '3')
  int? r3;

  @JsonKey(name: '4')
  int? r4;

  @JsonKey(name: '5')
  int? r5;

  RatingCount({
    this.r1,
    this.r2,
    this.r3,
    this.r4,
    this.r5,
  });

  factory RatingCount.fromJson(Map<String, dynamic> json) => _$RatingCountFromJson(json);

  Map<String, dynamic> toJson() => _$RatingCountToJson(this);
}
