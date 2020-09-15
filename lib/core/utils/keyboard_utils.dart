import 'package:flutter/material.dart';

void hideKeyboard(BuildContext context, Function() func) {
  FocusScope.of(context)?.unfocus();
  func();
}
