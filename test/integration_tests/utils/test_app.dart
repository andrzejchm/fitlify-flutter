import 'package:fitlify_flutter/dependency_injection/app_component.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

class TestApp {
  static Future<void> pumpPage<T>(WidgetTester tester, T _presenter, Widget Function() pageBuilder) async {
    await getIt.reset();
    configureDependencies();
    await tester.pumpWidget(
      TestWidgetFrame(
        child: Provider(
          create: (context) => _presenter,
          child: pageBuilder(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }
}

class TestWidgetFrame extends StatelessWidget {
  final Widget child;
  final bool embedInScaffold;

  const TestWidgetFrame({Key key, this.child, this.embedInScaffold = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(
        size: Size(1080, 1920),
        devicePixelRatio: 2.0,
      ),
      child: MaterialApp(
        home: embedInScaffold ? Scaffold(body: child) : child,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
      ),
    );
  }
}
