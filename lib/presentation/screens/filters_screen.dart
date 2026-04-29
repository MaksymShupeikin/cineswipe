import 'dart:math';
import 'package:cineswipe/core/app_exports.dart';

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

  static final List<Genre> _shuffledGenres =
      List<Genre>.from(allGenres)..shuffle(Random(42));

  @override
  Widget build(BuildContext context) {
    return Consumer<MoviesProvider>(
      builder: (context, provider, child) {
        final accentColor = provider.accentColor;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(bottom: size.height * 0.02),
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildSectionLabel('Genres'),
                  SizedBox(height: size.height * 0.012),
                  _buildChipRows<Genre>(
                    items: _shuffledGenres,
                    isSelected: (g) => provider.selectedGenreIds.contains(g.id),
                    label: (g) => g.name,
                    onTap: (g) => provider.toggleGenre(g.id),
                    accentColor: accentColor,
                  ),
                  SizedBox(height: size.height * 0.03),
                  _buildSectionLabel('Countries'),
                  SizedBox(height: size.height * 0.012),
                  _buildChipRows<Country>(
                    items: allCountries,
                    isSelected: (c) =>
                        provider.selectedCountryCodes.contains(c.code),
                    label: (c) => c.name,
                    onTap: (c) => provider.toggleCountry(c.code),
                    accentColor: accentColor,
                  ),
                  SizedBox(height: size.height * 0.03),
                  _buildSliderCard(
                    title: 'Rating',
                    value:
                        '${provider.minRating.toStringAsFixed(1)} – ${provider.maxRating.toStringAsFixed(1)}',
                    slider: _buildRatingSlider(context, provider, accentColor),
                  ),
                  SizedBox(height: size.height * 0.02),
                  _buildSliderCard(
                    title: 'Year',
                    value: '${provider.minYear} – ${provider.maxYear}',
                    slider: _buildYearSlider(context, provider, accentColor),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: size.height * 0.14),
              child: _buildBottomActions(context, accentColor),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: text.bold(
        fontSize: 16,
        color: AppColors.white.withValues(alpha: 0.7),
      ),
    );
  }

  Widget _buildChipRows<T>({
    required List<T> items,
    required bool Function(T) isSelected,
    required String Function(T) label,
    required void Function(T) onTap,
    required Color accentColor,
  }) {
    final rowSize = (items.length / 3).ceil();
    final rows = [
      items.sublist(0, rowSize.clamp(0, items.length)),
      items.sublist(
          rowSize.clamp(0, items.length), (rowSize * 2).clamp(0, items.length)),
      items.sublist(
          (rowSize * 2).clamp(0, items.length), items.length),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows
          .where((r) => r.isNotEmpty)
          .map((row) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildChipRow(
                  items: row,
                  isSelected: isSelected,
                  label: label,
                  onTap: onTap,
                  accentColor: accentColor,
                ),
              ))
          .toList(),
    );
  }

  Widget _buildChipRow<T>({
    required List<T> items,
    required bool Function(T) isSelected,
    required String Function(T) label,
    required void Function(T) onTap,
    required Color accentColor,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      padding: EdgeInsets.only(right: size.width * 0.06),
      child: Row(
        children: items.map((item) {
          final selected = isSelected(item);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                HapticService.light();
                onTap(item);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.white.withValues(alpha: 0.2)
                      : AppColors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected
                        ? AppColors.white.withValues(alpha: 0.4)
                        : AppColors.white.withValues(alpha: 0.1),
                    width: 1.5,
                  ),
                  boxShadow: [
                    if (selected)
                      BoxShadow(
                        color: AppColors.white.withValues(alpha: 0.1),
                        blurRadius: 10,
                        spreadRadius: -2,
                      ),
                  ],
                ),
                child: label(item).regular(
                  color: selected
                      ? AppColors.white
                      : AppColors.white.withValues(alpha: 0.6),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSliderCard({
    required String title,
    required String value,
    required Widget slider,
  }) {
    return LiquidGlass.withOwnLayer(
      settings: const LiquidGlassSettings(
        thickness: 12,
        blur: 18,
        glassColor: Color(0x0AFFFFFF),
      ),
      shape: LiquidRoundedSuperellipse(borderRadius: 20),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                title.bold(fontSize: 16),
                value.bold(fontSize: 14),
              ],
            ),
            slider,
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSlider(
    BuildContext context,
    MoviesProvider provider,
    Color accentColor,
  ) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: AppColors.white.withValues(alpha: 0.8),
        inactiveTrackColor: AppColors.white.withValues(alpha: 0.1),
        thumbColor: AppColors.white,
        overlayColor: AppColors.white.withValues(alpha: 0.15),
        trackHeight: 4,
        rangeThumbShape: const RoundRangeSliderThumbShape(
          enabledThumbRadius: 9,
          elevation: 4,
        ),
        rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
      ),
      child: RangeSlider(
        values: RangeValues(provider.minRating, provider.maxRating),
        min: 4.0,
        max: 10.0,
        divisions: 12,
        onChanged: (values) {
          if (values.start.roundToDouble() !=
                  provider.minRating.roundToDouble() ||
              values.end.roundToDouble() !=
                  provider.maxRating.roundToDouble()) {
            HapticService.light();
          }
          provider.updateRatingRange(values.start, values.end);
        },
      ),
    );
  }

  Widget _buildYearSlider(
    BuildContext context,
    MoviesProvider provider,
    Color accentColor,
  ) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: AppColors.white.withValues(alpha: 0.8),
        inactiveTrackColor: AppColors.white.withValues(alpha: 0.1),
        thumbColor: AppColors.white,
        overlayColor: AppColors.white.withValues(alpha: 0.15),
        trackHeight: 4,
        rangeThumbShape: const RoundRangeSliderThumbShape(
          enabledThumbRadius: 9,
          elevation: 4,
        ),
        rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
      ),
      child: RangeSlider(
        values: RangeValues(
          provider.minYear.toDouble(),
          provider.maxYear.toDouble(),
        ),
        min: 1975,
        max: 2024,
        divisions: 49,
        onChanged: (values) {
          final newMin = values.start.round();
          final newMax = values.end.round();
          if (newMin != provider.minYear || newMax != provider.maxYear) {
            HapticService.light();
          }
          provider.updateYearRange(newMin, newMax);
        },
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context, Color accentColor) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: () {
              HapticService.heavy();
              onFiltersApplied();
            },
            child: LiquidGlass.withOwnLayer(
              settings: LiquidGlassSettings(
                thickness: 20,
                blur: 24,
                glassColor: AppColors.white.withValues(alpha: 0.15),
              ),
              shape: LiquidRoundedSuperellipse(borderRadius: 24),
              child: Container(
                height: 60,
                alignment: Alignment.center,
                child: 'Apply Filters'.bold(fontSize: 17),
              ),
            ),
          ),
        ),
        SizedBox(width: size.width * 0.03),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              HapticService.medium();
              onFiltersReset();
            },
            child: LiquidGlass.withOwnLayer(
              settings: const LiquidGlassSettings(
                thickness: 14,
                blur: 18,
                glassColor: Color(0x0CFFFFFF),
              ),
              shape: LiquidRoundedSuperellipse(borderRadius: 24),
              child: Container(
                height: 60,
                alignment: Alignment.center,
                child: 'Reset'.regular(
                  color: AppColors.white.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
