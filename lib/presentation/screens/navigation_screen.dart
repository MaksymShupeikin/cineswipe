import 'package:cineswap/core/app_exports.dart';

class NavigationScreen extends StatefulWidget {
  final Size size;
  const NavigationScreen({super.key, required this.size});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 1;
  Color _previousAccentColor = AppColors.white;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final currentColor = context.watch<MoviesProvider>().accentColor;

    if (currentColor != _previousAccentColor) {
      setState(() {
        _previousAccentColor = currentColor;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentAccentColor =
        context.watch<MoviesProvider>().accentColor;
    final provider = Provider.of<MoviesProvider>(context);

    final List<Widget> pages = [
      FiltersScreen(
        size: widget.size,
        onFiltersApplied: () {
          setState(() {
            _selectedIndex = 1;
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            provider.loadFilteredMovies(count: 25, isInitial: true);
          });
        },
        onFiltersReset: () {
          setState(() {
            _selectedIndex = 1;
          });
           WidgetsBinding.instance.addPostFrameCallback((_) {
            provider.resetFilters();
          });
        },
      ),
      HomeScreen(size: widget.size),
      FavoritesScreen(size: widget.size),
    ];
    final Size size = widget.size;

    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Stack(
          children: [
            TweenAnimationBuilder<Color?>(
              tween: ColorTween(
                begin: _previousAccentColor,
                end: currentAccentColor,
              ),
              duration: const Duration(milliseconds: 700),
              onEnd: () {
                _previousAccentColor = currentAccentColor;
              },
              builder: (context, animatedColor, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.black, animatedColor!],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [0.0, 0.6],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical:
                          _selectedIndex == 2
                              ? 0
                              : size.height * 0.02,
                      horizontal: size.width * 0.06,
                    ),
                    child: IndexedStack(
                      index: _selectedIndex,
                      children: pages,
                    ),
                  ),
                );
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                margin: EdgeInsets.only(
                  bottom: size.height * 0.02,
                  left: size.width * 0.06,
                  right: size.width * 0.06,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.01,
                  horizontal: size.width * 0.1,
                ),
                decoration: BoxDecoration(
                  color: AppColors.black.withAlpha(240),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.white.withAlpha(127),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NavBarItem(
                      size: size,
                      isSelected: _selectedIndex == 0,
                      icon: Icons.filter_list_rounded,
                      text: 'Filter',
                      onTap: () {
                        setState(() {
                          _selectedIndex = 0;
                        });
                      },
                    ),
                    NavBarItem(
                      size: size,
                      isSelected: _selectedIndex == 1,
                      icon: Icons.home_rounded,
                      text: 'Home',
                      onTap: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                    ),
                    NavBarItem(
                      size: size,
                      isSelected: _selectedIndex == 2,
                      icon: Icons.favorite,
                      text: 'Liked',
                      onTap: () {
                        setState(() {
                          _selectedIndex = 2;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
