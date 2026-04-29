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

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final provider = Provider.of<MoviesProvider>(context, listen: false);
      await provider.loadInitialMovies();
      if (provider.movies.isNotEmpty && mounted) {
        _updateAccentColorFromPoster(provider.movies.first.posterUrl, context);
      }
    });
  }

  @override
  void dispose() {
    _swipeX.dispose();
    super.dispose();
  }

  Future<void> _updateAccentColorFromPoster(
    String imageUrl,
    BuildContext context,
  ) async {
    final color = await ColorFromImageService.getAverageColorFromNetworkImage(imageUrl);
    if (!context.mounted) return;
    Provider.of<MoviesProvider>(context, listen: false).setAccentColor(color);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MoviesProvider>(
      builder: (context, provider, child) {
        final movies = provider.movies;
        final isFetching = provider.isFetching;

        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: widget.size.height * 0.2),
              child: Listener(
                behavior: HitTestBehavior.translucent,
                onPointerDown: (e) {
                  _dragStartX = e.position.dx;
                },
                onPointerMove: (e) {
                  final offset = e.position.dx - _dragStartX;
                  final progress =
                      (offset / (widget.size.width * 0.4)).clamp(-1.0, 1.0);
                  if (_swipeX.value != progress) _swipeX.value = progress;
                },
                onPointerUp: (_) => _swipeX.value = 0.0,
                onPointerCancel: (_) => _swipeX.value = 0.0,
                child: isFetching
                    ? CardSwiper(
                        numberOfCardsDisplayed: 2,
                        allowedSwipeDirection:
                            const AllowedSwipeDirection.only(
                          left: true,
                          right: true,
                        ),
                        backCardOffset:
                            Offset(0, widget.size.height * 0.05),
                        cardsCount: 2,
                        padding: EdgeInsets.zero,
                        isDisabled: true,
                        cardBuilder: (context, index, _, __) =>
                            MovieCardShimmer(size: widget.size),
                        isLoop: true,
                      )
                    : CardSwiper(
                        numberOfCardsDisplayed: 2,
                        allowedSwipeDirection:
                            const AllowedSwipeDirection.only(
                          left: true,
                          right: true,
                        ),
                        backCardOffset:
                            Offset(0, widget.size.height * 0.05),
                        cardsCount: max(2, movies.length),
                        padding: EdgeInsets.zero,
                        isDisabled: false,
                        onSwipe: (previousIndex, currentIndex, direction) {
                          swipeCount++;

                          if (swipeCount % 15 == 0) {
                            provider.filtersApplied
                                ? provider.loadMoreFiltered()
                                : provider.loadMorePopular();
                          }

                          if (movies.isNotEmpty &&
                              previousIndex < movies.length) {
                            switch (direction) {
                              case CardSwiperDirection.left:
                                HapticService.medium();
                                _updateAccentColorFromPoster(
                                  movies[currentIndex!].posterUrl,
                                  context,
                                );
                                break;
                              case CardSwiperDirection.right:
                                HapticService.heavy();
                                _updateAccentColorFromPoster(
                                  movies[currentIndex!].posterUrl,
                                  context,
                                );
                                provider.addToFavorites(movies[previousIndex]);
                                break;
                              default:
                                break;
                            }
                          }
                          return true;
                        },
                        cardBuilder: (context, index, _, __) => MovieCard(
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
                        duration: swipeX == 0.0
                            ? const Duration(milliseconds: 450)
                            : const Duration(milliseconds: 60),
                        curve: swipeX == 0.0
                            ? Curves.elasticOut
                            : Curves.linear,
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
