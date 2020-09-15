// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'utils/test_keys.dart';

void main() {
  FlutterDriver driver;

  group("FirebaseWorkoutsRepository", () {
    //
    test("saving existing workout returns the same workout", () async {
      //
      await _performTest(driver, TestKeys.test1);
    });
    test("saving new workout returns workout with new id", () async {
      //
      await _performTest(driver, TestKeys.test2);
    });
    test("workout is created with current date", () async {
      //
      await _performTest(driver, TestKeys.test3);
    });
    test("all workouts are returned", () async {
      //
      await _performTest(driver, TestKeys.test4);
    });
  });

  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  tearDownAll(() async {
    const timeout = Duration(seconds: 5);
    await driver.tap(find.byValueKey(TestKeys.tearDownAllButton), timeout: timeout);
    await driver.waitFor(find.byValueKey(TestKeys.testsFinished), timeout: timeout);
    if (driver != null) {
      await driver.close();
    }
  });
}

Future<void> _performTest(FlutterDriver driver, String testKey) async {
  const timeout = Duration(seconds: 5);
  final resultText = find.byValueKey(TestKeys.testResult);
  final testButton = find.byValueKey(testKey);
  final tearDownButton = find.byValueKey(TestKeys.tearDownButton);
  await driver.waitFor(testButton, timeout: timeout);
  await driver.tap(testButton, timeout: timeout);
  await driver.waitFor(resultText, timeout: timeout);
  final result = await driver.getText(resultText, timeout: timeout);
  await driver.waitFor(tearDownButton, timeout: timeout);
  await driver.tap(tearDownButton, timeout: timeout);
  await driver.waitFor(testButton, timeout: timeout);
  expect(result, equals(TestKeys.success));
}
