import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  final Color darkBlue = const Color(0xFF004D7A);

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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: darkBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notification Settings',
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
            // --- GENERAL NOTIFICATIONS ---
            _buildSectionHeader('General'),
            const SizedBox(height: 10),
            _buildSwitchTile(
              icon: Icons.notifications_active_outlined,
              title: 'Push Notifications',
              subtitle: 'Allow app to send alert popups',
              value: _pushNotifications,
              onChanged: (val) {
                setState(() {
                  _pushNotifications = val;
                });
              },
            ),

            const SizedBox(height: 24),

            // --- ACTIVITY NOTIFICATIONS ---
            _buildSectionHeader('Alerts & Messages'),
            const SizedBox(height: 10),
            _buildSwitchTile(
              icon: Icons.chat_bubble_outline_rounded,
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
              icon: Icons.bookmark_border_rounded,
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
              icon: Icons.local_offer_outlined,
              title: 'Promotions & Announcements',
              subtitle: 'Special deals, room discounts, and news',
              value: _promosAndOffers,
              onChanged: (val) {
                setState(() {
                  _promosAndOffers = val;
                });
              },
            ),

            const SizedBox(height: 24),

            // --- SOUND & VIBRATION ---
            _buildSectionHeader('Sound & Feedback'),
            const SizedBox(height: 10),
            _buildSwitchTile(
              icon: Icons.volume_up_outlined,
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
              icon: Icons.vibration_rounded,
              title: 'Vibration',
              subtitle: 'Vibrate on receiving alerts',
              value: _vibrationEnabled,
              onChanged: (val) {
                setState(() {
                  _vibrationEnabled = val;
                });
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---
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

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SwitchListTile(
        activeColor: darkBlue,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: darkBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: darkBlue, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E1E),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}