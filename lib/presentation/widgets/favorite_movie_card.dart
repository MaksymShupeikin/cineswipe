import 'package:cineswap/core/app_exports.dart';

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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => MovieDetails(
                      size: widget.size,
                      movie: widget.movie,
                    ),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: widget.size.height * 0.01,
            ),
            padding: EdgeInsets.symmetric(
              vertical: widget.size.height * 0.01,
              horizontal: widget.size.width * 0.02,
            ),
            decoration: BoxDecoration(
              color: AppColors.black.withAlpha(127),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              spacing: widget.size.width * 0.04,
              children: [
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.movie.posterUrl,
                      width: widget.size.width * 0.25,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    spacing: widget.size.height * 0.003,
                    children: [
                      '${widget.movie.title} (${widget.movie.year})'
                          .bold(fontSize: 18),
                      widget.movie.genres.join(', ').regular(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: widget.size.height * 0.02,
          right: widget.size.width * 0.02,
          child: GestureDetector(
            onTap: widget.onDelete,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withAlpha(127),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                Icons.cancel,
                color: AppColors.white,
                size: widget.size.width * 0.06,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
