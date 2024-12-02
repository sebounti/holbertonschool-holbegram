import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:holbegram/firebase_options.dart';
import 'package:holbegram/providers/user_provider.dart';
import 'package:holbegram/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Charger les variables d'environnement
  await dotenv.load(fileName: "assets/.env");

  // Initialisez Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Affichez les variables d'environnement (optionnel)
  final apiKey = dotenv.env['API_KEY'] ?? 'default_api_key';
  final apiUrl = dotenv.env['API_URL'] ?? 'https://default.url';
  print('API Key: $apiKey');
  print('API URL: $apiUrl');

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
