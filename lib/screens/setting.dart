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

  final Color darkBlue = const Color(0xFF0A4F7D);
  final Color cardGrey = const Color(0xFFD9D9D9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: darkBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        toolbarHeight: 70,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECTION 1: ACCOUNT ---
            _buildSectionHeader('Account'),
            const SizedBox(height: 8),
            _buildCardGroup([
              _buildSettingItem(
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
              const Divider(color: Colors.white, height: 16, thickness: 1),
              _buildSettingItem(
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
              const Divider(color: Colors.white, height: 16, thickness: 1),
              _buildSettingItem(
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
            const SizedBox(height: 20),

            // --- SECTION 2: PREFERENCES / NOTIFICATIONS ---
            _buildSectionHeader('Preferences'),
            const SizedBox(height: 8),
            _buildCardGroup([
              _buildSettingItem(
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
            const SizedBox(height: 20),

            // --- SECTION 3: SUPPORT ---
            _buildSectionHeader('Support'),
            const SizedBox(height: 8),
            _buildCardGroup([
              _buildSettingItem(
                title: 'Help Center',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelpCenterScreen()),
                  );
                },
              ),
              const Divider(color: Colors.white, height: 16, thickness: 1),
              _buildSettingItem(
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
              const Divider(color: Colors.white, height: 16, thickness: 1),
              _buildSettingItem(
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
              const Divider(color: Colors.white, height: 16, thickness: 1),
              _buildSettingItem(
                title: 'About',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutScreen()),
                  );
                },
              ),
            ]),
            const SizedBox(height: 32),

            // --- LOGOUT BUTTON ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        const Divider(color: Colors.black38, thickness: 1, height: 1),
      ],
    );
  }

  Widget _buildCardGroup(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cardGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
