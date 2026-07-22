import 'package:cineswipe/core/app_exports.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class MoviesProvider with ChangeNotifier {
  final MovieService _movieService = MovieService();
  final StorageService _storageService = StorageService();
  final List<Movie> _movies = [];
  final List<Movie> _favorites = [];
  final List<int> _selectedGenreIds = [];
  final List<String> _selectedCountryCodes = [];
  final Set<int> _usedPages = {};
  final Random _random = Random();
  double _minRating = 4.0;
  double _maxRating = 10.0;
  int _minYear = 1975;
  int _maxYear = 2024;
  int _filteredPage = 0;
  bool _isFetching = false;
  bool _filtersApplied = false;
  bool _isLoadingMore = false;
  Color _accentColor = AppColors.white;

  List<Movie> get movies => _movies;
  List<Movie> get favorites => _favorites;
  List<int> get selectedGenreIds => _selectedGenreIds;
  List<String> get selectedCountryCodes => _selectedCountryCodes;
  bool get isFetching => _isFetching;
  bool get filtersApplied => _filtersApplied;
  Color get accentColor => _accentColor;
  double get minRating => _minRating;
  double get maxRating => _maxRating;
  int get minYear => _minYear;
  int get maxYear => _maxYear;

  Future<void> loadInitialMovies() async {
    _movies.clear();
    _usedPages.clear();

    // Show cached movies instantly — no shimmer on 2nd+ launch
    final cached = StorageService.getCachedMovies();
    if (cached.isNotEmpty) {
      _movies.addAll(cached);
      notifyListeners();
    } else {
      _isFetching = true;
      notifyListeners();
    }

    // Fetch fresh batch in parallel (appends to end of current list)
    await _loadPopularBatch(25);

    // Save the fresh movies to cache for the next launch
    StorageService.saveMovieCache(
      _movies.length > 25
          ? _movies.sublist(_movies.length - 25)
          : List.of(_movies),
    ).ignore();

    _isFetching = false;
    notifyListeners();
  }

  // Fetches `count` NEW movies in parallel and appends them to _movies.
  Future<void> _loadPopularBatch(int count) async {
    // Two random pages in parallel → ~40 candidate IDs
    final p1 = _generateUniquePage();
    final p2 = _generateUniquePage();
    final pageResults = await Future.wait([
      _movieService.fetchPopularMovieIds(p1),
      _movieService.fetchPopularMovieIds(p2),
    ]);

    final seenIds = _movies.map((m) => m.id).toSet();
    final candidateIds =
        pageResults
            .expand((ids) => ids)
            .toSet()
            .where((id) => !seenIds.contains(id))
            .take(count)
            .toList();

    // All detail requests fire simultaneously
    final results = await Future.wait(
      candidateIds.map(_movieService.fetchMovieDetails),
    );
    final newMovies =
        results.whereType<Movie>().where((m) => m.rating >= 4.0).toList();

    _precacheImages(newMovies);
    _movies.addAll(newMovies);
  }

  Future<void> loadPopularMovies({required int count}) async {
    await _loadPopularBatch(count - _movies.length);
    notifyListeners();
  }

  Future<void> loadMorePopular() async {
    await _loadPopularBatch(15);
    notifyListeners();
  }

  Future<void> loadFilteredMovies({
    required int count,
    required bool isInitial,
  }) async {
    if (_isFetching) return;

    if (isInitial) {
      _movies.clear();
      _filteredPage = 0;
      _isFetching = true;
      _filtersApplied = true;
      notifyListeners();
    }

    final List<Movie> newMovies = [];

    while (_movies.length + newMovies.length < count) {
      _filteredPage++;

      try {
        final movies = await _movieService.fetchFilteredMovies(
          genreIds: _selectedGenreIds,
          countryCodes: _selectedCountryCodes,
          minRating: _minRating,
          maxRating: _maxRating,
          minYear: _minYear,
          maxYear: _maxYear,
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
        debugPrint('loadFilteredMovies page $_filteredPage: $e');
        break;
      }
    }

    _precacheImages(newMovies);
    _movies.addAll(newMovies);

    if (isInitial) {
      _isFetching = false;
    }

    notifyListeners();
  }

  Future<void> loadMoreFiltered() async {
    if (_isLoadingMore) return;
    _isLoadingMore = true;
    await loadFilteredMovies(count: _movies.length + 15, isInitial: false);
    _isLoadingMore = false;
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

  void _precacheImages(List<Movie> movies) {
    final cache = DefaultCacheManager();
    for (final movie in movies) {
      cache.downloadFile(movie.posterUrl).ignore();
      cache.downloadFile(movie.backdropUrl).ignore();
    }
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

  void toggleCountry(String code) {
    if (_selectedCountryCodes.contains(code)) {
      _selectedCountryCodes.remove(code);
    } else {
      _selectedCountryCodes.add(code);
    }
    notifyListeners();
  }

  void updateRatingRange(double min, double max) {
    _minRating = min;
    _maxRating = max;
    notifyListeners();
  }

  void updateYearRange(int min, int max) {
    _minYear = min;
    _maxYear = max;
    notifyListeners();
  }

  void resetFilters() {
    _selectedGenreIds.clear();
    _selectedCountryCodes.clear();
    _minRating = 4.0;
    _maxRating = 10.0;
    _minYear = 1975;
    _maxYear = 2024;
    _filtersApplied = false;
    loadInitialMovies(); // calls notifyListeners() internally
  }
}
