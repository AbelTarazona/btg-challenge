import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'core/router/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp.router(
      title: 'BTG Challenge',
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
