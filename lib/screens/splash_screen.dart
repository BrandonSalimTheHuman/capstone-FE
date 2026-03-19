import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool isDark;
  const SplashScreen({super.key, this.isDark = true});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => WelcomeScreen(isDark: widget.isDark)),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.isDark ? AppColors.darkBg : AppColors.lightBg;
    final textColor = widget.isDark ? AppColors.white : AppColors.black;
    final accentColor = widget.isDark ? AppColors.amber : AppColors.black;

    return Scaffold(
      backgroundColor: bg,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              // Logo
              Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Groce',
                          style: GoogleFonts.poppins(
                            fontSize: 52,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                          ),
                        ),
                        TextSpan(
                          text: '\nWise',
                          style: GoogleFonts.poppins(
                            fontSize: 52,
                            fontWeight: FontWeight.w800,
                            color: accentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Shopping cart icon
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 72,
                    color: textColor,
                  ),
                ],
              ),
              const Spacer(flex: 2),
              Text(
                'YOUR WALLET DESERVES A DISCOUNT TOO!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: accentColor,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
