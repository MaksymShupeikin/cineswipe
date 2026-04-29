import 'package:flutter/services.dart';

class HapticService {
  /// Lighter tap for subtle feedback (e.g., selection change, scroll tick)
  static Future<void> light() async {
    await HapticFeedback.selectionClick();
  }

  /// Standard medium impact for meaningful actions (e.g., toggle, button press)
  static Future<void> medium() async {
    await HapticFeedback.mediumImpact();
  }

  /// Heavier impact for significant events (e.g., swipe confirmation, success)
  static Future<void> heavy() async {
    await HapticFeedback.heavyImpact();
  }

  /// Success notification pattern (two quick pulses)
  static Future<void> success() async {
    await HapticFeedback.vibrate(); // Fallback to standard vibrate if needed
    // Note: HapticFeedback doesn't have a built-in success pattern like iOS UINotificationFeedbackGenerator,
    // but heavyImpact is often used for this.
    await HapticFeedback.mediumImpact();
  }

  /// Error/Warning pattern
  static Future<void> error() async {
    await HapticFeedback.vibrate();
  }
}
