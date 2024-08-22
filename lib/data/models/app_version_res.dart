import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import 'meta.dart';

part 'app_version_res.freezed.dart';

part 'app_version_res.g.dart';

@freezed
class AppVersionRes with _$AppVersionRes {
  @JsonSerializable(explicitToJson: true)
  const factory AppVersionRes({
    required Meta meta,
    required AppVersion? data,
  }) = _AppVersionRes;

  factory AppVersionRes.fromJson(Map<String, dynamic> json) =>
      _$AppVersionResFromJson(json);
}

@freezed
class AppVersion with _$AppVersion {
  const factory AppVersion({
    required int serviceType,
    required int deviceType,
    required String version,
    required String minVersion,
    required String reviewVersion,
  }) = _AppVersion;

  factory AppVersion.fromJson(Map<String, dynamic> json) =>
      _$AppVersionFromJson(json);
}
