import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';

class SettingsScreen extends StatefulWidget {
  final bool isDark;
  final Function(bool) onThemeChanged;

  const SettingsScreen(
      {super.key, this.isDark = true, required this.onThemeChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _isDark;

  @override
  void initState() {
    super.initState();
    _isDark = widget.isDark;
  }

  @override
  Widget build(BuildContext context) {
    final bg = _isDark ? AppColors.darkBg : AppColors.lightBg;
    final textColor = _isDark ? AppColors.white : AppColors.black;
    final cardBg = _isDark ? AppColors.darkSurface : AppColors.lightCard;
    final subtitleColor = _isDark ? Colors.white54 : Colors.black54;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back, color: textColor),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Settings',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            // Profile card
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: _isDark
                          ? AppColors.purple.withOpacity(0.3)
                          : Colors.black12,
                      child: Text(
                        'B',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: _isDark ? AppColors.purple : Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Brandon Salim',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        Text(
                          'branskutgaming234@gmail.com',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: subtitleColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _section('Account', textColor),
                  _tile(
                    icon: Icons.person_outline,
                    label: 'Edit profile',
                    textColor: textColor,
                    cardBg: cardBg,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => EditProfileScreen(isDark: _isDark)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _tile(
                    icon: Icons.lock_outline,
                    label: 'Change password',
                    textColor: textColor,
                    cardBg: cardBg,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              ChangePasswordScreen(isDark: _isDark)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _section('Preferences', textColor),
                  _tile(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    textColor: textColor,
                    cardBg: cardBg,
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  // Theme toggle with live switch
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _isDark
                              ? Icons.dark_mode_outlined
                              : Icons.light_mode_outlined,
                          color: textColor,
                          size: 24,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            _isDark ? 'Dark mode' : 'Light mode',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ),
                        Switch(
                          value: _isDark,
                          onChanged: (val) {
                            setState(() => _isDark = val);
                            widget.onThemeChanged(val);
                          },
                          activeColor:
                              _isDark ? AppColors.purple : Colors.black,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _section('Support', textColor),
                  _tile(
                    icon: Icons.flag_outlined,
                    label: 'Report a problem',
                    textColor: textColor,
                    cardBg: cardBg,
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  // Logout
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.logout,
                              color: Colors.redAccent, size: 24),
                          const SizedBox(width: 16),
                          Text(
                            'Logout',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String label, Color textColor) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          label.toUpperCase(),
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: textColor.withOpacity(0.4),
            letterSpacing: 1.0,
          ),
        ),
      );

  Widget _tile({
    required IconData icon,
    required String label,
    required Color textColor,
    required Color cardBg,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            Icon(Icons.chevron_right,
                color: textColor.withOpacity(0.4), size: 20),
          ],
        ),
      ),
    );
  }
}
