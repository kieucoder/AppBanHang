
import 'package:flutter/material.dart';
import 'package:shopbanhang/screens/login_screen.dart';





void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tiệm Sữa 4CE',
      home: const LoginScreen(), // Màn hình checkout
    );
  }
}



