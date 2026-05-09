import 'package:flutter/material.dart';
import 'core/router/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BTG Challenge',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      routerConfig: appRouter,
    );
  }
}
