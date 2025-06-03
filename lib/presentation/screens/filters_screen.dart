import 'package:cineswap/core/app_exports.dart';

class FiltersScreen extends StatelessWidget {
  final Size size;
  final VoidCallback onFiltersApplied;
  final VoidCallback onFiltersReset;
  const FiltersScreen({
    super.key,
    required this.size,
    required this.onFiltersApplied,
     required this.onFiltersReset,
  });

  @override
  Widget build(BuildContext context) {
    final List<BoxShadow> shadow = [
      BoxShadow(
        color: AppColors.white.withAlpha(127),
        blurRadius: 10,
        spreadRadius: 2,
      ),
    ];

    return Consumer<MoviesProvider>(
      builder: (context, provider, child) {
        final selectedIds =
            context.watch<MoviesProvider>().selectedGenreIds;
        final RangeValues ratingRange = RangeValues(
          provider.minRating,
          provider.maxRating,
        );

        final RangeValues decadeRange = RangeValues(
          provider.minDecade.toDouble(),
          provider.maxDecade.toDouble(),
        );

        return Column(
          spacing: size.height * 0.02,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: size.height * 0.01,
                horizontal: size.width * 0.02,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.black.withAlpha(240),
                borderRadius: BorderRadius.circular(15),
                boxShadow: shadow,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                spacing: size.height * 0.02,
                children: [
                  'Genre'.bold(fontSize: 18),
                  Wrap(
                    spacing: size.width * 0.02,
                    runSpacing: size.height * 0.01,
                    alignment: WrapAlignment.spaceEvenly,
                    children:
                        allGenres.map((genre) {
                          final isSelected = selectedIds.contains(
                            genre.id,
                          );

                          return GestureDetector(
                            onTap:
                                () => provider.toggleGenre(genre.id),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.015,
                                horizontal: size.width * 0.03,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white.withAlpha(127),
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                                boxShadow:
                                    isSelected
                                        ? [
                                          BoxShadow(
                                            color: AppColors.white
                                                .withAlpha(120),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ]
                                        : [],
                              ),
                              child: genre.name.regular(),
                            ),
                          );
                        }).toList(),
                  ),
                  'Raiting'.bold(fontSize: 18),
                  RangeSlider(
                    inactiveColor: AppColors.white.withAlpha(127),
                    activeColor: AppColors.white,
                    values: ratingRange,
                    min: 0.0,
                    max: 10.0,
                    divisions: 100,
                    labels: RangeLabels(
                      provider.minRating.toStringAsFixed(1),
                      provider.maxRating.toStringAsFixed(1),
                    ),
                    onChanged: (RangeValues values) {
                      provider.updateRatingRange(
                        values.start,
                        values.end,
                      );
                    },
                  ),
                  'Release'.bold(fontSize: 18),
                  RangeSlider(
                    inactiveColor: AppColors.white.withAlpha(127),
                    activeColor: AppColors.white,
                    values: decadeRange,
                    min: 1920,
                    max: 2020,
                    divisions: 10,
                    labels: RangeLabels(
                      provider.minDecade.toString(),
                      provider.maxDecade.toString(),
                    ),
                    onChanged: (RangeValues values) {
                      provider.updateDecadeRange(
                        (values.start ~/ 10) * 10,
                        (values.end ~/ 10) * 10,
                      );
                    },
                  ),
                ],
              ),
            ),
            Row(
              spacing: size.width * 0.02,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onFiltersApplied,
                    child: Container(
                      height: size.height * 0.065,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.black.withAlpha(240),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: shadow,
                      ),
                      child: Text(
                        'Apply',
                        style: GoogleFonts.raleway(
                          color: AppColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onFiltersReset,
                  child: Container(
                    height: size.height * 0.065,
                    width: size.width * 0.25,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.black.withAlpha(240),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: shadow,
                    ),
                    child: Text(
                      'Reset',
                      style: GoogleFonts.raleway(
                        color: AppColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
