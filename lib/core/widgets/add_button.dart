import 'package:fitlify_flutter/core/widgets/accent_button.dart';
import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final VoidCallback onClicked;

  const AddButton({Key key, @required this.onClicked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AccentButton(
      padding: 8,
      icon: Icons.add,
      onClicked: onClicked,
    );
  }
}
