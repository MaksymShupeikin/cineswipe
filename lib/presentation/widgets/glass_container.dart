import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final BorderRadius? customBorderRadius;
  final EdgeInsetsGeometry? padding;
  final double blur;
  final double opacity;
  final Color? tintColor;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 20.0,
    this.customBorderRadius,
    this.padding,
    this.blur = 14.0,
    this.opacity = 0.12,
    this.tintColor,
    this.constraints,
    this.width,
    this.height,
  });

  BorderRadius get _radius =>
      customBorderRadius ?? BorderRadius.circular(borderRadius);

  @override
  Widget build(BuildContext context) {
    final base = tintColor ?? Colors.white;

    return ClipRRect(
      borderRadius: _radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          constraints: constraints,
          decoration: BoxDecoration(
            borderRadius: _radius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                base.withOpacity(opacity * 1.5),
                base.withOpacity(opacity * 0.4),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.18),
              width: 0.8,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
