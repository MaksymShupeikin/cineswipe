import 'package:cineswap/core/app_exports.dart';

class HomeScreen extends StatefulWidget {
  final Size size;
  const HomeScreen({super.key, required this.size});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int swipeCount = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          Provider.of<MoviesProvider>(
            context,
            listen: false,
          ).loadInitialMovies(),
    );
  }

  Future<void> _updateAccentColorFromPoster(
    String imageUrl,
    BuildContext context,
  ) async {
    final accentColor =
        await ColorFromImageService.getAverageColorFromNetworkImage(
          imageUrl,
        );

    Provider.of<MoviesProvider>(
      context,
      listen: false,
    ).setAccentColor(accentColor);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MoviesProvider>(
      builder: (context, provider, child) {
        final movies = provider.movies;
        final isFetching = provider.isFetching;

        return Column(
          children: [
            BlackContainer(size: widget.size),
            Expanded(
              child:
                  isFetching
                      ? Padding(
                        padding: EdgeInsets.only(
                          bottom: widget.size.height * 0.1,
                        ),
                        child: CardSwiper(
                          numberOfCardsDisplayed: 2,
                          backCardOffset: Offset(
                            0,
                            widget.size.height * 0.05,
                          ),
                          cardsCount: 2,
                          padding: EdgeInsets.zero,
                          isDisabled: true,
                          cardBuilder: (
                            context,
                            index,
                            percentThresholdX,
                            percentThresholdY,
                          ) {
                            return MovieCardShimmer(
                              size: widget.size,
                            );
                          },
                          isLoop: true,
                        ),
                      )
                      : Padding(
                        padding: EdgeInsets.only(
                          bottom: widget.size.height * 0.1,
                        ),
                        child: CardSwiper(
                          numberOfCardsDisplayed: 2,
                          backCardOffset: Offset(
                            0,
                            widget.size.height * 0.05,
                          ),
                          cardsCount:
                              isFetching ? 2 : max(2, movies.length),
                          padding: EdgeInsets.zero,
                          isDisabled: isFetching,
                          onSwipe: (
                            previousIndex,
                            currentIndex,
                            direction,
                          ) {
                            swipeCount++;

                            if (swipeCount % 15 == 0) {
                              if (provider.filtersApplied) {
                                provider.loadMoreFiltered();
                              } else {
                                provider.loadMorePopular();
                              }
                            }

                            if (movies.isNotEmpty &&
                                previousIndex < movies.length) {
                              switch (direction) {
                                case CardSwiperDirection.left:
                                  final movie = movies[currentIndex!];
                                  _updateAccentColorFromPoster(
                                    movie.posterUrl,
                                    context,
                                  );
                                  break;
                                case CardSwiperDirection.right:
                                  final currentMovie =
                                      movies[currentIndex!];
                                  _updateAccentColorFromPoster(
                                    currentMovie.posterUrl,
                                    context,
                                  );

                                  final swipedMovie =
                                      movies[previousIndex];

                                  provider.addToFavorites(
                                    swipedMovie,
                                  );
                                  break;
                                case CardSwiperDirection.top:
                                  final movie = movies[currentIndex!];
                                  _updateAccentColorFromPoster(
                                    movie.posterUrl,
                                    context,
                                  );
                                  break;
                                default:
                                  print("Other direction");
                              }
                            }

                            return true;
                          },

                          cardBuilder: (
                            context,
                            index,
                            percentThresholdX,
                            percentThresholdY,
                          ) {
                            final movie = movies[index];

                            return MovieCard(
                              size: widget.size,
                              movie: movie,
                            );
                          },
                          isLoop: true,
                        ),
                      ),
            ),
          ],
        );
      },
    );
  }
}
