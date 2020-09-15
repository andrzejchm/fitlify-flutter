import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: avoid_classes_with_only_static_members
class AppThemeTextStyles {
  static TextStyle get formLabel => const TextStyle(
        color: Colors.black,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      );

  static String get primaryFontFamily => GoogleFonts.lato().fontFamily;

  static TextStyle get appBarTitle => const TextStyle(
        color: Colors.black,
        height: 1.18,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get titleXXXL => const TextStyle(
        color: Colors.black,
        height: 1.18,
        fontSize: 56,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get title => const TextStyle(
        color: Colors.black,
        height: 1.18,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );
}

// ignore: avoid_classes_with_only_static_members
class AppThemeColors {
  static Color get accent => const Color(0xFF0168FF);

  static Color get accentVariant => const Color(0xFF0047AD);

  static Color get primary => const Color(0xff4CDBB8);

  static Color get primaryVariant => const Color(0xff63dfc0);

  static Color get text => const Color(0xFF000000);

  static Color get onAccent => const Color(0xFFFFFFFF);

  static Color get surface => const Color(0xFFFFFFFF);
}

class AppTheme {
  // ignore: prefer_constructors_over_static_methods
  static AppTheme get instance => AppTheme();

  static const BorderRadius borderRadiusM = BorderRadius.all(radiusM);

  static const Radius radiusM = Radius.circular(8);
  static const double elevationXS = 4;
  static const double elevationS = 8;
  static const double elevationM = 16;

  static const double spacingXS = 2;
  static const double spacingS = 4;
  static const double spacingM = 8;
  static const double spacingL = 16;
  static const double spacingXL = 32;

  static const smallIconSize = 14.0;

  ThemeData buildAppTheme() {
    final primaryColorScheme = ColorScheme(
      primary: AppThemeColors.primary,
      primaryVariant: AppThemeColors.primaryVariant,
      secondary: AppThemeColors.accent,
      secondaryVariant: AppThemeColors.accentVariant,
      surface: AppThemeColors.surface,
      background: const Color(0xffF2F2F3),
      error: const Color(0xFFF24363),
      onPrimary: const Color(0xFFFFFFFF),
      onSecondary: const Color(0xFFFFFFFF),
      onSurface: const Color(0xFF2B2D43),
      onBackground: const Color(0xFF2B2D43),
      onError: const Color(0xFFFFFFFF),
      brightness: Brightness.light,
    );
    return ThemeData(
        iconTheme: IconThemeData(color: primaryColorScheme.onSurface),
        scaffoldBackgroundColor: primaryColorScheme.background,
        colorScheme: primaryColorScheme,
        fontFamily: AppThemeTextStyles.primaryFontFamily,
        shadowColor: Colors.black26,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: primaryColorScheme.secondary),
          textTheme: TextTheme(headline6: AppThemeTextStyles.appBarTitle),
          color: Colors.white,
          brightness: Brightness.light,
          elevation: 0,
        ),
        dividerColor: const Color(0xFFCCD6E2),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFCCD6E2))),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColorScheme.secondary)),
        ),
        buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.accent),
        backgroundColor: const Color.fromARGB(255, 246, 247, 251),
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        }),
//      floatingActionButtonTheme: const FloatingActionButtonThemeData(foregroundColor: Colors.white),
        textTheme: TextTheme(
          caption: TextStyle(
            color: primaryColorScheme.onSurface,
            fontSize: 12,
          ),
          bodyText1: TextStyle(
            color: primaryColorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          subtitle1: TextStyle(
            color: primaryColorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          headline1: TextStyle(
            color: primaryColorScheme.onSurface,
            fontSize: 36,
            fontWeight: FontWeight.w700,
          ),
          headline2: TextStyle(
            color: primaryColorScheme.onSurface,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
          headline3: TextStyle(
            color: primaryColorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          headline4: TextStyle(
            color: primaryColorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          headline5: TextStyle(
            color: primaryColorScheme.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          headline6: TextStyle(
            color: primaryColorScheme.onSurface,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        accentColor: primaryColorScheme.secondary,
        primaryColor: primaryColorScheme.secondary,
        tabBarTheme: TabBarTheme(
          indicatorSize: TabBarIndicatorSize.label,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(width: 2, color: primaryColorScheme.secondary),
            insets: const EdgeInsets.only(bottom: 10),
          ),
          labelColor: primaryColorScheme.secondary,
          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          unselectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ));
  }
}
