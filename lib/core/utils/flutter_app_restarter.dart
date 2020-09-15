import 'package:fitlify_flutter/domain/services/app_restarter.dart';
import 'package:fitlify_flutter/main.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AppRestarter)
class FlutterAppRestarter implements AppRestarter {
  @override
  void restartApp() {
    FitlifyApp.restart();
  }
}
