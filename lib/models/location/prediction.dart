import 'package:json_annotation/json_annotation.dart';

part 'prediction.g.dart';

@JsonSerializable()
class Prediction {
  String description;

  @JsonKey(name: 'matched_substrings')
  List<MatchedSubstring> matchedSubstrings;

  @JsonKey(name: 'place_id')
  String? placeId;

  @JsonKey(name: 'structured_formatting')
  StructuredFormatting structuredFormatting;

  List<Term> terms;

  @JsonKey(fromJson: fromType)
  List<String> types;

  Prediction({
    required this.description,
    required this.matchedSubstrings,
    required this.structuredFormatting,
    required this.terms,
    required this.types,
    this.placeId,
  });
  factory Prediction.fromJson(Map<String, dynamic> json) => _$PredictionFromJson(json);
  Map<String, dynamic> toJson() => _$PredictionToJson(this);

  static List<MatchedSubstring> matchedSubstringToList(List<dynamic>? data) {
    List<MatchedSubstring> matchedSubstrings = <MatchedSubstring>[];

    if (data == null) return matchedSubstrings;

    matchedSubstrings = data.map((d) => MatchedSubstring.fromJson(d)).toList().cast<MatchedSubstring>();

    return matchedSubstrings;
  }

  static List<Term> termsToList(List<dynamic>? data) {
    List<Term> newTerms = <Term>[];

    if (data == null) return newTerms;

    newTerms = data.map((d) => Term.fromJson(d)).toList().cast<Term>();

    return newTerms;
  }

  static List<String> fromType(List<dynamic>? types) {
    if (types == null) return [];
    List<String> newTypes = types.whereType<String>().toList();
    return newTypes;
  }
}

/// matched_substrings
///
@JsonSerializable()
class MatchedSubstring {
  int length;
  int offset;

  MatchedSubstring({
    required this.length,
    required this.offset,
  });
  factory MatchedSubstring.fromJson(Map<String, dynamic> json) => _$MatchedSubstringFromJson(json);
  Map<String, dynamic> toJson() => _$MatchedSubstringToJson(this);
}

/// terms
///
@JsonSerializable()
class Term {
  int offset;
  String value;

  Term({
    required this.offset,
    required this.value,
  });
  factory Term.fromJson(Map<String, dynamic> json) => _$TermFromJson(json);
  Map<String, dynamic> toJson() => _$TermToJson(this);
}

/// structured_formatting
///
@JsonSerializable()
class StructuredFormatting {
  @JsonKey(name: 'main_text')
  String mainText;

  @JsonKey(name: 'main_text_matched_substrings')
  List<MainTextMatchedSubstring> mainTextMatchedSubstrings;

  @JsonKey(name: 'secondary_text')
  String secondaryText;

  StructuredFormatting({
    required this.mainText,
    required this.mainTextMatchedSubstrings,
    required this.secondaryText,
  });

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) => _$StructuredFormattingFromJson(json);
  Map<String, dynamic> toJson() => _$StructuredFormattingToJson(this);

  static List<MainTextMatchedSubstring> mainTextMatchedSubstring(List<dynamic>? data) {
    List<MainTextMatchedSubstring> mainTextMatchedSubstring = <MainTextMatchedSubstring>[];

    if (data == null) return mainTextMatchedSubstring;

    mainTextMatchedSubstring =
        data.map((d) => MainTextMatchedSubstring.fromJson(d)).toList().cast<MainTextMatchedSubstring>();

    return mainTextMatchedSubstring;
  }
}

/// main_text_matched_substrings
///
@JsonSerializable()
class MainTextMatchedSubstring {
  int length;
  int offset;

  MainTextMatchedSubstring({
    required this.length,
    required this.offset,
  });

  factory MainTextMatchedSubstring.fromJson(Map<String, dynamic> json) => _$MainTextMatchedSubstringFromJson(json);
  Map<String, dynamic> toJson() => _$MainTextMatchedSubstringToJson(this);
}
