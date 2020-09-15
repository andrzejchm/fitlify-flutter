import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
abstract class User implements _$User {
  const factory User({
    @required String id,
    @required bool isAnonymous,
    @required @nullable String displayName,
    @required @nullable String avatarUrl,
  }) = _User;

  const User._();
}
