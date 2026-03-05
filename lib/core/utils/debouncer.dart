import 'dart:async';
import 'package:flutter/foundation.dart';

/// Debouncer utility for delaying function execution
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({this.milliseconds = 500});

  /// Run the action after the debounce duration
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  /// Cancel any pending timer
  void cancel() {
    _timer?.cancel();
  }

  /// Dispose the debouncer
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }

  /// Check if timer is active
  bool get isActive => _timer?.isActive ?? false;
}
