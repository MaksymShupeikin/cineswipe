import 'package:cineswap/core/app_exports.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

class ColorFromImageService {
  static Future<Color> getAverageColorFromNetworkImage(
    String imageUrl,
  ) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) return Colors.black;

      final Uint8List bytes = response.bodyBytes;
      final ui.Codec codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: 10,
        targetHeight: 10,
      );
      final ui.FrameInfo frame = await codec.getNextFrame();
      final ui.Image image = frame.image;

      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      );
      if (byteData == null) return Colors.black;

      final Uint8List pixels = byteData.buffer.asUint8List();

      int redSum = 0;
      int greenSum = 0;
      int blueSum = 0;
      int pixelCount = 0;

      for (int i = 0; i < pixels.length; i += 80) {
        redSum += pixels[i];
        greenSum += pixels[i + 1];
        blueSum += pixels[i + 2];
        pixelCount++;
      }

      return Color.fromARGB(
        255,
        (redSum / pixelCount).round(),
        (greenSum / pixelCount).round(),
        (blueSum / pixelCount).round(),
      );
    } catch (e) {
      debugPrint('Error getAverageColorFromNetworkImage: $e');
      return AppColors.white;
    }
  }
}
