import 'package:fitlify_flutter/domain/failures/displayable_error.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_failure.freezed.dart';

@freezed
abstract class AuthFailure implements _$AuthFailure {
  const AuthFailure._();

  const factory AuthFailure.notLoggedIn() = AuthFailureNotLoggedIn;

  const factory AuthFailure.unknown(dynamic error, String reason) = AuthFailureUnknown;

  const factory AuthFailure.credentialAlreadyInUse() = AuthFailureCredentialAlreadyInUse;

  DisplayableError toDisplayableError() => map(
        notLoggedIn: (prop) => DisplayableError(S.current.errorTitleCommon, S.current.errorMessageNotLoggedIn),
        unknown: (prop) => DisplayableError.commonError(),
        credentialAlreadyInUse: (prop) => DisplayableError(S.current.errorTitleCommon, S.current.errorMessageCredentialAlreadyInUse),
      );
}
