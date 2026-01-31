import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/main_screen.dart';
import 'screens/add_wisata_screen.dart';
import 'screens/my_wisata_screen.dart';
import 'screens/detail_screen.dart';
import 'models/wisata.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const WisataApp());
}

class WisataApp extends StatelessWidget {
  const WisataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Wisata',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const MainScreen(),
        '/add_wisata': (context) => const AddWisataScreen(),
        '/my_wisata': (context) => const MyWisataScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final wisata = settings.arguments as Wisata;
          return MaterialPageRoute(
            builder: (context) => DetailScreen(wisata: wisata),
          );
        }
        return null;
      },
    );
  }
}
