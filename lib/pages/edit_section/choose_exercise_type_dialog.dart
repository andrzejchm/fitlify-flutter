import 'package:fitlify_flutter/domain/entities/exercise.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:fitlify_flutter/styling/app_theme.dart';
import 'package:flutter/material.dart';

class ChooseExerciseTypeInitialParams {}

class ChooseExerciseTypeDialog extends StatelessWidget {
  final ChooseExerciseTypeInitialParams initParams;

  const ChooseExerciseTypeDialog(this.initParams);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(S.of(context).selectTypeDialogTitle),
      children: [
        SimpleDialogOption(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          onPressed: () => Navigator.of(context).pop(ExerciseType.exercise),
          child: Text(
            S.of(context).exerciseTypeOption,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
        ),
        SimpleDialogOption(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          onPressed: () => Navigator.of(context).pop(ExerciseType.rest),
          child: Text(
            S.of(context).restTypeOption,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
        ),
      ],
    );
  }
}
