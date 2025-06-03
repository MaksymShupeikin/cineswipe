import 'package:cineswap/core/app_exports.dart';

class MovieDetails extends StatelessWidget {
  final Size size;
  final Movie movie;

  const MovieDetails({
    super.key,
    required this.size,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final SizedBox bigSizedBox = SizedBox(height: size.height * 0.03);
    final SizedBox smallSizedBox = SizedBox(
      height: size.height * 0.003,
    );

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              movie.backdropUrl,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.black.withAlpha(70),
                    AppColors.black,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 0.45],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.06,
              ),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        bigSizedBox,
                        Container(
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
                          child: Hero(
                            tag: movie.posterUrl,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                15.0,
                              ),
                              child: Image.network(
                                movie.posterUrl,
                                width: size.width * 0.5,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                        bigSizedBox,
                        movie.title.bold(fontSize: 28),
                        smallSizedBox,
                        movie.year.toString().bold(fontSize: 22),
                        smallSizedBox,
                        movie.genres.join(', ').regular(),
                        bigSizedBox,
                        Container(
                          height: size.height * 0.07,
                          padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.01,
                            horizontal: size.width * 0.01,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white.withAlpha(50),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
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
                        ),
                        bigSizedBox,
                        'Overview'.bold(fontSize: 22),
                        bigSizedBox,
                        movie.overview.regular(),
                        bigSizedBox,
                        'Cast'.bold(fontSize: 22),
                        bigSizedBox,
                        movie.actors.isEmpty
                            ? 'Cast unavailable'.regular()
                            : ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: 0,
                                maxHeight: size.height * 0.19,
                              ),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: movie.actors.length,
                                shrinkWrap: true,
                                physics:
                                    const ClampingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final Actor actor =
                                      movie.actors[index];
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      right: size.width * 0.04,
                                    ),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(
                                                15,
                                              ),
                                          child: Image.network(
                                            actor.profileUrl,
                                            width: size.width * 0.22,
                                            height:
                                                size.height * 0.15,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                        SizedBox(
                                          height: size.height * 0.01,
                                        ),
                                        actor.name.regular(),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                        bigSizedBox,
                        'Trailer'.bold(fontSize: 22),
                        bigSizedBox,
                        (movie.trailerUrl == null ||
                                movie.trailerUrl!.isEmpty)
                            ? 'Trailer unavailable'.regular()
                            : GestureDetector(
                              onTap: () async {
                                final url = Uri.parse(
                                  movie.trailerUrl!,
                                );

                                if (await canLaunchUrl(url)) {
                                  await launchUrl(
                                    url,
                                    mode:
                                        LaunchMode
                                            .externalApplication,
                                  );
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(15),
                                    child: Image.network(
                                      AppHelpers.getYouTubeThumbnail(
                                        movie.trailerUrl!,
                                      ),
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return const Icon(
                                          Icons.broken_image,
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: size.height * 0.01,
                                      horizontal: size.width * 0.02,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.black
                                          .withAlpha(127),
                                    ),
                                    child: const Icon(
                                      Icons.play_circle_outline,
                                      size: 40,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        bigSizedBox,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
