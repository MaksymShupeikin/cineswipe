import 'package:cineswap/core/app_exports.dart';
import 'package:http/http.dart' as http;

class MovieService {
  final String apiKey = dotenv.env['TMDB_API_KEY']!;

  Future<List<int>> fetchPopularMovieIds(int page) async {
    final url =
        'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&page=$page';
    final res = await http.get(Uri.parse(url));
    final data = json.decode(res.body);
    return (data['results'] as List)
        .map((e) => e['id'] as int)
        .toList();
  }

  Future<List<Movie>> fetchFilteredMovies({
    required List<int> genreIds,
    required double minRating,
    required double maxRating,
    required int minYear,
    required int maxYear,
    int page = 1,
  }) async {
    final queryParameters = {
      'sort_by': 'popularity.desc',
      'include_adult': 'false',
      'include_video': 'false',
      'page': '$page',
      'vote_average.gte': '$minRating',
      'vote_average.lte': '$maxRating',
      'primary_release_date.gte': '$minYear-01-01',
      'primary_release_date.lte': '$maxYear-12-31',
      if (genreIds.isNotEmpty) 'with_genres': genreIds.join(','),
      'language': 'en-US',
      'api_key': apiKey,
    };

    final uri = Uri.https(
      'api.themoviedb.org',
      '/3/discover/movie',
      queryParameters,
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch filtered movie IDs');
    }

    final data = json.decode(response.body);
    final results = data['results'] as List;

    final ids = results.map((e) => e['id'] as int).toList();

    final movies = <Movie>[];

    for (final id in ids) {
      final movie = await fetchMovieDetails(id);
      if (movie != null) movies.add(movie);
    }

    return movies;
  }

  Future<Movie?> fetchMovieDetails(int id) async {
    try {
      final url =
          'https://api.themoviedb.org/3/movie/$id?api_key=$apiKey&append_to_response=credits,videos';
      final res = await http.get(Uri.parse(url));
      if (res.statusCode != 200) return null;

      final data = json.decode(res.body);
      return Movie.fromJson(data);
    } catch (_) {
      return null;
    }
  }
}
