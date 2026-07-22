import 'package:cineswipe/core/app_exports.dart';

class HomeScreen extends StatefulWidget {
  final Size size;
  const HomeScreen({super.key, required this.size});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int swipeCount = 0;

  // Horizontal swipe progress: -1 (full left) .. 0 (idle) .. 1 (full right).
  // Updated by Listener — independent of CardSwiper's build cycle.
  final ValueNotifier<double> _swipeX = ValueNotifier(0.0);

  double _dragStartX = 0.0;
  double _pendingSwipeX = 0.0;
  bool _hapticTriggered = false;
  bool _swipeFrameScheduled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = Provider.of<MoviesProvider>(context, listen: false);
      _loadInitialMovies(provider);
    });
  }

  @override
  void dispose() {
    _swipeX.dispose();
    super.dispose();
  }

  Future<void> _updateAccentColorFromPoster(String imageUrl) async {
    final color = await ColorFromImageService.getAverageColorFromNetworkImage(
      imageUrl,
    );
    if (!mounted) return;
    Provider.of<MoviesProvider>(context, listen: false).setAccentColor(color);
  }

  Future<void> _loadInitialMovies(MoviesProvider provider) async {
    await provider.loadInitialMovies();
    if (!mounted || provider.movies.isEmpty) return;
    _updateAccentColorFromPoster(provider.movies.first.posterUrl);
  }

  void _setSwipeProgress(double progress, {bool immediate = false}) {
    _pendingSwipeX = progress;

    if (immediate) {
      if (_swipeX.value != progress) _swipeX.value = progress;
      return;
    }

    if (_swipeFrameScheduled) return;
    _swipeFrameScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _swipeFrameScheduled = false;
      if (!mounted) return;

      final nextProgress = _pendingSwipeX;
      if (nextProgress == 0.0 ||
          (_swipeX.value - nextProgress).abs() >= 0.005) {
        _swipeX.value = nextProgress;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<
      MoviesProvider,
      ({bool filtersApplied, bool isFetching, int moviesLength})
    >(
      selector:
          (_, provider) => (
            filtersApplied: provider.filtersApplied,
            isFetching: provider.isFetching,
            moviesLength: provider.movies.length,
          ),
      builder: (context, state, child) {
        final provider = context.read<MoviesProvider>();
        final movies = provider.movies;
        final isFetching = state.isFetching;

        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: widget.size.height * 0.2),
              child: Listener(
                behavior: HitTestBehavior.translucent,
                onPointerDown: (e) {
                  _dragStartX = e.position.dx;
                  _hapticTriggered = false;
                },
                onPointerMove: (e) {
                  final offset = e.position.dx - _dragStartX;
                  final progress = (offset / (widget.size.width * 0.4)).clamp(
                    -1.0,
                    1.0,
                  );

                  _setSwipeProgress(progress);

                  // Early haptic feedback based on progress threshold
                  if (progress.abs() > 0.7 && !_hapticTriggered) {
                    if (progress > 0) {
                      HapticService.heavy();
                    } else {
                      HapticService.medium();
                    }
                    _hapticTriggered = true;
                  }
                },
                onPointerUp: (_) {
                  _setSwipeProgress(0.0, immediate: true);
                  _hapticTriggered = false;
                },
                onPointerCancel: (_) {
                  _setSwipeProgress(0.0, immediate: true);
                  _hapticTriggered = false;
                },
                child:
                    isFetching
                        ? CardSwiper(
                          numberOfCardsDisplayed: 2,
                          allowedSwipeDirection:
                              const AllowedSwipeDirection.only(
                                left: true,
                                right: true,
                              ),
                          backCardOffset: Offset(0, widget.size.height * 0.05),
                          cardsCount: 2,
                          padding: EdgeInsets.zero,
                          isDisabled: true,
                          cardBuilder:
                              (context, index, _, __) =>
                                  MovieCardShimmer(size: widget.size),
                          isLoop: true,
                        )
                        : movies.isEmpty
                        ? GlassPlaceholder(
                          size: widget.size,
                          icon: Icons.movie_filter_outlined,
                          title: 'No movies found',
                          subtitle:
                              'Try adjusting your filters to find more great movies to watch.',
                          actionLabel: 'Reset Filters',
                          onAction: () => provider.resetFilters(),
                        )
                        : CardSwiper(
                          numberOfCardsDisplayed: 2,
                          allowedSwipeDirection:
                              const AllowedSwipeDirection.only(
                                left: true,
                                right: true,
                              ),
                          backCardOffset: Offset(0, widget.size.height * 0.05),
                          cardsCount: max(2, movies.length),
                          padding: EdgeInsets.zero,
                          isDisabled: false,
                          onSwipe: (previousIndex, currentIndex, direction) {
                            swipeCount++;
                            _hapticTriggered = false;

                            if (swipeCount % 15 == 0) {
                              state.filtersApplied
                                  ? provider.loadMoreFiltered()
                                  : provider.loadMorePopular();
                            }

                            if (movies.isNotEmpty &&
                                previousIndex < movies.length) {
                              switch (direction) {
                                case CardSwiperDirection.left:
                                  _updateAccentColorFromPoster(
                                    movies[currentIndex!].posterUrl,
                                  );
                                  break;
                                case CardSwiperDirection.right:
                                  _updateAccentColorFromPoster(
                                    movies[currentIndex!].posterUrl,
                                  );
                                  provider.addToFavorites(
                                    movies[previousIndex],
                                  );
                                  break;
                                default:
                                  break;
                              }
                            }
                            return true;
                          },
                          cardBuilder:
                              (context, index, _, __) => MovieCard(
                                size: widget.size,
                                movie: movies[index],
                              ),
                          isLoop: true,
                        ),
              ),
            ),

            Positioned(
              top: widget.size.height * 0.02,
              left: 0,
              right: 0,
              child: Center(
                child: IgnorePointer(
                  child: ValueListenableBuilder<double>(
                    valueListenable: _swipeX,
                    builder: (context, swipeX, _) {
                      return TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: swipeX),
                        duration:
                            swipeX == 0.0
                                ? const Duration(milliseconds: 450)
                                : const Duration(milliseconds: 60),
                        curve:
                            swipeX == 0.0 ? Curves.elasticOut : Curves.linear,
                        builder: (context, animX, _) {
                          return Transform.rotate(
                            angle: animX * 0.18,
                            alignment: Alignment.bottomCenter,
                            child: Transform.scale(
                              scale: 1.0 + animX.abs() * 0.12,
                              child: BlackContainer(
                                size: widget.size,
                                swipeProgress: animX,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
