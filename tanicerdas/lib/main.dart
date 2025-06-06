import 'package:flutter/material.dart';
import 'splash_screen.dart'; // Tambahkan ini

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tani Cerdas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const SplashScreen(), // Ubah jadi SplashScreen
    );
  }
}
