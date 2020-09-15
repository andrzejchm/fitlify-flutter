import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_test/flutter_test.dart';

import 'tests/firebase_workouts_repository_tests.dart';
import 'tests/test_result.dart';
import 'utils/test_keys.dart';

void main() {
  enableFlutterDriverExtension();
  runApp(FirestoreTestApp());
}

class FirestoreTestApp extends StatefulWidget {
  @override
  _FirestoreTestAppState createState() => _FirestoreTestAppState();
}

class _FirestoreTestAppState extends State<FirestoreTestApp> {
  FirebaseWorkoutsRepositoryTests workoutsRepositoryTests;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      final tests = FirebaseWorkoutsRepositoryTests();
      await tests.initialize();
      setState(() {
        workoutsRepositoryTests = tests;
      });
    } catch (ex, stack) {
      debugPrint("ERROR: $ex");
      debugPrint("$stack");
    }
  }

  TestResult _result;
  Future<void> Function() _tearDownFunc;
  bool _finishedTestSuite = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: _finishedTestSuite
              ? const Text(
                  TestKeys.testsFinished,
                  key: ValueKey(TestKeys.testsFinished),
                )
              : _result != null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_result.success == true ? TestKeys.success : TestKeys.failure, key: const ValueKey(TestKeys.testResult)),
                        FlatButton(
                            onPressed: () => _tearDown(),
                            child: const Text(
                              "Tear Down",
                              key: ValueKey(TestKeys.tearDownButton),
                            ))
                      ],
                    )
                  : workoutsRepositoryTests == null
                      ? const CircularProgressIndicator()
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Firestore test app"),
                            const SizedBox(height: 20),
                            FlatButton(
                              onPressed: () => _performTest(workoutsRepositoryTests.test1),
                              child: const Text(TestKeys.test1, key: ValueKey(TestKeys.test1)),
                            ),
                            FlatButton(
                              onPressed: () => _performTest(workoutsRepositoryTests.test2),
                              child: const Text(TestKeys.test2, key: ValueKey(TestKeys.test2)),
                            ),
                            FlatButton(
                              onPressed: () => _performTest(workoutsRepositoryTests.test3),
                              child: const Text(TestKeys.test3, key: ValueKey(TestKeys.test3)),
                            ),
                            FlatButton(
                              onPressed: () => _performTest(workoutsRepositoryTests.test4),
                              child: const Text(TestKeys.test4, key: ValueKey(TestKeys.test4)),
                            ),
                            FlatButton(
                                onPressed: () => _tearDownAll(),
                                child: const Text(TestKeys.tearDownAllButton, key: ValueKey(TestKeys.tearDownAllButton)))
                          ],
                        ),
        ),
      ),
    );
  }

  Future<void> _tearDown() async {
    await _tearDownFunc();
    setState(() {
      _result = null;
    });
  }

  Future<void> _performTest(TestSetup testSetup) async {
    await testSetup.setUp();
    final res = await testSetup.test();
    setState(() {
      _tearDownFunc = testSetup.tearDown;
      _result = res;
      if (_result.isFailure) {
        debugPrint("\n\n\nTEST FAILURE ${_result.failure}\n\n\nSTACK:\n${_result.stackTrace}");
      }
    });
  }

  Future<void> _tearDownAll() async {
    await workoutsRepositoryTests.tearDownAll();
    setState(() {
      _finishedTestSuite = true;
    });
  }
}
