import 'package:fitlify_flutter/domain/entities/exercise.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:fitlify_flutter/pages/edit_workout/widgets/measurable_property_row.dart';
import 'package:fitlify_flutter/presentation/model/editable.dart';
import 'package:fitlify_flutter/styling/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:kt_dart/collection.dart';

class EditExerciseRow extends StatelessWidget {
  final Editable<Exercise> exercise;
  final VoidCallback onClicked;
  final void Function(bool) onSelected;
  final bool editMode;

  const EditExerciseRow({
    Key key,
    @required this.exercise,
    @required this.onClicked,
    this.onSelected,
    this.editMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isRest = exercise.data.isRest;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Material(
        borderRadius: AppTheme.borderRadiusM,
        color: isRest ? colorScheme.background : colorScheme.secondaryVariant,
        child: InkWell(
          onTap: onClicked,
          borderRadius: AppTheme.borderRadiusM,
          child: Container(
            decoration: isRest
                ? BoxDecoration(border: Border.all(color: colorScheme.onBackground.withOpacity(0.1)), borderRadius: AppTheme.borderRadiusM)
                : null,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(editMode ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (editMode) Checkbox(value: exercise.selected, onChanged: (selected) => onSelected(selected)),
                      Expanded(
                        child: Text(
                          isRest ? S.current.restTypeOption : exercise.data.name,
                          textAlign: isRest ? TextAlign.center : TextAlign.start,
                          style: theme.textTheme.headline5
                              .copyWith(color: isRest ? colorScheme.onBackground.withOpacity(0.5) : colorScheme.onSecondary),
                        ),
                      ),
                      if (editMode)
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(
                            Icons.reorder,
                            color: (isRest ? colorScheme.onBackground : colorScheme.onSecondary).withOpacity(0.5),
                          ),
                        ),
                    ],
                  ),
                  if (!editMode && exercise.data.notes.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.sticky_note_2,
                          size: AppTheme.smallIconSize,
                          color: (isRest ? colorScheme.onSurface : colorScheme.onSecondary).withOpacity(0.6),
                        ),
                        const SizedBox(width: AppTheme.spacingS),
                        Text(
                          exercise.data.notes,
                          style: TextStyle(color: (isRest ? colorScheme.onSurface : colorScheme.onSecondary).withOpacity(0.6)),
                        ),
                      ],
                    ),
                  if (!editMode) const SizedBox(height: 10),
                  if (!editMode)
                    ...isRest
                        ? [MeasurablePropertyRow(property: exercise.data.rest.property, isRest: true)]
                        : exercise.data.properties.map((it) => MeasurablePropertyRow(property: it, isRest: false)).asList()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static String heroTag(String id) => "exerciseRow$id";
}
