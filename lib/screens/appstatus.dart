import 'package:flutter/material.dart';
import 'package:odbfinder/screens/chat.dart';

class ApplicationStatusScreen extends StatefulWidget {
  final String dormName;
  final String location;
  final String price;

  const ApplicationStatusScreen({
    super.key,
    this.dormName = 'SunResidence Female Dorm (Bed B)',
    this.location = 'Unit 402, Sampaloc, Manila',
    this.price = '₱1,500 / month',
  });

  @override
  State<ApplicationStatusScreen> createState() =>
      _ApplicationStatusScreenState();
}

class _ApplicationStatusScreenState extends State<ApplicationStatusScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    // Continuous rotation animation controller
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Takes 3 seconds per full turn
    )..repeat(); // Loops indefinitely in one direction
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF0A4F7D);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: darkBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Back',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        toolbarHeight: 65,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Application Status',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // =========================
            // PENDING STATUS CARD WITH ROTATION ANIMATION
            // =========================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF1E88E5), width: 2),
              ),
              child: Column(
                children: [
                  RotationTransition(
                    turns: _rotationController,
                    child: const Icon(
                      Icons.hourglass_top_rounded,
                      size: 48,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Pending',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Pending Admin Approval\nYour request for Bedspace #3 at ${widget.dormName} has been submitted successfully',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade800,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // =========================
            // STATUS TIMELINE
            // =========================
            _buildSectionHeader('Status Timeline'),
            const SizedBox(height: 12),

            _buildTimelineRow(
              iconText: '(v)',
              title: 'Application Submitted',
              statusText: 'Date & Time',
              isCompleted: true,
            ),
            _buildTimelineRow(
              iconText: '(*)',
              title: 'Under Review by Landlord\nEst. response within 24-48 hours',
              statusText: 'In Progress',
              isInProgress: true,
            ),
            _buildTimelineRow(
              iconText: '( )',
              title: 'Approval & Lease Signing',
              statusText: 'Pending',
            ),
            _buildTimelineRow(
              iconText: '( )',
              title: 'Payment & Move-in Key',
              statusText: 'Pending',
            ),
            const SizedBox(height: 16),

            // =========================
            // DETAILS SECTION
            // =========================
            _buildSectionHeader('Property & Application Details'),
            const SizedBox(height: 12),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.dormName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.location,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rent: ${widget.price}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Move-in: [Date]',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // =========================
            // ACTION BUTTONS
            // =========================
            _buildSectionHeader('Need Help or Changes?'),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => ChatDetailScreen(
                              landlordName: widget.dormName,
                              shouldGoToMessagesOnBack: false,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Chat with\nLandlord',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {
                        _showCancelDialog(context);
                      },
                      child: const Text(
                        'Cancel Request',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const Divider(color: Colors.black, thickness: 1),
      ],
    );
  }

  Widget _buildTimelineRow({
    required String iconText,
    required String title,
    required String statusText,
    bool isCompleted = false,
    bool isInProgress = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            iconText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isCompleted
                  ? Colors.green
                  : (isInProgress ? Colors.blue : Colors.black54),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight:
                    isInProgress ? FontWeight.bold : FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 12,
              fontWeight:
                  isInProgress ? FontWeight.bold : FontWeight.normal,
              color: isCompleted
                  ? Colors.green
                  : (isInProgress ? Colors.blue : Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel Request?'),
        content: const Text(
          'Are you sure you want to cancel your booking application for this room?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking request cancelled successfully.'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}