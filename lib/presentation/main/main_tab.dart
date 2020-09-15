import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum MainTab { workouts, history }

extension MainTabResources on MainTab {
  String get title {
    switch (this) {
      case MainTab.workouts:
        return S.current.workoutsTab;
      case MainTab.history:
        return S.current.historyTab;
      default:
        throw StateError("cannot parse $this into title");
    }
  }

  IconData get icon {
    switch (this) {
      case MainTab.workouts:
        return Icons.fitness_center_rounded;
      case MainTab.history:
        return Icons.history_rounded;
      default:
        throw StateError("cannot parse $this into icon");
    }
  }
}
