import 'package:cineswap/core/app_exports.dart';

part 'movie_model.g.dart';

@HiveType(typeId: 0)
class Movie {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final int year;

  @HiveField(3)
  final List<String> genres;

  @HiveField(4)
  final double rating;

  @HiveField(5)
  final String country;

  @HiveField(6)
  final String runtime;

  @HiveField(7)
  final String duration;

  @HiveField(8)
  final String overview;

  @HiveField(9)
  final String posterUrl;

  @HiveField(10)
  final String backdropUrl;

  @HiveField(11)
  final String? trailerUrl;

  @HiveField(12)
  final List<Actor> actors;

  Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.genres,
    required this.rating,
    required this.country,
    required this.runtime,
    required this.duration,
    required this.overview,
    required this.posterUrl,
    required this.backdropUrl,
    required this.trailerUrl,
    required this.actors,
  });

  factory Movie.fromJson(Map<String, dynamic> data) {
    final runtimeMinutes = data['runtime'] ?? 0;
    final durationFormatted = _formatRuntime(runtimeMinutes);
    final trailer = (data['videos']['results'] as List).firstWhere(
      (v) => v['site'] == 'YouTube' && v['type'] == 'Trailer',
      orElse: () => null,
    );

    final cast = data['credits']['cast'] as List;
    final actors =
        cast.take(6).map((a) {
          return Actor(
            name: a['name'] ?? 'Unknown',
            profileUrl:
                a['profile_path'] != null
                    ? 'https://image.tmdb.org/t/p/original${a['profile_path']}'
                    : '',
          );
        }).toList();

    return Movie(
      id: data['id'],
      title: data['title'] ?? '',
      year:
          int.tryParse(data['release_date']?.substring(0, 4) ?? '') ??
          0,
      genres:
          (data['genres'] as List)
              .map((e) => e['name'] as String)
              .toList(),
      rating: double.parse(((data['vote_average'] as num?)?.toDouble() ?? 0).toStringAsFixed(1)),
      country:
          (data['production_countries'] as List).isNotEmpty
              ? data['production_countries'][0]['name']
              : 'Unknown',
      runtime: '$runtimeMinutes min',
      duration: durationFormatted,
      overview: data['overview'] ?? '',
      posterUrl:
          data['poster_path'] != null
              ? 'https://image.tmdb.org/t/p/original${data['poster_path']}'
              : '',
      backdropUrl:
          data['backdrop_path'] != null
              ? 'https://image.tmdb.org/t/p/original${data['backdrop_path']}'
              : '',
      trailerUrl:
          trailer != null
              ? 'https://www.youtube.com/watch?v=${trailer['key']}'
              : null,
      actors: actors,
    );
  }

  static String _formatRuntime(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return '${hours}h ${remainingMinutes}min';
  }
}
