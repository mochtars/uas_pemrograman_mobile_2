import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const WisataApp());
}

class WisataApp extends StatelessWidget {
  const WisataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(currentIndex: 0),
        '/favorite': (context) => const MainScreen(currentIndex: 1),
        '/profile': (context) => const MainScreen(currentIndex: 2),
      },
    );
  }
}
