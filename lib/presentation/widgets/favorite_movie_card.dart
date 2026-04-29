import 'package:cineswipe/core/app_exports.dart';
import 'package:flutter/cupertino.dart';

class FavoriteMovieCard extends StatefulWidget {
  final Movie movie;
  final Size size;
  final VoidCallback onDelete;

  const FavoriteMovieCard({
    super.key,
    required this.movie,
    required this.size,
    required this.onDelete,
  });

  @override
  State<FavoriteMovieCard> createState() => _FavoriteMovieCardState();
}

class _FavoriteMovieCardState extends State<FavoriteMovieCard>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetails(
                  size: widget.size,
                  movie: widget.movie,
                ),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: widget.size.height * 0.01),
            child: LiquidGlass.withOwnLayer(
              settings: const LiquidGlassSettings(
                thickness: 20,
                blur: 22,
                glassColor: Color(0x0CFFFFFF),
              ),
              shape: LiquidRoundedSuperellipse(borderRadius: 20),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: widget.size.height * 0.012,
                  horizontal: widget.size.width * 0.03,
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withAlpha(115),
                            blurRadius: 12,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Hero(
                        tag: widget.movie.posterUrl,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: CachedNetworkImage(
                            imageUrl: widget.movie.posterUrl,
                            width: widget.size.width * 0.25,
                            fadeInDuration: Duration.zero,
                            placeholderFadeInDuration: Duration.zero,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.white10,
                              highlightColor: Colors.white24,
                              child: Container(
                                width: widget.size.width * 0.25,
                                height: widget.size.height * 0.15,
                                color: Colors.white,
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: widget.size.width * 0.25,
                              height: widget.size.height * 0.15,
                              color: Colors.white10,
                              child: const Icon(
                                Icons.movie_outlined,
                                color: Colors.white38,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: widget.size.width * 0.04),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          '${widget.movie.title} (${widget.movie.year})'
                              .bold(fontSize: 18),
                          SizedBox(height: widget.size.height * 0.003),
                          widget.movie.genres.join(', ').regular(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Increased delete button hit area
        Positioned(
          top: widget.size.height * 0.005,
          right: widget.size.width * 0.005,
          child: CupertinoButton(
            padding: const EdgeInsets.all(16),
            onPressed: () {
              HapticService.medium();
              widget.onDelete();
            },
            child: Icon(
              Icons.cancel_outlined,
              color: AppColors.white.withValues(alpha: 0.8),
              size: widget.size.width * 0.06,
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
