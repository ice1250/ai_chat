import 'package:freezed_annotation/freezed_annotation.dart';

import 'meta.dart';

part 'app_version_res.freezed.dart';
part 'app_version_res.g.dart';

@freezed
class AppVersionRes with _$AppVersionRes {
  const factory AppVersionRes({
    required Meta meta,
    required Data? data,
  }) = _AppVersionRes;

  factory AppVersionRes.fromJson(Map<String, dynamic> json) =>
      _$AppVersionResFromJson(json);

}

@freezed
class Data with _$Data {
  const factory Data({
    required int seq,
    required int serviceType,
    required int deviceType,
    required String version,
    required String minVersion,
    required String reviewVersion,
    required DateTime registDate,
    required DateTime updateDate,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

}
