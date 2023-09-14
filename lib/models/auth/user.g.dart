// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['ID'] as String,
      userLogin: json['user_login'] as String?,
      userNiceName: json['user_nicename'] as String?,
      userEmail: json['user_email'] as String?,
      displayName: json['display_name'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      avatar: json['avatar'] as String? ?? 'https://cdn.rnlab.io/placeholder-416x416.png',
      socialAvatar: User._toSocialString(json['social_avatar']),
      loginType: json['loginType'] as String? ?? 'email',
      roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
      options: json['options'] == null ? null : UserOptions.fromJson(json['options'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'ID': instance.id,
      'user_login': instance.userLogin,
      'user_nicename': instance.userNiceName,
      'user_email': instance.userEmail,
      'display_name': instance.displayName,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'avatar': instance.avatar,
      'socialAvatar': instance.socialAvatar,
      'loginType': instance.loginType,
      'roles': instance.roles,
      'options': User.optionsToJson(instance.options),
    };

UserOptions _$UserOptionsFromJson(Map<String, dynamic> json) => UserOptions(
      hideAds: json['hideAds'] as bool? ?? false,
      b2bkingCustomerGroupId: json['b2bkingCustomerGroupId'] as String? ?? '',
    );

Map<String, dynamic> _$UserOptionsToJson(UserOptions instance) => <String, dynamic>{
      'hideAds': instance.hideAds,
      'b2bkingCustomerGroupId': instance.b2bkingCustomerGroupId,
    };
