import 'package:fitlify_flutter/generated/l10n.dart';

class DisplayableError {
  final String title;
  final String message;

  DisplayableError(this.title, this.message);

  DisplayableError.commonError()
      : title = S.current.errorTitleCommon,
        message = S.current.errorMessageCommon;
}
