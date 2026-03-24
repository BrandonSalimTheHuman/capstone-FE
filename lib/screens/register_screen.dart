import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  final bool isDark;
  const RegisterScreen({super.key, this.isDark = true});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
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
                            'Create Account',
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: textColor,
                            ),
                          )),
                          const SizedBox(height: 20),
                          _label('Full Name', labelColor),
                          _field(
                            _nameCtrl,
                            'Your name',
                            fieldBg,
                            fieldTextColor,
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Please enter your name'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          _label('Email', labelColor),
                          _field(
                            _emailCtrl,
                            'your@email.com',
                            fieldBg,
                            fieldTextColor,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.isEmpty)
                                return 'Please enter your email';
                              if (!v.contains('@'))
                                return 'Enter a valid email';
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          _label('Password', labelColor),
                          _field(
                            _passCtrl,
                            '••••••••••••',
                            fieldBg,
                            fieldTextColor,
                            obscure: _obscurePass,
                            onToggleObscure: () =>
                                setState(() => _obscurePass = !_obscurePass),
                            validator: (v) {
                              if (v == null || v.isEmpty)
                                return 'Please enter a password';
                              if (v.length < 6)
                                return 'Password must be at least 6 characters';
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          _label('Confirm Password', labelColor),
                          _field(
                            _confirmCtrl,
                            '••••••••••••',
                            fieldBg,
                            fieldTextColor,
                            obscure: _obscureConfirm,
                            onToggleObscure: () => setState(
                                () => _obscureConfirm = !_obscureConfirm),
                            validator: (v) {
                              if (v == null || v.isEmpty)
                                return 'Please confirm your password';
                              if (v != _passCtrl.text)
                                return 'Passwords do not match';
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
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
                                'Sign Up',
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
                                        LoginScreen(isDark: isDark)),
                              ),
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.poppins(
                                      fontSize: 13, color: labelColor),
                                  children: [
                                    const TextSpan(
                                        text: 'Already have an account? '),
                                    TextSpan(
                                      text: 'Log in',
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

  Widget _field(
    TextEditingController ctrl,
    String hint,
    Color bg,
    Color textColor, {
    bool obscure = false,
    VoidCallback? onToggleObscure,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(fontSize: 14, color: textColor),
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: bg,
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
            fontSize: 14, color: textColor.withOpacity(0.5)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none, // Removes the default line
        ),
        errorStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.red),
        suffixIcon: onToggleObscure != null
            ? IconButton(
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: textColor.withOpacity(0.5),
                  size: 20,
                ),
                onPressed: onToggleObscure,
              )
            : null,
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
