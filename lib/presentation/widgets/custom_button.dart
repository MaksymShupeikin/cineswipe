import '../../core/app_exports.dart';

class CustomButton extends StatelessWidget {
  final Size size;
  final String image;
  final VoidCallback onTap;

  const CustomButton({
    super.key,
    required this.size,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size.height * 0.07,
        width: size.width * 0.2,
        padding: EdgeInsets.symmetric(
          vertical: size.height * 0.01,
          horizontal: size.width * 0.06,
        ),
        decoration: BoxDecoration(
          color: AppColors.white.withAlpha(50),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.white, width: 2),
        ),
        child: Image.asset(image, color: AppColors.white),
      ),
    );
  }
}
