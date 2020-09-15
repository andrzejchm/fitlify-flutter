import 'package:fitlify_flutter/domain/entities/rest.dart';
import 'package:fitlify_flutter/generated/l10n.dart';
import 'package:fitlify_flutter/pages/edit_workout/widgets/measurable_property_row.dart';
import 'package:fitlify_flutter/styling/app_theme.dart';
import 'package:flutter/material.dart';

class RestListItem extends StatelessWidget {
  final VoidCallback onClicked;
  final Rest rest;
  final VoidCallback deleteClicked;
  final Color color;

  const RestListItem({
    Key key,
    this.onClicked,
    @required this.rest,
    this.deleteClicked,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: color ?? colorScheme.background,
          border: Border.all(color: colorScheme.onBackground.withOpacity(0.1)),
          borderRadius: AppTheme.borderRadiusM,
        ),
        child: InkWell(
          borderRadius: AppTheme.borderRadiusM,
          onTap: onClicked,
          child: Padding(
            padding: EdgeInsets.only(
              top: deleteClicked == null ? 8.0 : 0,
              left: 8.0,
              right: 8.0,
              bottom: 8.0,
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    if (deleteClicked != null)
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.remove_circle, color: Theme.of(context).colorScheme.error),
                          onPressed: deleteClicked,
                        ),
                      ),
                    Text(S.of(context).restBetweenSetsTitle),
                  ],
                ),
                SizedBox(height: deleteClicked == null ? 10 : 0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: MeasurablePropertyRow(property: rest.property, isRest: true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
