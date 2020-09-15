import 'package:fitlify_flutter/core/utils/animation_durations.dart';
import 'package:fitlify_flutter/core/widgets/caption_text.dart';
import 'package:fitlify_flutter/domain/entities/section_type.dart';
import 'package:fitlify_flutter/domain/entities/section.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:fitlify_flutter/pages/edit_section/section_type_row.dart';
import 'package:fitlify_flutter/pages/edit_workout/widgets/edit_exercise_row.dart';
import 'package:fitlify_flutter/presentation/model/editable.dart';
import 'package:fitlify_flutter/styling/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';

class EditSectionRow extends StatelessWidget {
  final Editable<Section> section;
  final VoidCallback onClicked;
  final bool editMode;
  final void Function(bool selected) onSelected;
  final void Function(bool expanded) onExpanded;
  final TickerProvider vsync;

  bool get showTypeBadge => !editMode && section.data.type.type != SectionTypeEnum.normal;

  static String heroTag(String sectionId) => "EditSectionBackground#$sectionId";

  const EditSectionRow({
    Key key,
    @required this.section,
    @required this.vsync,
    this.onClicked,
    this.editMode,
    this.onSelected,
    this.onExpanded,
  }) : super(key: key);

  Editable<Section> get editable => section;

  bool get expanded => editable.expanded && !editMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Hero(
        tag: EditSectionRow.heroTag(section.data.id),
        child: Material(
          borderRadius: AppTheme.borderRadiusM,
          color: theme.colorScheme.surface,
          elevation: AppTheme.elevationM,
          child: InkWell(
            borderRadius: AppTheme.borderRadiusM,
            onTap: onClicked,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(theme),
                  _mainContent(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row _header(ThemeData theme) {
    return Row(
      children: [
        if (editMode) Checkbox(value: editable.selected, onChanged: (selected) => onSelected(selected)),
        Text(section.data.name, style: theme.textTheme.headline5),
        const Expanded(child: SizedBox.shrink()),
        if (showTypeBadge) SectionTypeRow.small(section.data.type),
        if (!editMode)
          IconButton(
            icon: Icon(
              expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            onPressed: () => onExpanded(editable.expanded),
          ),
        if (editMode)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              Icons.reorder,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          )
      ],
    );
  }

  AnimatedSize _mainContent(BuildContext context) {
    return AnimatedSize(
      duration: const ShortDuration(),
      alignment: Alignment.topCenter,
      vsync: vsync,
      child: SizedBox(
        height: expanded ? null : 0.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (section.data.description.isNotEmpty) ...[
              Text(section.data.description),
              const SizedBox(height: 20),
            ],
            if (section.data.exercises.isEmpty()) CaptionText.emptyMessage(S.of(context).noExercisesMessage),
            ...section.data.exercises
                .toMutableList()
                .map((ex) => EditExerciseRow(
                      exercise: Editable(data: ex),
                      onClicked: null,
                    ))
                .asList(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
