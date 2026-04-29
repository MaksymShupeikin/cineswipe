import 'package:cineswipe/core/app_exports.dart';


class MovieCardShimmer extends StatelessWidget {
  final Size size;

  const MovieCardShimmer({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(127),
              blurRadius: 8,
              spreadRadius: 6,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[500]!,
            highlightColor: Colors.grey[200]!,
            child: Stack(
              children: [
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: size.height * 0.65,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.01,
                      horizontal: size.width * 0.06,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 24,
                          color: Colors.white,
                        ),
                        SizedBox(height: size.height * 0.003),
                        Container(
                          width: double.infinity,
                          height: 16,
                          color: Colors.white,
                        ),
                        SizedBox(height: size.height * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: size.width * 0.05,
                              height: size.width * 0.05,
                              color: Colors.white,
                            ),
                            SizedBox(width: size.width * 0.02),
                            Container(
                              width: 30,
                              height: 16,
                              color: Colors.white,
                            ),
                            SizedBox(width: size.width * 0.02),
                            Container(
                              width: 10,
                              height: 16,
                              color: Colors.white,
                            ),
                            SizedBox(width: size.width * 0.02),
                            Container(
                              width: 50,
                              height: 16,
                              color: Colors.white,
                            ),
                            SizedBox(width: size.width * 0.02),
                            Container(
                              width: 10,
                              height: 16,
                              color: Colors.white,
                            ),
                            SizedBox(width: size.width * 0.02),
                            Container(
                              width: 40,
                              height: 16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
