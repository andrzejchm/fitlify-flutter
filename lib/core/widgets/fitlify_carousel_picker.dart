import 'package:flutter/cupertino.dart';

class FitlifyCarouselPicker extends StatelessWidget {
  final FixedExtentScrollController scrollController;
  final ValueChanged<int> onSelectedItemChanged;
  final String Function(int index) textBuilder;
  final int childCount;

  const FitlifyCarouselPicker({
    Key key,
    @required this.scrollController,
    @required this.onSelectedItemChanged,
    @required this.textBuilder,
    @required this.childCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker.builder(
      itemExtent: 40,
      scrollController: scrollController,
      onSelectedItemChanged: onSelectedItemChanged,
      itemBuilder: (context, index) => Center(child: Text(textBuilder(index))),
      childCount: childCount,
      useMagnifier: true,
      magnification: 1.3,
    );
  }
}
