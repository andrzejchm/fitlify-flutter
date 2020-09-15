import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:flutter/material.dart';

class AddRestButton extends StatelessWidget {
  final VoidCallback onClicked;

  const AddRestButton({
    Key key,
    @required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onClicked,
      child: Text(S.of(context).restBetweenSetsAction, style: const TextStyle(fontSize: 17)),
    );
  }
}
