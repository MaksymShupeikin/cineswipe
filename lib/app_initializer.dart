import 'package:cineswipe/core/app_exports.dart';

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  Hive.registerAdapter(MovieAdapter());
  Hive.registerAdapter(ActorAdapter());

  await Hive.openBox<Movie>('favorites');
  await Hive.openBox<Movie>('movieCache');

  await dotenv.load(fileName: ".env");
}
