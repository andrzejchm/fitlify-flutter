class Distance {
  int _meters;
  int _kilometers;

  int get meters => _meters;

  int get kilometers => _kilometers;

  int get totalMeters => kilometers * 1000 + meters;

  Distance(int meters)
      : _kilometers = meters ~/ 1000,
        _meters = meters % 1000;

  void updateMeters(int meters) {
    _meters = meters ?? _meters;
  }

  void updateKilometers(int kilometers) {
    _kilometers = kilometers ?? _kilometers;
  }

  String formatShort() => kilometers == 0
      ? "$meters m"
      : meters == 0
          ? "$kilometers km"
          : "$kilometers km $meters m";

  @override
  String toString() => formatShort();
}
