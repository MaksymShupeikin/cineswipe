import 'package:cineswap/core/app_exports.dart';

class MovieCard extends StatelessWidget {
  final Size size;
  final Movie movie;

  const MovieCard({
    super.key,
    required this.size,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => MovieDetails(size: size, movie: movie),
          ),
        );
      },
      child: Align(
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withAlpha(127),
                blurRadius: 8,
                spreadRadius: 6,
              ),
            ],
          ),
          child: Stack(
            children: [
              Hero(
                tag: movie.posterUrl,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(movie.posterUrl),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.01,
                    horizontal: size.width * 0.06,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.black.withAlpha(220),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    spacing: size.height * 0.003,
                    children: [
                      '${movie.title} (${movie.year})'.bold(
                        fontSize: 22,
                      ),
                      movie.genres.join(', ').regular(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: size.width * 0.02,
                        children: [
                          Icon(
                            Icons.star_rate_rounded,
                            color: AppColors.yellow,
                            size: size.width * 0.05,
                          ),
                          movie.rating.toString().regular(),
                          '•'.regular(),
                          AppHelpers.formatCountryName(
                            movie.country,
                          ).regular(),
                          '•'.regular(),
                          movie.duration.regular(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
