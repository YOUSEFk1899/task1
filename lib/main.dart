import 'package:flutter/material.dart';

import 'features/auth/presentation/login_page.dart';

void main() {
  runApp(const YZAccessoriesApp());
}

class YZAccessoriesApp extends StatelessWidget {
  const YZAccessoriesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YZ Accessories',

      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF111111),
          brightness: Brightness.light,
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF101010),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF111111),
          brightness: Brightness.dark,
        ),
      ),

      themeMode: ThemeMode.light,

      home: const LoginPage(),
    );
  }
}
