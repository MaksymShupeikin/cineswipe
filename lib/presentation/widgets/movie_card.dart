import 'package:cineswipe/core/app_exports.dart';

class MovieCard extends StatelessWidget {
  final Size size;
  final Movie movie;

  const MovieCard({super.key, required this.size, required this.movie});

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    final cacheWidth = (size.width * devicePixelRatio).round();
    final cacheHeight = (size.height * devicePixelRatio).round();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetails(size: size, movie: movie),
          ),
        );
      },
      child: Align(
        alignment: Alignment.center,
        child: RepaintBoundary(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.5),
                  blurRadius: 18,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  Hero(
                    tag: movie.posterUrl,
                    child: CachedNetworkImage(
                      imageUrl: movie.posterUrl,
                      fit: BoxFit.cover,
                      width: size.width,
                      height: size.height,
                      memCacheWidth: cacheWidth,
                      memCacheHeight: cacheHeight,
                      placeholder:
                          (context, url) => Shimmer.fromColors(
                            baseColor: Colors.white10,
                            highlightColor: Colors.white24,
                            child: Container(color: Colors.white),
                          ),
                      errorWidget:
                          (context, url, error) => Container(
                            color: Colors.white10,
                            child: const Center(
                              child: Icon(
                                Icons.movie_outlined,
                                color: Colors.white38,
                                size: 50,
                              ),
                            ),
                          ),
                    ),
                  ),
                  // Keep this overlay static; backdrop blur is expensive while
                  // the whole card is transformed every pointer frame.
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.012,
                        horizontal: size.width * 0.06,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.18),
                            Colors.black.withOpacity(0.68),
                          ],
                        ),
                        border: Border(
                          top: BorderSide(
                            color: Colors.white.withOpacity(0.10),
                            width: 0.8,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          '${movie.title} (${movie.year})'.bold(fontSize: 22),
                          SizedBox(height: size.height * 0.003),
                          movie.genres.join(', ').regular(),
                          SizedBox(height: size.height * 0.003),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star_rate_rounded,
                                color: AppColors.yellow,
                                size: size.width * 0.05,
                              ),
                              SizedBox(width: size.width * 0.02),
                              movie.rating.toString().regular(),
                              SizedBox(width: size.width * 0.02),
                              '•'.regular(),
                              SizedBox(width: size.width * 0.02),
                              AppHelpers.formatCountryName(
                                movie.country,
                              ).regular(),
                              SizedBox(width: size.width * 0.02),
                              '•'.regular(),
                              SizedBox(width: size.width * 0.02),
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
        ),
      ),
    );
  }
}
