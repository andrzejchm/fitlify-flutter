import 'package:fitlify_flutter/styling/app_theme.dart';
import 'package:flutter/material.dart';

class FitlifyDropdownButton<T> extends StatelessWidget {
  const FitlifyDropdownButton({
    Key key,
    @required this.dropdownMenuItems,
    @required this.value,
    @required this.onChanged,
  }) : super(key: key);

  final T value;
  final void Function(T) onChanged;
  final List<DropdownMenuItem<T>> dropdownMenuItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: AppTheme.borderRadiusM,
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: DropdownButton<T>(
          underline: const SizedBox.shrink(),
          isExpanded: true,
          itemHeight: 70,
          value: value,
          items: dropdownMenuItems,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
