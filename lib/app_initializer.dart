import 'package:cineswap/core/app_exports.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.black,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: AppColors.black,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  Hive.registerAdapter(MovieAdapter());
  Hive.registerAdapter(ActorAdapter());

  await Hive.openBox<Movie>('favorites');

  await dotenv.load(fileName: ".env");
}
