import '../../core/app_exports.dart';

class StorageService {
  static final Box<Movie> _box = Hive.box<Movie>('favorites');
  static final Box<Movie> _cacheBox = Hive.box<Movie>('movieCache');

  static List<Movie> getFavorites() => _box.values.toList();

  Future<void> addToFavorites(Movie movie) async {
    if (!_box.values.any((m) => m.id == movie.id)) {
      await _box.add(movie);
    }
  }

  Future<void> removeFromFavorites(int id) async {
    final key = _box.keys.firstWhere((k) => _box.get(k)!.id == id);
    await _box.delete(key);
  }

  static List<Movie> getCachedMovies() => _cacheBox.values.toList();

  static Future<void> saveMovieCache(List<Movie> movies) async {
    await _cacheBox.clear();
    await _cacheBox.addAll(movies);
  }
}
