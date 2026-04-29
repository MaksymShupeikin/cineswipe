import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cineswipe/core/app_colors.dart';

class LiquidBackground extends StatefulWidget {
  final Color accentColor;
  const LiquidBackground({required this.accentColor, super.key});

  @override
  State<LiquidBackground> createState() => _LiquidBackgroundState();
}

class _LiquidBackgroundState extends State<LiquidBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  Color _fromColor = AppColors.black;

  @override
  void initState() {
    super.initState();
    _fromColor = widget.accentColor;
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(LiquidBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.accentColor != widget.accentColor) {
      _fromColor = oldWidget.accentColor;
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(begin: _fromColor, end: widget.accentColor),
      duration: const Duration(milliseconds: 700),
      builder: (context, color, _) {
        return AnimatedBuilder(
          animation: _floatController,
          builder: (context, _) {
            return CustomPaint(
              painter: _LiquidPainter(
                accentColor: color ?? AppColors.black,
                t: _floatController.value,
              ),
              size: Size.infinite,
            );
          },
        );
      },
    );
  }
}

class _LiquidPainter extends CustomPainter {
  final Color accentColor;
  final double t;

  const _LiquidPainter({required this.accentColor, required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = AppColors.black,
    );

    // Each axis uses an incommensurable frequency (φ=1.618, √2=1.414, √3=1.732, √5=2.236)
    // so orbs never synchronize and the motion looks chaotic without ever snapping back.
    final double p = t * 2 * pi;

    _drawOrb(
      canvas, size,
      cx: 0.45 + 0.28 * cos(p * 1.000),
      cy: 0.16 + 0.09 * sin(p * 1.618),
      r: 0.70,
      opacity: 0.40,
    );

    _drawOrb(
      canvas, size,
      cx: 0.14 + 0.20 * sin(p * 1.414),
      cy: 0.58 + 0.13 * cos(p * 0.732),
      r: 0.44,
      opacity: 0.24,
    );

    _drawOrb(
      canvas, size,
      cx: 0.82 + 0.11 * cos(p * 1.732),
      cy: 0.26 + 0.17 * sin(p * 1.191),
      r: 0.30,
      opacity: 0.20,
    );

    _drawOrb(
      canvas, size,
      cx: 0.58 + 0.18 * sin(p * 2.236),
      cy: 0.44 + 0.14 * cos(p * 1.549),
      r: 0.20,
      opacity: 0.16,
    );

    // Dark bottom vignette — keeps text readable
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            AppColors.black.withOpacity(0.90),
          ],
          stops: const [0.20, 1.0],
        ).createShader(Offset.zero & size),
    );
  }

  void _drawOrb(
    Canvas canvas,
    Size size, {
    required double cx,
    required double cy,
    required double r,
    required double opacity,
  }) {
    final center = Offset(size.width * cx, size.height * cy);
    final radius = size.width * r;
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            accentColor.withOpacity(opacity),
            accentColor.withOpacity(0.0),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
  }

  @override
  bool shouldRepaint(_LiquidPainter old) =>
      old.t != t || old.accentColor != accentColor;
}
