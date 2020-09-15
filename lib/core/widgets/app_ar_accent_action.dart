import 'package:fitlify_flutter/styling/app_theme.dart';
import 'package:flutter/material.dart';

class AppBarAccentAction extends StatelessWidget {
  final VoidCallback onClicked;
  final String text;

  const AppBarAccentAction({
    Key key,
    @required this.onClicked,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onClicked,
      child: Text(text, style: AppThemeTextStyles.title.copyWith(color: AppThemeColors.accent)),
    );
  }
}
