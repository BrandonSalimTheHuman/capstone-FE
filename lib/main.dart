import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const GroceWiseApp());
}

class GroceWiseApp extends StatefulWidget {
  const GroceWiseApp({super.key});

  @override
  State<GroceWiseApp> createState() => _GroceWiseAppState();
}

class _GroceWiseAppState extends State<GroceWiseApp> {
  bool _isDark = true;

  void _toggleTheme(bool isDark) {
    setState(() => _isDark = isDark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GroceWise',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: SplashScreen(isDark: _isDark),
    );
  }
}
