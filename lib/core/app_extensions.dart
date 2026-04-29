import 'package:cineswipe/core/app_exports.dart';

extension StyledText on String {
  Text bold({required double fontSize, Color? color}) {
    return Text(
      this,
      style: GoogleFonts.raleway(
        color: color ?? AppColors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        height: 1.0,
      ),
      textHeightBehavior: const TextHeightBehavior(
        applyHeightToFirstAscent: false,
        applyHeightToLastDescent: false,
      ),
      textAlign: TextAlign.center,
      softWrap: true,
      overflow: TextOverflow.visible,
    );
  }

  Text regular({Color? color}) {
    return Text(
      this,
      style: GoogleFonts.raleway(
        color: color ?? AppColors.white,
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.0,
      ),
      textHeightBehavior: const TextHeightBehavior(
        applyHeightToFirstAscent: false,
        applyHeightToLastDescent: false,
      ),
      textAlign: TextAlign.center,
      softWrap: true,
      overflow: TextOverflow.visible,
    );
  }
}
