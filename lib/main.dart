import 'package:cineswipe/core/app_exports.dart';

void main() async {
  await initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MoviesProvider()),
      ],
      child: const Cineswipe(),
    ),
  );
}

class Cineswipe extends StatelessWidget {
  const Cineswipe({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return MaterialApp(
      title: 'CineSwipe',
      debugShowCheckedModeBanner: false,
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: NavigationScreen(size: size),
      ),
    );
  }
}
