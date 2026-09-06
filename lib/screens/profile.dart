import 'package:flutter/material.dart';
import 'package:odbfinder/screens/appstatus.dart';
import 'package:odbfinder/screens/setting.dart';

// ---------------------------------------------------------------------------
// PROFILE SCREEN
// ---------------------------------------------------------------------------
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final Color darkBlue = const Color(0xFF0A4F7D);
  final Color cardGrey = const Color(0xFFD9D9D9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header Card with Profile Picture & Name
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 24,
                  left: 16,
                  right: 16,
                ),
                decoration: BoxDecoration(
                  color: darkBlue,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    // Top Right Settings Icon
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Avatar Circle
                    Container(
                      width: 110,
                      height: 110,
                      decoration: const BoxDecoration(
                        color: Color(0xFFC4C4C4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // User Name
                    const Text(
                      'User',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Information Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoPill('Email:example@gmail.com'),
                    const SizedBox(height: 10),
                    _buildInfoPill('Contacts:090000000'),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              const Divider(color: Colors.black38, thickness: 1),
              const SizedBox(height: 8),

              // Account & Reservations Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Account & reservations',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildActionPill(
                      'Application Status / Active Bookings',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ApplicationStatusScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildActionPill('Saved', onTap: () {}),
                    const SizedBox(height: 12),
                    _buildActionPill('Recent Inquiries', onTap: () {}),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoPill(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: cardGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildActionPill(String text, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cardGrey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
