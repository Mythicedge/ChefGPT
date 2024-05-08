import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'Data/recipemodel_provider.dart'; 
import 'Screens/generated_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RecipeProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Recipe App',
        themeMode: ThemeMode.system,
        initialRoute: '/',
        onGenerateRoute: RouteGenerator().generateRoute,
      ),
    );
  }
}
