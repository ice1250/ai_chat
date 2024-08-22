import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import 'meta.dart';

part 'token_res.freezed.dart';
part 'token_res.g.dart';

@freezed
class TokenRes with _$TokenRes {

  @JsonSerializable(explicitToJson: true)
  const factory TokenRes({
    required Meta meta,
    required Token? data,
  }) = _TokenRes;

  factory TokenRes.fromJson(Map<String, dynamic> json) =>
      _$TokenResFromJson(json);
}

@freezed
class Token with _$Token {
  const factory Token({
    required String accessToken,
    required String refreshToken,
    required User user,
    required String lastLoginDateTime,
    required String? message,
  }) = _Token;

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
}

@freezed
class User with _$User {
  const factory User({
    required int userSeq,
    required String userId,
    required String userName,
    required String nickName,
    required String profileImageUrl,
    @Default(false) bool isPremium,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
