import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';

// ignore: prefer_function_declarations_over_variables
void Function(dynamic error, StackTrace stack, String reason) errorLogger = (error, stack, reason) =>
    FirebaseCrashlytics.instance.recordError(error, stack is StackTrace ? stack : StackTrace.current, reason: reason);

void logError(dynamic error, [StackTrace stack, String reason]) {
  errorLogger(error, stack, reason);
}

void debugLog(String message, [dynamic caller]) {
  debugPrint(caller == null ? message : "${caller.runtimeType}: $message");
}
