import 'package:cineswipe/core/app_exports.dart';

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
    final SizedBox smallSizedBox = SizedBox(height: size.height * 0.003);

    return Scaffold(
      body: Stack(
        children: [
          // Backdrop image — served from cache (preloaded with movie batch)
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: movie.backdropUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.black),
              errorWidget: (context, url, error) => Container(
                color: Colors.black,
                child: const Center(
                  child: Icon(Icons.movie_outlined, color: Colors.white24),
                ),
              ),
            ),
          ),
          // Blur overlay to make image feel like liquid glass base
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
              child: const SizedBox.expand(),
            ),
          ),
          // Dark gradient fade
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.black.withOpacity(0.45),
                    AppColors.black,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.05, 0.40],
                ),
              ),
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(height: MediaQuery.of(context).padding.top + 10),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      bigSizedBox,
                      // Poster — served from cache (same URL as swipe card)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withValues(alpha: 0.55),
                              blurRadius: 28,
                              spreadRadius: 4,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Hero(
                          tag: movie.posterUrl,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: movie.posterUrl,
                              width: size.width * 0.5,
                              fit: BoxFit.fitWidth,
                              errorWidget: (context, url, error) => Container(
                                width: size.width * 0.5,
                                height: size.height * 0.3,
                                color: Colors.white10,
                                child: const Icon(Icons.movie_outlined,
                                    color: Colors.white24),
                              ),
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
                      // Stats glass pill
                      LiquidGlass.withOwnLayer(
                        settings: const LiquidGlassSettings(
                          thickness: 20,
                          blur: 22,
                          glassColor: Color(0x0CFFFFFF),
                        ),
                        shape: LiquidRoundedSuperellipse(borderRadius: 18),
                        child: SizedBox(
                          height: size.height * 0.07,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.04,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
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
                          ),
                        ),
                      ),
                      bigSizedBox,
                      'Overview'.bold(fontSize: 22),
                      bigSizedBox,
                      movie.overview.regular(),
                      bigSizedBox,
                      'Cast'.bold(fontSize: 22),
                      bigSizedBox,
                    ],
                  ),
                ),
              ),
              // Actor list — spanning full width
              SliverToBoxAdapter(
                child: movie.actors.isEmpty
                    ? Center(child: 'Cast unavailable'.regular())
                    : SizedBox(
                        height: size.height * 0.22,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: movie.actors.length,
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.06,
                          ),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final Actor actor = movie.actors[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                right: size.width * 0.04,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.black
                                              .withValues(alpha: 0.40),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: CachedNetworkImage(
                                        imageUrl: actor.profileUrl,
                                        width: size.width * 0.22,
                                        height: size.height * 0.15,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Shimmer.fromColors(
                                          baseColor: Colors.white10,
                                          highlightColor: Colors.white24,
                                          child: Container(
                                            width: size.width * 0.22,
                                            height: size.height * 0.15,
                                            color: Colors.white,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                          width: size.width * 0.22,
                                          height: size.height * 0.15,
                                          color: Colors.white10,
                                          child: const Icon(
                                            Icons.person_outline,
                                            color: Colors.white24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.01),
                                  actor.name.regular(),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      bigSizedBox,
                      'Trailer'.bold(fontSize: 22),
                      bigSizedBox,
                      (movie.trailerUrl == null || movie.trailerUrl!.isEmpty)
                          ? 'Trailer unavailable'.regular()
                          : GestureDetector(
                              onTap: () {
                                HapticService.medium();
                                final videoId =
                                    AppHelpers.extractVideoId(movie.trailerUrl!);
                                if (videoId != null) {
                                  TrailerPlayerModal.show(context, videoId);
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: AppHelpers.getYouTubeThumbnail(
                                        movie.trailerUrl!,
                                      ),
                                      width: double.infinity,
                                      height: size.height * 0.22,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.broken_image),
                                    ),
                                    // Glass play button
                                    LiquidGlass.withOwnLayer(
                                      settings: const LiquidGlassSettings(
                                        thickness: 20,
                                        blur: 22,
                                        glassColor: Color(0x0CFFFFFF),
                                      ),
                                      shape: LiquidRoundedSuperellipse(
                                        borderRadius: 60,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                          size.width * 0.03,
                                        ),
                                        child: const Icon(
                                          Icons.play_arrow_rounded,
                                          size: 40,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      bigSizedBox,
                      SizedBox(height: size.height * 0.05),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Back button — last in Stack so it receives taps before the scroll view
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: size.width * 0.05,
            child: GestureDetector(
              onTap: () {
                HapticService.light();
                Navigator.of(context).pop();
              },
              behavior: HitTestBehavior.opaque,
              child: LiquidGlass.withOwnLayer(
                settings: const LiquidGlassSettings(
                  thickness: 12,
                  blur: 16,
                  glassColor: Color(0x33000000),
                ),
                shape: LiquidRoundedSuperellipse(borderRadius: 14),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
