import 'package:cineswipe/core/app_exports.dart';
import 'package:cupertino_native/cupertino_native.dart';

class NavigationScreen extends StatefulWidget {
  final Size size;
  const NavigationScreen({super.key, required this.size});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 1;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Pages are created once — same instances are always passed to IndexedStack,
    // preventing CachedNetworkImage from re-triggering shimmer on provider rebuilds.
    _pages = [
      FiltersScreen(
        size: widget.size,
        onFiltersApplied: () {
          setState(() => _selectedIndex = 1);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<MoviesProvider>(
              context,
              listen: false,
            ).loadFilteredMovies(count: 25, isInitial: true);
          });
        },
        onFiltersReset: () {
          setState(() => _selectedIndex = 1);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<MoviesProvider>(context, listen: false).resetFilters();
          });
        },
      ),
      HomeScreen(size: widget.size),
      FavoritesScreen(size: widget.size),
    ];
  }

  void _onTabTap(int index) {
    if (_selectedIndex != index) {
      HapticService.light();
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentAccentColor = context.select<MoviesProvider, Color>(
      (provider) => provider.accentColor,
    );

    final Size size = widget.size;

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          // Animated liquid background — full screen
          Positioned.fill(
            child: RepaintBoundary(
              child: LiquidBackground(accentColor: currentAccentColor),
            ),
          ),

          // Page content with safe area, padded below to clear the tab bar
          Positioned.fill(
            child: SafeArea(
              top: _selectedIndex != 2,
              bottom: false,
              child: Padding(
                padding: EdgeInsets.only(
                  top:
                      (_selectedIndex == 2 || _selectedIndex == 0)
                          ? 0
                          : size.height * 0.02,
                  left: size.width * 0.06,
                  right: size.width * 0.06,
                  bottom: 0,
                ),
                child: IndexedStack(index: _selectedIndex, children: _pages),
              ),
            ),
          ),

          // Bottom gradient overlay to block clicks and provide visual depth
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: size.height * 0.18,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.black.withValues(alpha: 0.0),
                      AppColors.black.withValues(alpha: 0.8),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Native iOS 26 liquid glass tab bar
          Positioned(
            bottom: size.height * 0.01,
            left: size.width * 0.06,
            right: size.width * 0.06,
            child: CNTabBar(
              backgroundColor: Colors.transparent,
              tint: AppColors.white,
              items: [
                CNTabBarItem(
                  label: 'Filter',
                  icon: CNSymbol(
                    _selectedIndex == 0
                        ? 'line.3.horizontal.decrease.circle.fill'
                        : 'line.3.horizontal.decrease.circle',
                  ),
                ),
                CNTabBarItem(
                  label: 'Home',
                  icon: CNSymbol(_selectedIndex == 1 ? 'house.fill' : 'house'),
                ),
                CNTabBarItem(
                  label: 'Liked',
                  icon: CNSymbol(_selectedIndex == 2 ? 'heart.fill' : 'heart'),
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onTabTap,
            ),
          ),
        ],
      ),
    );
  }
}
