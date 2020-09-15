class TimeDuration {
  int _seconds;
  int _minutes;

  int get seconds => _seconds;

  int get minutes => _minutes;

  int get totalSeconds => minutes * 60 + seconds;

  TimeDuration(int seconds)
      : _minutes = seconds ~/ 60,
        _seconds = seconds < 0 ? -1 : seconds % 60;

  void updateSeconds(int seconds) {
    _seconds = seconds ?? _seconds;
  }

  void updateMinutes(int minutes) {
    _minutes = minutes ?? _minutes;
  }

  String formatShort() {
    if (seconds < 0) {
      return "∞";
    }
    return minutes == 0
        ? "${_formatSeconds()} sec"
        : seconds == 0
            ? "$minutes min"
            : "$minutes min ${_formatSeconds()} sec";
  }

  String _formatSeconds() => seconds < 10 ? "0$seconds" : "$seconds";

  @override
  String toString() => formatShort();
}
