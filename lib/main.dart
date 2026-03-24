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

  // Global key so child widgets can call GroceWiseApp.of(context).toggleTheme()
  static _GroceWiseAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_GroceWiseAppState>()!;

  @override
  State<GroceWiseApp> createState() => _GroceWiseAppState();
}

class _GroceWiseAppState extends State<GroceWiseApp> {
  bool isDark = true;

  void toggleTheme(bool value) {
    setState(() => isDark = value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GroceWise',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: SplashScreen(isDark: isDark),
    );
  }
}
