import 'package:fitlify_flutter/domain/entities/workout.dart';
import 'package:fitlify_flutter/styling/app_theme.dart';
import 'package:flutter/material.dart';

class WorkoutListItem extends StatelessWidget {
  final Workout workout;
  final VoidCallback onClicked;

  const WorkoutListItem({
    Key key,
    @required this.workout,
    @required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM, vertical: AppTheme.spacingS),
      child: ClipRRect(
        borderRadius: AppTheme.borderRadiusM,
        child: Material(
          color: Theme.of(context).colorScheme.surface,
          child: ListTile(
            shape: const RoundedRectangleBorder(
              borderRadius: AppTheme.borderRadiusM,
            ),
            onTap: onClicked,
            title: Text(workout.name, maxLines: 1),
            subtitle: Text(workout.description, maxLines: 1),
          ),
        ),
      ),
    );
  }
}
