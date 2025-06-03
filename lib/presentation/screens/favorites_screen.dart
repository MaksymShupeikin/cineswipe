import 'package:cineswap/core/app_exports.dart';
import 'package:cineswap/presentation/widgets/favorite_movie_card.dart';

class FavoritesScreen extends StatefulWidget {
  final Size size;
  const FavoritesScreen({super.key, required this.size});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final movies = StorageService.getFavorites();
      Provider.of<MoviesProvider>(
        context,
        listen: false,
      ).loadFromHive(movies);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final Size size = widget.size;

    return Consumer<MoviesProvider>(
      builder: (context, provider, child) {
        final List<Movie> favorites = provider.favorites;

        return favorites.isEmpty
            ? Center(
              child:
                  'Swipe the movie to the right and it will appear here'
                      .bold(fontSize: 22),
            )
            : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    key: PageStorageKey('favoritesList'),
                    itemCount: favorites.length,
                    addAutomaticKeepAlives: true,
                    itemBuilder: (context, index) {
                      final movie = favorites[index];

                      return Padding(
                        padding:
                            index == 0
                                ? EdgeInsets.only(
                                  top: size.height * 0.02,
                                )
                                : index == favorites.length - 1
                                ? EdgeInsets.only(
                                  bottom: size.height * 0.15,
                                )
                                : EdgeInsets.zero,
                        child: FavoriteMovieCard(
                          movie: movie,
                          size: size,
                          onDelete:
                              () =>
                                  provider.removeFromFavorites(movie),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
