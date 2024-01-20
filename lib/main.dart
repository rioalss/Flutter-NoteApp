import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: AnimatedSplashScreen(
        splash: CircleAvatar(
          backgroundColor: Colors.amber.shade900,
          radius: 50,
          child: Image.asset(
            'assets/logo.png',
            alignment: Alignment.center,
            color: Colors.white,
            scale: 12,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        duration: 3000,
        centered: true,
        nextScreen: const HomePage(),
      ),
    );
  }
}
