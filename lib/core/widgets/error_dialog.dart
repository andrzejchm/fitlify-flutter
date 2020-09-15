import 'package:fitlify_flutter/domain/failures/displayable_error.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final DisplayableError error;

  const ErrorDialog({
    Key key,
    @required this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(error.title, style: Theme.of(context).textTheme.headline3),
      content: Text(error.message),
      actions: [
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(S.of(context).okAction),
        )
      ],
    );
  }
}
