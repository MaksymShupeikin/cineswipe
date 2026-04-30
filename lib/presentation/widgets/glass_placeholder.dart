import 'package:cineswipe/core/app_exports.dart';

class GlassPlaceholder extends StatelessWidget {
  final Size size;
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const GlassPlaceholder({
    super.key,
    required this.size,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
        child: LiquidGlass.withOwnLayer(
          settings: LiquidGlassSettings(
            thickness: 16,
            blur: 24,
            glassColor: AppColors.white.withValues(alpha: 0.1),
          ),
          shape: LiquidRoundedSuperellipse(borderRadius: 32),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 48,
                  color: AppColors.white.withValues(alpha: 0.6),
                ),
                const SizedBox(height: 20),
                title.bold(
                  fontSize: 22,
                  color: AppColors.white,
                ),
                const SizedBox(height: 12),
                subtitle.regular(
                  color: AppColors.white.withValues(alpha: 0.5),
                ),
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(height: 28),
                  GestureDetector(
                    onTap: () {
                      HapticService.medium();
                      onAction!();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: actionLabel!.bold(
                        fontSize: 16,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
