import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/main_screen.dart';
import 'screens/add_wisata_screen.dart';
import 'screens/detail_screen.dart';
import 'models/wisata.dart';

void main() {
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
