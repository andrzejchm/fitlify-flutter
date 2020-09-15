import 'package:flutter/material.dart';

class CaptionText extends StatelessWidget {
  const CaptionText(
    this.text, {
    Key key,
    this.padding = EdgeInsets.zero,
    this.opacity = 1.0,
  }) : super(key: key);

  const CaptionText.emptyMessage(this.text)
      : padding = const EdgeInsets.only(top: 32.0, bottom: 32.0),
        opacity = 0.6;

  final String text;
  final EdgeInsets padding;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Center(
          child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground.withOpacity(opacity)),
      )),
    );
  }
}
