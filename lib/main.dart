import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_wisata_screen.dart';
import 'screens/detail_wisata_screen.dart';
import 'screens/info_screen.dart';
import 'models/wisata_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Wisata',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/add_wisata': (context) => const AddWisataScreen(),
        '/info': (context) => const InfoScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail_wisata') {
          final wisata = settings.arguments as Wisata;
          return MaterialPageRoute(
            builder: (context) => DetailWisataScreen(wisata: wisata),
          );
        }
        return null;
      },
    );
  }
}
