import 'package:flutter/services.dart';

class HapticService {
  static bool _isRunning = false;
  static DateTime? _lastFeedbackAt;
  static const Duration _minInterval = Duration(milliseconds: 140);

  static bool _canRun() {
    final now = DateTime.now();
    final lastFeedbackAt = _lastFeedbackAt;
    if (_isRunning ||
        (lastFeedbackAt != null &&
            now.difference(lastFeedbackAt) < _minInterval)) {
      return false;
    }

    _isRunning = true;
    _lastFeedbackAt = now;
    return true;
  }

  static void _complete() {
    _isRunning = false;
  }

  /// Lighter tap for subtle feedback (e.g., selection change, scroll tick)
  static Future<void> light() async {
    if (!_canRun()) return;
    try {
      await HapticFeedback.selectionClick();
    } finally {
      _complete();
    }
  }

  /// Standard medium impact for meaningful actions (e.g., toggle, button press)
  static Future<void> medium() async {
    if (!_canRun()) return;
    try {
      await HapticFeedback.mediumImpact();
    } finally {
      _complete();
    }
  }

  /// Heavier impact for significant events (e.g., swipe confirmation, success)
  static Future<void> heavy() async {
    if (!_canRun()) return;
    try {
      await HapticFeedback.heavyImpact();
    } finally {
      _complete();
    }
  }

  /// Success notification pattern (two quick pulses)
  static Future<void> success() async {
    if (!_canRun()) return;
    try {
      await HapticFeedback.vibrate();
      await HapticFeedback.mediumImpact();
    } finally {
      _complete();
    }
  }

  /// Error/Warning pattern
  static Future<void> error() async {
    if (!_canRun()) return;
    try {
      await HapticFeedback.vibrate();
    } finally {
      _complete();
    }
  }
}
