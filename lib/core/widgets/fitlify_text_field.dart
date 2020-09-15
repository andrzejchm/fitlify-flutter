import 'package:fitlify_flutter/styling/app_theme.dart';
import 'package:flutter/material.dart';

class FitlifyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final void Function(String text) onChanged;
  final Color color;
  final bool autofocus;
  final TextInputType keyboardType;
  final FocusNode focusNode;

  const FitlifyTextField({
    Key key,
    this.controller,
    this.label,
    this.onChanged,
    this.color,
    this.autofocus = false,
    this.keyboardType,
    this.focusNode,
    this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: AppTheme.borderRadiusM,
      color: color ?? Theme.of(context).colorScheme.background,
      child: Padding(
        padding: EdgeInsets.only(top: label == null ? 0 : 12.0),
        child: _textField(),
      ),
    );
  }

  Widget _textField() => TextField(
        autofocus: autofocus,
        focusNode: focusNode,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          floatingLabelBehavior: label == null ? FloatingLabelBehavior.never : FloatingLabelBehavior.auto,
          border: const OutlineInputBorder(borderSide: BorderSide.none, gapPadding: 0),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none, gapPadding: 0),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none, gapPadding: 0),
        ),
        style: const TextStyle(fontSize: 17),
        onChanged: onChanged,
      );
}
