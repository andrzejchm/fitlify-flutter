import 'package:flutter/material.dart';

class CheckboxRow extends StatelessWidget {
  final void Function(bool checked) onChanged;
  final bool checked;
  final String text;

  const CheckboxRow({
    Key key,
    @required this.onChanged,
    @required this.checked,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(text),
        Checkbox(value: checked, onChanged: onChanged),
      ],
    );
  }
}
