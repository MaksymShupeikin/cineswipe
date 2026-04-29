import 'package:cineswipe/core/app_exports.dart';

class NavBarItem extends StatefulWidget {
  final Size size;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData icon;
  final String text;

  const NavBarItem({
    super.key,
    required this.onTap,
    required this.isSelected,
    required this.icon,
    required this.text,
    required this.size,
  });

  @override
  State<NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _scaleAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.3)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.3, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_controller);

    _rotationAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 0.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 100,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.2, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 100,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant NavBarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color iconColor =
        widget.isSelected ? AppColors.white : AppColors.white.withAlpha(127);

    return GestureDetector(
      onTap: widget.onTap,
      // Opaque so the full padded area responds to taps, not just the icon
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: widget.size.width * 0.04,
          vertical: widget.size.height * 0.006,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Icon(widget.icon, color: iconColor),
                  ),
                );
              },
            ),
            Text(
              widget.text,
              style: GoogleFonts.raleway(
                color: iconColor,
                fontSize: 15,
                fontWeight:
                    widget.isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
