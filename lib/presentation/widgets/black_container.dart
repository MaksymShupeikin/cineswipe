import 'package:cineswap/core/app_exports.dart';

class BlackContainer extends StatelessWidget {
  final Size size;
  final String? screenTitle;

  const BlackContainer({
    super.key,
    required this.size,
    this.screenTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.black.withAlpha(240),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.white.withAlpha(127),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical:
              screenTitle == null
                  ? size.height * 0.01
                  : size.height * 0.02,
          horizontal: size.width * 0.02,
        ),
        child:
            screenTitle == null
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: AppColors.white,
                          ),
                          SizedBox(height: size.height * 0.003),
                          'Skip'.regular(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_upward,
                            color: AppColors.white,
                          ),
                          SizedBox(height: size.height * 0.003),
                          'Seen'.regular(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_forward,
                            color: AppColors.white,
                          ),
                          SizedBox(height: size.height * 0.003),
                          'Like'.regular(),
                        ],
                      ),
                    ),
                  ],
                )
                : screenTitle!.bold(fontSize: 22),
      ),
    );
  }
}
