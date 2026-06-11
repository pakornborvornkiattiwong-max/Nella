import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const NellaEditor());
}

class NellaEditor extends StatelessWidget {
  const NellaEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nella Editor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.grey,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
