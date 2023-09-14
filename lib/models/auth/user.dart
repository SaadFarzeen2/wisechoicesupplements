import 'package:cirilla/constants/assets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: 'ID')
  String id;

  @JsonKey(name: 'user_login')
  String? userLogin;

  @JsonKey(name: 'user_nicename')
  String? userNiceName;

  @JsonKey(name: 'user_email')
  String? userEmail;

  @JsonKey(name: 'display_name')
  String? displayName;

  @JsonKey(name: 'first_name')
  String? firstName;

  @JsonKey(name: 'last_name')
  String? lastName;

  @JsonKey(defaultValue: Assets.noImageUrl)
  String? avatar;

  @JsonKey(name: 'social_avatar', fromJson: _toSocialString)
  String? socialAvatar;

  @JsonKey(defaultValue: 'email')
  String? loginType;

  List<String> roles;

  /// This property available on App builder since version 2.9.0
  @JsonKey(toJson: optionsToJson)
  UserOptions? options;

  User({
    required this.id,
    this.userLogin,
    this.userNiceName,
    this.userEmail,
    this.displayName,
    this.firstName,
    this.lastName,
    this.avatar,
    this.socialAvatar,
    this.loginType,
    required this.roles,
    this.options,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

 static String? _toSocialString(dynamic value) {
    if (value is String?) {
      return value;
    }
    return null;
  }
  
  static Map<String, dynamic> optionsToJson(UserOptions? userOptions) {
    if (userOptions != null) {
      return userOptions.toJson();
    }
    return {};
  }
}

/// The User Option Config store on/off features
///
/// Ex: To decided hide or display advertisement for logged user, we collect data via REST or computed value
/// and store here. But prefer only store for reading, do not manual edit value in this object.
///
/// Also it was born for open idea on the future of the app.
///
@JsonSerializable()
class UserOptions {
  /// Option hideAds
  ///
  /// This option to check hide or display advertisement on the app.
  /// Since App builder 2.9.0 we support [Paid Memberships Pro](https://www.paidmembershipspro.com)
  /// So to detect show/hide Ads on the app you should install [Paid Memberships Pro](https://www.paidmembershipspro.com)
  /// You can get more info [here](https://www.paidmembershipspro.com/documentation/content-controls/hide-ads/)
  ///
  /// Hide Ads if this option set true, default is false
  bool hideAds;

  String b2bkingCustomerGroupId;

  /// UserOptions constructor
  UserOptions({
    this.hideAds = false,
    this.b2bkingCustomerGroupId = '',
  });

  /// Empty Option Config
  factory UserOptions.empty() => UserOptions(hideAds: false);

  /// UserOptions from Json
  factory UserOptions.fromJson(Map<String, dynamic> json) => _$UserOptionsFromJson(json);

  /// Json from UserOptions
  Map<String, dynamic> toJson() => _$UserOptionsToJson(this);
}
