import 'package:fitlify_flutter/styling/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        child: Center(
          child: Shimmer.fromColors(
            baseColor: AppThemeColors.accent,
            highlightColor: AppThemeColors.accent.withOpacity(0.2),
            child: Text("Fitlify", style: AppThemeTextStyles.titleXXXL),
          ),
        ),
      ),
    );
  }
}
