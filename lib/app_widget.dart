import 'package:auto_route/auto_route.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:fitlify_flutter/routing/app_navigator.dart';
import 'package:fitlify_flutter/routing/router.gr.dart' as app_router;
import 'package:fitlify_flutter/styling/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: AppTheme.instance.buildAppTheme(),
      onGenerateRoute: app_router
          .Router() /*TODO remove this line, this is hack for https://github.com/Milad-Akarie/auto_route_library/issues/257#issuecomment-713140479*/,
      builder: ExtendedNavigator.builder<app_router.Router>(
        router: app_router.Router(),
        navigatorKey: AppNavigator.navigatorKey,
      ),
    );
  }
}
