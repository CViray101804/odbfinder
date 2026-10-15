import 'package:flutter/material.dart';

class TermsAndPrivacyScreen extends StatefulWidget {
  const TermsAndPrivacyScreen({super.key});

  @override
  State<TermsAndPrivacyScreen> createState() => _TermsAndPrivacyScreenState();
}

class _TermsAndPrivacyScreenState extends State<TermsAndPrivacyScreen>
    with SingleTickerProviderStateMixin {
  final Color darkBlue = const Color(0xFF004D7A);
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
          'Terms & Privacy',
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
      body: Column(
        children: [
          const SizedBox(height: 20),

          // --- TAB BAR SELECTOR ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              height: 48,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: darkBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey.shade700,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(text: 'Terms of Service'),
                  Tab(text: 'Privacy Policy'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // --- TAB VIEWS ---
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTermsContent(),
                _buildPrivacyContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- TERMS OF SERVICE CONTENT ---
  Widget _buildTermsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPolicyCard(
            title: '1. Acceptance of Terms',
            body: 'By downloading, accessing, or using ODB Finder, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use the application[cite: 12].',
          ),
          _buildPolicyCard(
            title: '2. User Accounts & Responsibilities',
            body: 'Users are responsible for maintaining the confidentiality of their login credentials. Students and landlords must provide accurate and truthful information in profile setup and listing posts[cite: 12].',
          ),
          _buildPolicyCard(
            title: '3. Listings & Bookings',
            body: 'ODB Finder serves as a platform connecting boarders with property owners. We do not directly own or manage the properties listed. Booking agreements are executed between the student and the landlord[cite: 12].',
          ),
          _buildPolicyCard(
            title: '4. Code of Conduct',
            body: 'Users must not submit fraudulent property details, harass landlords or boarders via in-app chat, or attempt to compromise app security[cite: 12].',
          ),
          _buildPolicyCard(
            title: '5. Limitation of Liability',
            body: 'ODB Finder is not responsible for disputes arising from lease contracts, monetary transactions made outside the app, or property damage[cite: 12].',
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --- PRIVACY POLICY CONTENT ---
  Widget _buildPrivacyContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPolicyCard(
            title: '1. Information We Collect',
            body: 'We collect account details (name, email, contact number), user preferences, chat logs, and room inquiries to deliver and improve our bedspace finder services[cite: 12].',
          ),
          _buildPolicyCard(
            title: '2. How We Use Your Information',
            body: 'Your information is used to facilitate chat communication with landlords, process booking application statuses, manage favorites, and send notification updates[cite: 12].',
          ),
          _buildPolicyCard(
            title: '3. Data Protection & Privacy',
            body: 'We prioritize your privacy and strictly adhere to data protection regulations. We do not sell or share your personal data with third-party advertisers[cite: 12].',
          ),
          _buildPolicyCard(
            title: '4. Media & Storage Access',
            body: 'If permitted, the app accesses your camera or gallery only when uploading room photos, verification documents, or sending chat images[cite: 12].',
          ),
          _buildPolicyCard(
            title: '5. Account Deletion & Rights',
            body: 'You have the right to request access to your stored personal data or request permanent deletion of your account at any time through our Help Center[cite: 12].',
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPolicyCard({
    required String title,
    required String body,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E1E),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}