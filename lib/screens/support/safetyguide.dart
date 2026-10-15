import 'package:flutter/material.dart';

class SafetyGuideScreen extends StatelessWidget {
  const SafetyGuideScreen({super.key});

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
          'Safety Guide',
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
            Text(
              'Tips for safe boarding and bedspace hunting[cite: 11]',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),

            // --- EMERGENCY NOTICE BANNER ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.shade100),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Colors.red, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'In Case of Emergency',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Call national emergency hotline 911 or local police immediately if you feel in danger[cite: 11].',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- SAFETY TIPS ACCORDION LIST ---
            const Text(
              'Essential Safety Tips',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 12),

            _buildGuideCard(
              icon: Icons.verified_user_outlined,
              title: '1. Verify Landlords & Listings',
              description: 'Always inspect the property in person before paying deposits. Ensure the landlord provides legitimate proof of ownership or property management authorization[cite: 11].',
            ),
            _buildGuideCard(
              icon: Icons.lock_outline_rounded,
              title: '2. Check Security Features',
              description: 'Look for working door locks, main gate security, 24/7 CCTV coverage, and well-lit hallways/common areas before committing[cite: 11].',
            ),
            _buildGuideCard(
              icon: Icons.payments_outlined,
              title: '3. Secure Transactions',
              description: 'Never send full payments to unverified bank/GCash accounts. Always request an official receipt or written contract agreement[cite: 11].',
            ),
            _buildGuideCard(
              icon: Icons.fire_extinguisher_outlined,
              title: '4. Fire & Disaster Preparedness',
              description: 'Locate fire exits, extinguishers, and emergency escape windows in the building. Ensure smoke detectors are functional[cite: 11].',
            ),
            _buildGuideCard(
              icon: Icons.group_outlined,
              title: '5. Roommate & Visitor Safety',
              description: 'Know your house rules regarding visitors and curfew. Keep your personal valuables locked in secure storage at all times[cite: 11].',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
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
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        leading: Icon(icon, color: darkBlue, size: 24),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E1E),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
            ),
            child: Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}