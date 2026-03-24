import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class ChangePasswordScreen extends StatefulWidget {
  final bool isDark;
  const ChangePasswordScreen({super.key, this.isDark = true});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _oldCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textColor = isDark ? AppColors.white : AppColors.black;
    final cardBg = isDark ? AppColors.darkSurface : AppColors.lightCard;
    final fieldBg = isDark ? AppColors.darkCard : Colors.white.withOpacity(0.7);
    final btnColor = isDark ? AppColors.purple : AppColors.black;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back, color: textColor),
              ),
              const SizedBox(height: 8),
              Text(
                'Change Password',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Current password', textColor),
                        const SizedBox(height: 8),
                        _field(
                          _oldCtrl,
                          fieldBg,
                          textColor,
                          obscure: _obscureOld,
                          onToggle: () =>
                              setState(() => _obscureOld = !_obscureOld),
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'Enter your current password'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        _label('New password', textColor),
                        const SizedBox(height: 8),
                        _field(
                          _newCtrl,
                          fieldBg,
                          textColor,
                          obscure: _obscureNew,
                          onToggle: () =>
                              setState(() => _obscureNew = !_obscureNew),
                          validator: (v) {
                            if (v == null || v.isEmpty)
                              return 'Enter a new password';
                            if (v.length < 6) return 'Minimum 6 characters';
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _label('Confirm new password', textColor),
                        const SizedBox(height: 8),
                        _field(
                          _confirmCtrl,
                          fieldBg,
                          textColor,
                          obscure: _obscureConfirm,
                          onToggle: () => setState(
                              () => _obscureConfirm = !_obscureConfirm),
                          validator: (v) {
                            if (v == null || v.isEmpty)
                              return 'Please confirm your password';
                            if (v != _newCtrl.text)
                              return 'Passwords do not match';
                            return null;
                          },
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Password changed successfully!',
                                      style: GoogleFonts.poppins(),
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: btnColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Confirm changes',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
      ),
    );
  }

  Widget _label(String text, Color color) => Text(
        text,
        style: GoogleFonts.poppins(
            fontSize: 14, fontWeight: FontWeight.w500, color: color),
      );

  Widget _field(
    TextEditingController ctrl,
    Color bg,
    Color textColor, {
    required bool obscure,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: TextFormField(
        controller: ctrl,
        obscureText: obscure,
        validator: validator,
        style: GoogleFonts.poppins(fontSize: 15, color: textColor),
        decoration: InputDecoration(
          hintText: '••••••••',
          hintStyle: GoogleFonts.poppins(
              fontSize: 15, color: textColor.withOpacity(0.35)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: IconButton(
            icon: Icon(
              obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: textColor.withOpacity(0.4),
              size: 20,
            ),
            onPressed: onToggle,
          ),
          errorStyle: const TextStyle(height: 0.01),
        ),
      ),
    );
  }
}
