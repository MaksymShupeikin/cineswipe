import 'package:cineswap/core/app_exports.dart';

extension StyledText on String {
  Text bold({required double fontSize}) {
    return Text(
      this,
      style: GoogleFonts.raleway(
        color: AppColors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        height: 1.0,
      ),
      textHeightBehavior: TextHeightBehavior(
        applyHeightToFirstAscent: false,
        applyHeightToLastDescent: false,
      ),
      textAlign: TextAlign.center,
      softWrap: true,
      overflow: TextOverflow.visible,
    );
  }

  Text regular() {
    return Text(
      this,
      style: GoogleFonts.raleway(
        color: AppColors.white,
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.0,
      ),
      textHeightBehavior: TextHeightBehavior(
        applyHeightToFirstAscent: false,
        applyHeightToLastDescent: false,
      ),
      textAlign: TextAlign.center,
      softWrap: true,
      overflow: TextOverflow.visible,
    );
  }
}
