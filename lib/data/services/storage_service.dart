import '../../core/app_exports.dart';

class StorageService {
  static final Box<Movie> _box = Hive.box<Movie>('favorites');

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
}
