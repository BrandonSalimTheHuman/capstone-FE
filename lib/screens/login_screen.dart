import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool isDark;
  const LoginScreen({super.key, this.isDark = true});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePass = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(isDark: widget.isDark)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final cardBg = isDark ? AppColors.darkSurface : AppColors.lightCard;
    final textColor = isDark ? AppColors.white : AppColors.black;
    final labelColor = isDark ? Colors.white70 : Colors.black87;
    final fieldBg = isDark ? AppColors.darkCard : Colors.white;
    final fieldTextColor = isDark ? Colors.white : Colors.black;
    final btnColor = isDark ? AppColors.purple : AppColors.black;
    final blobColor =
        isDark ? const Color(0xFF2A3A50) : const Color(0xFFFFFFFF);

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          Positioned(
            top: -20,
            right: -30,
            child: Container(
              width: 260,
              height: 200,
              decoration: BoxDecoration(
                color: blobColor,
                borderRadius: BorderRadius.circular(120),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 80),
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                              child: Text(
                            'Welcome!',
                            style: GoogleFonts.poppins(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: textColor,
                            ),
                          )),
                          const SizedBox(height: 20),
                          _label('Email', labelColor),
                          _emailField(fieldBg, fieldTextColor),
                          const SizedBox(height: 12),
                          _label('Password', labelColor),
                          _passwordField(fieldBg, fieldTextColor),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    onChanged: (v) => setState(
                                        () => _rememberMe = v ?? false),
                                    activeColor: btnColor,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  Text('Remember me',
                                      style: GoogleFonts.poppins(
                                          fontSize: 12, color: labelColor)),
                                ],
                              ),
                              Text('Forgot password?',
                                  style: GoogleFonts.poppins(
                                      fontSize: 12, color: labelColor)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: btnColor,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
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
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                  child: Divider(
                                      color: labelColor.withOpacity(0.3))),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text('or',
                                    style: GoogleFonts.poppins(
                                        fontSize: 12, color: labelColor)),
                              ),
                              Expanded(
                                  child: Divider(
                                      color: labelColor.withOpacity(0.3))),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _socialBtn('G', Colors.redAccent),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: GestureDetector(
                              onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        RegisterScreen(isDark: isDark)),
                              ),
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.poppins(
                                      fontSize: 13, color: labelColor),
                                  children: [
                                    const TextSpan(
                                        text: "Don't have an account? "),
                                    TextSpan(
                                      text: 'Sign Up',
                                      style: TextStyle(
                                        color: isDark
                                            ? AppColors.purple
                                            : AppColors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text, Color color) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child:
            Text(text, style: GoogleFonts.poppins(fontSize: 14, color: color)),
      );

  Widget _emailField(Color bg, Color textColor) {
    return TextFormField(
      controller: _emailCtrl,
      keyboardType: TextInputType.emailAddress,
      style: GoogleFonts.poppins(fontSize: 14, color: textColor),
      validator: (v) {
        if (v == null || v.isEmpty) return 'Please enter your email';
        if (!v.contains('@')) return 'Enter a valid email';
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: bg,
        hintText: 'your@email.com',
        hintStyle: GoogleFonts.poppins(
            fontSize: 14, color: textColor.withOpacity(0.5)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        // Removed height: 0.01 so the message is visible
        errorStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.red),
      ),
    );
  }

  Widget _passwordField(Color bg, Color textColor) {
    return TextFormField(
      controller: _passCtrl,
      obscureText: _obscurePass,
      style: GoogleFonts.poppins(fontSize: 14, color: textColor),
      validator: (v) {
        if (v == null || v.isEmpty) return 'Please enter your password';
        if (v.length < 6) return 'Password must be at least 6 characters';
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: bg,
        hintText: '••••••••••••',
        hintStyle: GoogleFonts.poppins(
            fontSize: 14, color: textColor.withOpacity(0.5)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        errorStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.red),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePass
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: textColor.withOpacity(0.5),
            size: 20,
          ),
          onPressed: () => setState(() => _obscurePass = !_obscurePass),
        ),
      ),
    );
  }

  Widget _socialBtn(String letter, Color color) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Center(
        child: Text(
          letter,
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
