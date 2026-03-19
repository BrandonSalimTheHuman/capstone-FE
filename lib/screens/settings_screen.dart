import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';

class SettingsScreen extends StatelessWidget {
  final bool isDark;
  final Function(bool) onThemeChanged;

  const SettingsScreen(
      {super.key, this.isDark = true, required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textColor = isDark ? AppColors.white : AppColors.black;
    final cardBg = isDark ? AppColors.darkSurface : AppColors.lightCard;

    final items = [
      _SettingItem(Icons.person_outline, 'Edit profile', () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => EditProfileScreen(isDark: isDark)),
        );
      }),
      _SettingItem(Icons.lock_outline, 'Change password', () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ChangePasswordScreen(isDark: isDark)),
        );
      }),
      _SettingItem(Icons.notifications_outlined, 'Notifications', () {}),
      _SettingItem(Icons.brush_outlined, 'Change theme', () {
        onThemeChanged(!isDark);
        Navigator.pop(context);
      }),
      _SettingItem(Icons.flag_outlined, 'Report a problem', () {}),
      _SettingItem(Icons.logout, 'Logout', () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }),
    ];

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
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
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return GestureDetector(
                    onTap: item.onTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 18),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Icon(item.icon, color: textColor, size: 24),
                          const SizedBox(width: 20),
                          Text(
                            item.label,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  _SettingItem(this.icon, this.label, this.onTap);
}
