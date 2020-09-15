import 'package:fitlify_flutter/core/utils/logger.dart';
import 'package:flutter_test/flutter_test.dart';

class TestResult {
  final dynamic failure;
  final StackTrace stackTrace;
  final bool success;

  bool get isFailure => failure != null;

  TestResult._(this.failure, this.stackTrace, this.success);

  TestResult.failure(this.failure, [StackTrace stack])
      : success = false,
        stackTrace = stack ?? StackTrace.current;

  TestResult.success()
      : failure = null,
        stackTrace = StackTrace.current,
        success = true;

  // ignore: avoid_positional_boolean_parameters
  factory TestResult.expect(dynamic value, Matcher matcher, {String reason}) {
    final desc = StringDescription();
    final matchState = {};
    final matches = matcher.matches(value, matchState);
    matcher.describe(desc);
    if (!matches) {
      matcher.describeMismatch(value, desc, matchState, true);
      debugLog("MISMATCH: $desc");
    }
    final failure = matches ? null : reason ?? desc.toString();
    final stackTrace = StackTrace.current;
    return TestResult._(failure, stackTrace, failure == null);
  }

  factory TestResult.allOf(List<TestResult> results) {
    final failedResult = results.firstWhere((element) => element.failure != null, orElse: () => null);
    final failure = failedResult?.failure;
    final stackTrace = failedResult?.stackTrace;
    return TestResult._(failure, stackTrace, failure == null);
  }
}
