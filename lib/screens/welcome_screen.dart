import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  final bool isDark;
  const WelcomeScreen({super.key, this.isDark = true});

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final textColor = isDark ? AppColors.white : AppColors.black;
    final subtitleColor = isDark ? Colors.white70 : Colors.black87;
    final primaryBtnColor = isDark ? AppColors.purple : AppColors.black;
    final outlineBtnColor = isDark ? AppColors.white : AppColors.black;

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          // Wavy blob top
          Positioned(
            top: -20,
            right: -30,
            child: Transform.rotate(
              angle: 3.14,
              child: _WaveBlob(
                color:
                    isDark ? const Color(0xFF2A3A50) : const Color(0xFFFFF8E1),
                width: 260,
                height: 200,
              ),
            ),
          ),
          // Wavy blob bottom
          Positioned(
            bottom: -30,
            left: -40,
            child: _WaveBlob(
              color: isDark ? const Color(0xFF1E2D42) : const Color(0xFFFFF8E1),
              width: 220,
              height: 180,
            ),
          ),
          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 3),
                  Text(
                    'Welcome!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Compare prices. Shop wiser.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: subtitleColor,
                    ),
                  ),
                  const Spacer(flex: 1),
                  // Create Account button
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => RegisterScreen(isDark: isDark)),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBtnColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Create Account',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Log In button
                  OutlinedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => LoginScreen(isDark: isDark)),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: outlineBtnColor,
                      side: BorderSide(color: outlineBtnColor, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: Text(
                      'Log In',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WaveBlob extends StatelessWidget {
  final Color color;
  final double width;
  final double height;

  const _WaveBlob({
    required this.color,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _BlobClipper(),
      child: Container(
        width: width,
        height: height,
        color: color,
      ),
    );
  }
}

class _BlobClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.4);
    path.quadraticBezierTo(
        size.width * 0.2, 0, size.width * 0.5, size.height * 0.2);
    path.quadraticBezierTo(
        size.width * 0.8, size.height * 0.4, size.width, size.height * 0.2);

    path.quadraticBezierTo(
        size.width * 1.1, size.height * 0.1, size.width * 0.5, size.height);

    path.quadraticBezierTo(-size.width * 0.2, size.height * 0.5,
        size.width * -0.4, size.height * 0.5);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
