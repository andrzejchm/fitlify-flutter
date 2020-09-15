import 'package:firebase_core/firebase_core.dart';
import 'package:fitlify_flutter/app_widget.dart';
import 'package:fitlify_flutter/dependency_injection/app_component.dart';
import 'package:fitlify_flutter/routing/app_init_error.dart';
import 'package:fitlify_flutter/routing/app_loading.dart';
import 'package:flutter/material.dart';

void main() {
  FlutterError.onError = (details) {
    debugPrint("${details.exception}\n${details.stack}");
  };
  runApp(FitlifyApp());
}

class FitlifyApp extends StatefulWidget {
  @override
  _FitlifyAppState createState() => _FitlifyAppState();

  static void restart() => _FitlifyAppState.instance?.restartApp();
}

class _FitlifyAppState extends State<FitlifyApp> {
  final Future<FirebaseApp> _initFirebase = Firebase.initializeApp();

  static _FitlifyAppState instance;

  Key _key;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  Future<void> restartApp() async {
    await getIt.reset();
    setState(() => _initialize());
  }

  void _initialize() {
    configureDependencies();
    _key = UniqueKey();
    instance = this;
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: FutureBuilder(
          future: _initFirebase,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AppWidget();
            } else if (snapshot.hasError) {
              return AppInitError();
            } else {
              return AppLoading();
            }
          }),
    );
  }
}
