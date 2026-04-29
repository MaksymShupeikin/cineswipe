import 'package:cineswipe/core/app_exports.dart';

class BlackContainer extends StatelessWidget {
  final Size size;
  final String? screenTitle;
  final double swipeProgress; // -1..0..1

  const BlackContainer({
    super.key,
    required this.size,
    this.screenTitle,
    this.swipeProgress = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final skipActivation = (-swipeProgress).clamp(0.0, 1.0);
    final likeActivation = swipeProgress.clamp(0.0, 1.0);

    final skipColor = Color.lerp(
      AppColors.white.withValues(alpha: 1.0 - likeActivation * 0.65),
      const Color(0xFFFF6B6B),
      skipActivation,
    )!;

    final likeColor = Color.lerp(
      AppColors.white.withValues(alpha: 1.0 - skipActivation * 0.65),
      const Color(0xFF5EE89A),
      likeActivation,
    )!;

    final skipScale = 1.0 + skipActivation * 0.35;
    final likeScale = 1.0 + likeActivation * 0.35;
    final dividerAlpha = (0.2 - swipeProgress.abs() * 0.2).clamp(0.0, 0.2);

    return LiquidGlass.withOwnLayer(
      settings: const LiquidGlassSettings(
        thickness: 14,
        blur: 20,
        glassColor: Color(0x55000000),
      ),
      shape: LiquidRoundedSuperellipse(borderRadius: 20),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical:
              screenTitle == null ? size.height * 0.006 : size.height * 0.015,
          horizontal: size.width * 0.02,
        ),
        child: screenTitle == null
            ? IntrinsicWidth(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Transform.scale(
                        scale: skipScale,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_back, color: skipColor, size: 20),
                            SizedBox(height: size.height * 0.002),
                            'Skip'.regular(color: skipColor),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 24,
                      color: AppColors.white.withValues(alpha: dividerAlpha),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Transform.scale(
                        scale: likeScale,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_forward,
                                color: likeColor, size: 20),
                            SizedBox(height: size.height * 0.002),
                            'Like'.regular(color: likeColor),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : screenTitle!.bold(fontSize: 22),
      ),
    );
  }
}
