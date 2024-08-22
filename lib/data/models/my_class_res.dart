import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import 'meta.dart';

part 'my_class_res.freezed.dart';

part 'my_class_res.g.dart';

@freezed
class MyClassRes with _$MyClassRes {
  @JsonSerializable(explicitToJson: true)
  const factory MyClassRes({
    required Meta meta,
    required List<MyClass>? data,
  }) = _MyClassRes;

  factory MyClassRes.fromJson(Map<String, dynamic> json) =>
      _$MyClassResFromJson(json);
}

@freezed
class MyClass with _$MyClass {
  const factory MyClass({
    required int userSeq,
    required int studyGroupSeq,
    required int studyGroupUserSeq,
    required String freeYn,
    required String beginDate,
    required String closeDate,
  }) = _MyClass;

  factory MyClass.fromJson(Map<String, dynamic> json) =>
      _$MyClassFromJson(json);
}
