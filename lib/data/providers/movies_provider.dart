import 'package:cineswap/core/app_exports.dart';

class MoviesProvider with ChangeNotifier {
  final MovieService _movieService = MovieService();
  final StorageService _storageService = StorageService();
  List<Movie> _movies = [];
  final List<Movie> _favorites = [];
  final List<int> _selectedGenreIds = [];
  final Set<int> _usedPages = {};
  final Random _random = Random();
  double _minRating = 0.0;
  double _maxRating = 10.0;
  int _minDecade = 1920;
  int _maxDecade = 2020;
  int _filteredPage = 0;
  bool _isFetching = false;
  bool _filtersApplied = false;
  Color _accentColor = AppColors.white;

  List<Movie> get movies => _movies;
  List<Movie> get favorites => _favorites;
  List<int> get selectedGenreIds => _selectedGenreIds;
  bool get isFetching => _isFetching;
  bool get filtersApplied => _filtersApplied;
  Color get accentColor => _accentColor;
  double get minRating => _minRating;
  double get maxRating => _maxRating;
  int get minDecade => _minDecade;
  int get maxDecade => _maxDecade;

  Future<void> loadInitialMovies() async {
    _movies.clear();
    _usedPages.clear();

    _isFetching = true;
    notifyListeners();

    await loadPopularMovies(count: 25);

    _isFetching = false;
    notifyListeners();
  }

  Future<void> loadPopularMovies({required int count}) async {
    final List<Movie> newMovies = [];

    while (_movies.length + newMovies.length < count) {
      int page = _generateUniquePage();
      final ids = await _movieService.fetchPopularMovieIds(page);

      for (final id in ids) {
        final movie = await _movieService.fetchMovieDetails(id);
        if (movie != null &&
            !_movies.any((m) => m.id == movie.id) &&
            !newMovies.any((m) => m.id == movie.id)) {
          newMovies.add(movie);
        }

        if (_movies.length + newMovies.length >= count) break;
      }
    }

    _movies.addAll(newMovies);
    notifyListeners();
  }

  Future<void> loadMorePopular() async {
    await loadPopularMovies(count: _movies.length + 15);
    notifyListeners();
  }

  Future<void> loadFilteredMovies({
    required int count,
    required bool isInitial,
  }) async {
    if (isInitial) {
      _movies.clear();
      _filteredPage = 0;
      _isFetching = true;
      notifyListeners();
    }

    final List<Movie> newMovies = [];

    while (_movies.length + newMovies.length < count) {
      _filteredPage++;

      try {
        final movies = await _movieService.fetchFilteredMovies(
          genreIds: _selectedGenreIds,
          minRating: _minRating,
          maxRating: _maxRating,
          minYear: _minDecade,
          maxYear: _maxDecade,
          page: _filteredPage,
        );

        for (final movie in movies) {
          if (!_movies.any((m) => m.id == movie.id) &&
              !newMovies.any((m) => m.id == movie.id)) {
            newMovies.add(movie);
          }

          if (_movies.length + newMovies.length >= count) break;
        }

        if (movies.isEmpty) break;
      } catch (e) {
        print(
          'Failed to load filtered movies on page $_filteredPage: $e',
        );
        break;
      }
    }

    _movies.addAll(newMovies);

    if (isInitial) {
      _isFetching = false;
    }

    notifyListeners();
  }

  Future<void> loadMoreFiltered() async {
    await loadFilteredMovies(
      count: _movies.length + 15,
      isInitial: false,
    );
    notifyListeners();
  }

  void loadFromHive(List<Movie> movies) {
    _favorites.clear();
    _favorites.addAll(movies);
    notifyListeners();
  }

  void addToFavorites(Movie movie) async {
    if (!_favorites.any((m) => m.id == movie.id)) {
      await _storageService.addToFavorites(movie);
      _favorites.add(movie);
      notifyListeners();
    }
  }

  void removeFromFavorites(Movie movie) async {
    _favorites.removeWhere((m) => m.id == movie.id);
    await _storageService.removeFromFavorites(movie.id);
    notifyListeners();
  }

  bool isFavorite(Movie movie) {
    return _favorites.any((m) => m.id == movie.id);
  }

  int _generateUniquePage() {
    int page;
    do {
      page = _random.nextInt(500) + 1;
    } while (_usedPages.contains(page));
    _usedPages.add(page);
    return page;
  }

  void setAccentColor(Color color) {
    _accentColor = color;
    notifyListeners();
  }

  void toggleGenre(int id) {
    if (_selectedGenreIds.contains(id)) {
      _selectedGenreIds.remove(id);
    } else {
      _selectedGenreIds.add(id);
    }
    notifyListeners();
  }

  void updateRatingRange(double min, double max) {
    _minRating = min;
    _maxRating = max;
    notifyListeners();
  }

  void updateDecadeRange(int min, int max) {
    _minDecade = min;
    _maxDecade = max;
    notifyListeners();
  }

  void resetFilters() {
    _selectedGenreIds.clear();
    _minRating = 0.0;
    _maxRating = 10.0;
    _minDecade = 1920;
    _maxDecade = 2020;
    _filtersApplied = false;
    loadInitialMovies();
    notifyListeners();
  }
}
