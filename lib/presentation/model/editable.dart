import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'editable.freezed.dart';

@freezed
abstract class Editable<T> implements _$Editable<T> {
  const factory Editable({
    @required T data,
    @Default(true) bool expanded,
    @Default(false) bool selected,
  }) = _Editable;

  Editable<T> byTogglingExpanded() => copyWith(expanded: !expanded);

  Editable<T> byTogglingSelected() => copyWith(selected: !selected);

  Editable<T> byUpdatingData(T data) => copyWith(data: data);

  const Editable._();
}
