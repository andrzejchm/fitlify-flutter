import 'package:flutter/foundation.dart';

extension ListExtensions<T> on List<T> {
  /// returns true if element was found and updated, false otherwise
  bool updateWhere(bool Function(T item) predicate, {@required T to}) {
    final index = indexWhere(predicate);
    if (index != -1) {
      this[index] = to;
      return true;
    }
    return false;
  }
}
