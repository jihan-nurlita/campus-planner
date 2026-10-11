import 'package:campus_planner/core/theme/app_theme.dart';
import 'package:campus_planner/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';

class CampusPlanner extends StatelessWidget {
  const CampusPlanner({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Ubah bagian pembungkusan material pada lib/app.dart
    return MaterialApp(
      title: 'Campus Planner',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
