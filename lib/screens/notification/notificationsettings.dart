import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  final Color darkBlue = const Color(0xFF0A4F7D);

  // Notification Preferences
  bool _pushNotifications = true;
  bool _chatMessages = true;
  bool _bookingUpdates = true;
  bool _promosAndOffers = false;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: darkBlue,
          automaticallyImplyLeading: false,
          elevation: 0,
          toolbarHeight: 70,
          title: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 22,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 4),
              const Text(
                'Back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Notification Settings',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- GENERAL NOTIFICATIONS ---
            _buildSectionHeader('General'),
            _buildSwitchTile(
              title: 'Push Notifications',
              subtitle: 'Allow app to send alert popups',
              value: _pushNotifications,
              onChanged: (val) {
                setState(() {
                  _pushNotifications = val;
                });
              },
            ),

            const SizedBox(height: 16),

            // --- ACTIVITY NOTIFICATIONS ---
            _buildSectionHeader('Alerts & Messages'),
            _buildSwitchTile(
              title: 'Chat Messages',
              subtitle: 'Notifications for new landlord/tenant messages',
              value: _chatMessages,
              onChanged: (val) {
                setState(() {
                  _chatMessages = val;
                });
              },
            ),
            _buildSwitchTile(
              title: 'Booking & Application Updates',
              subtitle: 'Status changes on your bedspace reservations',
              value: _bookingUpdates,
              onChanged: (val) {
                setState(() {
                  _bookingUpdates = val;
                });
              },
            ),
            _buildSwitchTile(
              title: 'Promotions & Announcements',
              subtitle: 'Special deals, room discounts, and news',
              value: _promosAndOffers,
              onChanged: (val) {
                setState(() {
                  _promosAndOffers = val;
                });
              },
            ),

            const SizedBox(height: 16),

            // --- SOUND & VIBRATION ---
            _buildSectionHeader('Sound & Feedback'),
            _buildSwitchTile(
              title: 'Sound',
              subtitle: 'Play sound for incoming notifications',
              value: _soundEnabled,
              onChanged: (val) {
                setState(() {
                  _soundEnabled = val;
                });
              },
            ),
            _buildSwitchTile(
              title: 'Vibration',
              subtitle: 'Vibrate on receiving alerts',
              value: _vibrationEnabled,
              onChanged: (val) {
                setState(() {
                  _vibrationEnabled = val;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: SwitchListTile(
        activeColor: darkBlue,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
          ),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}