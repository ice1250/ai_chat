import 'package:freezed_annotation/freezed_annotation.dart';

import 'meta.dart';

part 'token_res.freezed.dart';
part 'token_res.g.dart';

@freezed
class TokenRes with _$TokenRes {
  const factory TokenRes({
    required Meta meta,
    required Data? data,
  }) = _TokenRes;

  factory TokenRes.fromJson(Map<String, dynamic> json) =>
      _$TokenResFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    required String accessToken,
    required String refreshToken,
    required User user,
    required String lastLoginDateTime,
    required String? message,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
class User with _$User {
  const factory User({
    required int userSeq,
    required String userId,
    required String userName,
    required String nickName,
    required String profileImageUrl,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
