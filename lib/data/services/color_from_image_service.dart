import 'package:cineswipe/core/app_exports.dart';
import 'package:palette_generator/palette_generator.dart';

typedef ImageRegionColors = ({Color average, Color top, Color bottom});

class ColorFromImageService {
  static final Map<String, Future<ImageRegionColors>> _regionColorCache = {};

  /// Extracts dominant palette colors from a network image using k-means
  /// clustering (palette_generator). The image is sampled small for speed.
  /// Uses the disk cache from cached_network_image so repeated calls are cheap.
  static Future<ImageRegionColors> getImageRegionColors(String imageUrl) async {
    return _regionColorCache.putIfAbsent(
      imageUrl,
      () => _extractImageRegionColors(imageUrl),
    );
  }

  static Future<ImageRegionColors> _extractImageRegionColors(
    String imageUrl,
  ) async {
    const fallback = (
      average: AppColors.white,
      top: AppColors.white,
      bottom: AppColors.white,
    );

    try {
      final palette = await PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(imageUrl),
        size: const Size(80, 120),
        maximumColorCount: 8,
      );

      final vibrant = palette.vibrantColor?.color;
      final dominant = palette.dominantColor?.color;
      final light = palette.lightVibrantColor?.color;
      final dark =
          palette.darkVibrantColor?.color ?? palette.darkMutedColor?.color;

      final base = vibrant ?? dominant ?? AppColors.white;

      return (average: base, top: light ?? base, bottom: dark ?? base);
    } catch (e) {
      debugPrint('ColorFromImageService error: $e');
      return fallback;
    }
  }

  static Future<Color> getAverageColorFromNetworkImage(String imageUrl) async {
    return (await getImageRegionColors(imageUrl)).average;
  }
}
