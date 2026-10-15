import 'package:flutter/material.dart';
import 'package:odbfinder/register/login.dart';
import 'package:odbfinder/screens/accountsetting/editprofile.dart';
import 'package:odbfinder/screens/accountsetting/securityandpassword.dart';
import 'package:odbfinder/screens/accountsetting/verification.dart';
import 'package:odbfinder/screens/notification/notificationsettings.dart';
import 'package:odbfinder/screens/support/about.dart';
import 'package:odbfinder/screens/support/helpcenter.dart';
import 'package:odbfinder/screens/support/safetyguide.dart';
import 'package:odbfinder/screens/support/terms.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  final Color darkBlue = const Color(0xFF004D7A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: darkBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        toolbarHeight: 70,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECTION 1: ACCOUNT ---
            _buildSectionHeader('Account'),
            const SizedBox(height: 12),
            _buildCardGroup([
              _buildSettingItem(
                icon: Icons.person_outline_rounded,
                title: 'Edit Profile',
                subtitle: 'Edit Name, Phone, Profile Photo',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Divider(color: Colors.black12, height: 1),
              ),
              _buildSettingItem(
                icon: Icons.verified_user_outlined,
                title: 'Student Verification',
                subtitle: 'Status: [Verified/Unverified]',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VerificationScreen(),
                    ),
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Divider(color: Colors.black12, height: 1),
              ),
              _buildSettingItem(
                icon: Icons.lock_outline_rounded,
                title: 'Security & Password',
                subtitle: 'Change password',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SecurityAndPasswordScreen(),
                    ),
                  );
                },
              ),
            ]),
            const SizedBox(height: 24),

            // --- SECTION 2: PREFERENCES ---
            _buildSectionHeader('Preferences'),
            const SizedBox(height: 12),
            _buildCardGroup([
              _buildSettingItem(
                icon: Icons.notifications_outlined,
                title: 'Notifications Settings',
                subtitle: 'Push Alerts, SMS reminders',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationSettingsScreen(),
                    ),
                  );
                },
              ),
            ]),
            const SizedBox(height: 24),

            // --- SECTION 3: SUPPORT ---
            _buildSectionHeader('Support'),
            const SizedBox(height: 12),
            _buildCardGroup([
              _buildSettingItem(
                icon: Icons.help_outline_rounded,
                title: 'Help Center',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelpCenterScreen()),
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Divider(color: Colors.black12, height: 1),
              ),
              _buildSettingItem(
                icon: Icons.shield_outlined,
                title: 'Safety Guide',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SafetyGuideScreen(),
                    ),
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Divider(color: Colors.black12, height: 1),
              ),
              _buildSettingItem(
                icon: Icons.description_outlined,
                title: 'Terms of Service & Privacy Policy',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TermsAndPrivacyScreen(),
                    ),
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Divider(color: Colors.black12, height: 1),
              ),
              _buildSettingItem(
                icon: Icons.info_outline_rounded,
                title: 'About',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutScreen()),
                  );
                },
              ),
            ]),
            const SizedBox(height: 36),

            // --- LOGOUT BUTTON ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E1E1E),
      ),
    );
  }

  Widget _buildCardGroup(List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: darkBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: darkBlue, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}