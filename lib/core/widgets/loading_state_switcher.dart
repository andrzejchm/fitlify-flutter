import 'package:fitlify_flutter/core/utils/animation_durations.dart';
import 'package:flutter/material.dart';

class LoadingStateSwitcher extends StatelessWidget {
  final bool isEmpty;
  final bool isLoading;
  final WidgetBuilder emptyBuilder;
  final WidgetBuilder loadingBuilder;
  final WidgetBuilder childBuilder;

  const LoadingStateSwitcher({
    Key key,
    this.isEmpty = false,
    @required this.isLoading,
    this.emptyBuilder,
    @required this.loadingBuilder,
    @required this.childBuilder,
  })  : assert(emptyBuilder != null || !isEmpty, "if emptyBuilder is null then isEmpty has to be false always!"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const LongDuration(),
      child: isLoading
          ? loadingBuilder(context)
          : isEmpty
              ? emptyBuilder(context)
              : childBuilder(context),
    );
  }
}
